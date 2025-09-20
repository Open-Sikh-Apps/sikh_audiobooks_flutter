import 'dart:async';

import 'package:command_it/command_it.dart';
import 'package:logger/logger.dart';
import 'package:sikh_audiobooks_flutter/data/repositories/audiobooks/audiobooks_repository.dart';
import 'package:sikh_audiobooks_flutter/utils/result.dart';

class DiscoverViewModel {
  DiscoverViewModel({required AudiobooksRepository audiobooksRepository})
    : _audiobooksRepository = audiobooksRepository;

  final AudiobooksRepository _audiobooksRepository;
  final _log = Logger();

  late final Command<void, Result<void>?> refreshDiscoverDataCommand =
      Command.createAsyncNoParam(() async {
        final result = await _audiobooksRepository.refreshDiscoverData();

        if (result is Error) {
          _log.d("result is Error", error: result.error);
          return result;
        }

        return Result.ok(null);
      }, initialValue: null)..execute();
  late final allAuthorsStream = _audiobooksRepository.getAllAuthorsStream();

  startDownloadAuthorImage(String authorId) {
    unawaited(_audiobooksRepository.startDownloadAuthorImage(authorId));
  }

  cancelDownloadAuthorImage(String authorId) {
    unawaited(_audiobooksRepository.cancelDownloadAuthorImage(authorId));
  }
}
