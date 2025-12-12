// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chapter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Chapter {

/// Unique id of chapter
 String get id;/// id for this chapter's audiobook
 String get audioBookId;/// order of this chapter in the audiobook
 int get audioBookOrder;/// name, in both languages "pa" and "en"
 Map<String, String> get name;/// ref path to the chapter's audio in cloud storage
 String get audioPath;/// pdf url, if PdfUrlType of this book is per "chapter"
 String? get pdfUrl;/// duration of this chapter's audio
 ApiDuration get duration;/// path to locally stored audio, if any
 String? get localAudioPath;
/// Create a copy of Chapter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChapterCopyWith<Chapter> get copyWith => _$ChapterCopyWithImpl<Chapter>(this as Chapter, _$identity);

  /// Serializes this Chapter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Chapter&&(identical(other.id, id) || other.id == id)&&(identical(other.audioBookId, audioBookId) || other.audioBookId == audioBookId)&&(identical(other.audioBookOrder, audioBookOrder) || other.audioBookOrder == audioBookOrder)&&const DeepCollectionEquality().equals(other.name, name)&&(identical(other.audioPath, audioPath) || other.audioPath == audioPath)&&(identical(other.pdfUrl, pdfUrl) || other.pdfUrl == pdfUrl)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.localAudioPath, localAudioPath) || other.localAudioPath == localAudioPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,audioBookId,audioBookOrder,const DeepCollectionEquality().hash(name),audioPath,pdfUrl,duration,localAudioPath);

@override
String toString() {
  return 'Chapter(id: $id, audioBookId: $audioBookId, audioBookOrder: $audioBookOrder, name: $name, audioPath: $audioPath, pdfUrl: $pdfUrl, duration: $duration, localAudioPath: $localAudioPath)';
}


}

/// @nodoc
abstract mixin class $ChapterCopyWith<$Res>  {
  factory $ChapterCopyWith(Chapter value, $Res Function(Chapter) _then) = _$ChapterCopyWithImpl;
@useResult
$Res call({
 String id, String audioBookId, int audioBookOrder, Map<String, String> name, String audioPath, String? pdfUrl, ApiDuration duration, String? localAudioPath
});


$ApiDurationCopyWith<$Res> get duration;

}
/// @nodoc
class _$ChapterCopyWithImpl<$Res>
    implements $ChapterCopyWith<$Res> {
  _$ChapterCopyWithImpl(this._self, this._then);

  final Chapter _self;
  final $Res Function(Chapter) _then;

/// Create a copy of Chapter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? audioBookId = null,Object? audioBookOrder = null,Object? name = null,Object? audioPath = null,Object? pdfUrl = freezed,Object? duration = null,Object? localAudioPath = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,audioBookId: null == audioBookId ? _self.audioBookId : audioBookId // ignore: cast_nullable_to_non_nullable
as String,audioBookOrder: null == audioBookOrder ? _self.audioBookOrder : audioBookOrder // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as Map<String, String>,audioPath: null == audioPath ? _self.audioPath : audioPath // ignore: cast_nullable_to_non_nullable
as String,pdfUrl: freezed == pdfUrl ? _self.pdfUrl : pdfUrl // ignore: cast_nullable_to_non_nullable
as String?,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as ApiDuration,localAudioPath: freezed == localAudioPath ? _self.localAudioPath : localAudioPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of Chapter
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiDurationCopyWith<$Res> get duration {
  
  return $ApiDurationCopyWith<$Res>(_self.duration, (value) {
    return _then(_self.copyWith(duration: value));
  });
}
}


/// Adds pattern-matching-related methods to [Chapter].
extension ChapterPatterns on Chapter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Chapter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Chapter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Chapter value)  $default,){
final _that = this;
switch (_that) {
case _Chapter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Chapter value)?  $default,){
final _that = this;
switch (_that) {
case _Chapter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String audioBookId,  int audioBookOrder,  Map<String, String> name,  String audioPath,  String? pdfUrl,  ApiDuration duration,  String? localAudioPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Chapter() when $default != null:
return $default(_that.id,_that.audioBookId,_that.audioBookOrder,_that.name,_that.audioPath,_that.pdfUrl,_that.duration,_that.localAudioPath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String audioBookId,  int audioBookOrder,  Map<String, String> name,  String audioPath,  String? pdfUrl,  ApiDuration duration,  String? localAudioPath)  $default,) {final _that = this;
switch (_that) {
case _Chapter():
return $default(_that.id,_that.audioBookId,_that.audioBookOrder,_that.name,_that.audioPath,_that.pdfUrl,_that.duration,_that.localAudioPath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String audioBookId,  int audioBookOrder,  Map<String, String> name,  String audioPath,  String? pdfUrl,  ApiDuration duration,  String? localAudioPath)?  $default,) {final _that = this;
switch (_that) {
case _Chapter() when $default != null:
return $default(_that.id,_that.audioBookId,_that.audioBookOrder,_that.name,_that.audioPath,_that.pdfUrl,_that.duration,_that.localAudioPath);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Chapter implements Chapter {
  const _Chapter({required this.id, required this.audioBookId, required this.audioBookOrder, required final  Map<String, String> name, required this.audioPath, this.pdfUrl, required this.duration, this.localAudioPath}): _name = name;
  factory _Chapter.fromJson(Map<String, dynamic> json) => _$ChapterFromJson(json);

/// Unique id of chapter
@override final  String id;
/// id for this chapter's audiobook
@override final  String audioBookId;
/// order of this chapter in the audiobook
@override final  int audioBookOrder;
/// name, in both languages "pa" and "en"
 final  Map<String, String> _name;
/// name, in both languages "pa" and "en"
@override Map<String, String> get name {
  if (_name is EqualUnmodifiableMapView) return _name;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_name);
}

/// ref path to the chapter's audio in cloud storage
@override final  String audioPath;
/// pdf url, if PdfUrlType of this book is per "chapter"
@override final  String? pdfUrl;
/// duration of this chapter's audio
@override final  ApiDuration duration;
/// path to locally stored audio, if any
@override final  String? localAudioPath;

/// Create a copy of Chapter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChapterCopyWith<_Chapter> get copyWith => __$ChapterCopyWithImpl<_Chapter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChapterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Chapter&&(identical(other.id, id) || other.id == id)&&(identical(other.audioBookId, audioBookId) || other.audioBookId == audioBookId)&&(identical(other.audioBookOrder, audioBookOrder) || other.audioBookOrder == audioBookOrder)&&const DeepCollectionEquality().equals(other._name, _name)&&(identical(other.audioPath, audioPath) || other.audioPath == audioPath)&&(identical(other.pdfUrl, pdfUrl) || other.pdfUrl == pdfUrl)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.localAudioPath, localAudioPath) || other.localAudioPath == localAudioPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,audioBookId,audioBookOrder,const DeepCollectionEquality().hash(_name),audioPath,pdfUrl,duration,localAudioPath);

@override
String toString() {
  return 'Chapter(id: $id, audioBookId: $audioBookId, audioBookOrder: $audioBookOrder, name: $name, audioPath: $audioPath, pdfUrl: $pdfUrl, duration: $duration, localAudioPath: $localAudioPath)';
}


}

/// @nodoc
abstract mixin class _$ChapterCopyWith<$Res> implements $ChapterCopyWith<$Res> {
  factory _$ChapterCopyWith(_Chapter value, $Res Function(_Chapter) _then) = __$ChapterCopyWithImpl;
@override @useResult
$Res call({
 String id, String audioBookId, int audioBookOrder, Map<String, String> name, String audioPath, String? pdfUrl, ApiDuration duration, String? localAudioPath
});


@override $ApiDurationCopyWith<$Res> get duration;

}
/// @nodoc
class __$ChapterCopyWithImpl<$Res>
    implements _$ChapterCopyWith<$Res> {
  __$ChapterCopyWithImpl(this._self, this._then);

  final _Chapter _self;
  final $Res Function(_Chapter) _then;

/// Create a copy of Chapter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? audioBookId = null,Object? audioBookOrder = null,Object? name = null,Object? audioPath = null,Object? pdfUrl = freezed,Object? duration = null,Object? localAudioPath = freezed,}) {
  return _then(_Chapter(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,audioBookId: null == audioBookId ? _self.audioBookId : audioBookId // ignore: cast_nullable_to_non_nullable
as String,audioBookOrder: null == audioBookOrder ? _self.audioBookOrder : audioBookOrder // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self._name : name // ignore: cast_nullable_to_non_nullable
as Map<String, String>,audioPath: null == audioPath ? _self.audioPath : audioPath // ignore: cast_nullable_to_non_nullable
as String,pdfUrl: freezed == pdfUrl ? _self.pdfUrl : pdfUrl // ignore: cast_nullable_to_non_nullable
as String?,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as ApiDuration,localAudioPath: freezed == localAudioPath ? _self.localAudioPath : localAudioPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of Chapter
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiDurationCopyWith<$Res> get duration {
  
  return $ApiDurationCopyWith<$Res>(_self.duration, (value) {
    return _then(_self.copyWith(duration: value));
  });
}
}

// dart format on
