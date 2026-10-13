// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shape.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Shape {

 ShapeKind get kind; List<Offset> get points; String get name; int? get fill; int? get stroke; double get strokeWidth; double get radius;
/// Create a copy of Shape
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShapeCopyWith<Shape> get copyWith => _$ShapeCopyWithImpl<Shape>(this as Shape, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Shape&&(identical(other.kind, kind) || other.kind == kind)&&const DeepCollectionEquality().equals(other.points, points)&&(identical(other.name, name) || other.name == name)&&(identical(other.fill, fill) || other.fill == fill)&&(identical(other.stroke, stroke) || other.stroke == stroke)&&(identical(other.strokeWidth, strokeWidth) || other.strokeWidth == strokeWidth)&&(identical(other.radius, radius) || other.radius == radius));
}


@override
int get hashCode => Object.hash(runtimeType,kind,const DeepCollectionEquality().hash(points),name,fill,stroke,strokeWidth,radius);

@override
String toString() {
  return 'Shape(kind: $kind, points: $points, name: $name, fill: $fill, stroke: $stroke, strokeWidth: $strokeWidth, radius: $radius)';
}


}

/// @nodoc
abstract mixin class $ShapeCopyWith<$Res>  {
  factory $ShapeCopyWith(Shape value, $Res Function(Shape) _then) = _$ShapeCopyWithImpl;
@useResult
$Res call({
 ShapeKind kind, List<Offset> points, String name, int? fill, int? stroke, double strokeWidth, double radius
});




}
/// @nodoc
class _$ShapeCopyWithImpl<$Res>
    implements $ShapeCopyWith<$Res> {
  _$ShapeCopyWithImpl(this._self, this._then);

  final Shape _self;
  final $Res Function(Shape) _then;

/// Create a copy of Shape
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? points = null,Object? name = null,Object? fill = freezed,Object? stroke = freezed,Object? strokeWidth = null,Object? radius = null,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ShapeKind,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as List<Offset>,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,fill: freezed == fill ? _self.fill : fill // ignore: cast_nullable_to_non_nullable
as int?,stroke: freezed == stroke ? _self.stroke : stroke // ignore: cast_nullable_to_non_nullable
as int?,strokeWidth: null == strokeWidth ? _self.strokeWidth : strokeWidth // ignore: cast_nullable_to_non_nullable
as double,radius: null == radius ? _self.radius : radius // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [Shape].
extension ShapePatterns on Shape {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Shape value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Shape() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Shape value)  $default,){
final _that = this;
switch (_that) {
case _Shape():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Shape value)?  $default,){
final _that = this;
switch (_that) {
case _Shape() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ShapeKind kind,  List<Offset> points,  String name,  int? fill,  int? stroke,  double strokeWidth,  double radius)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Shape() when $default != null:
return $default(_that.kind,_that.points,_that.name,_that.fill,_that.stroke,_that.strokeWidth,_that.radius);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ShapeKind kind,  List<Offset> points,  String name,  int? fill,  int? stroke,  double strokeWidth,  double radius)  $default,) {final _that = this;
switch (_that) {
case _Shape():
return $default(_that.kind,_that.points,_that.name,_that.fill,_that.stroke,_that.strokeWidth,_that.radius);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ShapeKind kind,  List<Offset> points,  String name,  int? fill,  int? stroke,  double strokeWidth,  double radius)?  $default,) {final _that = this;
switch (_that) {
case _Shape() when $default != null:
return $default(_that.kind,_that.points,_that.name,_that.fill,_that.stroke,_that.strokeWidth,_that.radius);case _:
  return null;

}
}

}

/// @nodoc


class _Shape extends Shape {
  const _Shape({required this.kind, required final  List<Offset> points, this.name = '', this.fill, this.stroke, this.strokeWidth = 1.0, this.radius = 0.0}): _points = points,super._();
  

@override final  ShapeKind kind;
 final  List<Offset> _points;
@override List<Offset> get points {
  if (_points is EqualUnmodifiableListView) return _points;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_points);
}

@override@JsonKey() final  String name;
@override final  int? fill;
@override final  int? stroke;
@override@JsonKey() final  double strokeWidth;
@override@JsonKey() final  double radius;

/// Create a copy of Shape
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShapeCopyWith<_Shape> get copyWith => __$ShapeCopyWithImpl<_Shape>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Shape&&(identical(other.kind, kind) || other.kind == kind)&&const DeepCollectionEquality().equals(other._points, _points)&&(identical(other.name, name) || other.name == name)&&(identical(other.fill, fill) || other.fill == fill)&&(identical(other.stroke, stroke) || other.stroke == stroke)&&(identical(other.strokeWidth, strokeWidth) || other.strokeWidth == strokeWidth)&&(identical(other.radius, radius) || other.radius == radius));
}


@override
int get hashCode => Object.hash(runtimeType,kind,const DeepCollectionEquality().hash(_points),name,fill,stroke,strokeWidth,radius);

@override
String toString() {
  return 'Shape(kind: $kind, points: $points, name: $name, fill: $fill, stroke: $stroke, strokeWidth: $strokeWidth, radius: $radius)';
}


}

/// @nodoc
abstract mixin class _$ShapeCopyWith<$Res> implements $ShapeCopyWith<$Res> {
  factory _$ShapeCopyWith(_Shape value, $Res Function(_Shape) _then) = __$ShapeCopyWithImpl;
@override @useResult
$Res call({
 ShapeKind kind, List<Offset> points, String name, int? fill, int? stroke, double strokeWidth, double radius
});




}
/// @nodoc
class __$ShapeCopyWithImpl<$Res>
    implements _$ShapeCopyWith<$Res> {
  __$ShapeCopyWithImpl(this._self, this._then);

  final _Shape _self;
  final $Res Function(_Shape) _then;

/// Create a copy of Shape
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? points = null,Object? name = null,Object? fill = freezed,Object? stroke = freezed,Object? strokeWidth = null,Object? radius = null,}) {
  return _then(_Shape(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ShapeKind,points: null == points ? _self._points : points // ignore: cast_nullable_to_non_nullable
as List<Offset>,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,fill: freezed == fill ? _self.fill : fill // ignore: cast_nullable_to_non_nullable
as int?,stroke: freezed == stroke ? _self.stroke : stroke // ignore: cast_nullable_to_non_nullable
as int?,strokeWidth: null == strokeWidth ? _self.strokeWidth : strokeWidth // ignore: cast_nullable_to_non_nullable
as double,radius: null == radius ? _self.radius : radius // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
