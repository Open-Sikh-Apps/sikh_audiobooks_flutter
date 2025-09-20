import 'package:freezed_annotation/freezed_annotation.dart';

part 'duration.freezed.dart';
part 'duration.g.dart';

@freezed
abstract class Duration with _$Duration {
  const factory Duration({int? hours, int? minutes, int? seconds}) = _Duration;

  factory Duration.fromJson(Map<String, Object?> json) =>
      _$DurationFromJson(json);
}
