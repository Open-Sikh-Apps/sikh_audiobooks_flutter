import 'package:duck_router/duck_router.dart';
import 'package:sikh_audiobooks_flutter/routing/routes.dart';
import 'package:sikh_audiobooks_flutter/ui/audiobook/widgets/audiobook_screen.dart';
import 'package:sikh_audiobooks_flutter/ui/author/widgets/author_screen.dart';
import 'package:sikh_audiobooks_flutter/ui/discover/widgets/discover_screen.dart';
import 'package:sikh_audiobooks_flutter/ui/home/widgets/home_screen.dart';
import 'package:sikh_audiobooks_flutter/ui/library/widgets/library_screen.dart';
import 'package:sikh_audiobooks_flutter/ui/settings/widgets/settings_screen.dart';
import 'package:uuid/uuid.dart';

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
    return DiscoverScreen();
  };
}

class LibraryLocation extends Location {
  const LibraryLocation();

  @override
  String get path => Routes.library;

  @override
  LocationBuilder? get builder => (context) {
    return LibraryScreen();
  };
}

class AuthorLocation extends Location {
  AuthorLocation(this.id);

  final uuid = Uuid().v1();

  final String id;

  @override
  String get path => "${uuid}_${Routes.authorWithId(id)}";

  @override
  LocationBuilder? get builder => (context) {
    return AuthorScreen(id: id);
  };
}

class AudiobookLocation extends Location {
  AudiobookLocation(this.id);

  final String id;
  final uuid = Uuid().v1();

  @override
  String get path => "${uuid}_${Routes.audiobookWithId(id)}";

  @override
  LocationBuilder? get builder => (context) {
    return AudiobookScreen(id: id);
  };
}

class SettingsLocation extends Location {
  const SettingsLocation();

  @override
  String get path => Routes.settings;

  @override
  LocationBuilder? get builder => (context) {
    return SettingsScreen();
  };
}

DuckRouter router() {
  return DuckRouter(initialLocation: HomeLocation());
}
