import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:duck_router/duck_router.dart';
import 'package:flutter/material.dart';
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
  late final SettingsViewmodel viewModel;

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    DuckRouter.of(context).pop();
    return true;
  }

  @override
  void initState() {
    super.initState();
    viewModel = SettingsViewmodel(userSettingsRepository: getIt());
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    viewModel.onDispose();
    super.dispose();
    BackButtonInterceptor.remove(myInterceptor);
  }

  @override
  Widget build(BuildContext context) {
    final userLocale = watch(viewModel.userLocaleVN).value;
    final userThemeMode = watch(viewModel.userThemeModeVN).value;

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
          ],
        ),
      ),
    );
  }
}
