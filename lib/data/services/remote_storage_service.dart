import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:async/async.dart' hide Result;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';
import 'package:sikh_audiobooks_flutter/config/constants.dart';
import 'package:sikh_audiobooks_flutter/utils/result.dart';

abstract class RemoteStorageService {
  Future<Result<String>> getDataJsonString();
  // Future<Result<String>> downloadFile({
  //   required String storageFilePath,
  //   required String uuidFileNameLocalWithoutExtension,
  // });
  CancelableOperation downloadFileCancelable({
    required String storageFilePath,
    required String localFilePath,
  });
}

class RemoteStorageServiceFirebase extends RemoteStorageService {
  RemoteStorageServiceFirebase({
    required FirebaseStorage firebaseStorage,
    // required Directory appDocsDir,
  }) : _storage = firebaseStorage;
  //  _appDocsDir = appDocsDir;

  final _log = Logger();
  final FirebaseStorage _storage;
  // final Directory _appDocsDir;

  @override
  Future<Result<String>> getDataJsonString() async {
    final dataRef = _storage.ref(Constants.refPathDataMinifiedJson);

    final Uint8List? data;
    try {
      data = await dataRef.getData();
    } on FirebaseException catch (e) {
      // Handle any errors.
      _log.e("fetchAuthorList dataRef.getData() error", error: e);
      return Result.error(e);
    }
    if (data == null) {
      _log.e("data == null");
      return Result.error(Exception("data == null"));
    }
    try {
      final String jsonString = utf8.decode(data, allowMalformed: true);
      return Result.ok(jsonString);
    } catch (e) {
      _log.i("getDataJsonString exception:$e");
      return Result.error(e);
    }
  }

  // @override
  // Future<Result<String>> downloadFile({
  //   required String storageFilePath,
  //   required String uuidFileNameLocalWithoutExtension,
  // }) async {
  //   try {
  //     final fileExtension = storageFilePath.split(".").last;
  //     final localFileName = "$uuidFileNameLocalWithoutExtension$fileExtension";
  //     final localFilePath = join(_appDocsDir.path, localFileName);
  //     final dataRef = _storage.ref().child(storageFilePath);
  //     final localFile = File(localFilePath);
  //     await dataRef.writeToFile(localFile);
  //     return Result.ok(localFilePath);
  //   } catch (e) {
  //     return Result.error(e);
  //   }
  // }

  @override
  CancelableOperation downloadFileCancelable({
    required String storageFilePath,
    required String localFilePath,
  }) {
    final storageFileRef = _storage.ref().child(storageFilePath);
    final localFile = File(localFilePath);
    final downloadTask = storageFileRef.writeToFile(localFile);
    final cancelableOperation = CancelableOperation.fromFuture(
      downloadTask,
      onCancel: () {
        downloadTask.cancel();
      },
    );
    return cancelableOperation;
  }
}
