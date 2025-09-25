// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bookmark.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Bookmark {

// unique id of the bookmark
 String get id;/// id of the chapter this bookmark belongs to
 String get chapterId;// bookmark location in seconds
 int get locationInSeconds;/// updated at
/// in millisecondsSinceEpoch
 int get updatedAtInMs;
/// Create a copy of Bookmark
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookmarkCopyWith<Bookmark> get copyWith => _$BookmarkCopyWithImpl<Bookmark>(this as Bookmark, _$identity);

  /// Serializes this Bookmark to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Bookmark&&(identical(other.id, id) || other.id == id)&&(identical(other.chapterId, chapterId) || other.chapterId == chapterId)&&(identical(other.locationInSeconds, locationInSeconds) || other.locationInSeconds == locationInSeconds)&&(identical(other.updatedAtInMs, updatedAtInMs) || other.updatedAtInMs == updatedAtInMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,chapterId,locationInSeconds,updatedAtInMs);

@override
String toString() {
  return 'Bookmark(id: $id, chapterId: $chapterId, locationInSeconds: $locationInSeconds, updatedAtInMs: $updatedAtInMs)';
}


}

/// @nodoc
abstract mixin class $BookmarkCopyWith<$Res>  {
  factory $BookmarkCopyWith(Bookmark value, $Res Function(Bookmark) _then) = _$BookmarkCopyWithImpl;
@useResult
$Res call({
 String id, String chapterId, int locationInSeconds, int updatedAtInMs
});




}
/// @nodoc
class _$BookmarkCopyWithImpl<$Res>
    implements $BookmarkCopyWith<$Res> {
  _$BookmarkCopyWithImpl(this._self, this._then);

  final Bookmark _self;
  final $Res Function(Bookmark) _then;

/// Create a copy of Bookmark
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? chapterId = null,Object? locationInSeconds = null,Object? updatedAtInMs = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,chapterId: null == chapterId ? _self.chapterId : chapterId // ignore: cast_nullable_to_non_nullable
as String,locationInSeconds: null == locationInSeconds ? _self.locationInSeconds : locationInSeconds // ignore: cast_nullable_to_non_nullable
as int,updatedAtInMs: null == updatedAtInMs ? _self.updatedAtInMs : updatedAtInMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Bookmark].
extension BookmarkPatterns on Bookmark {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Bookmark value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Bookmark() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Bookmark value)  $default,){
final _that = this;
switch (_that) {
case _Bookmark():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Bookmark value)?  $default,){
final _that = this;
switch (_that) {
case _Bookmark() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String chapterId,  int locationInSeconds,  int updatedAtInMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Bookmark() when $default != null:
return $default(_that.id,_that.chapterId,_that.locationInSeconds,_that.updatedAtInMs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String chapterId,  int locationInSeconds,  int updatedAtInMs)  $default,) {final _that = this;
switch (_that) {
case _Bookmark():
return $default(_that.id,_that.chapterId,_that.locationInSeconds,_that.updatedAtInMs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String chapterId,  int locationInSeconds,  int updatedAtInMs)?  $default,) {final _that = this;
switch (_that) {
case _Bookmark() when $default != null:
return $default(_that.id,_that.chapterId,_that.locationInSeconds,_that.updatedAtInMs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Bookmark implements Bookmark {
   _Bookmark({required this.id, required this.chapterId, required this.locationInSeconds, required this.updatedAtInMs});
  factory _Bookmark.fromJson(Map<String, dynamic> json) => _$BookmarkFromJson(json);

// unique id of the bookmark
@override final  String id;
/// id of the chapter this bookmark belongs to
@override final  String chapterId;
// bookmark location in seconds
@override final  int locationInSeconds;
/// updated at
/// in millisecondsSinceEpoch
@override final  int updatedAtInMs;

/// Create a copy of Bookmark
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookmarkCopyWith<_Bookmark> get copyWith => __$BookmarkCopyWithImpl<_Bookmark>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookmarkToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Bookmark&&(identical(other.id, id) || other.id == id)&&(identical(other.chapterId, chapterId) || other.chapterId == chapterId)&&(identical(other.locationInSeconds, locationInSeconds) || other.locationInSeconds == locationInSeconds)&&(identical(other.updatedAtInMs, updatedAtInMs) || other.updatedAtInMs == updatedAtInMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,chapterId,locationInSeconds,updatedAtInMs);

@override
String toString() {
  return 'Bookmark(id: $id, chapterId: $chapterId, locationInSeconds: $locationInSeconds, updatedAtInMs: $updatedAtInMs)';
}


}

/// @nodoc
abstract mixin class _$BookmarkCopyWith<$Res> implements $BookmarkCopyWith<$Res> {
  factory _$BookmarkCopyWith(_Bookmark value, $Res Function(_Bookmark) _then) = __$BookmarkCopyWithImpl;
@override @useResult
$Res call({
 String id, String chapterId, int locationInSeconds, int updatedAtInMs
});




}
/// @nodoc
class __$BookmarkCopyWithImpl<$Res>
    implements _$BookmarkCopyWith<$Res> {
  __$BookmarkCopyWithImpl(this._self, this._then);

  final _Bookmark _self;
  final $Res Function(_Bookmark) _then;

/// Create a copy of Bookmark
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? chapterId = null,Object? locationInSeconds = null,Object? updatedAtInMs = null,}) {
  return _then(_Bookmark(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,chapterId: null == chapterId ? _self.chapterId : chapterId // ignore: cast_nullable_to_non_nullable
as String,locationInSeconds: null == locationInSeconds ? _self.locationInSeconds : locationInSeconds // ignore: cast_nullable_to_non_nullable
as int,updatedAtInMs: null == updatedAtInMs ? _self.updatedAtInMs : updatedAtInMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
