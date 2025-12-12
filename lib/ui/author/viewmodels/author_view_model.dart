import 'dart:async';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:command_it/command_it.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sikh_audiobooks_flutter/data/repositories/audiobooks/audiobooks_repository.dart';
import 'package:sikh_audiobooks_flutter/domain/models/author/author.dart';
import 'package:sikh_audiobooks_flutter/l10n/app_localizations.dart';
import 'package:sikh_audiobooks_flutter/ui/core/ui_state/audiobook_ui_state/audiobook_ui_state.dart';
import 'package:sikh_audiobooks_flutter/utils/enums.dart';
import 'package:sikh_audiobooks_flutter/utils/result.dart';

class AuthorViewModel extends Disposable {
  AuthorViewModel({
    required AudiobooksRepository audiobooksRepository,
    required String id,
  }) : _audiobooksRepository = audiobooksRepository,
       _id = id {
    _audiobooksRepository
        .getAuthorByIdStream(_id)
        .listen(
          (data) {
            _authorResultVN.value = Result.ok(data);
          },
          onError: (error) {
            _log.d("getAuthorByIdStream id:$_id onError", error: error);
            _authorResultVN.value = Result.error(error);
          },
        )
        .addTo(_compositeSubscription);

    CombineLatestStream.combine5(
          _audiobooksRepository.getAuthorByIdStream(_id),
          _audiobooksRepository.getAudiobooksByAuthorIdStream(_id),
          _audiobooksRepository.getChaptersByAuthorIdStream(_id),
          _audiobooksRepository.getInLibraryAudiobookIdsByAuthorIdStream(_id),
          _audiobooksRepository.getAudiobookResumeLocationsByAuthorIdStream(
            _id,
          ),
          (
            author,
            audiobooks,
            allChapters,
            inLibraryAudiobookIds,
            audiobookResumeLocations,
          ) {
            if (author == null) {
              return <AudiobookUiState>[];
            }
            final List<AudiobookUiState> result = [];
            for (final audiobook in audiobooks) {
              final inLibrary = inLibraryAudiobookIds.contains(audiobook.id);
              final chapters = allChapters
                  .where((c) => (c.audioBookId == audiobook.id))
                  .toList();
              final resumeLocation = audiobookResumeLocations.firstWhereOrNull(
                (l) => (l.id == audiobook.id),
              );
              result.add(
                AudiobookUiState(
                  author: author,
                  audiobook: audiobook,
                  inLibrary: inLibrary,
                  chapters: chapters,
                  resumeLocation: resumeLocation,
                  isPlaying: false,
                ),
              );
            }
            return result;
          },
        )
        .listen(
          (data) {
            _allAudiobookUiStatesResultVN.value = Result.ok(data);
          },
          onError: (error) {
            _log.d("combine5 onError", error: error);
            _allAudiobookUiStatesResultVN.value = Result.error(error);
          },
        )
        .addTo(_compositeSubscription);
    _filteredAudiobookUiStatesResultVL = _allAudiobookUiStatesResultVN
        .combineLatest5(
          _audiobookLanguageVN,
          _audiobookFilterVN,
          _audiobookAuthorSortVN,
          _currentLocaleVN,
          (
            allUiStatesResultVal,
            languageVal,
            filterVal,
            sortVal,
            currentLocaleVal,
          ) {
            if (allUiStatesResultVal == null) {
              return null;
            }

            List<AudiobookUiState> result;

            switch (allUiStatesResultVal) {
              case Ok<List<AudiobookUiState>>():
                result = allUiStatesResultVal.value;
              case Error<List<AudiobookUiState>>():
                return Result.error(allUiStatesResultVal.error);
            }

            if (languageVal != AudiobookLanguage.all) {
              result = result
                  .where((a) => (a.audiobook.language == languageVal.name))
                  .toList();
            }
            if (filterVal == AudiobookFilter.downloaded) {
              result = result.where((a) => (a.anyDownloaded())).toList();
            }

            switch (sortVal) {
              case AudiobookAuthorSort.authorDefault:
                result.sortBy((a) => (a.audiobook.authorOrder));
              case AudiobookAuthorSort.lastPlayed:
                result.sortBy((a) => (-(a.resumeLocation?.updatedAtInMs ?? 0)));
              case AudiobookAuthorSort.title:
                result.sortBy(
                  (a) =>
                      (a.audiobook.name[currentLocaleVal.languageCode] ?? ""),
                );
            }

            return Result.ok(result);
          },
        );
    internetStatusVN = _audiobooksRepository.internetStatusVN;
  }

  final _log = Logger();

  final ValueNotifier<Result<Author?>?> _authorResultVN = ValueNotifier(null);
  ValueNotifier<Result<Author?>?> get authorResultVN => _authorResultVN;

  final ValueNotifier<AudiobookLanguage> _audiobookLanguageVN = ValueNotifier(
    AudiobookLanguage.all,
  );
  ValueNotifier<AudiobookLanguage> get audiobookLanguageVN =>
      _audiobookLanguageVN;

  final ValueNotifier<AudiobookFilter> _audiobookFilterVN = ValueNotifier(
    AudiobookFilter.all,
  );
  ValueNotifier<AudiobookFilter> get audiobookFilterVN => _audiobookFilterVN;

  final ValueNotifier<AudiobookAuthorSort> _audiobookAuthorSortVN =
      ValueNotifier(AudiobookAuthorSort.authorDefault);
  ValueNotifier<AudiobookAuthorSort> get audiobookAuthorSortVN =>
      _audiobookAuthorSortVN;

  final ValueNotifier<Locale> _currentLocaleVN = ValueNotifier(
    AppLocalizations.supportedLocales.first,
  );

  final ValueNotifier<Result<List<AudiobookUiState>>?>
  _allAudiobookUiStatesResultVN = ValueNotifier(null);

  late final ValueListenable<Result<List<AudiobookUiState>>?>
  _filteredAudiobookUiStatesResultVL;

  ValueListenable<Result<List<AudiobookUiState>>?>
  get filteredAudiobookUiStatesResultVL => _filteredAudiobookUiStatesResultVL;

  final AudiobooksRepository _audiobooksRepository;
  final String _id;
  final CompositeSubscription _compositeSubscription = CompositeSubscription();

  late final Command<void, Result<void>?> refreshDataCommand =
      _audiobooksRepository.refreshDataCommand;

  void startDownloadAuthorImage(String authorId) {
    unawaited(_audiobooksRepository.startDownloadAuthorImage(authorId));
  }

  void cancelDownloadAuthorImage(String authorId) {
    unawaited(_audiobooksRepository.cancelDownloadAuthorImage(authorId));
  }

  void startDownloadAudiobookImage(String audiobookId) {
    unawaited(_audiobooksRepository.startDownloadAudiobookImage(audiobookId));
  }

  void cancelDownloadAudiobookImage(String audiobookId) {
    unawaited(_audiobooksRepository.cancelDownloadAudiobookImage(audiobookId));
  }

  void setAudiobookLanguageFilter(AudiobookLanguage language) {
    _audiobookLanguageVN.value = language;
  }

  void setAudiobookFilter(AudiobookFilter filter) {
    _audiobookFilterVN.value = filter;
  }

  void setAudiobookAuthorSort(AudiobookAuthorSort sort) {
    _audiobookAuthorSortVN.value = sort;
  }

  void notifyCurrentLocale(Locale locale) {
    _currentLocaleVN.value = locale;
  }

  @override
  FutureOr onDispose() async {
    await _compositeSubscription.dispose();

    _authorResultVN.dispose();
    _audiobookLanguageVN.dispose();
    _audiobookFilterVN.dispose();
    _audiobookAuthorSortVN.dispose();
    _currentLocaleVN.dispose();
    _allAudiobookUiStatesResultVN.dispose();
  }

  late final ValueNotifier<InternetStatus?> internetStatusVN;
}
