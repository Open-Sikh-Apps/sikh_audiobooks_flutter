// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key, required this.child});
//   final Widget child;

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int currentPageIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: widget.child,
//       bottomNavigationBar: NavigationBar(
//         onDestinationSelected: (int index) {
//           switch (index) {
//             case 0:
//               context.go(Routes.discover);
//               setState(() {
//                 currentPageIndex = index;
//               });
//             case 1:
//               context.go(Routes.library);
//               setState(() {
//                 currentPageIndex = index;
//               });
//             case 2:
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) {
//                     final viewModel = SettingsViewmodel(
//                       userSettingsRepository: getIt(),
//                     );
//                     return SettingsScreen(viewModel: viewModel);
//                   },
//                 ),
//               );
//             default:
//               break;
//           }
//         },
//         selectedIndex: currentPageIndex,
//         destinations: [
//           NavigationDestination(
//             selectedIcon: Icon(Icons.explore),
//             icon: Icon(Icons.explore_outlined),
//             label: AppLocalizations.of(context)?.labelDiscover ?? "",
//           ),
//           NavigationDestination(
//             selectedIcon: Icon(Icons.library_books),
//             icon: Icon(Icons.library_books_outlined),
//             label: AppLocalizations.of(context)?.labelMyLibrary ?? "",
//           ),
//           NavigationDestination(
//             selectedIcon: Icon(Icons.settings),
//             icon: Icon(Icons.settings_outlined),
//             label: AppLocalizations.of(context)?.settings ?? "",
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sikh_audiobooks_flutter/l10n/app_localizations.dart';
import 'package:sikh_audiobooks_flutter/main.dart';
import 'package:sikh_audiobooks_flutter/routing/router.gr.dart';
import 'package:sikh_audiobooks_flutter/ui/discover/viewmodels/discover_view_model.dart';
import 'package:sikh_audiobooks_flutter/ui/library/viewmodels/library_view_model.dart';
import 'package:sikh_audiobooks_flutter/ui/settings/viewmodels/settings_view_model.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final _discoverViewModel = DiscoverViewModel(audiobooksRepository: getIt());
  final _libraryViewModel = LibraryViewModel();

  final _settingsViewModel = SettingsViewmodel(userSettingsRepository: getIt());

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: [
        DiscoverRoute(viewModel: _discoverViewModel),
        LibraryRoute(viewModel: _libraryViewModel),
      ],
      bottomNavigationBuilder: (context, tabsRouter) {
        return NavigationBar(
          selectedIndex: tabsRouter.activeIndex,
          onDestinationSelected: (index) {
            switch (index) {
              case 0:
              case 1:
                tabsRouter.setActiveIndex(index);
              case 2:
                context.pushRoute(SettingsRoute(viewModel: _settingsViewModel));
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
        );
      },
    );
  }
}
