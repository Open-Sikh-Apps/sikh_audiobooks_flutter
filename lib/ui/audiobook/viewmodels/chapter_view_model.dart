import 'dart:async';

import 'package:command_it/command_it.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:sikh_audiobooks_flutter/data/repositories/audiobooks/audiobooks_repository.dart';
import 'package:sikh_audiobooks_flutter/utils/result.dart';

class ChapterViewModel extends Disposable {
  ChapterViewModel({
    required AudiobooksRepository audiobooksRepository,
    required String id,
  }) : _audiobooksRepository = audiobooksRepository,
       _id = id {
    internetStatusVN = _audiobooksRepository.internetStatusVN;
  }

  final AudiobooksRepository _audiobooksRepository;
  final String _id;

  late final Command<void, Result<void>?> _downloadCommand =
      Command.createAsyncNoParam(() async {
        //
        return Result.ok(null);
      }, initialValue: null);

  Command<void, Result<void>?> get downloadCommand => _downloadCommand;

  late final Command<void, Result<void>?> _removeDownloadCommand =
      Command.createAsyncNoParam(() async {
        //
        return Result.ok(null);
      }, initialValue: null);

  Command<void, Result<void>?> get removeDownloadCommand =>
      _removeDownloadCommand;

  late final Command<void, Result<void>?> _playCommand =
      Command.createAsyncNoParam(() async {
        //
        return Result.ok(null);
      }, initialValue: null);

  Command<void, Result<void>?> get playCommand => _playCommand;

  @override
  FutureOr onDispose() {
    _downloadCommand.dispose();
    _removeDownloadCommand.dispose();
    _playCommand.dispose();
  }

  late final ValueNotifier<InternetStatus?> internetStatusVN;
}
