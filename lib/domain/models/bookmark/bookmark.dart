import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmark.freezed.dart';
part 'bookmark.g.dart';

@freezed
abstract class Bookmark with _$Bookmark {
  factory Bookmark({
    // unique id of the bookmark
    required String id,

    /// id of the chapter this bookmark belongs to
    required String chapterId,

    // bookmark location in seconds
    required int locationInSeconds,

    /// updated at
    /// in millisecondsSinceEpoch
    required int updatedAtInMs,
  }) = _Bookmark;

  factory Bookmark.fromJson(Map<String, Object?> json) =>
      _$BookmarkFromJson(json);
}
