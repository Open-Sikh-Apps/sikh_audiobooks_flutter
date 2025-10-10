import 'dart:async';

import 'package:command_it/command_it.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:sikh_audiobooks_flutter/data/repositories/audiobooks/audiobooks_repository.dart';
import 'package:sikh_audiobooks_flutter/domain/models/author/author.dart';
import 'package:sikh_audiobooks_flutter/utils/result.dart';

class DiscoverViewModel extends Disposable {
  DiscoverViewModel({required AudiobooksRepository audiobooksRepository})
    : _audiobooksRepository = audiobooksRepository {
    _allAuthorsSubscription = _audiobooksRepository
        .getAllAuthorsStream()
        .listen(
          (data) {
            _allAuthorsResultVN.value = Result.ok(data);
          },
          onError: (error) {
            _log.d("getAllAuthorsStream onError", error: error);
            _allAuthorsResultVN.value = Result.error(error);
          },
        );
  }

  final _log = Logger();

  late final StreamSubscription _allAuthorsSubscription;
  final AudiobooksRepository _audiobooksRepository;

  late final Command<void, Result<void>?> refreshDataCommand =
      _audiobooksRepository.refreshDataCommand;

  final ValueNotifier<Result<List<Author>>?> _allAuthorsResultVN =
      ValueNotifier(null);

  ValueNotifier<Result<List<Author>>?> get allAuthorsResultVN =>
      _allAuthorsResultVN;

  void startDownloadAuthorImage(String authorId) {
    unawaited(_audiobooksRepository.startDownloadAuthorImage(authorId));
  }

  void cancelDownloadAuthorImage(String authorId) {
    unawaited(_audiobooksRepository.cancelDownloadAuthorImage(authorId));
  }

  @override
  FutureOr onDispose() async {
    _allAuthorsResultVN.dispose();
    await _allAuthorsSubscription.cancel();
  }
}
