import 'dart:async';

import 'package:command_it/command_it.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sikh_audiobooks_flutter/data/repositories/audiobooks/audiobooks_repository.dart';
import 'package:sikh_audiobooks_flutter/ui/core/ui_state/audiobook_ui_state/audiobook_ui_state.dart';
import 'package:sikh_audiobooks_flutter/ui/core/ui_state/chapter_ui_state/chapter_ui_state.dart';
import 'package:sikh_audiobooks_flutter/utils/result.dart';

class AudiobookViewModel extends Disposable {
  AudiobookViewModel({
    required AudiobooksRepository audiobooksRepository,
    required String id,
  }) : _audiobooksRepository = audiobooksRepository,
       _id = id {
    CombineLatestStream.combine5(
          _audiobooksRepository.getAuthorByAudiobookIdStream(_id),
          _audiobooksRepository.getAudiobookByIdStream(_id),
          _audiobooksRepository.getChaptersByAudiobookIdStream(_id),
          _audiobooksRepository.getInLibraryByAudiobookIdStream(_id),
          _audiobooksRepository.getAudiobookResumeLocationByAudiobookIdStream(
            _id,
          ),
          (author, audiobook, chapters, inLibrary, audiobookResumeLocation) {
            if (author == null || audiobook == null) {
              return null;
            }
            return AudiobookUiState(
              author: author,
              audiobook: audiobook,
              chapters: chapters,
              inLibrary: inLibrary,
              resumeLocation: audiobookResumeLocation,
              isPlaying: false,
            );
          },
        )
        .listen(
          (data) {
            _audiobookUiStateResultVN.value = Result.ok(data);
            _chapterUiStateListResultVN.value = Result.ok(
              data?.chapters
                  .map(
                    (c) => (ChapterUiState(
                      chapter: c,
                      isPlaying: false,
                      audiobookUiState: data,
                    )),
                  )
                  .toList(),
            );
          },
          onError: (error) {
            _log.d("combine5 onError", error: error);
            _audiobookUiStateResultVN.value = Result.error(error);
            _chapterUiStateListResultVN.value = Result.error(error);
          },
        )
        .addTo(_compositeSubscription);
  }

  final _log = Logger();

  final AudiobooksRepository _audiobooksRepository;
  final String _id;

  final ValueNotifier<Result<AudiobookUiState?>?> _audiobookUiStateResultVN =
      ValueNotifier(null);

  ValueNotifier<Result<AudiobookUiState?>?> get audiobookUiStateResultVN =>
      _audiobookUiStateResultVN;

  final ValueNotifier<Result<List<ChapterUiState>?>?>
  _chapterUiStateListResultVN = ValueNotifier(null);

  ValueNotifier<Result<List<ChapterUiState>?>?>
  get chapterUiStateListResultVN => _chapterUiStateListResultVN;

  final CompositeSubscription _compositeSubscription = CompositeSubscription();

  late final Command<void, Result<void>?> refreshDataCommand =
      _audiobooksRepository.refreshDataCommand;

  late final Command<void, Result<void>?> _playCommand =
      Command.createAsyncNoParam(() async {
        //
        return Result.ok(null);
      }, initialValue: null);

  Command<void, Result<void>?> get playCommand => _playCommand;

  late final Command<void, Result<void>?> _pauseCommand =
      Command.createAsyncNoParam(() async {
        //
        return Result.ok(null);
      }, initialValue: null);

  Command<void, Result<void>?> get pauseCommand => _pauseCommand;

  late final Command<void, Result<void>?> _downloadCommand =
      Command.createAsyncNoParam(() async {
        //
        return Result.ok(null);
      }, initialValue: null);

  Command<void, Result<void>?> get downloadCommand => _downloadCommand;

  late final Command<void, Result<void>?> _removeDownloadCommand =
      Command.createAsyncNoParam(() async {
        //
        return Result.ok(null);
      }, initialValue: null);

  Command<void, Result<void>?> get removeDownloadCommand =>
      _removeDownloadCommand;

  late final Command<void, Result<void>?> _addToLibraryCommand =
      Command.createAsyncNoParam(() async {
        //
        return Result.ok(null);
      }, initialValue: null);

  Command<void, Result<void>?> get addToLibraryCommand => _addToLibraryCommand;

  late final Command<void, Result<void>?> _removeFromLibraryCommand =
      Command.createAsyncNoParam(() async {
        //
        return Result.ok(null);
      }, initialValue: null);

  Command<void, Result<void>?> get removeFromLibraryCommand =>
      _removeFromLibraryCommand;

  void startDownloadAudiobookImage(String audiobookId) {
    unawaited(_audiobooksRepository.startDownloadAudiobookImage(audiobookId));
  }

  void cancelDownloadAudiobookImage(String audiobookId) {
    unawaited(_audiobooksRepository.cancelDownloadAudiobookImage(audiobookId));
  }

  void startDownloadAuthorImage(String authorId) {
    unawaited(_audiobooksRepository.startDownloadAuthorImage(authorId));
  }

  void cancelDownloadAuthorImage(String authorId) {
    unawaited(_audiobooksRepository.cancelDownloadAuthorImage(authorId));
  }

  @override
  FutureOr onDispose() async {
    await _compositeSubscription.dispose();

    _audiobookUiStateResultVN.dispose();
    _chapterUiStateListResultVN.dispose();

    _playCommand.dispose();
    _pauseCommand.dispose();
    _downloadCommand.dispose();
    _removeDownloadCommand.dispose();
    _addToLibraryCommand.dispose();
    _removeFromLibraryCommand.dispose();
  }
}
