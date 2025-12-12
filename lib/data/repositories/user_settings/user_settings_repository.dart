import 'dart:async';

import 'package:background_downloader/background_downloader.dart';
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
  ValueNotifier<int?> get localDataVersionVN;
  Future<Result<int?>> fetchLocalDataVersion();
  Future<Result<void>> saveLocalDataVersion({required int localDataVersion});
  ValueNotifier<bool?> get showDownloadNotificationsVN;
  Future<Result<bool?>> fetchShowDownloadNotifications();
  Future<Result<void>> saveShowDownloadNotifications({
    required bool showDownloadNotifications,
  });
  ValueNotifier<DownloadsConnectionPreference?>
  get downloadsConnectionPreferenceVN;
  Future<Result<DownloadsConnectionPreference?>>
  fetchDownloadConnectionPreference();
  Future<Result<void>> saveDownloadsConnectionPreference({
    required DownloadsConnectionPreference downloadsConnectionPreference,
  });
}

class UserSettingsRepositoryProd extends UserSettingsRepository {
  UserSettingsRepositoryProd({
    required SharedPreferencesService sharedPreferencesService,
  }) : _sharedPreferencesService = sharedPreferencesService;

  final _log = Logger();
  final SharedPreferencesService _sharedPreferencesService;

  final ValueNotifier<Locale?> _userLocaleVN = ValueNotifier(null);
  final ValueNotifier<ThemeMode?> _userThemeModeVN = ValueNotifier(null);
  final ValueNotifier<int?> _localDataVersionVN = ValueNotifier(null);

  final ValueNotifier<bool?> _showDownloadNotificationsVN = ValueNotifier(null);

  final ValueNotifier<DownloadsConnectionPreference?>
  _downloadsConnectionPreferenceVN = ValueNotifier(null);

  @override
  ValueNotifier<Locale?> get userLocaleVN => _userLocaleVN;

  @override
  ValueNotifier<ThemeMode?> get userThemeModeVN => _userThemeModeVN;

  @override
  ValueNotifier<int?> get localDataVersionVN => _localDataVersionVN;

  @override
  ValueNotifier<bool?> get showDownloadNotificationsVN =>
      _showDownloadNotificationsVN;

  @override
  ValueNotifier<DownloadsConnectionPreference?>
  get downloadsConnectionPreferenceVN => _downloadsConnectionPreferenceVN;

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
    _localDataVersionVN.dispose();
    _showDownloadNotificationsVN.dispose();
    _downloadsConnectionPreferenceVN.dispose();
  }

  @override
  Future<Result<DownloadsConnectionPreference?>>
  fetchDownloadConnectionPreference() async {
    final result = await _sharedPreferencesService
        .fetchDownloadsConnectionPreference();
    switch (result) {
      case Ok<DownloadsConnectionPreference?>():
        _downloadsConnectionPreferenceVN.value = result.value;
        return Result.ok(_downloadsConnectionPreferenceVN.value);
      case Error<DownloadsConnectionPreference?>():
        _log.e(
          'Failed to fech DownloadConnectionPreference from SharedPreferences',
          error: result.error,
        );
        return Result.error(result.error);
    }
  }

  @override
  Future<Result<void>> saveDownloadsConnectionPreference({
    required DownloadsConnectionPreference downloadsConnectionPreference,
  }) async {
    final currentSetting = await FileDownloader().getRequireWiFiSetting();

    switch (downloadsConnectionPreference) {
      case DownloadsConnectionPreference.wifiOnly:
        if (currentSetting != RequireWiFi.forAllTasks) {
          await FileDownloader().requireWiFi(RequireWiFi.forAllTasks);
        }
      case DownloadsConnectionPreference.anyNetwork:
        if (currentSetting != RequireWiFi.forNoTasks) {
          await FileDownloader().requireWiFi(RequireWiFi.forNoTasks);
        }
    }

    final result = await _sharedPreferencesService
        .saveDownloadsConnectionPreference(downloadsConnectionPreference);
    switch (result) {
      case Ok<void>():
        _downloadsConnectionPreferenceVN.value = downloadsConnectionPreference;
        return const Result.ok(null);
      case Error<void>():
        _log.e(
          'Failed to saveDownloadConnectionPreference to SharedPreferences',
          error: result.error,
        );
        return Result.error(result.error);
    }
  }

  @override
  Future<Result<int?>> fetchLocalDataVersion() async {
    final result = await _sharedPreferencesService.fetchLocalDataVersion();
    switch (result) {
      case Ok<int?>():
        _localDataVersionVN.value = result.value;
        return Result.ok(_localDataVersionVN.value);
      case Error<int?>():
        _log.e(
          'Failed to fech LocalDataVersion from SharedPreferences',
          error: result.error,
        );
        return Result.error(result.error);
    }
  }

  @override
  Future<Result<void>> saveLocalDataVersion({
    required int localDataVersion,
  }) async {
    final result = await _sharedPreferencesService.saveLocalDataVersion(
      localDataVersion,
    );
    switch (result) {
      case Ok<void>():
        _localDataVersionVN.value = localDataVersion;
        return const Result.ok(null);
      case Error<void>():
        _log.e(
          'Failed to saveLocalDataVersion to SharedPreferences',
          error: result.error,
        );
        return Result.error(result.error);
    }
  }

  @override
  Future<Result<bool?>> fetchShowDownloadNotifications() async {
    final result = await _sharedPreferencesService
        .fetchShowDownloadNotifications();
    switch (result) {
      case Ok<bool?>():
        _showDownloadNotificationsVN.value = result.value;
        return Result.ok(_showDownloadNotificationsVN.value);
      case Error<bool?>():
        _log.e(
          'Failed to fech ShowDownloadNotifications from SharedPreferences',
          error: result.error,
        );
        return Result.error(result.error);
    }
  }

  @override
  Future<Result<void>> saveShowDownloadNotifications({
    required bool showDownloadNotifications,
  }) async {
    _log.d("showDownloadNotifications:$showDownloadNotifications");
    final bool setShow;
    if (showDownloadNotifications) {
      final permissionType = PermissionType.notifications;
      PermissionStatus status = await FileDownloader().permissions.status(
        permissionType,
      );
      if (status == PermissionStatus.granted) {
        setShow = true;
      } else {
        status = await FileDownloader().permissions.request(permissionType);
        setShow = (status == PermissionStatus.granted);
      }
    } else {
      setShow = false;
    }

    _log.d("setShow:$setShow");

    final result = await _sharedPreferencesService
        .saveShowDownloadNotifications(setShow);
    switch (result) {
      case Ok<void>():
        _showDownloadNotificationsVN.value = setShow;
        _log.d(
          "_showDownloadNotificationsVN.value:${_showDownloadNotificationsVN.value}",
        );
        return const Result.ok(null);
      case Error<void>():
        _log.e(
          'Failed to showDownloadNotifications to SharedPreferences',
          error: result.error,
        );
        return Result.error(result.error);
    }
  }
}
