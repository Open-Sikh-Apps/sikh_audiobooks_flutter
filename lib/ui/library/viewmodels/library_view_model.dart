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
import 'package:sikh_audiobooks_flutter/l10n/app_localizations.dart';
import 'package:sikh_audiobooks_flutter/ui/core/ui_state/audiobook_ui_state/audiobook_ui_state.dart';
import 'package:sikh_audiobooks_flutter/utils/enums.dart';
import 'package:sikh_audiobooks_flutter/utils/result.dart';

class LibraryViewModel extends Disposable {
  LibraryViewModel({required AudiobooksRepository audiobooksRepository})
    : _audiobooksRepository = audiobooksRepository {
    CombineLatestStream.combine4(
          _audiobooksRepository.getInLibraryAudiobooksStream(),
          _audiobooksRepository.getInLibraryAuthorsStream(),
          _audiobooksRepository.getInLibraryChaptersStream(),
          _audiobooksRepository.getInLibraryAudiobookResumeLocationsStream(),
          (audiobooks, authors, chapters, audiobookResumeLocations) {
            final List<AudiobookUiState> result = [];
            for (final audiobook in audiobooks) {
              final author = authors.firstWhereOrNull(
                (a) => (a.id == audiobook.authorId),
              );
              if (author == null) {
                continue;
              }
              final currentChapters = chapters
                  .where((c) => (c.audioBookId == audiobook.id))
                  .toList();
              final resumeLocation = audiobookResumeLocations.firstWhereOrNull(
                (l) => (l.id == audiobook.id),
              );
              result.add(
                AudiobookUiState(
                  author: author,
                  audiobook: audiobook,
                  inLibrary: true,
                  chapters: currentChapters,
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
            _log.d("combine4 onError", error: error);
            _allAudiobookUiStatesResultVN.value = Result.error(error);
          },
        )
        .addTo(_compositeSubscription);
    _filteredAudiobookUiStatesResultVL = _allAudiobookUiStatesResultVN
        .combineLatest5(
          _audiobookLanguageVN,
          _audiobookFilterVN,
          _audiobookLibrarySortVN,
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
              case AudiobookLibrarySort.lastPlayed:
                result.sortBy((a) => (-(a.resumeLocation?.updatedAtInMs ?? 0)));
              case AudiobookLibrarySort.title:
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

  late final ValueNotifier<InternetStatus?> internetStatusVN;

  final _log = Logger();

  final AudiobooksRepository _audiobooksRepository;

  final CompositeSubscription _compositeSubscription = CompositeSubscription();

  final ValueNotifier<AudiobookLanguage> _audiobookLanguageVN = ValueNotifier(
    AudiobookLanguage.all,
  );
  ValueNotifier<AudiobookLanguage> get audiobookLanguageVN =>
      _audiobookLanguageVN;

  final ValueNotifier<AudiobookFilter> _audiobookFilterVN = ValueNotifier(
    AudiobookFilter.all,
  );
  ValueNotifier<AudiobookFilter> get audiobookFilterVN => _audiobookFilterVN;

  final ValueNotifier<AudiobookLibrarySort> _audiobookLibrarySortVN =
      ValueNotifier(AudiobookLibrarySort.lastPlayed);
  ValueNotifier<AudiobookLibrarySort> get audiobookLibrarySortVN =>
      _audiobookLibrarySortVN;

  final ValueNotifier<Locale> _currentLocaleVN = ValueNotifier(
    AppLocalizations.supportedLocales.first,
  );

  final ValueNotifier<Result<List<AudiobookUiState>>?>
  _allAudiobookUiStatesResultVN = ValueNotifier(null);

  ValueListenable<Result<List<AudiobookUiState>>?>
  get allAudiobookUiStatesResultVN => _allAudiobookUiStatesResultVN;

  late final ValueListenable<Result<List<AudiobookUiState>>?>
  _filteredAudiobookUiStatesResultVL;

  ValueListenable<Result<List<AudiobookUiState>>?>
  get filteredAudiobookUiStatesResultVL => _filteredAudiobookUiStatesResultVL;

  late final Command<void, Result<void>?> refreshDataCommand =
      _audiobooksRepository.refreshDataCommand;

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

  void setAudiobookAuthorSort(AudiobookLibrarySort sort) {
    _audiobookLibrarySortVN.value = sort;
  }

  void notifyCurrentLocale(Locale locale) {
    _currentLocaleVN.value = locale;
  }

  @override
  FutureOr onDispose() async {
    await _compositeSubscription.dispose();

    _audiobookLanguageVN.dispose();
    _audiobookFilterVN.dispose();
    _audiobookLibrarySortVN.dispose();
    _currentLocaleVN.dispose();
    _allAudiobookUiStatesResultVN.dispose();
  }
}
