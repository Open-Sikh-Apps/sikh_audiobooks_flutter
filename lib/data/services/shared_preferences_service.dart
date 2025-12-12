import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sikh_audiobooks_flutter/utils/result.dart';

enum DownloadsConnectionPreference { wifiOnly, anyNetwork }

class SharedPreferencesService {
  static const _localeKey = "LOCALE";
  static const _themeModeKey = "THEME-MODE";
  static const _dataVersionKey = "DATA-VERSION";
  static const _showDownloadNotificationsKey = "SHOW-DOWNLOAD-NOTIFICATIONS";
  static const _downloadConnectionPreferenceKey =
      "DOWNLOADS-CONNECTION-PREFERENCE";

  final _log = Logger();

  Future<Result<Locale?>> fetchUserLocale() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final localeString = sharedPreferences.getString(_localeKey);
      _log.d('Got localeString:$localeString from SharedPreferences');
      return Result.ok(localeString == null ? null : Locale(localeString));
    } catch (e) {
      _log.w('Failed to get localeString', error: e);
      return Result.error(e);
    }
  }

  Future<Result<void>> saveUserLocale(Locale? locale) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      if (locale == null) {
        await sharedPreferences.remove(_localeKey);
        _log.d('Removed localeString');
      } else {
        await sharedPreferences.setString(_localeKey, locale.languageCode);
        _log.d('Replaced localeString with ${locale.languageCode}');
      }
      return const Result.ok(null);
    } catch (e) {
      _log.w('Failed to set localeString', error: e);
      return Result.error(e);
    }
  }

  Future<Result<ThemeMode?>> fetchUserThemeMode() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final themeModeInt = sharedPreferences.getInt(_themeModeKey);
      _log.d('Got themeModeInt:$themeModeInt from SharedPreferences');
      return Result.ok(
        themeModeInt == null ? null : ThemeMode.values[themeModeInt],
      );
    } catch (e) {
      _log.w('Failed to get themeModeInt', error: e);
      return Result.error(e);
    }
  }

  Future<Result<void>> saveUserThemeMode(ThemeMode? themeMode) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      if (themeMode == null) {
        await sharedPreferences.remove(_themeModeKey);
        _log.d('Removed themeModeInt');
      } else {
        await sharedPreferences.setInt(_themeModeKey, themeMode.index);
        _log.d('Replaced themeModeInt with ${themeMode.index}');
      }
      return const Result.ok(null);
    } catch (e) {
      _log.w('Failed to set themeModeInt', error: e);
      return Result.error(e);
    }
  }

  Future<Result<int?>> fetchLocalDataVersion() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final dataVersion = sharedPreferences.getInt(_dataVersionKey);
      _log.d('Got dataVersion:$dataVersion from SharedPreferences');
      return Result.ok(dataVersion);
    } catch (e) {
      _log.w('Failed to get dataVersion', error: e);
      return Result.error(e);
    }
  }

  Future<Result<void>> saveLocalDataVersion(int? dataVersion) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      if (dataVersion == null) {
        await sharedPreferences.remove(_dataVersionKey);
        _log.d('Removed dataVersion');
      } else {
        await sharedPreferences.setInt(_dataVersionKey, dataVersion);
        _log.d('Replaced dataVersion with $dataVersion');
      }
      return const Result.ok(null);
    } catch (e) {
      _log.w('Failed to set dataVersion', error: e);
      return Result.error(e);
    }
  }

  Future<Result<bool?>> fetchShowDownloadNotifications() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final value = sharedPreferences.getBool(_showDownloadNotificationsKey);
      return Result.ok(value);
    } catch (e) {
      _log.w('Failed to get fetchShowDownloadNotifications', error: e);
      return Result.error(e);
    }
  }

  Future<Result<void>> saveShowDownloadNotifications(bool value) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setBool(_showDownloadNotificationsKey, value);
      _log.d('Replaced saveShowDownloadNotifications with $value');
      return Result.ok(null);
    } catch (e) {
      _log.w("Failed to saveShowDownloadNotifications", error: e);
      return Result.error(e);
    }
  }

  Future<Result<DownloadsConnectionPreference?>>
  fetchDownloadsConnectionPreference() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final downloadConnectionPreferenceInt = sharedPreferences.getInt(
        _downloadConnectionPreferenceKey,
      );
      _log.d(
        'Got downloadConnectionPreferenceInt:$downloadConnectionPreferenceInt from SharedPreferences',
      );
      return Result.ok(
        downloadConnectionPreferenceInt == null
            ? null
            : DownloadsConnectionPreference
                  .values[downloadConnectionPreferenceInt],
      );
    } catch (e) {
      _log.w('Failed to get themeModeInt', error: e);
      return Result.error(e);
    }
  }

  Future<Result<void>> saveDownloadsConnectionPreference(
    DownloadsConnectionPreference downloadConnectionPreference,
  ) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setInt(
        _downloadConnectionPreferenceKey,
        downloadConnectionPreference.index,
      );
      _log.d(
        'Replaced downloadConnectionPreference with ${downloadConnectionPreference.index}',
      );
      return const Result.ok(null);
    } catch (e) {
      _log.w('Failed to set downloadConnectionPreference', error: e);
      return Result.error(e);
    }
  }
}
