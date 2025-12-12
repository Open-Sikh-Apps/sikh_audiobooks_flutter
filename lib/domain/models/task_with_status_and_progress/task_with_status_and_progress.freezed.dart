// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_with_status_and_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TaskWithStatusAndProgress {

 Task get task; TaskStatus? get status; double? get progress;
/// Create a copy of TaskWithStatusAndProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskWithStatusAndProgressCopyWith<TaskWithStatusAndProgress> get copyWith => _$TaskWithStatusAndProgressCopyWithImpl<TaskWithStatusAndProgress>(this as TaskWithStatusAndProgress, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskWithStatusAndProgress&&(identical(other.task, task) || other.task == task)&&(identical(other.status, status) || other.status == status)&&(identical(other.progress, progress) || other.progress == progress));
}


@override
int get hashCode => Object.hash(runtimeType,task,status,progress);

@override
String toString() {
  return 'TaskWithStatusAndProgress(task: $task, status: $status, progress: $progress)';
}


}

/// @nodoc
abstract mixin class $TaskWithStatusAndProgressCopyWith<$Res>  {
  factory $TaskWithStatusAndProgressCopyWith(TaskWithStatusAndProgress value, $Res Function(TaskWithStatusAndProgress) _then) = _$TaskWithStatusAndProgressCopyWithImpl;
@useResult
$Res call({
 Task task, TaskStatus? status, double? progress
});




}
/// @nodoc
class _$TaskWithStatusAndProgressCopyWithImpl<$Res>
    implements $TaskWithStatusAndProgressCopyWith<$Res> {
  _$TaskWithStatusAndProgressCopyWithImpl(this._self, this._then);

  final TaskWithStatusAndProgress _self;
  final $Res Function(TaskWithStatusAndProgress) _then;

/// Create a copy of TaskWithStatusAndProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? task = null,Object? status = freezed,Object? progress = freezed,}) {
  return _then(_self.copyWith(
task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as Task,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus?,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskWithStatusAndProgress].
extension TaskWithStatusAndProgressPatterns on TaskWithStatusAndProgress {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskWithStatusAndProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskWithStatusAndProgress() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskWithStatusAndProgress value)  $default,){
final _that = this;
switch (_that) {
case _TaskWithStatusAndProgress():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskWithStatusAndProgress value)?  $default,){
final _that = this;
switch (_that) {
case _TaskWithStatusAndProgress() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Task task,  TaskStatus? status,  double? progress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskWithStatusAndProgress() when $default != null:
return $default(_that.task,_that.status,_that.progress);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Task task,  TaskStatus? status,  double? progress)  $default,) {final _that = this;
switch (_that) {
case _TaskWithStatusAndProgress():
return $default(_that.task,_that.status,_that.progress);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Task task,  TaskStatus? status,  double? progress)?  $default,) {final _that = this;
switch (_that) {
case _TaskWithStatusAndProgress() when $default != null:
return $default(_that.task,_that.status,_that.progress);case _:
  return null;

}
}

}

/// @nodoc


class _TaskWithStatusAndProgress implements TaskWithStatusAndProgress {
  const _TaskWithStatusAndProgress({required this.task, this.status, this.progress});
  

@override final  Task task;
@override final  TaskStatus? status;
@override final  double? progress;

/// Create a copy of TaskWithStatusAndProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskWithStatusAndProgressCopyWith<_TaskWithStatusAndProgress> get copyWith => __$TaskWithStatusAndProgressCopyWithImpl<_TaskWithStatusAndProgress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskWithStatusAndProgress&&(identical(other.task, task) || other.task == task)&&(identical(other.status, status) || other.status == status)&&(identical(other.progress, progress) || other.progress == progress));
}


@override
int get hashCode => Object.hash(runtimeType,task,status,progress);

@override
String toString() {
  return 'TaskWithStatusAndProgress(task: $task, status: $status, progress: $progress)';
}


}

/// @nodoc
abstract mixin class _$TaskWithStatusAndProgressCopyWith<$Res> implements $TaskWithStatusAndProgressCopyWith<$Res> {
  factory _$TaskWithStatusAndProgressCopyWith(_TaskWithStatusAndProgress value, $Res Function(_TaskWithStatusAndProgress) _then) = __$TaskWithStatusAndProgressCopyWithImpl;
@override @useResult
$Res call({
 Task task, TaskStatus? status, double? progress
});




}
/// @nodoc
class __$TaskWithStatusAndProgressCopyWithImpl<$Res>
    implements _$TaskWithStatusAndProgressCopyWith<$Res> {
  __$TaskWithStatusAndProgressCopyWithImpl(this._self, this._then);

  final _TaskWithStatusAndProgress _self;
  final $Res Function(_TaskWithStatusAndProgress) _then;

/// Create a copy of TaskWithStatusAndProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? task = null,Object? status = freezed,Object? progress = freezed,}) {
  return _then(_TaskWithStatusAndProgress(
task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as Task,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus?,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
