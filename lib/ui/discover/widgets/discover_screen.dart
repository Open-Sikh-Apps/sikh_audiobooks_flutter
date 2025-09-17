import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sikh_audiobooks_flutter/l10n/app_localizations.dart';
import 'package:sikh_audiobooks_flutter/routing/routes.dart';
import 'package:sikh_audiobooks_flutter/ui/discover/viewmodels/discover_view_model.dart';
import 'package:watch_it/watch_it.dart';

class DiscoverScreen extends WatchingWidget {
  const DiscoverScreen({super.key, required this.viewModel});
  final DiscoverViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(AppLocalizations.of(context)?.labelDiscover ?? ""),
          FilledButton(
            child: Text("Author 1"),
            onPressed: () {
              context.push(Routes.authorWithId("1"));
            },
          ),
          FilledButton(
            child: Text("Author 2"),
            onPressed: () {
              context.push(Routes.authorWithId("2"));
            },
          ),
        ],
      ),
    );
  }
}
