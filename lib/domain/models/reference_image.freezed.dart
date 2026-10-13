// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reference_image.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReferenceImage {

 Uint8List get bytes; String get id;/// Where the image's top-left corner sits in design units.
 double get x; double get y;/// Design units per image pixel.
 double get scale; double get opacity; bool get visible;
/// Create a copy of ReferenceImage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReferenceImageCopyWith<ReferenceImage> get copyWith => _$ReferenceImageCopyWithImpl<ReferenceImage>(this as ReferenceImage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReferenceImage&&const DeepCollectionEquality().equals(other.bytes, bytes)&&(identical(other.id, id) || other.id == id)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.scale, scale) || other.scale == scale)&&(identical(other.opacity, opacity) || other.opacity == opacity)&&(identical(other.visible, visible) || other.visible == visible));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(bytes),id,x,y,scale,opacity,visible);

@override
String toString() {
  return 'ReferenceImage(bytes: $bytes, id: $id, x: $x, y: $y, scale: $scale, opacity: $opacity, visible: $visible)';
}


}

/// @nodoc
abstract mixin class $ReferenceImageCopyWith<$Res>  {
  factory $ReferenceImageCopyWith(ReferenceImage value, $Res Function(ReferenceImage) _then) = _$ReferenceImageCopyWithImpl;
@useResult
$Res call({
 Uint8List bytes, String id, double x, double y, double scale, double opacity, bool visible
});




}
/// @nodoc
class _$ReferenceImageCopyWithImpl<$Res>
    implements $ReferenceImageCopyWith<$Res> {
  _$ReferenceImageCopyWithImpl(this._self, this._then);

  final ReferenceImage _self;
  final $Res Function(ReferenceImage) _then;

/// Create a copy of ReferenceImage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bytes = null,Object? id = null,Object? x = null,Object? y = null,Object? scale = null,Object? opacity = null,Object? visible = null,}) {
  return _then(_self.copyWith(
bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as Uint8List,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,scale: null == scale ? _self.scale : scale // ignore: cast_nullable_to_non_nullable
as double,opacity: null == opacity ? _self.opacity : opacity // ignore: cast_nullable_to_non_nullable
as double,visible: null == visible ? _self.visible : visible // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ReferenceImage].
extension ReferenceImagePatterns on ReferenceImage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReferenceImage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReferenceImage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReferenceImage value)  $default,){
final _that = this;
switch (_that) {
case _ReferenceImage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReferenceImage value)?  $default,){
final _that = this;
switch (_that) {
case _ReferenceImage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Uint8List bytes,  String id,  double x,  double y,  double scale,  double opacity,  bool visible)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReferenceImage() when $default != null:
return $default(_that.bytes,_that.id,_that.x,_that.y,_that.scale,_that.opacity,_that.visible);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Uint8List bytes,  String id,  double x,  double y,  double scale,  double opacity,  bool visible)  $default,) {final _that = this;
switch (_that) {
case _ReferenceImage():
return $default(_that.bytes,_that.id,_that.x,_that.y,_that.scale,_that.opacity,_that.visible);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Uint8List bytes,  String id,  double x,  double y,  double scale,  double opacity,  bool visible)?  $default,) {final _that = this;
switch (_that) {
case _ReferenceImage() when $default != null:
return $default(_that.bytes,_that.id,_that.x,_that.y,_that.scale,_that.opacity,_that.visible);case _:
  return null;

}
}

}

/// @nodoc


class _ReferenceImage extends ReferenceImage {
  const _ReferenceImage({required this.bytes, required this.id, this.x = 0.0, this.y = 0.0, this.scale = 1.0, this.opacity = 0.5, this.visible = true}): super._();
  

@override final  Uint8List bytes;
@override final  String id;
/// Where the image's top-left corner sits in design units.
@override@JsonKey() final  double x;
@override@JsonKey() final  double y;
/// Design units per image pixel.
@override@JsonKey() final  double scale;
@override@JsonKey() final  double opacity;
@override@JsonKey() final  bool visible;

/// Create a copy of ReferenceImage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReferenceImageCopyWith<_ReferenceImage> get copyWith => __$ReferenceImageCopyWithImpl<_ReferenceImage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReferenceImage&&const DeepCollectionEquality().equals(other.bytes, bytes)&&(identical(other.id, id) || other.id == id)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.scale, scale) || other.scale == scale)&&(identical(other.opacity, opacity) || other.opacity == opacity)&&(identical(other.visible, visible) || other.visible == visible));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(bytes),id,x,y,scale,opacity,visible);

@override
String toString() {
  return 'ReferenceImage(bytes: $bytes, id: $id, x: $x, y: $y, scale: $scale, opacity: $opacity, visible: $visible)';
}


}

/// @nodoc
abstract mixin class _$ReferenceImageCopyWith<$Res> implements $ReferenceImageCopyWith<$Res> {
  factory _$ReferenceImageCopyWith(_ReferenceImage value, $Res Function(_ReferenceImage) _then) = __$ReferenceImageCopyWithImpl;
@override @useResult
$Res call({
 Uint8List bytes, String id, double x, double y, double scale, double opacity, bool visible
});




}
/// @nodoc
class __$ReferenceImageCopyWithImpl<$Res>
    implements _$ReferenceImageCopyWith<$Res> {
  __$ReferenceImageCopyWithImpl(this._self, this._then);

  final _ReferenceImage _self;
  final $Res Function(_ReferenceImage) _then;

/// Create a copy of ReferenceImage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bytes = null,Object? id = null,Object? x = null,Object? y = null,Object? scale = null,Object? opacity = null,Object? visible = null,}) {
  return _then(_ReferenceImage(
bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as Uint8List,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,scale: null == scale ? _self.scale : scale // ignore: cast_nullable_to_non_nullable
as double,opacity: null == opacity ? _self.opacity : opacity // ignore: cast_nullable_to_non_nullable
as double,visible: null == visible ? _self.visible : visible // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
