import 'package:freezed_annotation/freezed_annotation.dart';

part 'audiobook_resume_location.freezed.dart';
part 'audiobook_resume_location.g.dart';

@freezed
abstract class AudiobookResumeLocation with _$AudiobookResumeLocation {
  factory AudiobookResumeLocation({
    /// Unique id of audiobook resume location
    /// this id matches with the audiobook's id
    /// this resume location points to
    required String id,

    /// id of the chapter
    required String chapterId,

    /// resume location in seconds
    required int locationInSeconds,

    /// updated at
    /// in millisecondsSinceEpoch
    required int updatedAtInMs,
  }) = _AudiobookResumeLocation;

  factory AudiobookResumeLocation.fromJson(Map<String, Object?> json) =>
      _$AudiobookResumeLocationFromJson(json);
}
