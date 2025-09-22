import 'package:sikh_audiobooks_flutter/data/repositories/audiobooks/audiobooks_repository.dart';

class AudiobookViewModel {
  AudiobookViewModel({
    required AudiobooksRepository audiobooksRepository,
    required String id,
  }) : _audiobooksRepository = audiobooksRepository,
       _id = id;

  final AudiobooksRepository _audiobooksRepository;
  final String _id;
}
