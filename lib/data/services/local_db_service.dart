import 'package:sembast/sembast.dart';
import 'package:sikh_audiobooks_flutter/config/constants.dart';
import 'package:sikh_audiobooks_flutter/domain/models/audiobook/audiobook.dart';
import 'package:sikh_audiobooks_flutter/domain/models/author/author.dart';
import 'package:sikh_audiobooks_flutter/domain/models/chapter/chapter.dart';
import 'package:sikh_audiobooks_flutter/utils/result.dart';

class LocalDbService {
  LocalDbService({required Database db}) : _db = db;
  final Database _db;

  final _authorsStore = stringMapStoreFactory.store(Constants.authorsDbKey);
  final _audiobooksStore = stringMapStoreFactory.store(
    Constants.audioBooksDbKey,
  );
  final _chaptersStore = stringMapStoreFactory.store(Constants.chaptersDbKey);

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

  Future<Result<void>> saveAuthor(Author author) async {
    try {
      await _authorsStore.record(author.id).put(_db, author.toJson());
      return Result.ok(null);
    } catch (e) {
      return Result.error(e);
    }
  }

  Stream<List<Author>> getAllAuthorsStream() {
    final query = _authorsStore.query(
      finder: Finder(sortOrders: [SortOrder(_authorOrderKey)]),
    );

    return query.onSnapshots(_db).map((snapshots) {
      final List<Author> result = [];
      for (var snapshot in snapshots) {
        result.add(Author.fromJson(snapshot.value));
      }
      return result;
    });
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

  Future<Result<void>> saveAudiobook(Audiobook audiobook) async {
    try {
      await _audiobooksStore.record(audiobook.id).put(_db, audiobook.toJson());
      return Result.ok(null);
    } catch (e) {
      return Result.error(e);
    }
  }

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

  static const _authorOrderKey = "order";
}
