import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sikh_audiobooks_flutter/utils/result.dart';

class SharedPreferencesService {
  static const _localeKey = "LOCALE";
  static const _themeModeKey = "THEME-MODE";
  static const _dataVersionKey = "DATA-VERSION";

  final _log = Logger();

  Future<Result<Locale?>> fetchUserLocale() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final localeString = sharedPreferences.getString(_localeKey);
      _log.t('Got localeString:$localeString from SharedPreferences');
      return Result.ok(localeString == null ? null : Locale(localeString));
    } on Exception catch (e) {
      _log.w('Failed to get localeString', error: e);
      return Result.error(e);
    }
  }

  Future<Result<void>> saveUserLocale(Locale? locale) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      if (locale == null) {
        await sharedPreferences.remove(_localeKey);
        _log.t('Removed localeString');
      } else {
        await sharedPreferences.setString(_localeKey, locale.languageCode);
        _log.t('Replaced localeString with ${locale.languageCode}');
      }
      return const Result.ok(null);
    } on Exception catch (e) {
      _log.w('Failed to set localeString', error: e);
      return Result.error(e);
    }
  }

  Future<Result<ThemeMode?>> fetchUserThemeMode() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final themeModeInt = sharedPreferences.getInt(_themeModeKey);
      _log.t('Got themeModeInt:$themeModeInt from SharedPreferences');
      return Result.ok(
        themeModeInt == null ? null : ThemeMode.values[themeModeInt],
      );
    } on Exception catch (e) {
      _log.w('Failed to get themeModeInt', error: e);
      return Result.error(e);
    }
  }

  Future<Result<void>> saveUserThemeMode(ThemeMode? themeMode) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      if (themeMode == null) {
        await sharedPreferences.remove(_themeModeKey);
        _log.t('Removed themeModeInt');
      } else {
        await sharedPreferences.setInt(_themeModeKey, themeMode.index);
        _log.t('Replaced themeModeInt with ${themeMode.index}');
      }
      return const Result.ok(null);
    } on Exception catch (e) {
      _log.w('Failed to set themeModeInt', error: e);
      return Result.error(e);
    }
  }

  Future<Result<int?>> fetchDataVersion() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final dataVersion = sharedPreferences.getInt(_dataVersionKey);
      _log.t('Got dataVersion:$dataVersion from SharedPreferences');
      return Result.ok(dataVersion);
    } on Exception catch (e) {
      _log.w('Failed to get dataVersion', error: e);
      return Result.error(e);
    }
  }

  Future<Result<void>> saveDataVersion(int? dataVersion) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      if (dataVersion == null) {
        await sharedPreferences.remove(_dataVersionKey);
        _log.t('Removed dataVersion');
      } else {
        await sharedPreferences.setInt(_dataVersionKey, dataVersion);
        _log.t('Replaced dataVersion with $dataVersion');
      }
      return const Result.ok(null);
    } on Exception catch (e) {
      _log.w('Failed to set dataVersion', error: e);
      return Result.error(e);
    }
  }
}
