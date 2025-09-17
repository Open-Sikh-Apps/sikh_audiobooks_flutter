import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sikh_audiobooks_flutter/routing/routes.dart';
import 'package:sikh_audiobooks_flutter/ui/audiobook/widgets/audiobook_screen.dart';
import 'package:sikh_audiobooks_flutter/ui/author/widgets/author_screen.dart';
import 'package:sikh_audiobooks_flutter/ui/discover/viewmodels/discover_view_model.dart';
import 'package:sikh_audiobooks_flutter/ui/discover/widgets/discover_screen.dart';
import 'package:sikh_audiobooks_flutter/ui/home/widgets/home_screen.dart';
import 'package:sikh_audiobooks_flutter/ui/library/viewmodels/library_view_model.dart';
import 'package:sikh_audiobooks_flutter/ui/library/widgets/library_screen.dart';

GoRouter router({
  required GlobalKey<NavigatorState> rootNavigatorKey,
  required GlobalKey<NavigatorState> shellNavigatorKey,
}) => GoRouter(
  initialLocation: Routes.discover,
  navigatorKey: rootNavigatorKey,
  routes: <RouteBase>[
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      builder: (context, state, child) {
        return HomeShell(child: child);
      },
      routes: <RouteBase>[
        GoRoute(
          path: Routes.discover,
          builder: (context, state) {
            final viewModel = DiscoverViewModel();
            return DiscoverScreen(viewModel: viewModel);
          },
        ),
        GoRoute(
          path: Routes.library,
          builder: (context, state) {
            final viewModel = LibraryViewModel();
            return LibraryScreen(viewModel: viewModel);
          },
        ),
        GoRoute(
          path: "${Routes.author}/:id",
          builder: (contex, state) {
            return AuthorScreen(id: state.pathParameters["id"] ?? "");
          },
        ),
        GoRoute(
          path: "${Routes.audiobook}/:id",
          builder: (contex, state) {
            return AudiobookScreen(id: state.pathParameters["id"] ?? "");
          },
        ),
      ],
    ),
  ],
);
