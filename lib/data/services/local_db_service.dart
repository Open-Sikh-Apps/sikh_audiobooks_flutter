import 'dart:async';
import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sembast/sembast.dart';
import 'package:sikh_audiobooks_flutter/config/constants.dart';
import 'package:sikh_audiobooks_flutter/domain/models/api_duration/api_duration.dart';
import 'package:sikh_audiobooks_flutter/domain/models/audiobook/audiobook.dart';
import 'package:sikh_audiobooks_flutter/domain/models/audiobook_resume_location/audiobook_resume_location.dart';
import 'package:sikh_audiobooks_flutter/domain/models/author/author.dart';
import 'package:sikh_audiobooks_flutter/domain/models/chapter/chapter.dart';
import 'package:sikh_audiobooks_flutter/utils/result.dart';

class LocalDbService extends Disposable {
  LocalDbService({required Database db}) : _db = db {
    //setup triggers for database

    // TODO do something if any of the items that are changed are in playing queue or currenly playing

    _authorsStore.addOnChangesListener(_db, _authorOnChanges);
    // TODO test audiobook listener
    _audiobooksStore.addOnChangesListener(_db, _audiobookOnChanges);
    // TODO test chapter listener
    _chaptersStore.addOnChangesListener(_db, _chapterOnChanges);
  }
  final _log = Logger();
  final Database _db;
  final _authorsStore = stringMapStoreFactory.store(Constants.authorsDbKey);
  final _audiobooksStore = stringMapStoreFactory.store(
    Constants.audioBooksDbKey,
  );
  final _chaptersStore = stringMapStoreFactory.store(Constants.chaptersDbKey);

  final _audiobookResumeLocationsStore = stringMapStoreFactory.store(
    Constants.audiobookResumeLocationsDbKey,
  );

  final _bookmarksStore = stringMapStoreFactory.store(Constants.bookmarksDbKey);

  final _inLibraryStore = stringMapStoreFactory.store(Constants.inLibraryDbKey);

  // Author

  Future<Result<Author?>> getAuthorById(String id) async {
    try {
      final record = await _authorsStore.record(id).get(_db);
      if (record == null) {
        return Result.ok(null);
      } else {
        final authorFromDb = Author.fromJson(record);
        return Result.ok(authorFromDb);
      }
    } catch (e) {
      return Result.error(e);
    }
  }

  Stream<Author?> getAuthorByIdStream(String id) {
    return _authorsStore.record(id).onSnapshot(_db).map((snapshot) {
      if (snapshot == null) {
        return null;
      } else {
        return Author.fromJson(snapshot.value);
      }
    });
  }

  Future<Result<void>> saveAuthor(Author author) async {
    try {
      await _authorsStore.record(author.id).put(_db, author.toJson());
      return Result.ok(null);
    } catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> deleteAuthorById(String authorId) async {
    try {
      await _authorsStore.record(authorId).delete(_db);
      return Result.ok(null);
    } catch (e) {
      return Result.error(e);
    }
  }

  Stream<List<Author>> getAllAuthorsStream() {
    final query = _authorsStore.query(
      finder: Finder(sortOrders: [SortOrder(_authorOrderKey)]),
    );

    return query
        .onSnapshots(_db)
        .map(
          (snapshots) => (snapshots
              .map((snapshot) => (Author.fromJson(snapshot.value)))
              .toList()),
        );
  }

  Future<Result<List<Author>>> getAllAuthors() async {
    try {
      final finder = Finder(sortOrders: [SortOrder(_authorOrderKey)]);
      final records = await _authorsStore.find(_db, finder: finder);
      return Result.ok(
        records.map((record) => Author.fromJson(record.value)).toList(),
      );
    } catch (e) {
      return Result.error(e);
    }
  }

  Stream<Author?> getAuthorByAudiobookIdStream(String audiobookId) {
    return getAudiobookByIdStream(audiobookId).flatMap((audiobook) {
      if (audiobook == null) {
        return Stream.value(null);
      }
      return getAuthorByIdStream(audiobook.authorId);
    });
  }

  Stream<List<Author>> getAuthorsByIdsStream(List<String> authorIds) {
    final query = _authorsStore.query(
      finder: Finder(filter: Filter.inList(Field.key, authorIds)),
    );

    return query
        .onSnapshots(_db)
        .map(
          (snapshots) => (snapshots
              .map((snapshot) => (Author.fromJson(snapshot.value)))
              .toList()),
        );
  }

  FutureOr<void> _authorOnChanges(
    Transaction txn,
    List<RecordChange<String, Map<String, Object?>>> changes,
  ) async {
    try {
      for (final change in changes) {
        //when an author is updated, check if imagePath is changed and if localImagePath is set for the older snapshot and if localImagePath is not set for new snapshot, if yes then delete the file at localImagePath.
        if (change.isUpdate) {
          final oldAuthorJson = change.oldSnapshot?.value;
          final newAuthorJson = change.newSnapshot?.value;
          if (oldAuthorJson != null && newAuthorJson != null) {
            final oldAuthor = Author.fromJson(oldAuthorJson);
            final newAuthor = Author.fromJson(newAuthorJson);
            final oldLocalImagePath = oldAuthor.localImagePath;
            final newLocalImagePath = newAuthor.localImagePath;

            if ((oldAuthor.imagePath != newAuthor.imagePath) &&
                (oldLocalImagePath != null) &&
                (newLocalImagePath == null)) {
              _log.d("deleteding oldLocalImagePath: $oldLocalImagePath");
              final fileToDelete = File(oldLocalImagePath);
              if (await fileToDelete.exists()) {
                await fileToDelete.delete();
              }
            }
          }
        }

        //when an author is deleted, delete any file at localImagePath if available.
        if (change.isDelete) {
          final oldAuthorJson = change.oldSnapshot?.value;
          if (oldAuthorJson != null) {
            final oldAuthor = Author.fromJson(oldAuthorJson);
            final oldLocalImagePath = oldAuthor.localImagePath;

            if (oldLocalImagePath != null) {
              _log.d("deleteding oldLocalImagePath: $oldLocalImagePath");
              final fileToDelete = File(oldLocalImagePath);
              if (await fileToDelete.exists()) {
                await fileToDelete.delete();
              }
            }
          }
        }
      }
    } catch (e) {
      _log.e("error in author trigger", error: e);
    }
  }
  // Audiobook

  Future<Result<Audiobook?>> getAudiobookById(String id) async {
    try {
      final record = await _audiobooksStore.record(id).get(_db);
      if (record == null) {
        return Result.ok(null);
      } else {
        return Result.ok(Audiobook.fromJson(record));
      }
    } catch (e) {
      return Result.error(e);
    }
  }

  Stream<Audiobook?> getAudiobookByIdStream(String id) {
    return _audiobooksStore.record(id).onSnapshot(_db).map((snapshot) {
      if (snapshot == null) {
        return null;
      } else {
        return Audiobook.fromJson(snapshot.value);
      }
    });
  }

  Future<Result<void>> saveAudiobook(Audiobook audiobook) async {
    try {
      await _audiobooksStore.record(audiobook.id).put(_db, audiobook.toJson());
      return Result.ok(null);
    } catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> deleteAudiobookById(String audiobookId) async {
    try {
      await _audiobooksStore.record(audiobookId).delete(_db);
      return Result.ok(null);
    } catch (e) {
      return Result.error(e);
    }
  }

  Stream<List<Audiobook>> getAudiobooksByAuthorIdStream(String authorId) {
    final query = _audiobooksStore.query(
      finder: Finder(filter: Filter.equals(_audiobookAuthorIdKey, authorId)),
    );
    return query
        .onSnapshots(_db)
        .map(
          (snapshots) => (snapshots
              .map((snapshot) => (Audiobook.fromJson(snapshot.value)))
              .toList()),
        );
  }

  Future<Result<List<Audiobook>>> getAllAudiobooks() async {
    try {
      final records = await _audiobooksStore.find(_db);
      return Result.ok(
        records.map((record) => Audiobook.fromJson(record.value)).toList(),
      );
    } catch (e) {
      return Result.error(e);
    }
  }

  Stream<List<Audiobook>> getAudiobooksByIdsStream(List<String> audiobookIds) {
    final query = _audiobooksStore.query(
      finder: Finder(filter: Filter.inList(Field.key, audiobookIds)),
    );
    return query
        .onSnapshots(_db)
        .map(
          (snapshots) => (snapshots
              .map((snapshot) => (Audiobook.fromJson(snapshot.value)))
              .toList()),
        );
  }

  FutureOr<void> _audiobookOnChanges(
    Transaction txn,
    List<RecordChange<String, Map<String, Object?>>> changes,
  ) async {
    try {
      for (final change in changes) {
        //when an audiobook is updated, check if imagePath is changed and if localImagePath is set for the older snapshot and if localImagePath is not set fro the new snapshot, if yes then delete the file at localImagePath.

        if (change.isUpdate) {
          final oldJson = change.oldSnapshot?.value;
          final newJson = change.newSnapshot?.value;
          if (oldJson != null && newJson != null) {
            final oldAudiobook = Audiobook.fromJson(oldJson);
            final newAudiobook = Audiobook.fromJson(newJson);
            final oldLocalImagePath = oldAudiobook.localImagePath;
            final newLocalImagePath = newAudiobook.localImagePath;

            if ((oldAudiobook.imagePath != newAudiobook.imagePath) &&
                (oldLocalImagePath != null) &&
                (newLocalImagePath == null)) {
              _log.d("deleteding oldLocalImagePath: $oldLocalImagePath");
              final fileToDelete = File(oldLocalImagePath);
              if (await fileToDelete.exists()) {
                await fileToDelete.delete();
              }
            }
          }
        }

        //when an audiobook is deleted, delete any file at localImagePath if available. delete it's resume location and inLibrary value if available
        if (change.isDelete) {
          final oldJson = change.oldSnapshot?.value;
          if (oldJson != null) {
            final oldAudiobook = Audiobook.fromJson(oldJson);
            final oldLocalImagePath = oldAudiobook.localImagePath;

            if (oldLocalImagePath != null) {
              _log.d("deleteding oldLocalImagePath: $oldLocalImagePath");
              final fileToDelete = File(oldLocalImagePath);
              if (await fileToDelete.exists()) {
                await fileToDelete.delete();
              }
            }
            await _audiobookResumeLocationsStore
                .record(oldAudiobook.id)
                .delete(txn);
            await _inLibraryStore.record(oldAudiobook.id).delete(txn);
          }
        }
      }
    } catch (e) {
      _log.e("error in author trigger", error: e);
    }
  }

  // Chapter

  Future<Result<Chapter?>> getChapterById(String id) async {
    try {
      final record = await _chaptersStore.record(id).get(_db);
      if (record == null) {
        return Result.ok(null);
      } else {
        return Result.ok(Chapter.fromJson(record));
      }
    } catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> saveChapter(Chapter chapter) async {
    try {
      await _chaptersStore.record(chapter.id).put(_db, chapter.toJson());
      return Result.ok(null);
    } catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> deleteChapterById(String chapterId) async {
    try {
      await _chaptersStore.record(chapterId).delete(_db);
      return Result.ok(null);
    } catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<List<Chapter>>> getAllChapters() async {
    try {
      final records = await _chaptersStore.find(_db);
      return Result.ok(
        records.map((record) => Chapter.fromJson(record.value)).toList(),
      );
    } catch (e) {
      return Result.error(e);
    }
  }

  Stream<List<Chapter>> getChaptersByAudiobookIdStream(String audiobookId) {
    final query = _chaptersStore.query(
      finder: Finder(
        filter: Filter.equals(_chapterAudioBookIdKey, audiobookId),
        sortOrders: [SortOrder(_chapterAudioBookOrderKey)],
      ),
    );
    return query
        .onSnapshots(_db)
        .map(
          (snapshots) => (snapshots
              .map((snapshot) => (Chapter.fromJson(snapshot.value)))
              .toList()),
        );
  }

  Stream<List<Chapter>> getChaptersByAudiobookIdsStream(
    List<String> audiobookIds,
  ) {
    final query = _chaptersStore.query(
      finder: Finder(
        filter: Filter.inList(_chapterAudioBookIdKey, audiobookIds),
        sortOrders: [SortOrder(_chapterAudioBookOrderKey)],
      ),
    );
    return query
        .onSnapshots(_db)
        .map(
          (snapshots) => (snapshots
              .map((snapshot) => (Chapter.fromJson(snapshot.value)))
              .toList()),
        );
  }

  Stream<List<Chapter>> getChaptersByAuthorIdStream(String authorId) {
    return getAudiobooksByAuthorIdStream(authorId).flatMap(
      (audiobookIds) => (getChaptersByAudiobookIdsStream(
        audiobookIds.map((a) => (a.id)).toList(),
      )),
    );
  }

  FutureOr<void> _chapterOnChanges(
    Transaction txn,
    List<RecordChange<String, Map<String, Object?>>> changes,
  ) async {
    try {
      for (final change in changes) {
        if (change.isUpdate) {
          //when a chapter is updated, check if audioPath is changed and if localAudioPath is set for the older snapshot and localAudioPath is not set for the new snapshot, if yes then delete the file at localAudioPath.

          final oldJson = change.oldSnapshot?.value;
          final newJson = change.newSnapshot?.value;
          if (oldJson != null && newJson != null) {
            final oldChapter = Chapter.fromJson(oldJson);
            final newChapter = Chapter.fromJson(newJson);
            final oldLocalAudioPath = oldChapter.localAudioPath;
            final newLocalAudioPath = newChapter.localAudioPath;

            if ((oldChapter.audioPath != newChapter.audioPath) &&
                (oldLocalAudioPath != null) &&
                (newLocalAudioPath == null)) {
              _log.d("deleteding newLocalAudioPath: $oldLocalAudioPath");
              final fileToDelete = File(oldLocalAudioPath);
              if (await fileToDelete.exists()) {
                await fileToDelete.delete();
              }
            }

            // When chapter audioPath is modified, reset the timeLocation to zero for any audiobook resume location with this chapter id

            if ((oldChapter.audioPath != newChapter.audioPath) &&
                (oldChapter.duration != newChapter.duration)) {
              _log.d(
                "audioPath updated: ${newChapter.audioPath}\n udpating its audiobookResumeLocations locationInSeconds to 0",
              );

              await _audiobookResumeLocationsStore.update(
                txn,
                {_audiobookResumeLocationLocationInSecondsKey: 0},
                finder: Finder(
                  filter: Filter.equals(
                    _audiobookResumeLocationChapterIdKey,
                    newChapter.id,
                  ),
                ),
              );
            }
          }
        }

        //when a chapter is deleted, delete any file at localAudioPath if available. reset the resume location to the next chapter if available with timeLocation as zero. If next chapter is not available, then reset the resume location to the end of previous chapter if available. If previous chapter is not available then simply delete this resume location. delete all it's bookmarks.
        if (change.isDelete) {
          final oldJson = change.oldSnapshot?.value;
          if (oldJson != null) {
            final oldChapter = Chapter.fromJson(oldJson);
            final oldLocalAudioPath = oldChapter.localAudioPath;

            if (oldLocalAudioPath != null) {
              _log.d("deleteding oldLocalAudioPath: $oldLocalAudioPath");
              final fileToDelete = File(oldLocalAudioPath);
              if (await fileToDelete.exists()) {
                await fileToDelete.delete();
              }
            }
            //first check if any audiobook resume location exists for this audiobook id and this chapter id

            final audiobookResumeLocationRecord = _audiobookResumeLocationsStore
                .record(oldChapter.audioBookId);

            final audiobookResumeLocationMap =
                await audiobookResumeLocationRecord.get(txn);

            if (audiobookResumeLocationMap != null) {
              final audiobookResumeLocation = AudiobookResumeLocation.fromJson(
                audiobookResumeLocationMap,
              );
              if (audiobookResumeLocation.chapterId == oldChapter.id) {
                // now perform adjustment of this "resume location"
                final nextChapters = (await _chaptersStore.find(
                  txn,
                  finder: Finder(
                    filter: Filter.and([
                      Filter.equals(
                        _chapterAudioBookIdKey,
                        oldChapter.audioBookId,
                      ),
                      Filter.greaterThan(
                        _chapterAudioBookOrderKey,
                        oldChapter.audioBookOrder,
                      ),
                    ]),
                    sortOrders: [SortOrder(_chapterAudioBookOrderKey)],
                  ),
                )).map((snap) => (Chapter.fromJson(snap.value))).toList();
                if (nextChapters.isNotEmpty) {
                  final nextChapter = nextChapters.first;
                  await audiobookResumeLocationRecord.update(txn, {
                    _audiobookResumeLocationChapterIdKey: nextChapter.id,
                    _audiobookResumeLocationLocationInSecondsKey: 0,
                  });
                } else {
                  final previousChapters = (await _chaptersStore.find(
                    txn,
                    finder: Finder(
                      filter: Filter.and([
                        Filter.equals(
                          _chapterAudioBookIdKey,
                          oldChapter.audioBookId,
                        ),
                        Filter.lessThan(
                          _chapterAudioBookOrderKey,
                          oldChapter.audioBookOrder,
                        ),
                      ]),
                      sortOrders: [SortOrder(_chapterAudioBookOrderKey)],
                    ),
                  )).map((snap) => (Chapter.fromJson(snap.value))).toList();
                  if (previousChapters.isNotEmpty) {
                    final prevChapter = previousChapters.last;
                    await audiobookResumeLocationRecord.update(txn, {
                      _audiobookResumeLocationChapterIdKey: prevChapter.id,
                      _audiobookResumeLocationLocationInSecondsKey: prevChapter
                          .duration
                          .toDuration()
                          .inSeconds,
                    });
                  } else {
                    await audiobookResumeLocationRecord.delete(txn);
                  }
                }
              }
            }
            // delete all bookmarks
            await _bookmarksStore.delete(
              txn,
              finder: Finder(
                filter: Filter.equals(_bookmarkChapterIdKey, oldChapter.id),
              ),
            );
          }
        }
      }
    } catch (e) {
      _log.e("error in author trigger", error: e);
    }
  }

  Future<Result<void>> addAudiobookToLibrary(String audiobookId) async {
    try {
      await _inLibraryStore.record(audiobookId).put(_db, {"added": true});
      return Result.ok(null);
    } catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> removeAudiobookFromLibrary(String audiobookId) async {
    try {
      await _inLibraryStore.record(audiobookId).delete(_db);
      return Result.ok(null);
    } catch (e) {
      return Result.error(e);
    }
  }

  Stream<bool> getInLibraryByAudiobookIdStream(String audiobookId) {
    return _inLibraryStore.record(audiobookId).onSnapshot(_db).map((snapshot) {
      if (snapshot == null) {
        return false;
      }
      return true;
    });
  }

  Stream<List<String>> getInLibraryByAudiobookIdsStream(
    List<String> audiobookIds,
  ) {
    final query = _inLibraryStore.query(
      finder: Finder(filter: Filter.inList(Field.key, audiobookIds)),
    );
    return query
        .onSnapshots(_db)
        .map(
          (snapshots) => (snapshots.map((snapshot) => (snapshot.key)).toList()),
        );
  }

  Stream<List<String>> getInLibraryAudiobookIdsByAuthorIdStream(
    String authorId,
  ) {
    return getAudiobooksByAuthorIdStream(authorId).flatMap(
      (audiobookIds) => (getInLibraryByAudiobookIdsStream(
        audiobookIds.map((a) => (a.id)).toList(),
      )),
    );
  }

  Stream<List<String>> getInLibraryAudiobookIdsStream() {
    return _inLibraryStore
        .query()
        .onSnapshots(_db)
        .map((snapshots) => (snapshots.map((s) => (s.key)).toList()));
  }

  Stream<List<Audiobook>> getInLibraryAudiobooksStream() {
    return getInLibraryAudiobookIdsStream().flatMap(
      (audiobookIds) => (getAudiobooksByIdsStream(audiobookIds)),
    );
  }

  Stream<List<Author>> getInLibraryAuthorsStream() {
    return getInLibraryAudiobooksStream()
        .map((audiobooks) => (audiobooks.map((a) => (a.authorId)).toList()))
        .flatMap((authorIds) => (getAuthorsByIdsStream(authorIds)));
  }

  Stream<List<AudiobookResumeLocation>>
  getInLibraryAudiobookResumeLocationsStream() {
    return getInLibraryAudiobookIdsStream().flatMap(
      (audiobookIds) =>
          (getAudiobookResumeLocationsByAudiobookIdsStream(audiobookIds)),
    );
  }

  Stream<List<Chapter>> getInLibraryChaptersStream() {
    return getInLibraryAudiobookIdsStream().flatMap(
      (audiobookIds) => (getChaptersByAudiobookIdsStream(audiobookIds)),
    );
  }

  Stream<AudiobookResumeLocation?>
  getAudiobookResumeLocationByAudiobookIdStream(String audiobookId) {
    return _audiobookResumeLocationsStore
        .record(audiobookId)
        .onSnapshot(_db)
        .map((snapshot) {
          if (snapshot == null) {
            return null;
          } else {
            return AudiobookResumeLocation.fromJson(snapshot.value);
          }
        });
  }

  Stream<List<AudiobookResumeLocation>>
  getAudiobookResumeLocationsByAudiobookIdsStream(List<String> audiobookIds) {
    final query = _audiobookResumeLocationsStore.query(
      finder: Finder(filter: Filter.inList(Field.key, audiobookIds)),
    );
    return query
        .onSnapshots(_db)
        .map(
          (snapshots) => (snapshots
              .map(
                (snapshot) =>
                    (AudiobookResumeLocation.fromJson(snapshot.value)),
              )
              .toList()),
        );
  }

  Stream<List<AudiobookResumeLocation>>
  getAudiobookResumeLocationsByAuthorIdStream(String authorId) {
    return getAudiobooksByAuthorIdStream(authorId).flatMap(
      (audiobooks) => (getAudiobookResumeLocationsByAudiobookIdsStream(
        audiobooks.map((a) => (a.id)).toList(),
      )),
    );
  }

  static const _authorOrderKey = "order";

  static const _audiobookAuthorIdKey = "authorId";

  static const _chapterAudioBookIdKey = "audioBookId";
  static const _chapterAudioBookOrderKey = "audioBookOrder";

  static const _audiobookResumeLocationLocationInSecondsKey =
      "locationInSeconds";
  static const _audiobookResumeLocationChapterIdKey = "chapterId";

  static const _bookmarkChapterIdKey = "chapterId";

  @override
  FutureOr onDispose() {
    _authorsStore.removeOnChangesListener(_db, _authorOnChanges);
    _audiobooksStore.removeOnChangesListener(_db, _audiobookOnChanges);
    _chaptersStore.removeOnChangesListener(_db, _chapterOnChanges);
  }
}
