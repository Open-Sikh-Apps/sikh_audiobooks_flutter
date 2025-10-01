// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audiobook_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AudiobookUiState {

 Author get author; Audiobook get audiobook; bool get inLibrary; List<Chapter> get chapters; AudiobookResumeLocation? get resumeLocation; int? get downloadProgressPercent; bool get isPlaying;
/// Create a copy of AudiobookUiState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AudiobookUiStateCopyWith<AudiobookUiState> get copyWith => _$AudiobookUiStateCopyWithImpl<AudiobookUiState>(this as AudiobookUiState, _$identity);

  /// Serializes this AudiobookUiState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AudiobookUiState&&(identical(other.author, author) || other.author == author)&&(identical(other.audiobook, audiobook) || other.audiobook == audiobook)&&(identical(other.inLibrary, inLibrary) || other.inLibrary == inLibrary)&&const DeepCollectionEquality().equals(other.chapters, chapters)&&(identical(other.resumeLocation, resumeLocation) || other.resumeLocation == resumeLocation)&&(identical(other.downloadProgressPercent, downloadProgressPercent) || other.downloadProgressPercent == downloadProgressPercent)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,author,audiobook,inLibrary,const DeepCollectionEquality().hash(chapters),resumeLocation,downloadProgressPercent,isPlaying);

@override
String toString() {
  return 'AudiobookUiState(author: $author, audiobook: $audiobook, inLibrary: $inLibrary, chapters: $chapters, resumeLocation: $resumeLocation, downloadProgressPercent: $downloadProgressPercent, isPlaying: $isPlaying)';
}


}

/// @nodoc
abstract mixin class $AudiobookUiStateCopyWith<$Res>  {
  factory $AudiobookUiStateCopyWith(AudiobookUiState value, $Res Function(AudiobookUiState) _then) = _$AudiobookUiStateCopyWithImpl;
@useResult
$Res call({
 Author author, Audiobook audiobook, bool inLibrary, List<Chapter> chapters, AudiobookResumeLocation? resumeLocation, int? downloadProgressPercent, bool isPlaying
});


$AuthorCopyWith<$Res> get author;$AudiobookCopyWith<$Res> get audiobook;$AudiobookResumeLocationCopyWith<$Res>? get resumeLocation;

}
/// @nodoc
class _$AudiobookUiStateCopyWithImpl<$Res>
    implements $AudiobookUiStateCopyWith<$Res> {
  _$AudiobookUiStateCopyWithImpl(this._self, this._then);

  final AudiobookUiState _self;
  final $Res Function(AudiobookUiState) _then;

/// Create a copy of AudiobookUiState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? author = null,Object? audiobook = null,Object? inLibrary = null,Object? chapters = null,Object? resumeLocation = freezed,Object? downloadProgressPercent = freezed,Object? isPlaying = null,}) {
  return _then(_self.copyWith(
author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as Author,audiobook: null == audiobook ? _self.audiobook : audiobook // ignore: cast_nullable_to_non_nullable
as Audiobook,inLibrary: null == inLibrary ? _self.inLibrary : inLibrary // ignore: cast_nullable_to_non_nullable
as bool,chapters: null == chapters ? _self.chapters : chapters // ignore: cast_nullable_to_non_nullable
as List<Chapter>,resumeLocation: freezed == resumeLocation ? _self.resumeLocation : resumeLocation // ignore: cast_nullable_to_non_nullable
as AudiobookResumeLocation?,downloadProgressPercent: freezed == downloadProgressPercent ? _self.downloadProgressPercent : downloadProgressPercent // ignore: cast_nullable_to_non_nullable
as int?,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of AudiobookUiState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthorCopyWith<$Res> get author {
  
  return $AuthorCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}/// Create a copy of AudiobookUiState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AudiobookCopyWith<$Res> get audiobook {
  
  return $AudiobookCopyWith<$Res>(_self.audiobook, (value) {
    return _then(_self.copyWith(audiobook: value));
  });
}/// Create a copy of AudiobookUiState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AudiobookResumeLocationCopyWith<$Res>? get resumeLocation {
    if (_self.resumeLocation == null) {
    return null;
  }

  return $AudiobookResumeLocationCopyWith<$Res>(_self.resumeLocation!, (value) {
    return _then(_self.copyWith(resumeLocation: value));
  });
}
}


/// Adds pattern-matching-related methods to [AudiobookUiState].
extension AudiobookUiStatePatterns on AudiobookUiState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AudiobookUiState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AudiobookUiState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AudiobookUiState value)  $default,){
final _that = this;
switch (_that) {
case _AudiobookUiState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AudiobookUiState value)?  $default,){
final _that = this;
switch (_that) {
case _AudiobookUiState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Author author,  Audiobook audiobook,  bool inLibrary,  List<Chapter> chapters,  AudiobookResumeLocation? resumeLocation,  int? downloadProgressPercent,  bool isPlaying)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AudiobookUiState() when $default != null:
return $default(_that.author,_that.audiobook,_that.inLibrary,_that.chapters,_that.resumeLocation,_that.downloadProgressPercent,_that.isPlaying);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Author author,  Audiobook audiobook,  bool inLibrary,  List<Chapter> chapters,  AudiobookResumeLocation? resumeLocation,  int? downloadProgressPercent,  bool isPlaying)  $default,) {final _that = this;
switch (_that) {
case _AudiobookUiState():
return $default(_that.author,_that.audiobook,_that.inLibrary,_that.chapters,_that.resumeLocation,_that.downloadProgressPercent,_that.isPlaying);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Author author,  Audiobook audiobook,  bool inLibrary,  List<Chapter> chapters,  AudiobookResumeLocation? resumeLocation,  int? downloadProgressPercent,  bool isPlaying)?  $default,) {final _that = this;
switch (_that) {
case _AudiobookUiState() when $default != null:
return $default(_that.author,_that.audiobook,_that.inLibrary,_that.chapters,_that.resumeLocation,_that.downloadProgressPercent,_that.isPlaying);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AudiobookUiState implements AudiobookUiState {
   _AudiobookUiState({required this.author, required this.audiobook, required this.inLibrary, required final  List<Chapter> chapters, this.resumeLocation, this.downloadProgressPercent, required this.isPlaying}): _chapters = chapters;
  factory _AudiobookUiState.fromJson(Map<String, dynamic> json) => _$AudiobookUiStateFromJson(json);

@override final  Author author;
@override final  Audiobook audiobook;
@override final  bool inLibrary;
 final  List<Chapter> _chapters;
@override List<Chapter> get chapters {
  if (_chapters is EqualUnmodifiableListView) return _chapters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_chapters);
}

@override final  AudiobookResumeLocation? resumeLocation;
@override final  int? downloadProgressPercent;
@override final  bool isPlaying;

/// Create a copy of AudiobookUiState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AudiobookUiStateCopyWith<_AudiobookUiState> get copyWith => __$AudiobookUiStateCopyWithImpl<_AudiobookUiState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AudiobookUiStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AudiobookUiState&&(identical(other.author, author) || other.author == author)&&(identical(other.audiobook, audiobook) || other.audiobook == audiobook)&&(identical(other.inLibrary, inLibrary) || other.inLibrary == inLibrary)&&const DeepCollectionEquality().equals(other._chapters, _chapters)&&(identical(other.resumeLocation, resumeLocation) || other.resumeLocation == resumeLocation)&&(identical(other.downloadProgressPercent, downloadProgressPercent) || other.downloadProgressPercent == downloadProgressPercent)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,author,audiobook,inLibrary,const DeepCollectionEquality().hash(_chapters),resumeLocation,downloadProgressPercent,isPlaying);

@override
String toString() {
  return 'AudiobookUiState(author: $author, audiobook: $audiobook, inLibrary: $inLibrary, chapters: $chapters, resumeLocation: $resumeLocation, downloadProgressPercent: $downloadProgressPercent, isPlaying: $isPlaying)';
}


}

/// @nodoc
abstract mixin class _$AudiobookUiStateCopyWith<$Res> implements $AudiobookUiStateCopyWith<$Res> {
  factory _$AudiobookUiStateCopyWith(_AudiobookUiState value, $Res Function(_AudiobookUiState) _then) = __$AudiobookUiStateCopyWithImpl;
@override @useResult
$Res call({
 Author author, Audiobook audiobook, bool inLibrary, List<Chapter> chapters, AudiobookResumeLocation? resumeLocation, int? downloadProgressPercent, bool isPlaying
});


@override $AuthorCopyWith<$Res> get author;@override $AudiobookCopyWith<$Res> get audiobook;@override $AudiobookResumeLocationCopyWith<$Res>? get resumeLocation;

}
/// @nodoc
class __$AudiobookUiStateCopyWithImpl<$Res>
    implements _$AudiobookUiStateCopyWith<$Res> {
  __$AudiobookUiStateCopyWithImpl(this._self, this._then);

  final _AudiobookUiState _self;
  final $Res Function(_AudiobookUiState) _then;

/// Create a copy of AudiobookUiState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? author = null,Object? audiobook = null,Object? inLibrary = null,Object? chapters = null,Object? resumeLocation = freezed,Object? downloadProgressPercent = freezed,Object? isPlaying = null,}) {
  return _then(_AudiobookUiState(
author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as Author,audiobook: null == audiobook ? _self.audiobook : audiobook // ignore: cast_nullable_to_non_nullable
as Audiobook,inLibrary: null == inLibrary ? _self.inLibrary : inLibrary // ignore: cast_nullable_to_non_nullable
as bool,chapters: null == chapters ? _self._chapters : chapters // ignore: cast_nullable_to_non_nullable
as List<Chapter>,resumeLocation: freezed == resumeLocation ? _self.resumeLocation : resumeLocation // ignore: cast_nullable_to_non_nullable
as AudiobookResumeLocation?,downloadProgressPercent: freezed == downloadProgressPercent ? _self.downloadProgressPercent : downloadProgressPercent // ignore: cast_nullable_to_non_nullable
as int?,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of AudiobookUiState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthorCopyWith<$Res> get author {
  
  return $AuthorCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}/// Create a copy of AudiobookUiState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AudiobookCopyWith<$Res> get audiobook {
  
  return $AudiobookCopyWith<$Res>(_self.audiobook, (value) {
    return _then(_self.copyWith(audiobook: value));
  });
}/// Create a copy of AudiobookUiState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AudiobookResumeLocationCopyWith<$Res>? get resumeLocation {
    if (_self.resumeLocation == null) {
    return null;
  }

  return $AudiobookResumeLocationCopyWith<$Res>(_self.resumeLocation!, (value) {
    return _then(_self.copyWith(resumeLocation: value));
  });
}
}

// dart format on
