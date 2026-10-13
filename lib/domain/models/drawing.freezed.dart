// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'drawing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Drawing {

 String get name; double get width; double get height; List<PaintLayer> get layers;/// Optional picture drawn under the shapes, for tracing.
 ReferenceImage? get reference;
/// Create a copy of Drawing
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DrawingCopyWith<Drawing> get copyWith => _$DrawingCopyWithImpl<Drawing>(this as Drawing, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Drawing&&(identical(other.name, name) || other.name == name)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&const DeepCollectionEquality().equals(other.layers, layers)&&(identical(other.reference, reference) || other.reference == reference));
}


@override
int get hashCode => Object.hash(runtimeType,name,width,height,const DeepCollectionEquality().hash(layers),reference);

@override
String toString() {
  return 'Drawing(name: $name, width: $width, height: $height, layers: $layers, reference: $reference)';
}


}

/// @nodoc
abstract mixin class $DrawingCopyWith<$Res>  {
  factory $DrawingCopyWith(Drawing value, $Res Function(Drawing) _then) = _$DrawingCopyWithImpl;
@useResult
$Res call({
 String name, double width, double height, List<PaintLayer> layers, ReferenceImage? reference
});


$ReferenceImageCopyWith<$Res>? get reference;

}
/// @nodoc
class _$DrawingCopyWithImpl<$Res>
    implements $DrawingCopyWith<$Res> {
  _$DrawingCopyWithImpl(this._self, this._then);

  final Drawing _self;
  final $Res Function(Drawing) _then;

/// Create a copy of Drawing
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? width = null,Object? height = null,Object? layers = null,Object? reference = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,layers: null == layers ? _self.layers : layers // ignore: cast_nullable_to_non_nullable
as List<PaintLayer>,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as ReferenceImage?,
  ));
}
/// Create a copy of Drawing
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReferenceImageCopyWith<$Res>? get reference {
    if (_self.reference == null) {
    return null;
  }

  return $ReferenceImageCopyWith<$Res>(_self.reference!, (value) {
    return _then(_self.copyWith(reference: value));
  });
}
}


/// Adds pattern-matching-related methods to [Drawing].
extension DrawingPatterns on Drawing {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Drawing value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Drawing() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Drawing value)  $default,){
final _that = this;
switch (_that) {
case _Drawing():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Drawing value)?  $default,){
final _that = this;
switch (_that) {
case _Drawing() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  double width,  double height,  List<PaintLayer> layers,  ReferenceImage? reference)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Drawing() when $default != null:
return $default(_that.name,_that.width,_that.height,_that.layers,_that.reference);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  double width,  double height,  List<PaintLayer> layers,  ReferenceImage? reference)  $default,) {final _that = this;
switch (_that) {
case _Drawing():
return $default(_that.name,_that.width,_that.height,_that.layers,_that.reference);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  double width,  double height,  List<PaintLayer> layers,  ReferenceImage? reference)?  $default,) {final _that = this;
switch (_that) {
case _Drawing() when $default != null:
return $default(_that.name,_that.width,_that.height,_that.layers,_that.reference);case _:
  return null;

}
}

}

/// @nodoc


class _Drawing extends Drawing {
  const _Drawing({required this.name, this.width = AppConstants.defaultCanvasWidth, this.height = AppConstants.defaultCanvasHeight, final  List<PaintLayer> layers = const [PaintLayer(name: 'Layer 1')], this.reference}): _layers = layers,super._();
  

@override final  String name;
@override@JsonKey() final  double width;
@override@JsonKey() final  double height;
 final  List<PaintLayer> _layers;
@override@JsonKey() List<PaintLayer> get layers {
  if (_layers is EqualUnmodifiableListView) return _layers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_layers);
}

/// Optional picture drawn under the shapes, for tracing.
@override final  ReferenceImage? reference;

/// Create a copy of Drawing
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DrawingCopyWith<_Drawing> get copyWith => __$DrawingCopyWithImpl<_Drawing>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Drawing&&(identical(other.name, name) || other.name == name)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&const DeepCollectionEquality().equals(other._layers, _layers)&&(identical(other.reference, reference) || other.reference == reference));
}


@override
int get hashCode => Object.hash(runtimeType,name,width,height,const DeepCollectionEquality().hash(_layers),reference);

@override
String toString() {
  return 'Drawing(name: $name, width: $width, height: $height, layers: $layers, reference: $reference)';
}


}

/// @nodoc
abstract mixin class _$DrawingCopyWith<$Res> implements $DrawingCopyWith<$Res> {
  factory _$DrawingCopyWith(_Drawing value, $Res Function(_Drawing) _then) = __$DrawingCopyWithImpl;
@override @useResult
$Res call({
 String name, double width, double height, List<PaintLayer> layers, ReferenceImage? reference
});


@override $ReferenceImageCopyWith<$Res>? get reference;

}
/// @nodoc
class __$DrawingCopyWithImpl<$Res>
    implements _$DrawingCopyWith<$Res> {
  __$DrawingCopyWithImpl(this._self, this._then);

  final _Drawing _self;
  final $Res Function(_Drawing) _then;

/// Create a copy of Drawing
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? width = null,Object? height = null,Object? layers = null,Object? reference = freezed,}) {
  return _then(_Drawing(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,layers: null == layers ? _self._layers : layers // ignore: cast_nullable_to_non_nullable
as List<PaintLayer>,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as ReferenceImage?,
  ));
}

/// Create a copy of Drawing
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReferenceImageCopyWith<$Res>? get reference {
    if (_self.reference == null) {
    return null;
  }

  return $ReferenceImageCopyWith<$Res>(_self.reference!, (value) {
    return _then(_self.copyWith(reference: value));
  });
}
}

// dart format on
