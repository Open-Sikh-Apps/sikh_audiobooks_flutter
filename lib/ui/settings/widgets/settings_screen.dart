import 'package:flutter/material.dart';
import 'package:sikh_audiobooks_flutter/data/services/shared_preferences_service.dart';
import 'package:sikh_audiobooks_flutter/l10n/app_localizations.dart';
import 'package:sikh_audiobooks_flutter/main.dart';
import 'package:sikh_audiobooks_flutter/ui/settings/viewmodels/settings_view_model.dart';
import 'package:sikh_audiobooks_flutter/ui/settings/widgets/settings_tile.dart';
import 'package:sikh_audiobooks_flutter/utils/locale.dart';
import 'package:watch_it/watch_it.dart';

class SettingsScreen extends WatchingStatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final SettingsViewModel viewModel;

  // bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
  //   DuckRouter.of(context).pop();
  //   return true;
  // }

  @override
  void initState() {
    super.initState();
    viewModel = SettingsViewModel(userSettingsRepository: getIt());
    // BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    viewModel.onDispose();
    super.dispose();
    // BackButtonInterceptor.remove(myInterceptor);
  }

  @override
  Widget build(BuildContext context) {
    final userLocale = watch(viewModel.userLocaleVN).value;
    final userThemeMode = watch(viewModel.userThemeModeVN).value;
    final showDownloadNotifications = watch(
      viewModel.showDownloadNotificationsVN,
    ).value;
    final downloadsConnectionPreference = watch(
      viewModel.downloadsConnectionPreferenceVN,
    ).value;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.settings ?? "",
          style: TextTheme.of(context).titleLarge,
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            SettingsTile(
              icon: Icon(Icons.language),
              title: AppLocalizations.of(context)?.labelLanguage ?? "",
              selectionSheetTitle:
                  AppLocalizations.of(context)?.labelLanguage ?? "",
              selectedValue: userLocale,
              options: <SettingsTileOption<Locale?>>[
                SettingsTileOption(
                  value: null,
                  title: AppLocalizations.of(context)?.labelSystem ?? "",
                ),
                ...AppLocalizations.supportedLocales.map(
                  (locale) => SettingsTileOption(
                    value: locale,
                    title: locale.fullName(),
                  ),
                ),
              ],
              onSubmitted: (locale) {
                viewModel.saveUserLocale(locale);
              },
            ),
            SettingsTile(
              icon: Icon(Icons.contrast),
              title: AppLocalizations.of(context)?.labelTheme ?? "",
              selectionSheetTitle:
                  AppLocalizations.of(context)?.labelTheme ?? "",
              selectedValue: userThemeMode,
              options: <SettingsTileOption<ThemeMode?>>[
                SettingsTileOption(
                  icon: Icon(Icons.contrast),
                  value: null,
                  title: AppLocalizations.of(context)?.labelSystem ?? "",
                ),
                SettingsTileOption(
                  icon: Icon(Icons.light_mode),
                  value: ThemeMode.light,
                  title: AppLocalizations.of(context)?.labelLight ?? "",
                ),
                SettingsTileOption(
                  icon: Icon(Icons.dark_mode),
                  value: ThemeMode.dark,
                  title: AppLocalizations.of(context)?.labelDark ?? "",
                ),
              ],
              onSubmitted: (themeMode) {
                viewModel.saveUserThemeMode(themeMode);
              },
            ),
            SettingsTile(
              icon: Icon(Icons.notifications),
              title:
                  AppLocalizations.of(context)?.labelDownloadNotifications ??
                  "",
              selectionSheetTitle:
                  AppLocalizations.of(
                    context,
                  )?.titleShowDownloadNotifications ??
                  "",
              selectedValue: showDownloadNotifications,
              options: <SettingsTileOption<bool?>>[
                SettingsTileOption(
                  value: true,
                  title: AppLocalizations.of(context)?.labelShow ?? "",
                ),
                SettingsTileOption(
                  value: false,
                  title: AppLocalizations.of(context)?.labelHide ?? "",
                ),
              ],
              onSubmitted: (value) {
                viewModel.saveShowDownloadNotifications(value);
              },
            ),
            SettingsTile(
              icon: Icon(Icons.download),
              title:
                  AppLocalizations.of(
                    context,
                  )?.labelDownloadsConnectionPreference ??
                  "",
              selectionSheetTitle:
                  AppLocalizations.of(
                    context,
                  )?.labelDownloadsConnectionPreference ??
                  "",
              selectedValue: downloadsConnectionPreference,
              options: <SettingsTileOption<DownloadsConnectionPreference?>>[
                SettingsTileOption(
                  value: DownloadsConnectionPreference.wifiOnly,
                  title: AppLocalizations.of(context)?.labelWifiOnly ?? "",
                ),
                SettingsTileOption(
                  value: DownloadsConnectionPreference.anyNetwork,
                  title: AppLocalizations.of(context)?.labelAnyNetwork ?? "",
                ),
              ],
              onSubmitted: (value) {
                viewModel.saveDownloadConnectionPreference(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
