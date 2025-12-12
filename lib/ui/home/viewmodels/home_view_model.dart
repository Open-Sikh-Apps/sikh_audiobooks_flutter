import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:sikh_audiobooks_flutter/data/repositories/audiobooks/audiobooks_repository.dart';

class HomeViewModel extends Disposable {
  HomeViewModel({required AudiobooksRepository audiobooksRepository})
    : _audiobooksRepository = audiobooksRepository {
    internetStatusVN = _audiobooksRepository.internetStatusVN;
  }
  final AudiobooksRepository _audiobooksRepository;
  late final ValueNotifier<InternetStatus?> internetStatusVN;
  @override
  FutureOr onDispose() {}
}
