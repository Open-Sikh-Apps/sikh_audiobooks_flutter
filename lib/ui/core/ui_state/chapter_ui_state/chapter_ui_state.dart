import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sikh_audiobooks_flutter/domain/models/chapter/chapter.dart';
import 'package:sikh_audiobooks_flutter/ui/core/ui_state/audiobook_ui_state/audiobook_ui_state.dart';

part 'chapter_ui_state.freezed.dart';
part 'chapter_ui_state.g.dart';

@freezed
abstract class ChapterUiState with _$ChapterUiState {
  factory ChapterUiState({
    required Chapter chapter,
    int? downloadProgressPercent,
    required bool isPlaying,
    required AudiobookUiState audiobookUiState,
  }) = _ChapterUiState;

  factory ChapterUiState.fromJson(Map<String, dynamic> json) =>
      _$ChapterUiStateFromJson(json);
}
