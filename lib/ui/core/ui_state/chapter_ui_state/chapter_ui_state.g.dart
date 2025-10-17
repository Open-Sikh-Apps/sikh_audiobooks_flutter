// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_ui_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChapterUiState _$ChapterUiStateFromJson(Map<String, dynamic> json) =>
    _ChapterUiState(
      chapter: Chapter.fromJson(json['chapter'] as Map<String, dynamic>),
      downloadProgressPercent: (json['downloadProgressPercent'] as num?)
          ?.toInt(),
      isPlaying: json['isPlaying'] as bool,
      audiobookUiState: AudiobookUiState.fromJson(
        json['audiobookUiState'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$ChapterUiStateToJson(_ChapterUiState instance) =>
    <String, dynamic>{
      'chapter': instance.chapter.toJson(),
      'downloadProgressPercent': instance.downloadProgressPercent,
      'isPlaying': instance.isPlaying,
      'audiobookUiState': instance.audiobookUiState.toJson(),
    };
