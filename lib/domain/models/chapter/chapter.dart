import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sikh_audiobooks_flutter/domain/models/api_duration/api_duration.dart';

part 'chapter.freezed.dart';
part 'chapter.g.dart';

@freezed
abstract class Chapter with _$Chapter {
  const factory Chapter({
    /// Unique id of chapter
    required String id,

    /// id for this chapter's audiobook
    required String audioBookId,

    /// order of this chapter in the audiobook
    required int audioBookOrder,

    /// name, in both languages "pa" and "en"
    required Map<String, String> name,

    /// ref path to the chapter's audio in cloud storage
    required String audioPath,

    /// pdf url, if PdfUrlType of this book is per "chapter"
    String? pdfUrl,

    /// duration of this chapter's audio
    required ApiDuration duration,

    /// path to locally stored audio, if any
    String? localAudioPath,
  }) = _Chapter;

  factory Chapter.fromJson(Map<String, Object?> json) =>
      _$ChapterFromJson(json);
}

extension ChapterIterableExtensions on Iterable<Chapter> {
  Duration totalDuration() {
    return map(
      (c) => (c.duration.toDuration()),
    ).fold(Duration(), (previousValue, element) => (previousValue + element));
  }

  bool anyDownloaded() {
    if (isEmpty) {
      return false;
    } else {
      return any((c) => (c.localAudioPath != null));
    }
  }

  bool allDownloaded() {
    if (isEmpty) {
      return false;
    } else {
      return every((c) => (c.localAudioPath != null));
    }
  }
}
