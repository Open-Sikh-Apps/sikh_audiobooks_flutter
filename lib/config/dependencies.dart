import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sikh_audiobooks_flutter/config/constants.dart';
import 'package:sikh_audiobooks_flutter/data/repositories/audiobooks/audiobooks_repository.dart';
import 'package:sikh_audiobooks_flutter/data/repositories/user_settings/user_settings_repository.dart';
import 'package:sikh_audiobooks_flutter/data/services/local_db_service.dart';
import 'package:sikh_audiobooks_flutter/data/services/remote_db_service.dart';
import 'package:sikh_audiobooks_flutter/data/services/remote_storage_service.dart';
import 'package:sikh_audiobooks_flutter/data/services/shared_preferences_service.dart';
import 'package:sikh_audiobooks_flutter/firebase_options.dart';
import 'package:sikh_audiobooks_flutter/main.dart';
import 'package:sikh_audiobooks_flutter/routing/router.dart';

Future<void> setupDependencies() async {
  await initFirebase();
  final appDocsDir = await getApplicationDocumentsDirectory();

  getIt.registerSingleton(
    appDocsDir,
    instanceName: Constants.appDocsDirInstanceName,
  );

  final db = await initLocalDb(
    getIt(instanceName: Constants.appDocsDirInstanceName),
  );

  getIt.registerSingleton(db);
  getIt.registerSingleton(LocalDbService(db: getIt()));

  getIt.registerSingleton(SharedPreferencesService());
  getIt.registerSingleton(FirebaseDatabase.instance);
  getIt.registerSingleton(FirebaseStorage.instance);

  getIt.registerSingleton(
    RemoteDbServiceFirebase(firebaseDatabase: getIt()) as RemoteDbService,
  );

  getIt.registerSingleton(
    RemoteStorageServiceFirebase(firebaseStorage: getIt())
        as RemoteStorageService,
  );

  getIt.registerSingleton(
    UserSettingsRepositoryProd(sharedPreferencesService: getIt())
        as UserSettingsRepository,
  );
  getIt.registerSingleton(
    AudiobooksRepositoryProd(
          sharedPreferencesService: getIt(),
          remoteDbService: getIt(),
          remoteStorageService: getIt(),
          dbService: getIt(),
          appDocsDir: getIt(instanceName: Constants.appDocsDirInstanceName),
        )
        as AudiobooksRepository,
  );

  getIt.registerSingleton(router());
}

Future<void> initFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<Database> initLocalDb(Directory appDocsDir) async {
  // make sure it exists
  await appDocsDir.create(recursive: true);
  // build the database path
  final dbPath = join(appDocsDir.path, Constants.pathLocalDb);
  // open the database
  final db = await databaseFactoryIo.openDatabase(dbPath);
  return db;
}
