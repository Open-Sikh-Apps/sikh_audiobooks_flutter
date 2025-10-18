import 'dart:async';

import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sikh_audiobooks_flutter/data/repositories/user_settings/user_settings_repository.dart';
import 'package:sikh_audiobooks_flutter/utils/result.dart';

class SettingsViewModel extends Disposable {
  SettingsViewModel({required UserSettingsRepository userSettingsRepository})
    : _userSettingsRepository = userSettingsRepository;
  final UserSettingsRepository _userSettingsRepository;

  late final ValueNotifier<Locale?> userLocaleVN =
      _userSettingsRepository.userLocaleVN;
  late final ValueNotifier<ThemeMode?> userThemeModeVN =
      _userSettingsRepository.userThemeModeVN;

  late final Command<Locale?, Result<void>?> saveUserLocale =
      Command.createAsync((selectedLocale) async {
        final saveResult = await _userSettingsRepository.saveUserLocale(
          locale: selectedLocale,
        );
        return saveResult;
      }, initialValue: null);

  late final Command<ThemeMode?, Result<void>?> saveUserThemeMode =
      Command.createAsync((selectedThemeMode) async {
        final saveResult = await _userSettingsRepository.saveUserThemeMode(
          themeMode: selectedThemeMode,
        );
        return saveResult;
      }, initialValue: null);

  @override
  FutureOr onDispose() async {}
}
