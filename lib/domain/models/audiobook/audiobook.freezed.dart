// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audiobook.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Audiobook {

/// Unique id of audiobook
 String get id;/// id for this book's author
 String get authorId;/// order of this book in the author's books
 int get authorOrder;/// name, in both languages "pa" and "en"
 Map<String, String> get name;/// pdf url is per "book" or per "chapter"
 PdfUrlType get pdfUrlType;/// pdf url, if PdfUrlType is per "book"
 String? get pdfUrl;/// ref path to this book's image in cloud storage
 String get imagePath;/// language code for book's language
 String get language;/// path to locally stored image, if any
 String? get localImagePath;
/// Create a copy of Audiobook
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AudiobookCopyWith<Audiobook> get copyWith => _$AudiobookCopyWithImpl<Audiobook>(this as Audiobook, _$identity);

  /// Serializes this Audiobook to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Audiobook&&(identical(other.id, id) || other.id == id)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.authorOrder, authorOrder) || other.authorOrder == authorOrder)&&const DeepCollectionEquality().equals(other.name, name)&&(identical(other.pdfUrlType, pdfUrlType) || other.pdfUrlType == pdfUrlType)&&(identical(other.pdfUrl, pdfUrl) || other.pdfUrl == pdfUrl)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.language, language) || other.language == language)&&(identical(other.localImagePath, localImagePath) || other.localImagePath == localImagePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,authorId,authorOrder,const DeepCollectionEquality().hash(name),pdfUrlType,pdfUrl,imagePath,language,localImagePath);

@override
String toString() {
  return 'Audiobook(id: $id, authorId: $authorId, authorOrder: $authorOrder, name: $name, pdfUrlType: $pdfUrlType, pdfUrl: $pdfUrl, imagePath: $imagePath, language: $language, localImagePath: $localImagePath)';
}


}

/// @nodoc
abstract mixin class $AudiobookCopyWith<$Res>  {
  factory $AudiobookCopyWith(Audiobook value, $Res Function(Audiobook) _then) = _$AudiobookCopyWithImpl;
@useResult
$Res call({
 String id, String authorId, int authorOrder, Map<String, String> name, PdfUrlType pdfUrlType, String? pdfUrl, String imagePath, String language, String? localImagePath
});




}
/// @nodoc
class _$AudiobookCopyWithImpl<$Res>
    implements $AudiobookCopyWith<$Res> {
  _$AudiobookCopyWithImpl(this._self, this._then);

  final Audiobook _self;
  final $Res Function(Audiobook) _then;

/// Create a copy of Audiobook
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? authorId = null,Object? authorOrder = null,Object? name = null,Object? pdfUrlType = null,Object? pdfUrl = freezed,Object? imagePath = null,Object? language = null,Object? localImagePath = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,authorOrder: null == authorOrder ? _self.authorOrder : authorOrder // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as Map<String, String>,pdfUrlType: null == pdfUrlType ? _self.pdfUrlType : pdfUrlType // ignore: cast_nullable_to_non_nullable
as PdfUrlType,pdfUrl: freezed == pdfUrl ? _self.pdfUrl : pdfUrl // ignore: cast_nullable_to_non_nullable
as String?,imagePath: null == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,localImagePath: freezed == localImagePath ? _self.localImagePath : localImagePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Audiobook].
extension AudiobookPatterns on Audiobook {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Audiobook value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Audiobook() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Audiobook value)  $default,){
final _that = this;
switch (_that) {
case _Audiobook():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Audiobook value)?  $default,){
final _that = this;
switch (_that) {
case _Audiobook() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String authorId,  int authorOrder,  Map<String, String> name,  PdfUrlType pdfUrlType,  String? pdfUrl,  String imagePath,  String language,  String? localImagePath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Audiobook() when $default != null:
return $default(_that.id,_that.authorId,_that.authorOrder,_that.name,_that.pdfUrlType,_that.pdfUrl,_that.imagePath,_that.language,_that.localImagePath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String authorId,  int authorOrder,  Map<String, String> name,  PdfUrlType pdfUrlType,  String? pdfUrl,  String imagePath,  String language,  String? localImagePath)  $default,) {final _that = this;
switch (_that) {
case _Audiobook():
return $default(_that.id,_that.authorId,_that.authorOrder,_that.name,_that.pdfUrlType,_that.pdfUrl,_that.imagePath,_that.language,_that.localImagePath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String authorId,  int authorOrder,  Map<String, String> name,  PdfUrlType pdfUrlType,  String? pdfUrl,  String imagePath,  String language,  String? localImagePath)?  $default,) {final _that = this;
switch (_that) {
case _Audiobook() when $default != null:
return $default(_that.id,_that.authorId,_that.authorOrder,_that.name,_that.pdfUrlType,_that.pdfUrl,_that.imagePath,_that.language,_that.localImagePath);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Audiobook implements Audiobook {
  const _Audiobook({required this.id, required this.authorId, required this.authorOrder, required final  Map<String, String> name, required this.pdfUrlType, this.pdfUrl, required this.imagePath, required this.language, this.localImagePath}): _name = name;
  factory _Audiobook.fromJson(Map<String, dynamic> json) => _$AudiobookFromJson(json);

/// Unique id of audiobook
@override final  String id;
/// id for this book's author
@override final  String authorId;
/// order of this book in the author's books
@override final  int authorOrder;
/// name, in both languages "pa" and "en"
 final  Map<String, String> _name;
/// name, in both languages "pa" and "en"
@override Map<String, String> get name {
  if (_name is EqualUnmodifiableMapView) return _name;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_name);
}

/// pdf url is per "book" or per "chapter"
@override final  PdfUrlType pdfUrlType;
/// pdf url, if PdfUrlType is per "book"
@override final  String? pdfUrl;
/// ref path to this book's image in cloud storage
@override final  String imagePath;
/// language code for book's language
@override final  String language;
/// path to locally stored image, if any
@override final  String? localImagePath;

/// Create a copy of Audiobook
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AudiobookCopyWith<_Audiobook> get copyWith => __$AudiobookCopyWithImpl<_Audiobook>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AudiobookToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Audiobook&&(identical(other.id, id) || other.id == id)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.authorOrder, authorOrder) || other.authorOrder == authorOrder)&&const DeepCollectionEquality().equals(other._name, _name)&&(identical(other.pdfUrlType, pdfUrlType) || other.pdfUrlType == pdfUrlType)&&(identical(other.pdfUrl, pdfUrl) || other.pdfUrl == pdfUrl)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.language, language) || other.language == language)&&(identical(other.localImagePath, localImagePath) || other.localImagePath == localImagePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,authorId,authorOrder,const DeepCollectionEquality().hash(_name),pdfUrlType,pdfUrl,imagePath,language,localImagePath);

@override
String toString() {
  return 'Audiobook(id: $id, authorId: $authorId, authorOrder: $authorOrder, name: $name, pdfUrlType: $pdfUrlType, pdfUrl: $pdfUrl, imagePath: $imagePath, language: $language, localImagePath: $localImagePath)';
}


}

/// @nodoc
abstract mixin class _$AudiobookCopyWith<$Res> implements $AudiobookCopyWith<$Res> {
  factory _$AudiobookCopyWith(_Audiobook value, $Res Function(_Audiobook) _then) = __$AudiobookCopyWithImpl;
@override @useResult
$Res call({
 String id, String authorId, int authorOrder, Map<String, String> name, PdfUrlType pdfUrlType, String? pdfUrl, String imagePath, String language, String? localImagePath
});




}
/// @nodoc
class __$AudiobookCopyWithImpl<$Res>
    implements _$AudiobookCopyWith<$Res> {
  __$AudiobookCopyWithImpl(this._self, this._then);

  final _Audiobook _self;
  final $Res Function(_Audiobook) _then;

/// Create a copy of Audiobook
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? authorId = null,Object? authorOrder = null,Object? name = null,Object? pdfUrlType = null,Object? pdfUrl = freezed,Object? imagePath = null,Object? language = null,Object? localImagePath = freezed,}) {
  return _then(_Audiobook(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,authorOrder: null == authorOrder ? _self.authorOrder : authorOrder // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self._name : name // ignore: cast_nullable_to_non_nullable
as Map<String, String>,pdfUrlType: null == pdfUrlType ? _self.pdfUrlType : pdfUrlType // ignore: cast_nullable_to_non_nullable
as PdfUrlType,pdfUrl: freezed == pdfUrl ? _self.pdfUrl : pdfUrl // ignore: cast_nullable_to_non_nullable
as String?,imagePath: null == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,localImagePath: freezed == localImagePath ? _self.localImagePath : localImagePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
