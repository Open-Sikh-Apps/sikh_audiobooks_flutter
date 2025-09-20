// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'author.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Author {

/// Unique id of author
 String get id;/// name, in both languages "pa" and "en"
 Map<String, String> get name;/// order of author in author list
 int get order;/// ref path to this author's image in cloud storage
 String get imagePath;/// about author url, in both languages "pa" and "en"
 Map<String, String> get aboutUrl;/// path to locally stored image, if any
 String? get localImagePath;
/// Create a copy of Author
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthorCopyWith<Author> get copyWith => _$AuthorCopyWithImpl<Author>(this as Author, _$identity);

  /// Serializes this Author to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Author&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.name, name)&&(identical(other.order, order) || other.order == order)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&const DeepCollectionEquality().equals(other.aboutUrl, aboutUrl)&&(identical(other.localImagePath, localImagePath) || other.localImagePath == localImagePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(name),order,imagePath,const DeepCollectionEquality().hash(aboutUrl),localImagePath);

@override
String toString() {
  return 'Author(id: $id, name: $name, order: $order, imagePath: $imagePath, aboutUrl: $aboutUrl, localImagePath: $localImagePath)';
}


}

/// @nodoc
abstract mixin class $AuthorCopyWith<$Res>  {
  factory $AuthorCopyWith(Author value, $Res Function(Author) _then) = _$AuthorCopyWithImpl;
@useResult
$Res call({
 String id, Map<String, String> name, int order, String imagePath, Map<String, String> aboutUrl, String? localImagePath
});




}
/// @nodoc
class _$AuthorCopyWithImpl<$Res>
    implements $AuthorCopyWith<$Res> {
  _$AuthorCopyWithImpl(this._self, this._then);

  final Author _self;
  final $Res Function(Author) _then;

/// Create a copy of Author
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? order = null,Object? imagePath = null,Object? aboutUrl = null,Object? localImagePath = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as Map<String, String>,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,imagePath: null == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String,aboutUrl: null == aboutUrl ? _self.aboutUrl : aboutUrl // ignore: cast_nullable_to_non_nullable
as Map<String, String>,localImagePath: freezed == localImagePath ? _self.localImagePath : localImagePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Author].
extension AuthorPatterns on Author {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Author value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Author() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Author value)  $default,){
final _that = this;
switch (_that) {
case _Author():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Author value)?  $default,){
final _that = this;
switch (_that) {
case _Author() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  Map<String, String> name,  int order,  String imagePath,  Map<String, String> aboutUrl,  String? localImagePath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Author() when $default != null:
return $default(_that.id,_that.name,_that.order,_that.imagePath,_that.aboutUrl,_that.localImagePath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  Map<String, String> name,  int order,  String imagePath,  Map<String, String> aboutUrl,  String? localImagePath)  $default,) {final _that = this;
switch (_that) {
case _Author():
return $default(_that.id,_that.name,_that.order,_that.imagePath,_that.aboutUrl,_that.localImagePath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  Map<String, String> name,  int order,  String imagePath,  Map<String, String> aboutUrl,  String? localImagePath)?  $default,) {final _that = this;
switch (_that) {
case _Author() when $default != null:
return $default(_that.id,_that.name,_that.order,_that.imagePath,_that.aboutUrl,_that.localImagePath);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Author implements Author {
  const _Author({required this.id, required final  Map<String, String> name, required this.order, required this.imagePath, required final  Map<String, String> aboutUrl, this.localImagePath}): _name = name,_aboutUrl = aboutUrl;
  factory _Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);

/// Unique id of author
@override final  String id;
/// name, in both languages "pa" and "en"
 final  Map<String, String> _name;
/// name, in both languages "pa" and "en"
@override Map<String, String> get name {
  if (_name is EqualUnmodifiableMapView) return _name;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_name);
}

/// order of author in author list
@override final  int order;
/// ref path to this author's image in cloud storage
@override final  String imagePath;
/// about author url, in both languages "pa" and "en"
 final  Map<String, String> _aboutUrl;
/// about author url, in both languages "pa" and "en"
@override Map<String, String> get aboutUrl {
  if (_aboutUrl is EqualUnmodifiableMapView) return _aboutUrl;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_aboutUrl);
}

/// path to locally stored image, if any
@override final  String? localImagePath;

/// Create a copy of Author
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthorCopyWith<_Author> get copyWith => __$AuthorCopyWithImpl<_Author>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Author&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._name, _name)&&(identical(other.order, order) || other.order == order)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&const DeepCollectionEquality().equals(other._aboutUrl, _aboutUrl)&&(identical(other.localImagePath, localImagePath) || other.localImagePath == localImagePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_name),order,imagePath,const DeepCollectionEquality().hash(_aboutUrl),localImagePath);

@override
String toString() {
  return 'Author(id: $id, name: $name, order: $order, imagePath: $imagePath, aboutUrl: $aboutUrl, localImagePath: $localImagePath)';
}


}

/// @nodoc
abstract mixin class _$AuthorCopyWith<$Res> implements $AuthorCopyWith<$Res> {
  factory _$AuthorCopyWith(_Author value, $Res Function(_Author) _then) = __$AuthorCopyWithImpl;
@override @useResult
$Res call({
 String id, Map<String, String> name, int order, String imagePath, Map<String, String> aboutUrl, String? localImagePath
});




}
/// @nodoc
class __$AuthorCopyWithImpl<$Res>
    implements _$AuthorCopyWith<$Res> {
  __$AuthorCopyWithImpl(this._self, this._then);

  final _Author _self;
  final $Res Function(_Author) _then;

/// Create a copy of Author
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? order = null,Object? imagePath = null,Object? aboutUrl = null,Object? localImagePath = freezed,}) {
  return _then(_Author(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self._name : name // ignore: cast_nullable_to_non_nullable
as Map<String, String>,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,imagePath: null == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String,aboutUrl: null == aboutUrl ? _self._aboutUrl : aboutUrl // ignore: cast_nullable_to_non_nullable
as Map<String, String>,localImagePath: freezed == localImagePath ? _self.localImagePath : localImagePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
