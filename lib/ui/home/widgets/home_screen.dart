import 'package:duck_router/duck_router.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:sikh_audiobooks_flutter/l10n/app_localizations.dart';
import 'package:sikh_audiobooks_flutter/main.dart';
import 'package:sikh_audiobooks_flutter/routing/router.dart';
import 'package:sikh_audiobooks_flutter/ui/home/viewmodels/home_view_model.dart';
import 'package:watch_it/watch_it.dart';

class HomeScreen extends WatchingStatefulWidget {
  const HomeScreen({super.key, required this.shell});

  final DuckShell shell;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeViewModel viewModel;

  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    viewModel = HomeViewModel(audiobooksRepository: getIt());
  }

  @override
  void dispose() {
    viewModel.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final internetStatus = watch(viewModel.internetStatusVN).value;
    final colorScheme = ColorScheme.of(context);

    return Scaffold(
      body: widget.shell,
      bottomNavigationBar: Container(
        color: (internetStatus == InternetStatus.disconnected)
            ? colorScheme.tertiary
            : colorScheme.surfaceContainer,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NavigationBar(
                height: null,
                selectedIndex: currentPageIndex,
                onDestinationSelected: (index) {
                  switch (index) {
                    case 0:
                    case 1:
                      DuckRouter.of(context).root();
                      widget.shell.switchChild(index);
                      setState(() {
                        currentPageIndex = index;
                      });
                    case 2:
                      DuckRouter.of(
                        context,
                      ).navigate(to: const SettingsLocation(), root: true);
                    default:
                      break;
                  }
                },
                destinations: [
                  NavigationDestination(
                    selectedIcon: Icon(Icons.explore),
                    icon: Icon(Icons.explore_outlined),
                    label: AppLocalizations.of(context)?.labelDiscover ?? "",
                  ),
                  NavigationDestination(
                    selectedIcon: Icon(Icons.library_books),
                    icon: Icon(Icons.library_books_outlined),
                    label: AppLocalizations.of(context)?.labelMyLibrary ?? "",
                  ),
                  NavigationDestination(
                    selectedIcon: Icon(Icons.settings),
                    icon: Icon(Icons.settings_outlined),
                    label: AppLocalizations.of(context)?.settings ?? "",
                  ),
                ],
              ),
              if (internetStatus == InternetStatus.disconnected)
                Container(
                  width: double.infinity,
                  color: colorScheme.tertiary,
                  alignment: AlignmentGeometry.center,
                  child: Text(
                    AppLocalizations.of(context)?.messageNoConnection ?? "",
                    style: TextTheme.of(
                      context,
                    ).bodyLarge?.copyWith(color: colorScheme.onTertiary),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
