import 'package:flutter/material.dart';
import 'package:sikh_audiobooks_flutter/l10n/app_localizations.dart';
import 'package:sikh_audiobooks_flutter/ui/library/viewmodels/library_view_model.dart';
import 'package:watch_it/watch_it.dart';

class LibraryScreen extends WatchingStatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late final LibraryViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = LibraryViewModel();
  }

  @override
  void dispose() {
    viewModel.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Center(
        child: Text(AppLocalizations.of(context)?.labelMyLibrary ?? ""),
      ),
    );
  }
}
