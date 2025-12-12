import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart' hide Result;
import 'package:background_downloader/background_downloader.dart';
import 'package:collection/collection.dart';
import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sikh_audiobooks_flutter/config/constants.dart';
import 'package:sikh_audiobooks_flutter/data/repositories/user_settings/user_settings_repository.dart';
import 'package:sikh_audiobooks_flutter/data/services/local_db_service.dart';
import 'package:sikh_audiobooks_flutter/data/services/remote_db_service.dart';
import 'package:sikh_audiobooks_flutter/data/services/remote_storage_service.dart';
import 'package:sikh_audiobooks_flutter/data/services/shared_preferences_service.dart';
import 'package:sikh_audiobooks_flutter/domain/models/audiobook/audiobook.dart';
import 'package:sikh_audiobooks_flutter/domain/models/audiobook_resume_location/audiobook_resume_location.dart';
import 'package:sikh_audiobooks_flutter/domain/models/author/author.dart';
import 'package:sikh_audiobooks_flutter/domain/models/chapter/chapter.dart';
import 'package:sikh_audiobooks_flutter/domain/models/task_with_status_and_progress/task_with_status_and_progress.dart';
import 'package:sikh_audiobooks_flutter/l10n/app_localizations.dart';
import 'package:sikh_audiobooks_flutter/utils/result.dart';

abstract class AudiobooksRepository extends Disposable {
  Command<void, Result<void>?> get refreshDataCommand;
  ValueNotifier<InternetStatus?> get internetStatusVN;
  ValueNotifier<Map<String, TaskWithStatusAndProgress>>
  get downloadTasksUpdates;

  Future<void> startDownloadAuthorImage(String authorId);
  Future<void> cancelDownloadAuthorImage(String authorId);

  Future<void> startDownloadAudiobookImage(String audiobookId);
  Future<void> cancelDownloadAudiobookImage(String audiobookId);

  Stream<List<Author>> getAllAuthorsStream();
  Stream<Author?> getAuthorByIdStream(String id);
  Stream<Author?> getAuthorByAudiobookIdStream(String audiobookId);

  Stream<Audiobook?> getAudiobookByIdStream(String id);
  Stream<List<Audiobook>> getAudiobooksByAuthorIdStream(String authorId);

  Stream<List<Chapter>> getChaptersByAudiobookIdStream(String audiobookId);
  Stream<List<Chapter>> getChaptersByAuthorIdStream(String authorId);

  Future<Result<void>> addAudiobookToLibrary(String audiobookId);
  Future<Result<void>> removeAudiobookFromLibrary(String audiobookId);

  Stream<bool> getInLibraryByAudiobookIdStream(String audiobookId);
  Stream<List<String>> getInLibraryAudiobookIdsByAuthorIdStream(
    String authorId,
  );

  Stream<AudiobookResumeLocation?>
  getAudiobookResumeLocationByAudiobookIdStream(String audiobookId);
  Stream<List<AudiobookResumeLocation>>
  getAudiobookResumeLocationsByAuthorIdStream(String authorId);

  Stream<List<Audiobook>> getInLibraryAudiobooksStream();
  Stream<List<Author>> getInLibraryAuthorsStream();
  Stream<List<AudiobookResumeLocation>>
  getInLibraryAudiobookResumeLocationsStream();
  Stream<List<Chapter>> getInLibraryChaptersStream();

  Future<Result<void>> downloadAudiobook(
    BuildContext context,
    String audiobookId,
  );
  Future<Result<void>> removeAudiobook(audiobookId);
}

/// handle offline functionality
/// expose internet connection status
/// on offline
///    - cancel refreshDataCommand
///    - cancel any image downloads
///    - TODO(stop any network audio which is playing and disable from queue)
///    - TODO(disable any network audios in queue)
///    - pauseall
/// on online
///    - start refreshDataCommand if failed previously
///    - refresh frontend widgets to load images again, if needed
///    - TODO(enable any disabled network audios in queue)
/// general operations
///    - check online/offline
///        - before starting any image download
///        - before syncing database online
// pause internet subscription on app background
// TODO(but not when any network audio in playing queue)
///
/// Fetches Author List from server or local (if available)
/// First checks if the "data_version" from realtime database
/// and compares with locally saved in shared prefs
/// - updates local text data, if obsolete
/// - downloads any author images, if missing or obsolete
///
/// TODO when starting download, check if notification permssions are granted,
///   if yes, continue downloading showing notifications
///   if not, check if user previously denied in shared prefs
///     if yes, continue downloading without notifications
///     if not, show rationale dialog, request notif permission
///     and continue downloading accordingly

class AudiobooksRepositoryProd extends AudiobooksRepository {
  AudiobooksRepositoryProd({
    required UserSettingsRepository userSettingsRepository,
    required RemoteDbService remoteDbService,
    required RemoteStorageService remoteStorageService,
    required LocalDbService dbService,
    required Directory appDocsDir,
  }) : _userSettingsRepository = userSettingsRepository,
       _remoteDbService = remoteDbService,
       _remoteStorageService = remoteStorageService,
       _localDbService = dbService,
       _appDocsDir = appDocsDir {
    _refreshDataCommand = Command.createAsyncNoParam(() async {
      _log.d("_refreshDataCommand executing");

      _refreshDataCancellable = CancelableOperation.fromFuture(
        _parseAndUpdateJsonData(),
      );

      final result = await _refreshDataCancellable?.valueOrCancellation();
      if (_refreshDataCancellable?.isCanceled == true) {
        return Result.error("Fetch cancelled.");
      }
      if (result is Error) {
        _log.d("result is Error", error: result.error);
        return result;
      }

      return Result.ok(null);
    }, initialValue: null);
    _refreshDataCommand.execute();

    _internetStatusVNSubscription = _internetStatusVN.listen((status, _) async {
      if (status == InternetStatus.disconnected) {
        await _refreshDataCancellable?.cancel();
        await cancelImageDownloads();
      } else if (status == InternetStatus.connected) {
        final refreshDataCommandResults = _refreshDataCommand.results.value;
        if (refreshDataCommandResults.hasError ||
            (refreshDataCommandResults.data is Error)) {
          _refreshDataCommand.execute();
        }
      }
    });

    _internetStatusSubscription = subscribeInternetChanges();

    FGBGEvents.instance.stream
        .listen((event) async {
          switch (event) {
            case FGBGType.background:
              await _internetStatusSubscription?.cancel();
              _internetStatusSubscription = null;
            case FGBGType.foreground:
              _internetStatusSubscription ??= subscribeInternetChanges();
          }
        })
        .addTo(_compositeSubscription);

    unawaited(initDownloader());
  }

  final _log = Logger();
  final UserSettingsRepository _userSettingsRepository;
  final RemoteDbService _remoteDbService;
  final RemoteStorageService _remoteStorageService;
  final LocalDbService _localDbService;
  final Map<String, CancelableOperation> _imageDownloadTasksMap = {};
  final Directory _appDocsDir;

  CancelableOperation<Result<void>>? _refreshDataCancellable;

  late final Command<void, Result<void>?> _refreshDataCommand;

  @override
  Command<void, Result<void>?> get refreshDataCommand => _refreshDataCommand;

  final ValueNotifier<InternetStatus?> _internetStatusVN = ValueNotifier(null);

  @override
  ValueNotifier<InternetStatus?> get internetStatusVN => _internetStatusVN;

  final ValueNotifier<Map<String, TaskWithStatusAndProgress>>
  _downloadTasksUpdates = ValueNotifier({});

  @override
  ValueNotifier<Map<String, TaskWithStatusAndProgress>>
  get downloadTasksUpdates => _downloadTasksUpdates;

  StreamSubscription<InternetStatus>? _internetStatusSubscription;

  final _compositeSubscription = CompositeSubscription();

  late final ListenableSubscription _internetStatusVNSubscription;

  @override
  Future<void> startDownloadAuthorImage(String authorId) async {
    if (internetStatusVN.value == InternetStatus.disconnected) {
      return;
    }
    try {
      if (_imageDownloadTasksMap.containsKey(authorId)) {
        _log.d("already downloading");
        //already downloading, no need to download again
        return;
      }

      final Result<Author?> authorFromDbResult = await _localDbService
          .getAuthorById(authorId);
      final Author? authorFromDb;

      switch (authorFromDbResult) {
        case Ok<Author?>():
          authorFromDb = authorFromDbResult.value;
        case Error<Author?>():
          _log.d("authorFromDbResult is Error:\t$authorFromDbResult");
          throw authorFromDbResult.error;
      }
      if (authorFromDb == null) {
        throw Exception("authorFromDb == null");
      }
      if (authorFromDb.localImagePath != null) {
        //image already downloaded
        //no need to download again
        return;
      }

      final fileExtension = authorFromDb.imagePath.split(".").last;
      final localFileName = "${authorFromDb.id}.$fileExtension";
      final localFilePath = join(_appDocsDir.path, localFileName);

      _log.d(
        "startDownloadAuthorImage new task authorId:$authorId\nlocalFilePath:$localFilePath\nstorageFilePath:${authorFromDb.imagePath}",
      );

      final cancelable = _remoteStorageService.downloadFileCancelable(
        storageFilePath: authorFromDb.imagePath,
        localFilePath: localFilePath,
      );
      _imageDownloadTasksMap[authorId] = cancelable;
      await cancelable.valueOrCancellation();
      if (cancelable.isCanceled) {
        throw "Download cancelled";
      }

      final Result<Author?> authorFromDbAfterDownloadResult =
          await _localDbService.getAuthorById(authorId);
      final Author? authorFromDbAfterDownload;

      switch (authorFromDbAfterDownloadResult) {
        case Ok<Author?>():
          authorFromDbAfterDownload = authorFromDbAfterDownloadResult.value;
        case Error<Author?>():
          _log.d(
            "authorFromDbAfterDownloadResult is Error:\t$authorFromDbAfterDownloadResult",
          );
          throw authorFromDbAfterDownloadResult.error;
      }
      if (authorFromDbAfterDownload == null ||
          authorFromDbAfterDownload.imagePath != authorFromDb.imagePath) {
        throw Exception(
          "authorFromDbAfterDownload == null || authorFromDbAfterDownload.imagePath != authorFromDb.imagePath",
        );
      }
      if (authorFromDbAfterDownload.localImagePath != null) {
        //image already downloaded
        //no need to download again
        return;
      }

      final Result<void> saveAuthorResult = await _localDbService.saveAuthor(
        authorFromDbAfterDownload.copyWith(localImagePath: localFilePath),
      );

      if (saveAuthorResult is Error) {
        throw saveAuthorResult.error;
      }
      //done downloading, remove from tasks
      _imageDownloadTasksMap.remove(authorId);
    } catch (e) {
      _log.d("startDownloadAuthorImage catch", error: e);
    }
  }

  @override
  Future<void> cancelDownloadAuthorImage(String authorId) async {
    if (_imageDownloadTasksMap.containsKey(authorId)) {
      _log.d("cancelDownloadAuthorImage new task authorId:$authorId");
      final cancelable = _imageDownloadTasksMap.remove(authorId);
      await cancelable?.cancel();
    }
  }

  @override
  Future<void> startDownloadAudiobookImage(String audiobookId) async {
    if (internetStatusVN.value == InternetStatus.disconnected) {
      return;
    }
    try {
      if (_imageDownloadTasksMap.containsKey(audiobookId)) {
        _log.d("already downloading");
        //already downloading, no need to download again
        return;
      }

      final Result<Audiobook?> audiobookFromDbResult = await _localDbService
          .getAudiobookById(audiobookId);
      final Audiobook? audiobookFromDb;

      switch (audiobookFromDbResult) {
        case Ok<Audiobook?>():
          audiobookFromDb = audiobookFromDbResult.value;
        case Error<Audiobook?>():
          _log.d("authorFromDbResult is Error:\t$audiobookFromDbResult");
          throw audiobookFromDbResult.error;
      }
      if (audiobookFromDb == null) {
        throw Exception("audiobookFromDb == null");
      }
      if (audiobookFromDb.localImagePath != null) {
        //image already downloaded
        //no need to download again
        return;
      }

      final fileExtension = audiobookFromDb.imagePath.split(".").last;
      final localFileName = "${audiobookFromDb.id}.$fileExtension";
      final localFilePath = join(_appDocsDir.path, localFileName);

      _log.d(
        "startDownloadAudiobookImage new task authorId:$audiobookId\nlocalFilePath:$localFilePath\nstorageFilePath:${audiobookFromDb.imagePath}",
      );

      final cancelable = _remoteStorageService.downloadFileCancelable(
        storageFilePath: audiobookFromDb.imagePath,
        localFilePath: localFilePath,
      );
      _imageDownloadTasksMap[audiobookId] = cancelable;
      await cancelable.valueOrCancellation();
      if (cancelable.isCanceled) {
        throw "Download cancelled";
      }

      final Result<Audiobook?> audiobookFromDbAfterDownloadResult =
          await _localDbService.getAudiobookById(audiobookId);
      final Audiobook? audiobookFromDbAfterDownload;

      switch (audiobookFromDbAfterDownloadResult) {
        case Ok<Audiobook?>():
          audiobookFromDbAfterDownload =
              audiobookFromDbAfterDownloadResult.value;
        case Error<Audiobook?>():
          _log.d(
            "audiobookFromDbAfterDownloadResult is Error:\t$audiobookFromDbAfterDownloadResult",
          );
          throw audiobookFromDbAfterDownloadResult.error;
      }
      if (audiobookFromDbAfterDownload == null ||
          audiobookFromDbAfterDownload.imagePath != audiobookFromDb.imagePath) {
        throw Exception(
          "audiobookFromDbAfterDownload == null || audiobookFromDbAfterDownload.imagePath != audiobookFromDb.imagePath",
        );
      }
      if (audiobookFromDbAfterDownload.localImagePath != null) {
        //image already downloaded
        //no need to download again
        return;
      }

      final Result<void> saveAudiobookResult = await _localDbService
          .saveAudiobook(
            audiobookFromDbAfterDownload.copyWith(
              localImagePath: localFilePath,
            ),
          );

      if (saveAudiobookResult is Error) {
        throw saveAudiobookResult.error;
      }
      //done downloading, remove from tasks
      _imageDownloadTasksMap.remove(audiobookId);
    } catch (e) {
      _log.d("startDownloadAudiobookImage catch", error: e);
    }
  }

  @override
  Future<void> cancelDownloadAudiobookImage(String audiobookId) async {
    if (_imageDownloadTasksMap.containsKey(audiobookId)) {
      _log.d("cancelDownloadAudiobookImage new task audiobookId:$audiobookId");
      final cancelable = _imageDownloadTasksMap.remove(audiobookId);
      await cancelable?.cancel();
    }
  }

  Future<Result<void>> _parseAndUpdateJsonData() async {
    if (internetStatusVN.value == InternetStatus.disconnected) {
      return Result.error("No Internet");
    }

    final dataVersionResult = await _userSettingsRepository
        .fetchLocalDataVersion();
    final int? localDataVersion;

    switch (dataVersionResult) {
      case Ok<int?>():
        localDataVersion = dataVersionResult.value;
      case Error<int?>():
        _log.e("dataVersionResult error", error: dataVersionResult.error);
        return dataVersionResult;
    }
    final serverDataVersionResult = await _remoteDbService.fetchDataVersion();

    final int serverDataVersion;
    switch (serverDataVersionResult) {
      case Ok<int>():
        serverDataVersion = serverDataVersionResult.value;
      case Error<int>():
        _log.e(
          "serverDataVersionResult error",
          error: serverDataVersionResult.error,
        );
        return serverDataVersionResult;
    }

    _log.i(
      "localDataVersion:$localDataVersion\nserverDataVersion:$serverDataVersion",
    );

    if (localDataVersion == null || localDataVersion < serverDataVersion) {
      _log.d("downloading new data");
      // download and parse latest data from data_minified.json
      final dataJsonStringResult = await _remoteStorageService
          .getDataJsonString();

      final String jsonString;

      switch (dataJsonStringResult) {
        case Ok<String>():
          jsonString = dataJsonStringResult.value;
        case Error<String>():
          _log.i(
            "dataJsonStringResult is Error",
            error: dataJsonStringResult.error,
          );
          return dataJsonStringResult;
      }

      try {
        Map<String, Object?> jsonData = jsonDecode(jsonString);
        //parse json from "data"

        // first let's parse authors
        // download list of all authors from db
        // for every author check if an author already exists using it's id
        // if yes, check if it's imagePath has changed
        // if it has changed, delete the file at the old localImagePath if it exists
        // delete any extra authors from db, which are no longer present in server data

        final authorsJson = jsonData[Constants.authorsDbKey] as List<dynamic>;
        final allAuthorsFromDbResult = await _localDbService.getAllAuthors();
        final List<Author> allAuthorsFromDb;

        switch (allAuthorsFromDbResult) {
          case Ok<List<Author>>():
            allAuthorsFromDb = allAuthorsFromDbResult.value;
          case Error<List<Author>>():
            _log.d("allAuthorsFromDbResult is Error:\t$allAuthorsFromDbResult");
            return Result.error(allAuthorsFromDbResult.error);
        }

        for (final authorJson in authorsJson) {
          final authorJsonAsMap = authorJson as Map<String, Object?>;
          final Author author;
          try {
            author = Author.fromJson(authorJsonAsMap);
          } catch (e) {
            _log.d(
              "error Author.fromJson(authorJsonAsMap)\nauthorJsonAsMap:\n$authorJsonAsMap",
            );
            return Result.error(e);
          }

          final Author? authorFromDb = allAuthorsFromDb.firstWhereOrNull(
            (a) => (a.id == author.id),
          );

          final localImagePath = authorFromDb?.localImagePath;

          final Result<void> authorSaveResult = await _localDbService
              .saveAuthor(
                author.copyWith(
                  localImagePath:
                      (authorFromDb != null &&
                          author.imagePath == authorFromDb.imagePath)
                      ? localImagePath
                      : null,
                ),
              );

          if (authorSaveResult is Error) {
            _log.d("authorSaveResult is Error", error: authorSaveResult.error);
            return authorSaveResult;
          }
          if (authorFromDb != null) {
            allAuthorsFromDb.removeWhere((a) => (a.id == author.id));
          }
        }

        for (final authorToDelete in allAuthorsFromDb) {
          _log.i("deleting author with id ${authorToDelete.id}");
          _localDbService.deleteAuthorById(authorToDelete.id);
        }

        //then let's parse audiobooks
        //for every audiobook check if an audiobook already exists using it's id
        // if yes, check if it's imagePath has changed
        // if it has changed, delete the file at the old localImagePath if it exists
        final audiobooksJson =
            jsonData[Constants.audioBooksDbKey] as List<dynamic>;
        final allAudiobooksFromDbResult = await _localDbService
            .getAllAudiobooks();
        final List<Audiobook> allAudiobooksFromDb;

        switch (allAudiobooksFromDbResult) {
          case Ok<List<Audiobook>>():
            allAudiobooksFromDb = allAudiobooksFromDbResult.value;
          case Error<List<Audiobook>>():
            _log.d(
              "allAudiobooksFromDbResult is Error:\t$allAudiobooksFromDbResult",
            );
            return Result.error(allAudiobooksFromDbResult.error);
        }

        for (final audiobookJson in audiobooksJson) {
          final audiobookJsonMap = audiobookJson as Map<String, Object?>;

          final Audiobook audiobook;
          try {
            audiobook = Audiobook.fromJson(audiobookJsonMap);
          } catch (e) {
            _log.d(
              "error Audiobook.fromJson(authorJsonAsMap)\naudiobookJsonMap:\n$audiobookJsonMap",
            );
            return Result.error(e);
          }

          final Audiobook? audiobookFromDb = allAudiobooksFromDb
              .firstWhereOrNull((a) => (a.id == audiobook.id));

          final localImagePath = audiobookFromDb?.localImagePath;

          final Result<void> audiobookSaveResult = await _localDbService
              .saveAudiobook(
                audiobook.copyWith(
                  localImagePath:
                      (audiobookFromDb != null &&
                          audiobook.imagePath == audiobookFromDb.imagePath)
                      ? localImagePath
                      : null,
                ),
              );

          if (audiobookSaveResult is Error) {
            _log.d(
              "authorSaveResult is Error",
              error: audiobookSaveResult.error,
            );
            return audiobookSaveResult;
          }
          if (audiobookFromDb != null) {
            allAudiobooksFromDb.removeWhere((a) => (a.id == audiobook.id));
          }
        }

        for (final audiobookToDelete in allAudiobooksFromDb) {
          _log.i("deleting audiobook with id ${audiobookToDelete.id}");
          _localDbService.deleteAudiobookById(audiobookToDelete.id);
        }

        //then let's parse chapters
        //for every chapter check if a chapter already exists using it's id
        // if yes, check if it's audioPath has changed
        // if it has changed, delete the file at the old localAudioPath if it exists
        final chaptersJson = jsonData[Constants.chaptersDbKey] as List<dynamic>;

        final allChaptersFromDbResult = await _localDbService.getAllChapters();
        final List<Chapter> allChaptersFromDb;

        switch (allChaptersFromDbResult) {
          case Ok<List<Chapter>>():
            allChaptersFromDb = allChaptersFromDbResult.value;
          case Error<List<Chapter>>():
            _log.d(
              "allChaptersFromDbResult is Error:\t$allChaptersFromDbResult",
            );
            return Result.error(allChaptersFromDbResult.error);
        }

        for (final chapterJson in chaptersJson) {
          final chapterJsonMap = chapterJson as Map<String, Object?>;

          final Chapter chapter;
          try {
            chapter = Chapter.fromJson(chapterJsonMap);
          } catch (e) {
            _log.d(
              "error Chapter.fromJson(chapterJsonMap)\nchapterJsonMap:\n$chapterJsonMap",
            );
            return Result.error(e);
          }

          final Chapter? chapterFromDb = allChaptersFromDb.firstWhereOrNull(
            (c) => (c.id == chapter.id),
          );

          final localAudioPath = chapterFromDb?.localAudioPath;

          final Result<void> chapterSaveResult = await _localDbService
              .saveChapter(
                chapter.copyWith(
                  localAudioPath:
                      (chapterFromDb != null &&
                          (chapter.audioPath == chapterFromDb.audioPath ||
                              chapter.duration == chapterFromDb.duration))
                      ? localAudioPath
                      : null,
                ),
              );

          if (chapterSaveResult is Error) {
            _log.d(
              "chapterSaveResult is Error",
              error: chapterSaveResult.error,
            );
            return chapterSaveResult;
          }
          if (chapterFromDb != null) {
            allChaptersFromDb.removeWhere((c) => (c.id == chapter.id));
          }
        }

        for (final chapterToDelete in allChaptersFromDb) {
          _log.i("deleting chapter with id ${chapterToDelete.id}");
          _localDbService.deleteChapterById(chapterToDelete.id);
        }

        //(also, later update audiobook's current timestamp, duration left, and update bookmarks, if any, as required)

        // saveLocalDataVersion
        _userSettingsRepository.saveLocalDataVersion(
          localDataVersion: serverDataVersion,
        );
      } catch (e) {
        return Result.error(e);
      }
    }

    return Result.ok(null);
  }

  @override
  Stream<List<Author>> getAllAuthorsStream() {
    return _localDbService.getAllAuthorsStream();
  }

  @override
  Stream<Author?> getAuthorByIdStream(String id) {
    return _localDbService.getAuthorByIdStream(id);
  }

  @override
  Stream<List<Audiobook>> getAudiobooksByAuthorIdStream(String authorId) {
    return _localDbService.getAudiobooksByAuthorIdStream(authorId);
  }

  @override
  FutureOr onDispose() async {
    await cancelImageDownloads();
    _refreshDataCommand.dispose();
    _internetStatusVNSubscription.cancel();
    await _compositeSubscription.dispose();
    await _internetStatusSubscription?.cancel();
    _internetStatusVN.dispose();
  }

  Future cancelImageDownloads() async {
    for (final downloadTaskEntry in _imageDownloadTasksMap.entries) {
      await downloadTaskEntry.value.cancel();
      _imageDownloadTasksMap.remove(downloadTaskEntry.key);
    }
  }

  StreamSubscription<InternetStatus> subscribeInternetChanges() {
    return InternetConnection().onStatusChange.listen((InternetStatus status) {
      _internetStatusVN.value = status;
    });
  }

  @override
  Stream<List<AudiobookResumeLocation>>
  getAudiobookResumeLocationsByAuthorIdStream(String authorId) {
    return _localDbService.getAudiobookResumeLocationsByAuthorIdStream(
      authorId,
    );
  }

  @override
  Stream<List<Chapter>> getChaptersByAuthorIdStream(String authorId) {
    return _localDbService.getChaptersByAuthorIdStream(authorId);
  }

  @override
  Stream<List<String>> getInLibraryAudiobookIdsByAuthorIdStream(
    String authorId,
  ) {
    return _localDbService.getInLibraryAudiobookIdsByAuthorIdStream(authorId);
  }

  @override
  Stream<Audiobook?> getAudiobookByIdStream(String id) {
    return _localDbService.getAudiobookByIdStream(id);
  }

  @override
  Stream<AudiobookResumeLocation?>
  getAudiobookResumeLocationByAudiobookIdStream(String audiobookId) {
    return _localDbService.getAudiobookResumeLocationByAudiobookIdStream(
      audiobookId,
    );
  }

  @override
  Stream<Author?> getAuthorByAudiobookIdStream(String audiobookId) {
    return _localDbService.getAuthorByAudiobookIdStream(audiobookId);
  }

  @override
  Stream<List<Chapter>> getChaptersByAudiobookIdStream(String audiobookId) {
    return _localDbService.getChaptersByAudiobookIdStream(audiobookId);
  }

  @override
  Stream<bool> getInLibraryByAudiobookIdStream(String audiobookId) {
    return _localDbService.getInLibraryByAudiobookIdStream(audiobookId);
  }

  @override
  Future<Result<void>> addAudiobookToLibrary(String audiobookId) {
    return _localDbService.addAudiobookToLibrary(audiobookId);
  }

  @override
  Future<Result<void>> removeAudiobookFromLibrary(String audiobookId) {
    return _localDbService.removeAudiobookFromLibrary(audiobookId);
  }

  @override
  Stream<List<AudiobookResumeLocation>>
  getInLibraryAudiobookResumeLocationsStream() {
    return _localDbService.getInLibraryAudiobookResumeLocationsStream();
  }

  @override
  Stream<List<Audiobook>> getInLibraryAudiobooksStream() {
    return _localDbService.getInLibraryAudiobooksStream();
  }

  @override
  Stream<List<Author>> getInLibraryAuthorsStream() {
    return _localDbService.getInLibraryAuthorsStream();
  }

  @override
  Stream<List<Chapter>> getInLibraryChaptersStream() {
    return _localDbService.getInLibraryChaptersStream();
  }

  Future<void> initDownloader() async {
    FileDownloader().updates
        .listen((update) {
          final currentUpdates = _downloadTasksUpdates.value;

          switch (update) {
            case TaskStatusUpdate():
              if (update.status.isFinalState) {
                //remove task from _downloadTasksUpdates
                currentUpdates.remove(update.task.taskId);
              } else {
                //just update the status in _downloadTasksUpdates
                currentUpdates.update(
                  update.task.taskId,
                  (oldUpdate) => (oldUpdate.copyWith(status: update.status)),
                  ifAbsent: () => (TaskWithStatusAndProgress(
                    task: update.task,
                    status: update.status,
                  )),
                );
              }
            case TaskProgressUpdate():
              final updateProgress = update.progress;
              currentUpdates.update(
                update.task.taskId,
                (oldUpdate) => (oldUpdate.copyWith(progress: updateProgress)),
                ifAbsent: () => (TaskWithStatusAndProgress(
                  task: update.task,
                  progress: updateProgress,
                )),
              );
          }

          _downloadTasksUpdates.value = currentUpdates;
        })
        .addTo(_compositeSubscription);
    await FileDownloader().start();
  }

  @override
  Future<Result<void>> downloadAudiobook(
    BuildContext context,
    String audiobookId,
  ) async {
    //check if audiobook not aleady downloading
    // - if yes, skip this download
    final records = await FileDownloader().database.allRecords(
      group: audiobookId,
    );
    if (records.any((record) => (record.status.isNotFinalState))) {
      return Result.error("already downloading for this audiobook");
    }

    if (context.mounted) {
      final preDownloadChecksResult = await _preDownloadChecks(context);
      if (preDownloadChecksResult is Error) {
        return preDownloadChecksResult;
      }
    }
    //get audiobook chapters

    //remove chapters which are already downloading individually (without group tag)

    //enqueue download remaining chapters with group tag

    return Result.ok(null);
  }

  @override
  Future<Result<void>> removeAudiobook(audiobookId) async {
    // TODO: implement removeAudiobook
    return Result.ok(null);
  }

  Future<Result<void>> _preDownloadChecks(BuildContext context) async {
    final bool? showDownloadNotifications =
        _userSettingsRepository.showDownloadNotificationsVN.value;

    DownloadsConnectionPreference? downloadsConnectionPreference =
        _userSettingsRepository.downloadsConnectionPreferenceVN.value;

    if (showDownloadNotifications == null ||
        showDownloadNotifications == true) {
      // check permission status
      // if denied, show dialog explaining permission, and request for permission
      final permissionType = PermissionType.notifications;
      PermissionStatus status = await FileDownloader().permissions.status(
        permissionType,
      );
      if (status != PermissionStatus.granted) {
        if (context.mounted) {
          final bool requestPermission;
          if (showDownloadNotifications == null) {
            requestPermission =
                await _showDownloadNotificationsRationaleDialog(context) ??
                false;
          } else {
            requestPermission = true;
          }

          final saveShowDownloadNotificationsResult =
              await _userSettingsRepository.saveShowDownloadNotifications(
                showDownloadNotifications: requestPermission,
              );

          switch (saveShowDownloadNotificationsResult) {
            case Ok<void>():
              break;
            case Error<void>():
              return Result.error("Error saveShowDownloadNotifications");
          }
        } else {
          return Result.error("!context.mounted for showDownloadNotifications");
        }
      }
    }

    if (context.mounted) {
      if (downloadsConnectionPreference == null) {
        downloadsConnectionPreference =
            await _showDownloadsConnectionPreferenceDialog(context);
        if (downloadsConnectionPreference != null) {
          final downloadConnectionPreferenceResult =
              await _userSettingsRepository.saveDownloadsConnectionPreference(
                downloadsConnectionPreference: downloadsConnectionPreference,
              );
          switch (downloadConnectionPreferenceResult) {
            case Ok<void>():
              break;
            case Error<void>():
              return Result.error("Error saveDownloadConnectionPreference");
          }
        }
      }
    } else {
      return Result.error("!context.mounted for downloadConnectionPreference");
    }

    return Result.ok(null);
  }

  Future<bool?> _showDownloadNotificationsRationaleDialog(
    BuildContext context,
  ) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context)?.titleShowDownloadNotifications ?? "",
        ),
        content: SingleChildScrollView(
          child: Text(
            AppLocalizations.of(context)?.messageCanBeChangedInSettings ?? "",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)?.labelNo ?? ""),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context)?.labelYes ?? ""),
          ),
        ],
      ),
    );
  }

  Future<DownloadsConnectionPreference?>
  _showDownloadsConnectionPreferenceDialog(BuildContext context) {
    return showDialog<DownloadsConnectionPreference?>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context)?.labelDownloadsConnectionPreference ??
              "",
        ),
        content: SingleChildScrollView(
          child: Text(
            AppLocalizations.of(context)?.messageCanBeChangedInSettings ?? "",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context, DownloadsConnectionPreference.wifiOnly),
            child: Text(AppLocalizations.of(context)?.labelWifiOnly ?? ""),
          ),
          TextButton(
            onPressed: () => Navigator.pop(
              context,
              DownloadsConnectionPreference.anyNetwork,
            ),
            child: Text(AppLocalizations.of(context)?.labelAnyNetwork ?? ""),
          ),
        ],
      ),
    );
  }
}
