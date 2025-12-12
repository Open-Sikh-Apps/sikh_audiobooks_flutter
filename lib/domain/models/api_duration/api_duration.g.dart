// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_duration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApiDuration _$ApiDurationFromJson(Map<String, dynamic> json) => _ApiDuration(
  hours: (json['hours'] as num?)?.toInt(),
  minutes: (json['minutes'] as num?)?.toInt(),
  seconds: (json['seconds'] as num?)?.toInt(),
);

Map<String, dynamic> _$ApiDurationToJson(_ApiDuration instance) =>
    <String, dynamic>{
      'hours': instance.hours,
      'minutes': instance.minutes,
      'seconds': instance.seconds,
    };
