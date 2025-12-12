import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_duration.freezed.dart';
part 'api_duration.g.dart';

@freezed
abstract class ApiDuration with _$ApiDuration {
  const factory ApiDuration({int? hours, int? minutes, int? seconds}) =
      _ApiDuration;

  factory ApiDuration.fromJson(Map<String, Object?> json) =>
      _$ApiDurationFromJson(json);
}

extension ApiDurationExtensions on ApiDuration {
  Duration toDuration() {
    return Duration(
      hours: hours ?? 0,
      minutes: minutes ?? 0,
      seconds: seconds ?? 0,
    );
  }

  String toDurationString() {
    final hoursString = (hours != null)
        ? "${hours.toString().padLeft(2, "0")}:"
        : null;
    final minutesString =
        "${(minutes != null) ? minutes.toString().padLeft(2, "0") : "00"}:";
    final secondsString = (seconds != null)
        ? seconds.toString().padLeft(2, "0")
        : "00";

    return "${(hoursString != null) ? hoursString : ''}$minutesString$secondsString";
  }
}
