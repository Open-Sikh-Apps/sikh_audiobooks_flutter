// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Chapter _$ChapterFromJson(Map<String, dynamic> json) => _Chapter(
  id: json['id'] as String,
  audioBookId: json['audioBookId'] as String,
  audioBookOrder: (json['audioBookOrder'] as num).toInt(),
  name: Map<String, String>.from(json['name'] as Map),
  audioPath: json['audioPath'] as String,
  pdfUrl: json['pdfUrl'] as String?,
  duration: ApiDuration.fromJson(json['duration'] as Map<String, dynamic>),
  localAudioPath: json['localAudioPath'] as String?,
);

Map<String, dynamic> _$ChapterToJson(_Chapter instance) => <String, dynamic>{
  'id': instance.id,
  'audioBookId': instance.audioBookId,
  'audioBookOrder': instance.audioBookOrder,
  'name': instance.name,
  'audioPath': instance.audioPath,
  'pdfUrl': instance.pdfUrl,
  'duration': instance.duration.toJson(),
  'localAudioPath': instance.localAudioPath,
};
