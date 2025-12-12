import 'package:background_downloader/background_downloader.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_with_status_and_progress.freezed.dart';

@freezed
abstract class TaskWithStatusAndProgress with _$TaskWithStatusAndProgress {
  const factory TaskWithStatusAndProgress({
    required Task task,
    TaskStatus? status,
    double? progress,
  }) = _TaskWithStatusAndProgress;
}
