import 'package:command_it/command_it.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sikh_audiobooks_flutter/config/dependencies.dart';
import 'package:sikh_audiobooks_flutter/l10n/app_localizations.dart';
import 'package:sikh_audiobooks_flutter/main_view_model.dart';
import 'package:sikh_audiobooks_flutter/ui/core/themes/dimens.dart';
import 'package:sikh_audiobooks_flutter/utils/result.dart';
import 'package:watch_it/watch_it.dart';

import 'firebase_options.dart';

final getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setupDependencies();
  runApp(
    MainApp(mainViewModel: MainViewModel(userSettingsRepository: getIt())),
  );
}

class MainApp extends WatchingWidget {
  const MainApp({super.key, required this.mainViewModel});
  final MainViewModel mainViewModel;

  @override
  Widget build(BuildContext context) {
    final fetchUserSettingsResults = watch(
      mainViewModel.fetchSettingsCommand.results,
    ).value;

    return fetchUserSettingsResults.toWidget(
      whileExecuting: (_, _) => LoadingHome(),
      onError: (_, _, _) => ErrorHome(),
      onData: (result, _) {
        if (result == null) {
          return LoadingHome();
        }
        if (result is Error) {
          return ErrorHome();
        } else {
          return RouterHome(mainViewModel: mainViewModel, goRouter: getIt());
        }
      },
    );
  }
}

class RouterHome extends WatchingWidget {
  const RouterHome({
    super.key,
    required this.mainViewModel,
    required this.goRouter,
  });

  final MainViewModel mainViewModel;
  final GoRouter goRouter;

  @override
  Widget build(BuildContext context) {
    final userLocale = watch(mainViewModel.userLocaleVN).value;
    final userThemeMode = watch(mainViewModel.userThemeModeVN).value;

    return MaterialApp.router(
      onGenerateTitle: (context) =>
          AppLocalizations.of(context)?.appTitle ?? "",
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      darkTheme: ThemeData.dark(),
      themeMode: userThemeMode,
      locale: userLocale,
      routerConfig: goRouter,
    );
  }
}

class ErrorHome extends StatelessWidget {
  const ErrorHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) =>
          AppLocalizations.of(context)?.appTitle ?? "",
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      darkTheme: ThemeData.dark(),
      home: Builder(
        builder: (context) {
          return Scaffold(
            body: SafeArea(
              child: SizedBox(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: Dimens.paddingVertical,
                    children: [
                      Icon(Icons.error, size: Dimens.of(context).titleIconSize),
                      Text(AppLocalizations.of(context)?.errorLoading ?? ""),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class LoadingHome extends StatelessWidget {
  const LoadingHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) =>
          AppLocalizations.of(context)?.appTitle ?? "",
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      darkTheme: ThemeData.dark(),
      home: const Scaffold(
        body: SafeArea(
          child: SizedBox(child: Center(child: CircularProgressIndicator())),
        ),
      ),
    );
  }
}
