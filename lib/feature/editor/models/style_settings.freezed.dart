// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'style_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StyleSettings {

 int get fillColor; bool get fillOn; int get strokeColor; bool get strokeOn; double get strokeWidth; double get radius;/// Which swatch a palette click paints: true = fill, false = stroke.
 bool get editFill;
/// Create a copy of StyleSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StyleSettingsCopyWith<StyleSettings> get copyWith => _$StyleSettingsCopyWithImpl<StyleSettings>(this as StyleSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StyleSettings&&(identical(other.fillColor, fillColor) || other.fillColor == fillColor)&&(identical(other.fillOn, fillOn) || other.fillOn == fillOn)&&(identical(other.strokeColor, strokeColor) || other.strokeColor == strokeColor)&&(identical(other.strokeOn, strokeOn) || other.strokeOn == strokeOn)&&(identical(other.strokeWidth, strokeWidth) || other.strokeWidth == strokeWidth)&&(identical(other.radius, radius) || other.radius == radius)&&(identical(other.editFill, editFill) || other.editFill == editFill));
}


@override
int get hashCode => Object.hash(runtimeType,fillColor,fillOn,strokeColor,strokeOn,strokeWidth,radius,editFill);

@override
String toString() {
  return 'StyleSettings(fillColor: $fillColor, fillOn: $fillOn, strokeColor: $strokeColor, strokeOn: $strokeOn, strokeWidth: $strokeWidth, radius: $radius, editFill: $editFill)';
}


}

/// @nodoc
abstract mixin class $StyleSettingsCopyWith<$Res>  {
  factory $StyleSettingsCopyWith(StyleSettings value, $Res Function(StyleSettings) _then) = _$StyleSettingsCopyWithImpl;
@useResult
$Res call({
 int fillColor, bool fillOn, int strokeColor, bool strokeOn, double strokeWidth, double radius, bool editFill
});




}
/// @nodoc
class _$StyleSettingsCopyWithImpl<$Res>
    implements $StyleSettingsCopyWith<$Res> {
  _$StyleSettingsCopyWithImpl(this._self, this._then);

  final StyleSettings _self;
  final $Res Function(StyleSettings) _then;

/// Create a copy of StyleSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fillColor = null,Object? fillOn = null,Object? strokeColor = null,Object? strokeOn = null,Object? strokeWidth = null,Object? radius = null,Object? editFill = null,}) {
  return _then(_self.copyWith(
fillColor: null == fillColor ? _self.fillColor : fillColor // ignore: cast_nullable_to_non_nullable
as int,fillOn: null == fillOn ? _self.fillOn : fillOn // ignore: cast_nullable_to_non_nullable
as bool,strokeColor: null == strokeColor ? _self.strokeColor : strokeColor // ignore: cast_nullable_to_non_nullable
as int,strokeOn: null == strokeOn ? _self.strokeOn : strokeOn // ignore: cast_nullable_to_non_nullable
as bool,strokeWidth: null == strokeWidth ? _self.strokeWidth : strokeWidth // ignore: cast_nullable_to_non_nullable
as double,radius: null == radius ? _self.radius : radius // ignore: cast_nullable_to_non_nullable
as double,editFill: null == editFill ? _self.editFill : editFill // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StyleSettings].
extension StyleSettingsPatterns on StyleSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StyleSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StyleSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StyleSettings value)  $default,){
final _that = this;
switch (_that) {
case _StyleSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StyleSettings value)?  $default,){
final _that = this;
switch (_that) {
case _StyleSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int fillColor,  bool fillOn,  int strokeColor,  bool strokeOn,  double strokeWidth,  double radius,  bool editFill)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StyleSettings() when $default != null:
return $default(_that.fillColor,_that.fillOn,_that.strokeColor,_that.strokeOn,_that.strokeWidth,_that.radius,_that.editFill);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int fillColor,  bool fillOn,  int strokeColor,  bool strokeOn,  double strokeWidth,  double radius,  bool editFill)  $default,) {final _that = this;
switch (_that) {
case _StyleSettings():
return $default(_that.fillColor,_that.fillOn,_that.strokeColor,_that.strokeOn,_that.strokeWidth,_that.radius,_that.editFill);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int fillColor,  bool fillOn,  int strokeColor,  bool strokeOn,  double strokeWidth,  double radius,  bool editFill)?  $default,) {final _that = this;
switch (_that) {
case _StyleSettings() when $default != null:
return $default(_that.fillColor,_that.fillOn,_that.strokeColor,_that.strokeOn,_that.strokeWidth,_that.radius,_that.editFill);case _:
  return null;

}
}

}

/// @nodoc


class _StyleSettings implements StyleSettings {
  const _StyleSettings({this.fillColor = 0xFFED1C24, this.fillOn = true, this.strokeColor = 0xFF000000, this.strokeOn = true, this.strokeWidth = 1.0, this.radius = 0.0, this.editFill = true});
  

@override@JsonKey() final  int fillColor;
@override@JsonKey() final  bool fillOn;
@override@JsonKey() final  int strokeColor;
@override@JsonKey() final  bool strokeOn;
@override@JsonKey() final  double strokeWidth;
@override@JsonKey() final  double radius;
/// Which swatch a palette click paints: true = fill, false = stroke.
@override@JsonKey() final  bool editFill;

/// Create a copy of StyleSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StyleSettingsCopyWith<_StyleSettings> get copyWith => __$StyleSettingsCopyWithImpl<_StyleSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StyleSettings&&(identical(other.fillColor, fillColor) || other.fillColor == fillColor)&&(identical(other.fillOn, fillOn) || other.fillOn == fillOn)&&(identical(other.strokeColor, strokeColor) || other.strokeColor == strokeColor)&&(identical(other.strokeOn, strokeOn) || other.strokeOn == strokeOn)&&(identical(other.strokeWidth, strokeWidth) || other.strokeWidth == strokeWidth)&&(identical(other.radius, radius) || other.radius == radius)&&(identical(other.editFill, editFill) || other.editFill == editFill));
}


@override
int get hashCode => Object.hash(runtimeType,fillColor,fillOn,strokeColor,strokeOn,strokeWidth,radius,editFill);

@override
String toString() {
  return 'StyleSettings(fillColor: $fillColor, fillOn: $fillOn, strokeColor: $strokeColor, strokeOn: $strokeOn, strokeWidth: $strokeWidth, radius: $radius, editFill: $editFill)';
}


}

/// @nodoc
abstract mixin class _$StyleSettingsCopyWith<$Res> implements $StyleSettingsCopyWith<$Res> {
  factory _$StyleSettingsCopyWith(_StyleSettings value, $Res Function(_StyleSettings) _then) = __$StyleSettingsCopyWithImpl;
@override @useResult
$Res call({
 int fillColor, bool fillOn, int strokeColor, bool strokeOn, double strokeWidth, double radius, bool editFill
});




}
/// @nodoc
class __$StyleSettingsCopyWithImpl<$Res>
    implements _$StyleSettingsCopyWith<$Res> {
  __$StyleSettingsCopyWithImpl(this._self, this._then);

  final _StyleSettings _self;
  final $Res Function(_StyleSettings) _then;

/// Create a copy of StyleSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fillColor = null,Object? fillOn = null,Object? strokeColor = null,Object? strokeOn = null,Object? strokeWidth = null,Object? radius = null,Object? editFill = null,}) {
  return _then(_StyleSettings(
fillColor: null == fillColor ? _self.fillColor : fillColor // ignore: cast_nullable_to_non_nullable
as int,fillOn: null == fillOn ? _self.fillOn : fillOn // ignore: cast_nullable_to_non_nullable
as bool,strokeColor: null == strokeColor ? _self.strokeColor : strokeColor // ignore: cast_nullable_to_non_nullable
as int,strokeOn: null == strokeOn ? _self.strokeOn : strokeOn // ignore: cast_nullable_to_non_nullable
as bool,strokeWidth: null == strokeWidth ? _self.strokeWidth : strokeWidth // ignore: cast_nullable_to_non_nullable
as double,radius: null == radius ? _self.radius : radius // ignore: cast_nullable_to_non_nullable
as double,editFill: null == editFill ? _self.editFill : editFill // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
