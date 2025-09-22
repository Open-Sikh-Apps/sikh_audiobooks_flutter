import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart' hide Result;
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
  Future<Result<void>> refreshDiscoverData();
  Stream<List<Author>> getAllAuthorsStream();
  Future<void> startDownloadAuthorImage(String authorId);
  Future<void> cancelDownloadAuthorImage(String authorId);
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

  @override
  Future<Result<void>> refreshDiscoverData() async {
    final parseAndUpdateResult = await _parseAndUpdateJsonData();
    if (parseAndUpdateResult is Error) {
      return Result.error(parseAndUpdateResult.error);
    }

    return Result.ok(null);
  }

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

      _log.d("startDownloadAuthorImage new task authorId:$authorId");

      final fileExtension = authorFromDb.imagePath.split(".").last;
      final localFileName = "${authorFromDb.id}$fileExtension";
      final localFilePath = join(_appDocsDir.path, localFileName);
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
        // for every author check if an author already exists using it's id
        // if yes, check if it's imagePath has changed
        // if it has changed, delete the file at the old localImagePath if it exists
        final authorsJson = jsonData[Constants.authorsDbKey] as List<dynamic>;
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

          final Result<Author?> authorFromDbResult = await _localDbService
              .getAuthorById(author.id);

          final Author? authorFromDb;

          switch (authorFromDbResult) {
            case Ok<Author?>():
              authorFromDb = authorFromDbResult.value;
            case Error<Author?>():
              _log.d("authorFromDbResult is Error:\t$authorFromDbResult");
              return Result.error(authorFromDbResult.error);
          }

          if (authorFromDb != null &&
              author.imagePath != authorFromDb.imagePath &&
              authorFromDb.localImagePath != null) {
            //delete file at authorFromDb.localImagePath

            try {
              final fileToDelete = File(authorFromDb.localImagePath ?? "");
              if (await fileToDelete.exists()) {
                await fileToDelete.delete();
              }
            } catch (e) {
              _log.d("error deleting file at: ${authorFromDb.localImagePath}");
              return Result.error(e);
            }
          }

          final Result<void> authorSaveResult = await _localDbService
              .saveAuthor(author);

          if (authorSaveResult is Error) {
            _log.d("authorSaveResult is Error", error: authorSaveResult.error);
            return authorSaveResult;
          }
        }

        //then let's parse audiobooks
        //for every audiobook check if an audiobook already exists using it's id
        // if yes, check if it's imagePath has changed
        // if it has changed, delete the file at the old localImagePath if it exists
        final audiobooksJson =
            jsonData[Constants.audioBooksDbKey] as List<dynamic>;
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

          final Result<Audiobook?> audiobookFromDbResult = await _localDbService
              .getAudiobookById(audiobook.id);

          final Audiobook? audiobookFromDb;

          switch (audiobookFromDbResult) {
            case Ok<Audiobook?>():
              audiobookFromDb = audiobookFromDbResult.value;
            case Error<Audiobook?>():
              _log.d("audiobookFromDbResult is Error:\t$audiobookFromDbResult");
              return Result.error(audiobookFromDbResult.error);
          }

          if (audiobookFromDb != null &&
              audiobook.imagePath != audiobookFromDb.imagePath &&
              audiobookFromDb.localImagePath != null) {
            //delete file at authorFromDb.localImagePath

            try {
              final fileToDelete = File(audiobookFromDb.localImagePath ?? "");
              if (await fileToDelete.exists()) {
                await fileToDelete.delete();
              }
            } catch (e) {
              _log.d(
                "error deleting file at: ${audiobookFromDb.localImagePath}",
              );
              return Result.error(e);
            }
          }

          final Result<void> audiobookSaveResult = await _localDbService
              .saveAudiobook(audiobook);

          if (audiobookSaveResult is Error) {
            _log.d(
              "authorSaveResult is Error",
              error: audiobookSaveResult.error,
            );
            return audiobookSaveResult;
          }
        }

        //then let's parse chapters
        //for every chapter check if a chapter already exists using it's id
        // if yes, check if it's audioPath has changed
        // if it has changed, delete the file at the old localAudioPath if it exists
        final chaptersJson = jsonData[Constants.chaptersDbKey] as List<dynamic>;

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

          final Result<Chapter?> chapterFromDbResult = await _localDbService
              .getChapterById(chapter.id);

          final Chapter? chapterFromDb;

          switch (chapterFromDbResult) {
            case Ok<Chapter?>():
              chapterFromDb = chapterFromDbResult.value;
            case Error<Chapter?>():
              _log.d("chapterFromDbResult is Error:\t$chapterFromDbResult");
              return Result.error(chapterFromDbResult.error);
          }

          if (chapterFromDb != null &&
              chapter.audioPath != chapterFromDb.audioPath &&
              chapterFromDb.localAudioPath != null) {
            //delete file at authorFromDb.localImagePath

            try {
              final fileToDelete = File(chapterFromDb.localAudioPath ?? "");
              if (await fileToDelete.exists()) {
                await fileToDelete.delete();
              }
            } catch (e) {
              _log.d("error deleting file at: ${chapterFromDb.localAudioPath}");
              return Result.error(e);
            }
          }

          final Result<void> chapterSaveResult = await _localDbService
              .saveChapter(chapter);

          if (chapterSaveResult is Error) {
            _log.d(
              "chapterSaveResult is Error",
              error: chapterSaveResult.error,
            );
            return chapterSaveResult;
          }
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
  FutureOr onDispose() {}
}
