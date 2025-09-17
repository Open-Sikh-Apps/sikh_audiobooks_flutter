import 'package:flutter/material.dart';
import 'package:sikh_audiobooks_flutter/l10n/app_localizations.dart';
import 'package:sikh_audiobooks_flutter/ui/library/viewmodels/library_view_model.dart';
import 'package:watch_it/watch_it.dart';

class LibraryScreen extends WatchingWidget {
  const LibraryScreen({super.key, required this.viewModel});
  final LibraryViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Center(
        child: Text(AppLocalizations.of(context)?.labelMyLibrary ?? ""),
      ),
    );
  }
}
