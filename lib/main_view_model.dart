import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:sikh_audiobooks_flutter/data/repositories/user_settings/user_settings_repository.dart';
import 'package:sikh_audiobooks_flutter/utils/result.dart';

class MainViewModel {
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
          return Result.error((userLocaleResult as Error).error);
        }

        final userThemeModeResult = await _userSettingsRepository
            .fetchUserThemeMode();

        if (userThemeModeResult is Error) {
          return Result.error((userThemeModeResult as Error).error);
        }

        return Result.ok(null);
      }, initialValue: null)..execute();
}
