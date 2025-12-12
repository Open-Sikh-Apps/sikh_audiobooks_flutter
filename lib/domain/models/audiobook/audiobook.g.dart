// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audiobook.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Audiobook _$AudiobookFromJson(Map<String, dynamic> json) => _Audiobook(
  id: json['id'] as String,
  authorId: json['authorId'] as String,
  authorOrder: (json['authorOrder'] as num).toInt(),
  name: Map<String, String>.from(json['name'] as Map),
  pdfUrlType: $enumDecode(_$PdfUrlTypeEnumMap, json['pdfUrlType']),
  pdfUrl: json['pdfUrl'] as String?,
  imagePath: json['imagePath'] as String,
  language: json['language'] as String,
  localImagePath: json['localImagePath'] as String?,
);

Map<String, dynamic> _$AudiobookToJson(_Audiobook instance) =>
    <String, dynamic>{
      'id': instance.id,
      'authorId': instance.authorId,
      'authorOrder': instance.authorOrder,
      'name': instance.name,
      'pdfUrlType': _$PdfUrlTypeEnumMap[instance.pdfUrlType]!,
      'pdfUrl': instance.pdfUrl,
      'imagePath': instance.imagePath,
      'language': instance.language,
      'localImagePath': instance.localImagePath,
    };

const _$PdfUrlTypeEnumMap = {
  PdfUrlType.book: 'book',
  PdfUrlType.chapter: 'chapter',
};
