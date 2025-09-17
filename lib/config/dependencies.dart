import 'package:flutter/material.dart';
import 'package:sikh_audiobooks_flutter/config/constants.dart';
import 'package:sikh_audiobooks_flutter/data/repositories/user_settings/user_settings_repository.dart';
import 'package:sikh_audiobooks_flutter/data/services/shared_preferences_service.dart';
import 'package:sikh_audiobooks_flutter/main.dart';
import 'package:sikh_audiobooks_flutter/routing/router.dart';

void setupDependencies() {
  getIt.registerSingleton(SharedPreferencesService());
  getIt.registerSingleton(
    UserSettingsRepositoryProd(sharedPreferencesService: getIt())
        as UserSettingsRepository,
  );
  getIt.registerSingleton(
    GlobalKey<NavigatorState>(),
    instanceName: Constants.rootNavigatorinstanceName,
  );
  getIt.registerSingleton(
    GlobalKey<NavigatorState>(),
    instanceName: Constants.shellNavigatorinstanceName,
  );

  getIt.registerSingleton(
    router(
      rootNavigatorKey: getIt(
        instanceName: Constants.rootNavigatorinstanceName,
      ),
      shellNavigatorKey: getIt(
        instanceName: Constants.shellNavigatorinstanceName,
      ),
    ),
  );
}
