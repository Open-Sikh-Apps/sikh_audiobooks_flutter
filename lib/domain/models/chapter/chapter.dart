import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sikh_audiobooks_flutter/domain/models/duration/duration.dart';

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
    required Duration duration,

    /// path to locally stored audio, if any
    String? localAudioPath,
  }) = _Chapter;

  factory Chapter.fromJson(Map<String, Object?> json) =>
      _$ChapterFromJson(json);
}
