// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paint_layer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PaintLayer {

 String get name; bool get visible; List<Shape> get shapes;
/// Create a copy of PaintLayer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaintLayerCopyWith<PaintLayer> get copyWith => _$PaintLayerCopyWithImpl<PaintLayer>(this as PaintLayer, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaintLayer&&(identical(other.name, name) || other.name == name)&&(identical(other.visible, visible) || other.visible == visible)&&const DeepCollectionEquality().equals(other.shapes, shapes));
}


@override
int get hashCode => Object.hash(runtimeType,name,visible,const DeepCollectionEquality().hash(shapes));

@override
String toString() {
  return 'PaintLayer(name: $name, visible: $visible, shapes: $shapes)';
}


}

/// @nodoc
abstract mixin class $PaintLayerCopyWith<$Res>  {
  factory $PaintLayerCopyWith(PaintLayer value, $Res Function(PaintLayer) _then) = _$PaintLayerCopyWithImpl;
@useResult
$Res call({
 String name, bool visible, List<Shape> shapes
});




}
/// @nodoc
class _$PaintLayerCopyWithImpl<$Res>
    implements $PaintLayerCopyWith<$Res> {
  _$PaintLayerCopyWithImpl(this._self, this._then);

  final PaintLayer _self;
  final $Res Function(PaintLayer) _then;

/// Create a copy of PaintLayer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? visible = null,Object? shapes = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,visible: null == visible ? _self.visible : visible // ignore: cast_nullable_to_non_nullable
as bool,shapes: null == shapes ? _self.shapes : shapes // ignore: cast_nullable_to_non_nullable
as List<Shape>,
  ));
}

}


/// Adds pattern-matching-related methods to [PaintLayer].
extension PaintLayerPatterns on PaintLayer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaintLayer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaintLayer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaintLayer value)  $default,){
final _that = this;
switch (_that) {
case _PaintLayer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaintLayer value)?  $default,){
final _that = this;
switch (_that) {
case _PaintLayer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  bool visible,  List<Shape> shapes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaintLayer() when $default != null:
return $default(_that.name,_that.visible,_that.shapes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  bool visible,  List<Shape> shapes)  $default,) {final _that = this;
switch (_that) {
case _PaintLayer():
return $default(_that.name,_that.visible,_that.shapes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  bool visible,  List<Shape> shapes)?  $default,) {final _that = this;
switch (_that) {
case _PaintLayer() when $default != null:
return $default(_that.name,_that.visible,_that.shapes);case _:
  return null;

}
}

}

/// @nodoc


class _PaintLayer implements PaintLayer {
  const _PaintLayer({required this.name, this.visible = true, final  List<Shape> shapes = const <Shape>[]}): _shapes = shapes;
  

@override final  String name;
@override@JsonKey() final  bool visible;
 final  List<Shape> _shapes;
@override@JsonKey() List<Shape> get shapes {
  if (_shapes is EqualUnmodifiableListView) return _shapes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_shapes);
}


/// Create a copy of PaintLayer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaintLayerCopyWith<_PaintLayer> get copyWith => __$PaintLayerCopyWithImpl<_PaintLayer>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaintLayer&&(identical(other.name, name) || other.name == name)&&(identical(other.visible, visible) || other.visible == visible)&&const DeepCollectionEquality().equals(other._shapes, _shapes));
}


@override
int get hashCode => Object.hash(runtimeType,name,visible,const DeepCollectionEquality().hash(_shapes));

@override
String toString() {
  return 'PaintLayer(name: $name, visible: $visible, shapes: $shapes)';
}


}

/// @nodoc
abstract mixin class _$PaintLayerCopyWith<$Res> implements $PaintLayerCopyWith<$Res> {
  factory _$PaintLayerCopyWith(_PaintLayer value, $Res Function(_PaintLayer) _then) = __$PaintLayerCopyWithImpl;
@override @useResult
$Res call({
 String name, bool visible, List<Shape> shapes
});




}
/// @nodoc
class __$PaintLayerCopyWithImpl<$Res>
    implements _$PaintLayerCopyWith<$Res> {
  __$PaintLayerCopyWithImpl(this._self, this._then);

  final _PaintLayer _self;
  final $Res Function(_PaintLayer) _then;

/// Create a copy of PaintLayer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? visible = null,Object? shapes = null,}) {
  return _then(_PaintLayer(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,visible: null == visible ? _self.visible : visible // ignore: cast_nullable_to_non_nullable
as bool,shapes: null == shapes ? _self._shapes : shapes // ignore: cast_nullable_to_non_nullable
as List<Shape>,
  ));
}


}

// dart format on
