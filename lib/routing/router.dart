// GoRouter router({
//   required GlobalKey<NavigatorState> rootNavigatorKey,
//   required GlobalKey<NavigatorState> shellNavigatorKey,
// }) {
//   return GoRouter(
//     initialLocation: Routes.discover,
//     navigatorKey: rootNavigatorKey,
//     routes: <RouteBase>[
//       ShellRoute(
//         navigatorKey: shellNavigatorKey,
//         builder: (context, state, child) {
//           return HomeScreen(child: child);
//         },
//         routes: <RouteBase>[
//           GoRoute(
//             path: Routes.discover,
//             builder: (context, state) {
//               final viewModel = DiscoverViewModel(
//                 audiobooksRepository: getIt(),
//               );
//               return DiscoverScreen(viewModel: viewModel);
//             },
//           ),
//           GoRoute(
//             path: Routes.library,
//             builder: (context, state) {
//               final viewModel = LibraryViewModel();
//               return LibraryScreen(viewModel: viewModel);
//             },
//           ),
//           GoRoute(
//             path: "${Routes.author}/:id",
//             builder: (contex, state) {
//               return AuthorScreen(id: state.pathParameters["id"] ?? "");
//             },
//           ),
//           GoRoute(
//             path: "${Routes.audiobook}/:id",
//             builder: (contex, state) {
//               return AudiobookScreen(id: state.pathParameters["id"] ?? "");
//             },
//           ),
//         ],
//       ),
//     ],
//   );
// }

import 'package:auto_route/auto_route.dart';
import 'package:sikh_audiobooks_flutter/routing/router.gr.dart';
import 'package:sikh_audiobooks_flutter/routing/routes.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => RouteType.material(); //.cupertino, .adaptive ..etc

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      path: Routes.home,
      page: HomeRoute.page,
      children: [
        AutoRoute(path: Routes.discoverRelative, page: DiscoverRoute.page),
        AutoRoute(path: Routes.libraryRelative, page: LibraryRoute.page),
        AutoRoute(path: Routes.authorRelative, page: AuthorRoute.page),
        AutoRoute(path: Routes.audiobookRelative, page: AudiobookRoute.page),
      ],
    ),
    AutoRoute(path: Routes.settings, page: SettingsRoute.page),
    AutoRoute(path: Routes.player, page: PlayerRoute.page),
  ];
}
