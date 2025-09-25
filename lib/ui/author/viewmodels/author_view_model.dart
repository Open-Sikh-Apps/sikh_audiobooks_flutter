import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:sikh_audiobooks_flutter/data/repositories/audiobooks/audiobooks_repository.dart';

class AuthorViewModel extends Disposable {
  AuthorViewModel({
    required AudiobooksRepository audiobooksRepository,
    required String id,
  }) : _audiobooksRepository = audiobooksRepository,
       _id = id;

  final AudiobooksRepository _audiobooksRepository;
  final String _id;

  @override
  FutureOr onDispose() {}
}
