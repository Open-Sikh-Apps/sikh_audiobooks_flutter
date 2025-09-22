import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sikh_audiobooks_flutter/ui/player/viewmodels/player_view_model.dart';
import 'package:watch_it/watch_it.dart';

@RoutePage()
class PlayerScreen extends WatchingWidget {
  const PlayerScreen({super.key, required this.viewModel});
  final PlayerViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Center(child: Text("Player Screen\nWork in progress!")),
    );
  }
}
