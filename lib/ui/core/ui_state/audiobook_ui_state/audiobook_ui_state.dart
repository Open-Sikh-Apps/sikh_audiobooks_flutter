import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sikh_audiobooks_flutter/domain/models/api_duration/api_duration.dart';
import 'package:sikh_audiobooks_flutter/domain/models/audiobook/audiobook.dart';
import 'package:sikh_audiobooks_flutter/domain/models/audiobook_resume_location/audiobook_resume_location.dart';
import 'package:sikh_audiobooks_flutter/domain/models/author/author.dart';
import 'package:sikh_audiobooks_flutter/domain/models/chapter/chapter.dart';

part 'audiobook_ui_state.freezed.dart';
part 'audiobook_ui_state.g.dart';

@freezed
abstract class AudiobookUiState with _$AudiobookUiState {
  factory AudiobookUiState({
    required Author author,
    required Audiobook audiobook,
    required bool inLibrary,
    required List<Chapter> chapters,
    AudiobookResumeLocation? resumeLocation,
    int? downloadProgressPercent,
    required bool isPlaying,
  }) = _AudiobookUiState;

  factory AudiobookUiState.fromJson(Map<String, dynamic> json) =>
      _$AudiobookUiStateFromJson(json);
}

extension AudiobookUiStateExtensions on AudiobookUiState {
  Duration totalDuration() {
    return chapters.totalDuration();
  }

  Duration leftDuration() {
    final currentResumeLocation = resumeLocation;
    if (currentResumeLocation == null) {
      return totalDuration();
    } else {
      final resumeChapter = chapters.firstWhereOrNull(
        (c) => (c.id == currentResumeLocation.chapterId),
      );
      if (resumeChapter == null) {
        return totalDuration();
      }
      final nextChaptersDuration = chapters
          .where((c) => (c.audioBookOrder > resumeChapter.audioBookOrder))
          .totalDuration();
      final thisChapterLeftDuration =
          resumeChapter.duration.toDuration() -
          Duration(seconds: currentResumeLocation.locationInSeconds);
      return nextChaptersDuration + thisChapterLeftDuration;
    }
  }

  bool anyDownloaded() => chapters.anyDownloaded();
  bool allDownloaded() => chapters.allDownloaded();
}
