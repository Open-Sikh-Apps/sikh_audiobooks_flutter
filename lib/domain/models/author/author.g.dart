// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Author _$AuthorFromJson(Map<String, dynamic> json) => _Author(
  id: json['id'] as String,
  name: Map<String, String>.from(json['name'] as Map),
  order: (json['order'] as num).toInt(),
  imagePath: json['imagePath'] as String,
  aboutUrl: Map<String, String>.from(json['aboutUrl'] as Map),
  localImagePath: json['localImagePath'] as String?,
);

Map<String, dynamic> _$AuthorToJson(_Author instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'order': instance.order,
  'imagePath': instance.imagePath,
  'aboutUrl': instance.aboutUrl,
  'localImagePath': instance.localImagePath,
};
