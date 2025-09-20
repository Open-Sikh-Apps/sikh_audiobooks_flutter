// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'duration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Duration _$DurationFromJson(Map<String, dynamic> json) => _Duration(
  hours: (json['hours'] as num?)?.toInt(),
  minutes: (json['minutes'] as num?)?.toInt(),
  seconds: (json['seconds'] as num?)?.toInt(),
);

Map<String, dynamic> _$DurationToJson(_Duration instance) => <String, dynamic>{
  'hours': instance.hours,
  'minutes': instance.minutes,
  'seconds': instance.seconds,
};
