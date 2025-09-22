// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i8;
import 'package:flutter/material.dart' as _i9;
import 'package:sikh_audiobooks_flutter/ui/audiobook/viewmodels/audiobook_view_model.dart'
    as _i10;
import 'package:sikh_audiobooks_flutter/ui/audiobook/widgets/audiobook_screen.dart'
    as _i1;
import 'package:sikh_audiobooks_flutter/ui/author/viewmodels/author_view_model.dart'
    as _i11;
import 'package:sikh_audiobooks_flutter/ui/author/widgets/author_screen.dart'
    as _i2;
import 'package:sikh_audiobooks_flutter/ui/discover/viewmodels/discover_view_model.dart'
    as _i12;
import 'package:sikh_audiobooks_flutter/ui/discover/widgets/discover_screen.dart'
    as _i3;
import 'package:sikh_audiobooks_flutter/ui/home/widgets/home_screen.dart'
    as _i4;
import 'package:sikh_audiobooks_flutter/ui/library/viewmodels/library_view_model.dart'
    as _i13;
import 'package:sikh_audiobooks_flutter/ui/library/widgets/library_screen.dart'
    as _i5;
import 'package:sikh_audiobooks_flutter/ui/player/viewmodels/player_view_model.dart'
    as _i14;
import 'package:sikh_audiobooks_flutter/ui/player/widgets/player_screen.dart'
    as _i6;
import 'package:sikh_audiobooks_flutter/ui/settings/viewmodels/settings_view_model.dart'
    as _i15;
import 'package:sikh_audiobooks_flutter/ui/settings/widgets/settings_screen.dart'
    as _i7;

/// generated route for
/// [_i1.AudiobookScreen]
class AudiobookRoute extends _i8.PageRouteInfo<AudiobookRouteArgs> {
  AudiobookRoute({
    _i9.Key? key,
    required _i10.AudiobookViewModel viewModel,
    List<_i8.PageRouteInfo>? children,
  }) : super(
         AudiobookRoute.name,
         args: AudiobookRouteArgs(key: key, viewModel: viewModel),
         initialChildren: children,
       );

  static const String name = 'AudiobookRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AudiobookRouteArgs>();
      return _i1.AudiobookScreen(key: args.key, viewModel: args.viewModel);
    },
  );
}

class AudiobookRouteArgs {
  const AudiobookRouteArgs({this.key, required this.viewModel});

  final _i9.Key? key;

  final _i10.AudiobookViewModel viewModel;

  @override
  String toString() {
    return 'AudiobookRouteArgs{key: $key, viewModel: $viewModel}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AudiobookRouteArgs) return false;
    return key == other.key && viewModel == other.viewModel;
  }

  @override
  int get hashCode => key.hashCode ^ viewModel.hashCode;
}

/// generated route for
/// [_i2.AuthorScreen]
class AuthorRoute extends _i8.PageRouteInfo<AuthorRouteArgs> {
  AuthorRoute({
    _i9.Key? key,
    required _i11.AuthorViewModel viewModel,
    List<_i8.PageRouteInfo>? children,
  }) : super(
         AuthorRoute.name,
         args: AuthorRouteArgs(key: key, viewModel: viewModel),
         initialChildren: children,
       );

  static const String name = 'AuthorRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AuthorRouteArgs>();
      return _i2.AuthorScreen(key: args.key, viewModel: args.viewModel);
    },
  );
}

class AuthorRouteArgs {
  const AuthorRouteArgs({this.key, required this.viewModel});

  final _i9.Key? key;

  final _i11.AuthorViewModel viewModel;

  @override
  String toString() {
    return 'AuthorRouteArgs{key: $key, viewModel: $viewModel}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AuthorRouteArgs) return false;
    return key == other.key && viewModel == other.viewModel;
  }

  @override
  int get hashCode => key.hashCode ^ viewModel.hashCode;
}

/// generated route for
/// [_i3.DiscoverScreen]
class DiscoverRoute extends _i8.PageRouteInfo<DiscoverRouteArgs> {
  DiscoverRoute({
    _i9.Key? key,
    required _i12.DiscoverViewModel viewModel,
    List<_i8.PageRouteInfo>? children,
  }) : super(
         DiscoverRoute.name,
         args: DiscoverRouteArgs(key: key, viewModel: viewModel),
         initialChildren: children,
       );

  static const String name = 'DiscoverRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DiscoverRouteArgs>();
      return _i3.DiscoverScreen(key: args.key, viewModel: args.viewModel);
    },
  );
}

class DiscoverRouteArgs {
  const DiscoverRouteArgs({this.key, required this.viewModel});

  final _i9.Key? key;

  final _i12.DiscoverViewModel viewModel;

  @override
  String toString() {
    return 'DiscoverRouteArgs{key: $key, viewModel: $viewModel}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DiscoverRouteArgs) return false;
    return key == other.key && viewModel == other.viewModel;
  }

  @override
  int get hashCode => key.hashCode ^ viewModel.hashCode;
}

/// generated route for
/// [_i4.HomeScreen]
class HomeRoute extends _i8.PageRouteInfo<HomeRouteArgs> {
  HomeRoute({_i9.Key? key, List<_i8.PageRouteInfo>? children})
    : super(
        HomeRoute.name,
        args: HomeRouteArgs(key: key),
        initialChildren: children,
      );

  static const String name = 'HomeRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<HomeRouteArgs>(
        orElse: () => const HomeRouteArgs(),
      );
      return _i4.HomeScreen(key: args.key);
    },
  );
}

class HomeRouteArgs {
  const HomeRouteArgs({this.key});

  final _i9.Key? key;

  @override
  String toString() {
    return 'HomeRouteArgs{key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! HomeRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [_i5.LibraryScreen]
class LibraryRoute extends _i8.PageRouteInfo<LibraryRouteArgs> {
  LibraryRoute({
    _i9.Key? key,
    required _i13.LibraryViewModel viewModel,
    List<_i8.PageRouteInfo>? children,
  }) : super(
         LibraryRoute.name,
         args: LibraryRouteArgs(key: key, viewModel: viewModel),
         initialChildren: children,
       );

  static const String name = 'LibraryRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LibraryRouteArgs>();
      return _i5.LibraryScreen(key: args.key, viewModel: args.viewModel);
    },
  );
}

class LibraryRouteArgs {
  const LibraryRouteArgs({this.key, required this.viewModel});

  final _i9.Key? key;

  final _i13.LibraryViewModel viewModel;

  @override
  String toString() {
    return 'LibraryRouteArgs{key: $key, viewModel: $viewModel}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LibraryRouteArgs) return false;
    return key == other.key && viewModel == other.viewModel;
  }

  @override
  int get hashCode => key.hashCode ^ viewModel.hashCode;
}

/// generated route for
/// [_i6.PlayerScreen]
class PlayerRoute extends _i8.PageRouteInfo<PlayerRouteArgs> {
  PlayerRoute({
    _i9.Key? key,
    required _i14.PlayerViewModel viewModel,
    List<_i8.PageRouteInfo>? children,
  }) : super(
         PlayerRoute.name,
         args: PlayerRouteArgs(key: key, viewModel: viewModel),
         initialChildren: children,
       );

  static const String name = 'PlayerRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PlayerRouteArgs>();
      return _i6.PlayerScreen(key: args.key, viewModel: args.viewModel);
    },
  );
}

class PlayerRouteArgs {
  const PlayerRouteArgs({this.key, required this.viewModel});

  final _i9.Key? key;

  final _i14.PlayerViewModel viewModel;

  @override
  String toString() {
    return 'PlayerRouteArgs{key: $key, viewModel: $viewModel}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PlayerRouteArgs) return false;
    return key == other.key && viewModel == other.viewModel;
  }

  @override
  int get hashCode => key.hashCode ^ viewModel.hashCode;
}

/// generated route for
/// [_i7.SettingsScreen]
class SettingsRoute extends _i8.PageRouteInfo<SettingsRouteArgs> {
  SettingsRoute({
    _i9.Key? key,
    required _i15.SettingsViewmodel viewModel,
    List<_i8.PageRouteInfo>? children,
  }) : super(
         SettingsRoute.name,
         args: SettingsRouteArgs(key: key, viewModel: viewModel),
         initialChildren: children,
       );

  static const String name = 'SettingsRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SettingsRouteArgs>();
      return _i7.SettingsScreen(key: args.key, viewModel: args.viewModel);
    },
  );
}

class SettingsRouteArgs {
  const SettingsRouteArgs({this.key, required this.viewModel});

  final _i9.Key? key;

  final _i15.SettingsViewmodel viewModel;

  @override
  String toString() {
    return 'SettingsRouteArgs{key: $key, viewModel: $viewModel}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SettingsRouteArgs) return false;
    return key == other.key && viewModel == other.viewModel;
  }

  @override
  int get hashCode => key.hashCode ^ viewModel.hashCode;
}
