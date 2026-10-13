// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'view_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ViewSettings {

 double get zoom; Offset get pan; Size get viewport; bool get needsFit; bool get snap; bool get grid;/// Index into the list of workspace background colours.
 int get background;
/// Create a copy of ViewSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ViewSettingsCopyWith<ViewSettings> get copyWith => _$ViewSettingsCopyWithImpl<ViewSettings>(this as ViewSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ViewSettings&&(identical(other.zoom, zoom) || other.zoom == zoom)&&(identical(other.pan, pan) || other.pan == pan)&&(identical(other.viewport, viewport) || other.viewport == viewport)&&(identical(other.needsFit, needsFit) || other.needsFit == needsFit)&&(identical(other.snap, snap) || other.snap == snap)&&(identical(other.grid, grid) || other.grid == grid)&&(identical(other.background, background) || other.background == background));
}


@override
int get hashCode => Object.hash(runtimeType,zoom,pan,viewport,needsFit,snap,grid,background);

@override
String toString() {
  return 'ViewSettings(zoom: $zoom, pan: $pan, viewport: $viewport, needsFit: $needsFit, snap: $snap, grid: $grid, background: $background)';
}


}

/// @nodoc
abstract mixin class $ViewSettingsCopyWith<$Res>  {
  factory $ViewSettingsCopyWith(ViewSettings value, $Res Function(ViewSettings) _then) = _$ViewSettingsCopyWithImpl;
@useResult
$Res call({
 double zoom, Offset pan, Size viewport, bool needsFit, bool snap, bool grid, int background
});




}
/// @nodoc
class _$ViewSettingsCopyWithImpl<$Res>
    implements $ViewSettingsCopyWith<$Res> {
  _$ViewSettingsCopyWithImpl(this._self, this._then);

  final ViewSettings _self;
  final $Res Function(ViewSettings) _then;

/// Create a copy of ViewSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? zoom = null,Object? pan = null,Object? viewport = null,Object? needsFit = null,Object? snap = null,Object? grid = null,Object? background = null,}) {
  return _then(_self.copyWith(
zoom: null == zoom ? _self.zoom : zoom // ignore: cast_nullable_to_non_nullable
as double,pan: null == pan ? _self.pan : pan // ignore: cast_nullable_to_non_nullable
as Offset,viewport: null == viewport ? _self.viewport : viewport // ignore: cast_nullable_to_non_nullable
as Size,needsFit: null == needsFit ? _self.needsFit : needsFit // ignore: cast_nullable_to_non_nullable
as bool,snap: null == snap ? _self.snap : snap // ignore: cast_nullable_to_non_nullable
as bool,grid: null == grid ? _self.grid : grid // ignore: cast_nullable_to_non_nullable
as bool,background: null == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ViewSettings].
extension ViewSettingsPatterns on ViewSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ViewSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ViewSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ViewSettings value)  $default,){
final _that = this;
switch (_that) {
case _ViewSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ViewSettings value)?  $default,){
final _that = this;
switch (_that) {
case _ViewSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double zoom,  Offset pan,  Size viewport,  bool needsFit,  bool snap,  bool grid,  int background)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ViewSettings() when $default != null:
return $default(_that.zoom,_that.pan,_that.viewport,_that.needsFit,_that.snap,_that.grid,_that.background);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double zoom,  Offset pan,  Size viewport,  bool needsFit,  bool snap,  bool grid,  int background)  $default,) {final _that = this;
switch (_that) {
case _ViewSettings():
return $default(_that.zoom,_that.pan,_that.viewport,_that.needsFit,_that.snap,_that.grid,_that.background);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double zoom,  Offset pan,  Size viewport,  bool needsFit,  bool snap,  bool grid,  int background)?  $default,) {final _that = this;
switch (_that) {
case _ViewSettings() when $default != null:
return $default(_that.zoom,_that.pan,_that.viewport,_that.needsFit,_that.snap,_that.grid,_that.background);case _:
  return null;

}
}

}

/// @nodoc


class _ViewSettings implements ViewSettings {
  const _ViewSettings({this.zoom = 6.0, this.pan = const Offset(40, 40), this.viewport = Size.zero, this.needsFit = true, this.snap = true, this.grid = true, this.background = 0});
  

@override@JsonKey() final  double zoom;
@override@JsonKey() final  Offset pan;
@override@JsonKey() final  Size viewport;
@override@JsonKey() final  bool needsFit;
@override@JsonKey() final  bool snap;
@override@JsonKey() final  bool grid;
/// Index into the list of workspace background colours.
@override@JsonKey() final  int background;

/// Create a copy of ViewSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ViewSettingsCopyWith<_ViewSettings> get copyWith => __$ViewSettingsCopyWithImpl<_ViewSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ViewSettings&&(identical(other.zoom, zoom) || other.zoom == zoom)&&(identical(other.pan, pan) || other.pan == pan)&&(identical(other.viewport, viewport) || other.viewport == viewport)&&(identical(other.needsFit, needsFit) || other.needsFit == needsFit)&&(identical(other.snap, snap) || other.snap == snap)&&(identical(other.grid, grid) || other.grid == grid)&&(identical(other.background, background) || other.background == background));
}


@override
int get hashCode => Object.hash(runtimeType,zoom,pan,viewport,needsFit,snap,grid,background);

@override
String toString() {
  return 'ViewSettings(zoom: $zoom, pan: $pan, viewport: $viewport, needsFit: $needsFit, snap: $snap, grid: $grid, background: $background)';
}


}

/// @nodoc
abstract mixin class _$ViewSettingsCopyWith<$Res> implements $ViewSettingsCopyWith<$Res> {
  factory _$ViewSettingsCopyWith(_ViewSettings value, $Res Function(_ViewSettings) _then) = __$ViewSettingsCopyWithImpl;
@override @useResult
$Res call({
 double zoom, Offset pan, Size viewport, bool needsFit, bool snap, bool grid, int background
});




}
/// @nodoc
class __$ViewSettingsCopyWithImpl<$Res>
    implements _$ViewSettingsCopyWith<$Res> {
  __$ViewSettingsCopyWithImpl(this._self, this._then);

  final _ViewSettings _self;
  final $Res Function(_ViewSettings) _then;

/// Create a copy of ViewSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? zoom = null,Object? pan = null,Object? viewport = null,Object? needsFit = null,Object? snap = null,Object? grid = null,Object? background = null,}) {
  return _then(_ViewSettings(
zoom: null == zoom ? _self.zoom : zoom // ignore: cast_nullable_to_non_nullable
as double,pan: null == pan ? _self.pan : pan // ignore: cast_nullable_to_non_nullable
as Offset,viewport: null == viewport ? _self.viewport : viewport // ignore: cast_nullable_to_non_nullable
as Size,needsFit: null == needsFit ? _self.needsFit : needsFit // ignore: cast_nullable_to_non_nullable
as bool,snap: null == snap ? _self.snap : snap // ignore: cast_nullable_to_non_nullable
as bool,grid: null == grid ? _self.grid : grid // ignore: cast_nullable_to_non_nullable
as bool,background: null == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
