// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_duration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ApiDuration {

 int? get hours; int? get minutes; int? get seconds;
/// Create a copy of ApiDuration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiDurationCopyWith<ApiDuration> get copyWith => _$ApiDurationCopyWithImpl<ApiDuration>(this as ApiDuration, _$identity);

  /// Serializes this ApiDuration to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiDuration&&(identical(other.hours, hours) || other.hours == hours)&&(identical(other.minutes, minutes) || other.minutes == minutes)&&(identical(other.seconds, seconds) || other.seconds == seconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hours,minutes,seconds);

@override
String toString() {
  return 'ApiDuration(hours: $hours, minutes: $minutes, seconds: $seconds)';
}


}

/// @nodoc
abstract mixin class $ApiDurationCopyWith<$Res>  {
  factory $ApiDurationCopyWith(ApiDuration value, $Res Function(ApiDuration) _then) = _$ApiDurationCopyWithImpl;
@useResult
$Res call({
 int? hours, int? minutes, int? seconds
});




}
/// @nodoc
class _$ApiDurationCopyWithImpl<$Res>
    implements $ApiDurationCopyWith<$Res> {
  _$ApiDurationCopyWithImpl(this._self, this._then);

  final ApiDuration _self;
  final $Res Function(ApiDuration) _then;

/// Create a copy of ApiDuration
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


/// Adds pattern-matching-related methods to [ApiDuration].
extension ApiDurationPatterns on ApiDuration {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiDuration value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiDuration() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiDuration value)  $default,){
final _that = this;
switch (_that) {
case _ApiDuration():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiDuration value)?  $default,){
final _that = this;
switch (_that) {
case _ApiDuration() when $default != null:
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
case _ApiDuration() when $default != null:
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
case _ApiDuration():
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
case _ApiDuration() when $default != null:
return $default(_that.hours,_that.minutes,_that.seconds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApiDuration implements ApiDuration {
  const _ApiDuration({this.hours, this.minutes, this.seconds});
  factory _ApiDuration.fromJson(Map<String, dynamic> json) => _$ApiDurationFromJson(json);

@override final  int? hours;
@override final  int? minutes;
@override final  int? seconds;

/// Create a copy of ApiDuration
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiDurationCopyWith<_ApiDuration> get copyWith => __$ApiDurationCopyWithImpl<_ApiDuration>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApiDurationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiDuration&&(identical(other.hours, hours) || other.hours == hours)&&(identical(other.minutes, minutes) || other.minutes == minutes)&&(identical(other.seconds, seconds) || other.seconds == seconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hours,minutes,seconds);

@override
String toString() {
  return 'ApiDuration(hours: $hours, minutes: $minutes, seconds: $seconds)';
}


}

/// @nodoc
abstract mixin class _$ApiDurationCopyWith<$Res> implements $ApiDurationCopyWith<$Res> {
  factory _$ApiDurationCopyWith(_ApiDuration value, $Res Function(_ApiDuration) _then) = __$ApiDurationCopyWithImpl;
@override @useResult
$Res call({
 int? hours, int? minutes, int? seconds
});




}
/// @nodoc
class __$ApiDurationCopyWithImpl<$Res>
    implements _$ApiDurationCopyWith<$Res> {
  __$ApiDurationCopyWithImpl(this._self, this._then);

  final _ApiDuration _self;
  final $Res Function(_ApiDuration) _then;

/// Create a copy of ApiDuration
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hours = freezed,Object? minutes = freezed,Object? seconds = freezed,}) {
  return _then(_ApiDuration(
hours: freezed == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as int?,minutes: freezed == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int?,seconds: freezed == seconds ? _self.seconds : seconds // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
