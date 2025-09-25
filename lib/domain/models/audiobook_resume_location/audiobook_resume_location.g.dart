// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audiobook_resume_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AudiobookResumeLocation _$AudiobookResumeLocationFromJson(
  Map<String, dynamic> json,
) => _AudiobookResumeLocation(
  id: json['id'] as String,
  chapterId: json['chapterId'] as String,
  locationInSeconds: (json['locationInSeconds'] as num).toInt(),
  updatedAtInMs: (json['updatedAtInMs'] as num).toInt(),
);

Map<String, dynamic> _$AudiobookResumeLocationToJson(
  _AudiobookResumeLocation instance,
) => <String, dynamic>{
  'id': instance.id,
  'chapterId': instance.chapterId,
  'locationInSeconds': instance.locationInSeconds,
  'updatedAtInMs': instance.updatedAtInMs,
};
