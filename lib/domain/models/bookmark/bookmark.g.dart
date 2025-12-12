// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Bookmark _$BookmarkFromJson(Map<String, dynamic> json) => _Bookmark(
  id: json['id'] as String,
  chapterId: json['chapterId'] as String,
  locationInSeconds: (json['locationInSeconds'] as num).toInt(),
  updatedAtInMs: (json['updatedAtInMs'] as num).toInt(),
);

Map<String, dynamic> _$BookmarkToJson(_Bookmark instance) => <String, dynamic>{
  'id': instance.id,
  'chapterId': instance.chapterId,
  'locationInSeconds': instance.locationInSeconds,
  'updatedAtInMs': instance.updatedAtInMs,
};
