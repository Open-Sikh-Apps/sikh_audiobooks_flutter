import 'package:command_it/command_it.dart';
import 'package:duck_router/duck_router.dart';
import 'package:flutter/material.dart';
import 'package:sikh_audiobooks_flutter/config/dependencies.dart';
import 'package:sikh_audiobooks_flutter/l10n/app_localizations.dart';
import 'package:sikh_audiobooks_flutter/main_view_model.dart';
import 'package:sikh_audiobooks_flutter/ui/core/themes/dimens.dart';
import 'package:sikh_audiobooks_flutter/utils/result.dart';
import 'package:sikh_audiobooks_flutter/utils/utils.dart';
import 'package:watch_it/watch_it.dart';

final getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await lockOrientationPortrait();
  await setupDependencies();
  runApp(MainApp(router: getIt()));
}

class MainApp extends WatchingStatefulWidget {
  const MainApp({super.key, required this.router});
  final DuckRouter router;

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final MainViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = MainViewModel(userSettingsRepository: getIt());
  }

  @override
  void dispose() {
    viewModel.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fetchUserSettingsResults = watch(
      viewModel.fetchSettingsCommand.results,
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
          return RouterHome(mainViewModel: viewModel, router: widget.router);
        }
      },
    );
  }
}

class RouterHome extends WatchingWidget {
  const RouterHome({
    super.key,
    required this.mainViewModel,
    required this.router,
  });

  final MainViewModel mainViewModel;
  final DuckRouter router;

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
      routerConfig: router,
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
