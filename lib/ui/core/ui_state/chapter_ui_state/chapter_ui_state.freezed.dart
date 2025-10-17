// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chapter_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChapterUiState {

 Chapter get chapter; int? get downloadProgressPercent; bool get isPlaying; AudiobookUiState get audiobookUiState;
/// Create a copy of ChapterUiState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChapterUiStateCopyWith<ChapterUiState> get copyWith => _$ChapterUiStateCopyWithImpl<ChapterUiState>(this as ChapterUiState, _$identity);

  /// Serializes this ChapterUiState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChapterUiState&&(identical(other.chapter, chapter) || other.chapter == chapter)&&(identical(other.downloadProgressPercent, downloadProgressPercent) || other.downloadProgressPercent == downloadProgressPercent)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.audiobookUiState, audiobookUiState) || other.audiobookUiState == audiobookUiState));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,chapter,downloadProgressPercent,isPlaying,audiobookUiState);

@override
String toString() {
  return 'ChapterUiState(chapter: $chapter, downloadProgressPercent: $downloadProgressPercent, isPlaying: $isPlaying, audiobookUiState: $audiobookUiState)';
}


}

/// @nodoc
abstract mixin class $ChapterUiStateCopyWith<$Res>  {
  factory $ChapterUiStateCopyWith(ChapterUiState value, $Res Function(ChapterUiState) _then) = _$ChapterUiStateCopyWithImpl;
@useResult
$Res call({
 Chapter chapter, int? downloadProgressPercent, bool isPlaying, AudiobookUiState audiobookUiState
});


$ChapterCopyWith<$Res> get chapter;$AudiobookUiStateCopyWith<$Res> get audiobookUiState;

}
/// @nodoc
class _$ChapterUiStateCopyWithImpl<$Res>
    implements $ChapterUiStateCopyWith<$Res> {
  _$ChapterUiStateCopyWithImpl(this._self, this._then);

  final ChapterUiState _self;
  final $Res Function(ChapterUiState) _then;

/// Create a copy of ChapterUiState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chapter = null,Object? downloadProgressPercent = freezed,Object? isPlaying = null,Object? audiobookUiState = null,}) {
  return _then(_self.copyWith(
chapter: null == chapter ? _self.chapter : chapter // ignore: cast_nullable_to_non_nullable
as Chapter,downloadProgressPercent: freezed == downloadProgressPercent ? _self.downloadProgressPercent : downloadProgressPercent // ignore: cast_nullable_to_non_nullable
as int?,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,audiobookUiState: null == audiobookUiState ? _self.audiobookUiState : audiobookUiState // ignore: cast_nullable_to_non_nullable
as AudiobookUiState,
  ));
}
/// Create a copy of ChapterUiState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChapterCopyWith<$Res> get chapter {
  
  return $ChapterCopyWith<$Res>(_self.chapter, (value) {
    return _then(_self.copyWith(chapter: value));
  });
}/// Create a copy of ChapterUiState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AudiobookUiStateCopyWith<$Res> get audiobookUiState {
  
  return $AudiobookUiStateCopyWith<$Res>(_self.audiobookUiState, (value) {
    return _then(_self.copyWith(audiobookUiState: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChapterUiState].
extension ChapterUiStatePatterns on ChapterUiState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChapterUiState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChapterUiState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChapterUiState value)  $default,){
final _that = this;
switch (_that) {
case _ChapterUiState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChapterUiState value)?  $default,){
final _that = this;
switch (_that) {
case _ChapterUiState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Chapter chapter,  int? downloadProgressPercent,  bool isPlaying,  AudiobookUiState audiobookUiState)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChapterUiState() when $default != null:
return $default(_that.chapter,_that.downloadProgressPercent,_that.isPlaying,_that.audiobookUiState);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Chapter chapter,  int? downloadProgressPercent,  bool isPlaying,  AudiobookUiState audiobookUiState)  $default,) {final _that = this;
switch (_that) {
case _ChapterUiState():
return $default(_that.chapter,_that.downloadProgressPercent,_that.isPlaying,_that.audiobookUiState);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Chapter chapter,  int? downloadProgressPercent,  bool isPlaying,  AudiobookUiState audiobookUiState)?  $default,) {final _that = this;
switch (_that) {
case _ChapterUiState() when $default != null:
return $default(_that.chapter,_that.downloadProgressPercent,_that.isPlaying,_that.audiobookUiState);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChapterUiState implements ChapterUiState {
   _ChapterUiState({required this.chapter, this.downloadProgressPercent, required this.isPlaying, required this.audiobookUiState});
  factory _ChapterUiState.fromJson(Map<String, dynamic> json) => _$ChapterUiStateFromJson(json);

@override final  Chapter chapter;
@override final  int? downloadProgressPercent;
@override final  bool isPlaying;
@override final  AudiobookUiState audiobookUiState;

/// Create a copy of ChapterUiState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChapterUiStateCopyWith<_ChapterUiState> get copyWith => __$ChapterUiStateCopyWithImpl<_ChapterUiState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChapterUiStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChapterUiState&&(identical(other.chapter, chapter) || other.chapter == chapter)&&(identical(other.downloadProgressPercent, downloadProgressPercent) || other.downloadProgressPercent == downloadProgressPercent)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.audiobookUiState, audiobookUiState) || other.audiobookUiState == audiobookUiState));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,chapter,downloadProgressPercent,isPlaying,audiobookUiState);

@override
String toString() {
  return 'ChapterUiState(chapter: $chapter, downloadProgressPercent: $downloadProgressPercent, isPlaying: $isPlaying, audiobookUiState: $audiobookUiState)';
}


}

/// @nodoc
abstract mixin class _$ChapterUiStateCopyWith<$Res> implements $ChapterUiStateCopyWith<$Res> {
  factory _$ChapterUiStateCopyWith(_ChapterUiState value, $Res Function(_ChapterUiState) _then) = __$ChapterUiStateCopyWithImpl;
@override @useResult
$Res call({
 Chapter chapter, int? downloadProgressPercent, bool isPlaying, AudiobookUiState audiobookUiState
});


@override $ChapterCopyWith<$Res> get chapter;@override $AudiobookUiStateCopyWith<$Res> get audiobookUiState;

}
/// @nodoc
class __$ChapterUiStateCopyWithImpl<$Res>
    implements _$ChapterUiStateCopyWith<$Res> {
  __$ChapterUiStateCopyWithImpl(this._self, this._then);

  final _ChapterUiState _self;
  final $Res Function(_ChapterUiState) _then;

/// Create a copy of ChapterUiState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chapter = null,Object? downloadProgressPercent = freezed,Object? isPlaying = null,Object? audiobookUiState = null,}) {
  return _then(_ChapterUiState(
chapter: null == chapter ? _self.chapter : chapter // ignore: cast_nullable_to_non_nullable
as Chapter,downloadProgressPercent: freezed == downloadProgressPercent ? _self.downloadProgressPercent : downloadProgressPercent // ignore: cast_nullable_to_non_nullable
as int?,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,audiobookUiState: null == audiobookUiState ? _self.audiobookUiState : audiobookUiState // ignore: cast_nullable_to_non_nullable
as AudiobookUiState,
  ));
}

/// Create a copy of ChapterUiState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChapterCopyWith<$Res> get chapter {
  
  return $ChapterCopyWith<$Res>(_self.chapter, (value) {
    return _then(_self.copyWith(chapter: value));
  });
}/// Create a copy of ChapterUiState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AudiobookUiStateCopyWith<$Res> get audiobookUiState {
  
  return $AudiobookUiStateCopyWith<$Res>(_self.audiobookUiState, (value) {
    return _then(_self.copyWith(audiobookUiState: value));
  });
}
}

// dart format on
