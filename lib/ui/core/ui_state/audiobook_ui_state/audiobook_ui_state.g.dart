// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audiobook_ui_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AudiobookUiState _$AudiobookUiStateFromJson(Map<String, dynamic> json) =>
    _AudiobookUiState(
      author: Author.fromJson(json['author'] as Map<String, dynamic>),
      audiobook: Audiobook.fromJson(json['audiobook'] as Map<String, dynamic>),
      inLibrary: json['inLibrary'] as bool,
      chapters: (json['chapters'] as List<dynamic>)
          .map((e) => Chapter.fromJson(e as Map<String, dynamic>))
          .toList(),
      resumeLocation: json['resumeLocation'] == null
          ? null
          : AudiobookResumeLocation.fromJson(
              json['resumeLocation'] as Map<String, dynamic>,
            ),
      downloadProgressPercent: (json['downloadProgressPercent'] as num?)
          ?.toInt(),
      isPlaying: json['isPlaying'] as bool,
    );

Map<String, dynamic> _$AudiobookUiStateToJson(_AudiobookUiState instance) =>
    <String, dynamic>{
      'author': instance.author.toJson(),
      'audiobook': instance.audiobook.toJson(),
      'inLibrary': instance.inLibrary,
      'chapters': instance.chapters.map((e) => e.toJson()).toList(),
      'resumeLocation': instance.resumeLocation?.toJson(),
      'downloadProgressPercent': instance.downloadProgressPercent,
      'isPlaying': instance.isPlaying,
    };
