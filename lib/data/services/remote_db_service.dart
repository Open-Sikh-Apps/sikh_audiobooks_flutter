import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';
import 'package:sikh_audiobooks_flutter/config/constants.dart';
import 'package:sikh_audiobooks_flutter/utils/result.dart';

abstract class RemoteDbService {
  Future<Result<int>> fetchDataVersion();
}

class RemoteDbServiceFirebase extends RemoteDbService {
  RemoteDbServiceFirebase({required FirebaseDatabase firebaseDatabase})
    : _firebaseDb = firebaseDatabase;

  final _log = Logger();
  final FirebaseDatabase _firebaseDb;
  @override
  Future<Result<int>> fetchDataVersion() async {
    final Object? dataVersion;
    try {
      dataVersion =
          (await _firebaseDb.ref(Constants.refPathDataVersion).get()).value;
    } catch (e) {
      return Result.error(e);
    }

    if (dataVersion == null || dataVersion is! int) {
      _log.e("invalid dataVersion: $dataVersion");

      return Result.error(Exception("invalid dataVersion: $dataVersion"));
    }

    return Result.ok(dataVersion);
  }
}
