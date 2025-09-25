import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart' hide Result;
import 'package:collection/collection.dart';
import 'package:command_it/command_it.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:sikh_audiobooks_flutter/config/constants.dart';
import 'package:sikh_audiobooks_flutter/data/services/local_db_service.dart';
import 'package:sikh_audiobooks_flutter/data/services/remote_db_service.dart';
import 'package:sikh_audiobooks_flutter/data/services/remote_storage_service.dart';
import 'package:sikh_audiobooks_flutter/data/services/shared_preferences_service.dart';
import 'package:sikh_audiobooks_flutter/domain/models/audiobook/audiobook.dart';
import 'package:sikh_audiobooks_flutter/domain/models/author/author.dart';
import 'package:sikh_audiobooks_flutter/domain/models/chapter/chapter.dart';
import 'package:sikh_audiobooks_flutter/utils/result.dart';

abstract class AudiobooksRepository extends Disposable {
  /// Fetches Author List from server or local (if available)
  /// First checks if the "data_version" from realtime database
  /// and compares with locally saved in shared prefs
  /// - updates local text data, if obsolete
  /// - downloads any author images, if missing or obsolete
  // Future<List<Author>> fetchAuthorList();
  Command<void, Result<void>?> get refreshDataCommand;
  Stream<List<Author>> getAllAuthorsStream();
  Future<void> startDownloadAuthorImage(String authorId);
  Future<void> cancelDownloadAuthorImage(String authorId);
  Stream<Author?> getAuthorByIdStream(String id);
  Stream<List<Audiobook>> getAudiobooksByAuthorId(String authorId);
}

class AudiobooksRepositoryProd extends AudiobooksRepository {
  AudiobooksRepositoryProd({
    required SharedPreferencesService sharedPreferencesService,
    required RemoteDbService remoteDbService,
    required RemoteStorageService remoteStorageService,
    required LocalDbService dbService,
    required Directory appDocsDir,
  }) : _sharedPreferencesService = sharedPreferencesService,
       _remoteDbService = remoteDbService,
       _remoteStorageService = remoteStorageService,
       _localDbService = dbService,
       _appDocsDir = appDocsDir;

  final _log = Logger();
  final SharedPreferencesService _sharedPreferencesService;
  final RemoteDbService _remoteDbService;
  final RemoteStorageService _remoteStorageService;
  final LocalDbService _localDbService;
  final Map<String, CancelableOperation> _downloadTasksMap = {};
  final Directory _appDocsDir;

  late final Command<void, Result<void>?> _refreshDataCommand =
      Command.createAsyncNoParam(() async {
        _log.d("_refreshDataCommand executing");
        final result = await _parseAndUpdateJsonData();

        if (result is Error) {
          _log.d("result is Error", error: result.error);
          return result;
        }

        return Result.ok(null);
      }, initialValue: null)..execute();

  @override
  Command<void, Result<void>?> get refreshDataCommand => _refreshDataCommand;

  @override
  Future<void> startDownloadAuthorImage(String authorId) async {
    try {
      if (_downloadTasksMap.containsKey(authorId)) {
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
        "startDownloadAuthorImage new task authorId:$authorId\nlocalFilePath:$localFilePath",
      );

      final cancelable = _remoteStorageService.downloadFileCancelable(
        storageFilePath: authorFromDb.imagePath,
        localFilePath: localFilePath,
      );
      _downloadTasksMap[authorId] = cancelable;
      await cancelable.value;

      final Result<void> saveAuthorResult = await _localDbService.saveAuthor(
        authorFromDb.copyWith(localImagePath: localFilePath),
      );

      if (saveAuthorResult is Error) {
        throw saveAuthorResult.error;
      }
    } catch (e) {
      _log.d("startDownloadAuthorImage catch", error: e);
    }
  }

  @override
  Future<void> cancelDownloadAuthorImage(String authorId) async {
    if (_downloadTasksMap.containsKey(authorId)) {
      _log.d("cancelDownloadAuthorImage new task authorId:$authorId");
      final cancelable = _downloadTasksMap.remove(authorId);
      await cancelable?.cancel();
    }
  }

  Future<Result<void>> _parseAndUpdateJsonData() async {
    final dataVersionResult = await _sharedPreferencesService
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
                          chapter.audioPath == chapterFromDb.audioPath)
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
        _sharedPreferencesService.saveLocalDataVersion(serverDataVersion);
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
  Stream<List<Audiobook>> getAudiobooksByAuthorId(String authorId) {
    return _localDbService.getAudiobooksByAuthorId(authorId);
  }

  @override
  FutureOr onDispose() {}
}
