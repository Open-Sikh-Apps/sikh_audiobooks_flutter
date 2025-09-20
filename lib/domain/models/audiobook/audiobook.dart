import 'package:freezed_annotation/freezed_annotation.dart';

part 'audiobook.freezed.dart';
part 'audiobook.g.dart';

enum PdfUrlType { book, chapter }

@freezed
abstract class Audiobook with _$Audiobook {
  const factory Audiobook({
    /// Unique id of audiobook
    required String id,

    /// id for this book's author
    required String authorId,

    /// order of this book in the author's books
    required int authorOrder,

    /// name, in both languages "pa" and "en"
    required Map<String, String> name,

    /// pdf url is per "book" or per "chapter"
    required PdfUrlType pdfUrlType,

    /// pdf url, if PdfUrlType is per "book"
    String? pdfUrl,

    /// ref path to this book's image in cloud storage
    required String imagePath,

    /// language code for book's language
    required String language,

    /// path to locally stored image, if any
    String? localImagePath,
  }) = _Audiobook;

  factory Audiobook.fromJson(Map<String, Object?> json) =>
      _$AudiobookFromJson(json);
}
