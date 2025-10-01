import 'package:duck_router/duck_router.dart';
import 'package:flutter/material.dart';
import 'package:sikh_audiobooks_flutter/l10n/app_localizations.dart';
import 'package:sikh_audiobooks_flutter/routing/router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.shell});

  final DuckShell shell;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.shell,
      bottomNavigationBar: NavigationBar(
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
    );
  }
}
