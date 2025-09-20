// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'duration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Duration {

 int? get hours; int? get minutes; int? get seconds;
/// Create a copy of Duration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DurationCopyWith<Duration> get copyWith => _$DurationCopyWithImpl<Duration>(this as Duration, _$identity);

  /// Serializes this Duration to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Duration&&(identical(other.hours, hours) || other.hours == hours)&&(identical(other.minutes, minutes) || other.minutes == minutes)&&(identical(other.seconds, seconds) || other.seconds == seconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hours,minutes,seconds);

@override
String toString() {
  return 'Duration(hours: $hours, minutes: $minutes, seconds: $seconds)';
}


}

/// @nodoc
abstract mixin class $DurationCopyWith<$Res>  {
  factory $DurationCopyWith(Duration value, $Res Function(Duration) _then) = _$DurationCopyWithImpl;
@useResult
$Res call({
 int? hours, int? minutes, int? seconds
});




}
/// @nodoc
class _$DurationCopyWithImpl<$Res>
    implements $DurationCopyWith<$Res> {
  _$DurationCopyWithImpl(this._self, this._then);

  final Duration _self;
  final $Res Function(Duration) _then;

/// Create a copy of Duration
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hours = freezed,Object? minutes = freezed,Object? seconds = freezed,}) {
  return _then(_self.copyWith(
hours: freezed == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as int?,minutes: freezed == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int?,seconds: freezed == seconds ? _self.seconds : seconds // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Duration].
extension DurationPatterns on Duration {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Duration value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Duration() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Duration value)  $default,){
final _that = this;
switch (_that) {
case _Duration():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Duration value)?  $default,){
final _that = this;
switch (_that) {
case _Duration() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? hours,  int? minutes,  int? seconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Duration() when $default != null:
return $default(_that.hours,_that.minutes,_that.seconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? hours,  int? minutes,  int? seconds)  $default,) {final _that = this;
switch (_that) {
case _Duration():
return $default(_that.hours,_that.minutes,_that.seconds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? hours,  int? minutes,  int? seconds)?  $default,) {final _that = this;
switch (_that) {
case _Duration() when $default != null:
return $default(_that.hours,_that.minutes,_that.seconds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Duration implements Duration {
  const _Duration({this.hours, this.minutes, this.seconds});
  factory _Duration.fromJson(Map<String, dynamic> json) => _$DurationFromJson(json);

@override final  int? hours;
@override final  int? minutes;
@override final  int? seconds;

/// Create a copy of Duration
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DurationCopyWith<_Duration> get copyWith => __$DurationCopyWithImpl<_Duration>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DurationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Duration&&(identical(other.hours, hours) || other.hours == hours)&&(identical(other.minutes, minutes) || other.minutes == minutes)&&(identical(other.seconds, seconds) || other.seconds == seconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hours,minutes,seconds);

@override
String toString() {
  return 'Duration(hours: $hours, minutes: $minutes, seconds: $seconds)';
}


}

/// @nodoc
abstract mixin class _$DurationCopyWith<$Res> implements $DurationCopyWith<$Res> {
  factory _$DurationCopyWith(_Duration value, $Res Function(_Duration) _then) = __$DurationCopyWithImpl;
@override @useResult
$Res call({
 int? hours, int? minutes, int? seconds
});




}
/// @nodoc
class __$DurationCopyWithImpl<$Res>
    implements _$DurationCopyWith<$Res> {
  __$DurationCopyWithImpl(this._self, this._then);

  final _Duration _self;
  final $Res Function(_Duration) _then;

/// Create a copy of Duration
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hours = freezed,Object? minutes = freezed,Object? seconds = freezed,}) {
  return _then(_Duration(
hours: freezed == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as int?,minutes: freezed == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int?,seconds: freezed == seconds ? _self.seconds : seconds // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
