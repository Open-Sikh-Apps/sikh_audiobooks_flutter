import 'package:freezed_annotation/freezed_annotation.dart';

part 'author.freezed.dart';
part 'author.g.dart';

@freezed
abstract class Author with _$Author {
  const factory Author({
    /// Unique id of author
    required String id,

    /// name, in both languages "pa" and "en"
    required Map<String, String> name,

    /// order of author in author list
    required int order,

    /// ref path to this author's image in cloud storage
    required String imagePath,

    /// about author url, in both languages "pa" and "en"
    required Map<String, String> aboutUrl,

    /// path to locally stored image, if any
    String? localImagePath,
  }) = _Author;

  factory Author.fromJson(Map<String, Object?> json) => _$AuthorFromJson(json);
}
