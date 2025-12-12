import 'dart:async';

import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sikh_audiobooks_flutter/data/repositories/user_settings/user_settings_repository.dart';
import 'package:sikh_audiobooks_flutter/utils/result.dart';

class MainViewModel extends Disposable {
  MainViewModel({required UserSettingsRepository userSettingsRepository})
    : _userSettingsRepository = userSettingsRepository;
  final UserSettingsRepository _userSettingsRepository;

  late final ValueNotifier<Locale?> userLocaleVN =
      _userSettingsRepository.userLocaleVN;
  late final ValueNotifier<ThemeMode?> userThemeModeVN =
      _userSettingsRepository.userThemeModeVN;

  late final Command<void, Result<void>?> fetchSettingsCommand =
      Command.createAsyncNoParam(() async {
        final userLocaleResult = await _userSettingsRepository
            .fetchUserLocale();
        if (userLocaleResult is Error) {
          return userLocaleResult;
        }

        final userThemeModeResult = await _userSettingsRepository
            .fetchUserThemeMode();

        if (userThemeModeResult is Error) {
          return userThemeModeResult;
        }

        final localDataVersionResult = await _userSettingsRepository
            .fetchLocalDataVersion();

        if (localDataVersionResult is Error) {
          return localDataVersionResult;
        }

        final showDownloadNotificationsResult = await _userSettingsRepository
            .fetchShowDownloadNotifications();

        if (showDownloadNotificationsResult is Error) {
          return showDownloadNotificationsResult;
        }

        final downloadConnectionPreferenceResult = await _userSettingsRepository
            .fetchDownloadConnectionPreference();

        if (downloadConnectionPreferenceResult is Error) {
          return downloadConnectionPreferenceResult;
        }

        return Result.ok(null);
      }, initialValue: null)..execute();

  @override
  FutureOr onDispose() {
    fetchSettingsCommand.dispose();
  }
}
