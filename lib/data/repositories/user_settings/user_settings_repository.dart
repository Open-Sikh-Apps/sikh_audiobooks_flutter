import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:sikh_audiobooks_flutter/data/services/shared_preferences_service.dart';
import 'package:sikh_audiobooks_flutter/utils/result.dart';

abstract class UserSettingsRepository extends Disposable {
  ValueNotifier<Locale?> get userLocaleVN;
  Future<Result<Locale?>> fetchUserLocale();
  Future<Result<void>> saveUserLocale({required Locale? locale});
  ValueNotifier<ThemeMode?> get userThemeModeVN;
  Future<Result<ThemeMode?>> fetchUserThemeMode();
  Future<Result<void>> saveUserThemeMode({required ThemeMode? themeMode});
}

class UserSettingsRepositoryProd extends UserSettingsRepository {
  UserSettingsRepositoryProd({
    required SharedPreferencesService sharedPreferencesService,
  }) : _sharedPreferencesService = sharedPreferencesService;

  final _log = Logger();
  final SharedPreferencesService _sharedPreferencesService;

  final ValueNotifier<Locale?> _userLocaleVN = ValueNotifier(null);
  final ValueNotifier<ThemeMode?> _userThemeModeVN = ValueNotifier(null);

  @override
  ValueNotifier<Locale?> get userLocaleVN => _userLocaleVN;
  @override
  ValueNotifier<ThemeMode?> get userThemeModeVN => _userThemeModeVN;

  @override
  Future<Result<Locale?>> fetchUserLocale() async {
    final result = await _sharedPreferencesService.fetchUserLocale();
    switch (result) {
      case Ok<Locale?>():
        _userLocaleVN.value = result.value;
        return Result.ok(_userLocaleVN.value);
      case Error<Locale?>():
        _log.e(
          'Failed to fech User Locale from SharedPreferences',
          error: result.error,
        );
        return Result.error(result.error);
    }
  }

  @override
  Future<Result<void>> saveUserLocale({required Locale? locale}) async {
    final result = await _sharedPreferencesService.saveUserLocale(locale);
    switch (result) {
      case Ok<void>():
        _userLocaleVN.value = locale;
        return const Result.ok(null);
      case Error<void>():
        _log.e(
          'Failed to save User Locale to SharedPreferences',
          error: result.error,
        );
        return Result.error(result.error);
    }
  }

  @override
  Future<Result<ThemeMode?>> fetchUserThemeMode() async {
    final result = await _sharedPreferencesService.fetchUserThemeMode();
    switch (result) {
      case Ok<ThemeMode?>():
        _userThemeModeVN.value = result.value;
        return Result.ok(_userThemeModeVN.value);
      case Error<ThemeMode?>():
        _log.e(
          'Failed to fech User ThemeMode from SharedPreferences',
          error: result.error,
        );
        return Result.error(result.error);
    }
  }

  @override
  Future<Result<void>> saveUserThemeMode({
    required ThemeMode? themeMode,
  }) async {
    final result = await _sharedPreferencesService.saveUserThemeMode(themeMode);
    switch (result) {
      case Ok<void>():
        _userThemeModeVN.value = themeMode;
        return const Result.ok(null);
      case Error<void>():
        _log.e(
          'Failed to save User ThemeMode to SharedPreferences',
          error: result.error,
        );
        return Result.error(result.error);
    }
  }

  @override
  FutureOr onDispose() {
    _userLocaleVN.dispose();
    _userThemeModeVN.dispose();
  }
}
