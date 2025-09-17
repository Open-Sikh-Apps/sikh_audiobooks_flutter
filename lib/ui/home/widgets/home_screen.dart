import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sikh_audiobooks_flutter/l10n/app_localizations.dart';
import 'package:sikh_audiobooks_flutter/main.dart';
import 'package:sikh_audiobooks_flutter/routing/routes.dart';
import 'package:sikh_audiobooks_flutter/ui/settings/viewmodels/settings_view_model.dart';
import 'package:sikh_audiobooks_flutter/ui/settings/widgets/settings_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.child});
  final Widget child;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          switch (index) {
            case 0:
              context.go(Routes.discover);
              setState(() {
                currentPageIndex = index;
              });
            case 1:
              context.go(Routes.library);
              setState(() {
                currentPageIndex = index;
              });
            case 2:
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    final viewModel = SettingsViewmodel(
                      userSettingsRepository: getIt(),
                    );
                    return SettingsScreen(viewModel: viewModel);
                  },
                ),
              );
            default:
              break;
          }
        },
        selectedIndex: currentPageIndex,
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
    );
  }
}
