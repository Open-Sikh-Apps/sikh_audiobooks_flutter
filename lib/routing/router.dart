import 'package:duck_router/duck_router.dart';
import 'package:sikh_audiobooks_flutter/main.dart';
import 'package:sikh_audiobooks_flutter/routing/routes.dart';
import 'package:sikh_audiobooks_flutter/ui/audiobook/viewmodels/audiobook_view_model.dart';
import 'package:sikh_audiobooks_flutter/ui/audiobook/widgets/audiobook_screen.dart';
import 'package:sikh_audiobooks_flutter/ui/author/viewmodels/author_view_model.dart';
import 'package:sikh_audiobooks_flutter/ui/author/widgets/author_screen.dart';
import 'package:sikh_audiobooks_flutter/ui/discover/viewmodels/discover_view_model.dart';
import 'package:sikh_audiobooks_flutter/ui/discover/widgets/discover_screen.dart';
import 'package:sikh_audiobooks_flutter/ui/home/widgets/home_screen.dart';
import 'package:sikh_audiobooks_flutter/ui/library/viewmodels/library_view_model.dart';
import 'package:sikh_audiobooks_flutter/ui/library/widgets/library_screen.dart';
import 'package:sikh_audiobooks_flutter/ui/settings/viewmodels/settings_view_model.dart';
import 'package:sikh_audiobooks_flutter/ui/settings/widgets/settings_screen.dart';

class HomeLocation extends StatefulLocation {
  @override
  StatefulLocationBuilder get childBuilder => (context, shell) {
    return HomeScreen(shell: shell);
  };

  @override
  List<Location> get children => [
    const DiscoverLocation(),
    const LibraryLocation(),
  ];

  @override
  String get path => Routes.home;
}

class DiscoverLocation extends Location {
  const DiscoverLocation();

  @override
  String get path => Routes.discover;

  @override
  LocationBuilder? get builder => (context) {
    final viewModel = getIt.registerSingletonIfAbsent(
      () => DiscoverViewModel(audiobooksRepository: getIt()),
    );
    return DiscoverScreen(viewModel: viewModel);
  };
}

class LibraryLocation extends Location {
  const LibraryLocation();

  @override
  String get path => Routes.library;

  @override
  LocationBuilder? get builder => (context) {
    final viewModel = getIt.registerSingletonIfAbsent(() => LibraryViewModel());
    return LibraryScreen(viewModel: viewModel);
  };
}

class AuthorLocation extends Location {
  const AuthorLocation(this.id);

  final String id;

  @override
  String get path => Routes.authorWithId(id);

  @override
  LocationBuilder? get builder => (context) {
    final viewModel = getIt.registerSingletonIfAbsent(
      () => AuthorViewModel(audiobooksRepository: getIt(), id: id),
      instanceName: id,
    );
    return AuthorScreen(viewModel: viewModel);
  };
}

class AudiobookLocation extends Location {
  const AudiobookLocation(this.id);

  final String id;

  @override
  String get path => Routes.audiobookWithId(id);

  @override
  LocationBuilder? get builder => (context) {
    final viewModel = getIt.registerSingletonIfAbsent(
      () => AudiobookViewModel(audiobooksRepository: getIt(), id: id),
      instanceName: id,
    );
    return AudiobookScreen(viewModel: viewModel);
  };
}

class SettingsLocation extends Location {
  const SettingsLocation();

  @override
  String get path => Routes.settings;

  @override
  LocationBuilder? get builder => (context) {
    final viewModel = getIt.registerSingletonIfAbsent(
      () => SettingsViewmodel(userSettingsRepository: getIt()),
    );

    return SettingsScreen(viewModel: viewModel);
  };
}

DuckRouter router() {
  return DuckRouter(initialLocation: HomeLocation());
}
