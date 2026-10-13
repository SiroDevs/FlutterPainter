// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gesture_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GestureState {

 GestureMode get mode;/// Where the gesture began (design units).
 Offset get origin;/// The previous pointer position, for relative drags.
 Offset get last;/// The grabbed handle: a corner (0-3) or a vertex index.
 int get handle;/// The grabbed shape's points and box when the drag began.
 List<Offset> get startPoints; Rect get startBounds;/// Time of the previous click, to detect double-clicks.
 int get lastClickMs;
/// Create a copy of GestureState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GestureStateCopyWith<GestureState> get copyWith => _$GestureStateCopyWithImpl<GestureState>(this as GestureState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GestureState&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.last, last) || other.last == last)&&(identical(other.handle, handle) || other.handle == handle)&&const DeepCollectionEquality().equals(other.startPoints, startPoints)&&(identical(other.startBounds, startBounds) || other.startBounds == startBounds)&&(identical(other.lastClickMs, lastClickMs) || other.lastClickMs == lastClickMs));
}


@override
int get hashCode => Object.hash(runtimeType,mode,origin,last,handle,const DeepCollectionEquality().hash(startPoints),startBounds,lastClickMs);

@override
String toString() {
  return 'GestureState(mode: $mode, origin: $origin, last: $last, handle: $handle, startPoints: $startPoints, startBounds: $startBounds, lastClickMs: $lastClickMs)';
}


}

/// @nodoc
abstract mixin class $GestureStateCopyWith<$Res>  {
  factory $GestureStateCopyWith(GestureState value, $Res Function(GestureState) _then) = _$GestureStateCopyWithImpl;
@useResult
$Res call({
 GestureMode mode, Offset origin, Offset last, int handle, List<Offset> startPoints, Rect startBounds, int lastClickMs
});




}
/// @nodoc
class _$GestureStateCopyWithImpl<$Res>
    implements $GestureStateCopyWith<$Res> {
  _$GestureStateCopyWithImpl(this._self, this._then);

  final GestureState _self;
  final $Res Function(GestureState) _then;

/// Create a copy of GestureState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? origin = null,Object? last = null,Object? handle = null,Object? startPoints = null,Object? startBounds = null,Object? lastClickMs = null,}) {
  return _then(_self.copyWith(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as GestureMode,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as Offset,last: null == last ? _self.last : last // ignore: cast_nullable_to_non_nullable
as Offset,handle: null == handle ? _self.handle : handle // ignore: cast_nullable_to_non_nullable
as int,startPoints: null == startPoints ? _self.startPoints : startPoints // ignore: cast_nullable_to_non_nullable
as List<Offset>,startBounds: null == startBounds ? _self.startBounds : startBounds // ignore: cast_nullable_to_non_nullable
as Rect,lastClickMs: null == lastClickMs ? _self.lastClickMs : lastClickMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [GestureState].
extension GestureStatePatterns on GestureState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GestureState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GestureState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GestureState value)  $default,){
final _that = this;
switch (_that) {
case _GestureState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GestureState value)?  $default,){
final _that = this;
switch (_that) {
case _GestureState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GestureMode mode,  Offset origin,  Offset last,  int handle,  List<Offset> startPoints,  Rect startBounds,  int lastClickMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GestureState() when $default != null:
return $default(_that.mode,_that.origin,_that.last,_that.handle,_that.startPoints,_that.startBounds,_that.lastClickMs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GestureMode mode,  Offset origin,  Offset last,  int handle,  List<Offset> startPoints,  Rect startBounds,  int lastClickMs)  $default,) {final _that = this;
switch (_that) {
case _GestureState():
return $default(_that.mode,_that.origin,_that.last,_that.handle,_that.startPoints,_that.startBounds,_that.lastClickMs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GestureMode mode,  Offset origin,  Offset last,  int handle,  List<Offset> startPoints,  Rect startBounds,  int lastClickMs)?  $default,) {final _that = this;
switch (_that) {
case _GestureState() when $default != null:
return $default(_that.mode,_that.origin,_that.last,_that.handle,_that.startPoints,_that.startBounds,_that.lastClickMs);case _:
  return null;

}
}

}

/// @nodoc


class _GestureState implements GestureState {
  const _GestureState({this.mode = GestureMode.none, this.origin = Offset.zero, this.last = Offset.zero, this.handle = -1, final  List<Offset> startPoints = const <Offset>[], this.startBounds = Rect.zero, this.lastClickMs = 0}): _startPoints = startPoints;
  

@override@JsonKey() final  GestureMode mode;
/// Where the gesture began (design units).
@override@JsonKey() final  Offset origin;
/// The previous pointer position, for relative drags.
@override@JsonKey() final  Offset last;
/// The grabbed handle: a corner (0-3) or a vertex index.
@override@JsonKey() final  int handle;
/// The grabbed shape's points and box when the drag began.
 final  List<Offset> _startPoints;
/// The grabbed shape's points and box when the drag began.
@override@JsonKey() List<Offset> get startPoints {
  if (_startPoints is EqualUnmodifiableListView) return _startPoints;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_startPoints);
}

@override@JsonKey() final  Rect startBounds;
/// Time of the previous click, to detect double-clicks.
@override@JsonKey() final  int lastClickMs;

/// Create a copy of GestureState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GestureStateCopyWith<_GestureState> get copyWith => __$GestureStateCopyWithImpl<_GestureState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GestureState&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.last, last) || other.last == last)&&(identical(other.handle, handle) || other.handle == handle)&&const DeepCollectionEquality().equals(other._startPoints, _startPoints)&&(identical(other.startBounds, startBounds) || other.startBounds == startBounds)&&(identical(other.lastClickMs, lastClickMs) || other.lastClickMs == lastClickMs));
}


@override
int get hashCode => Object.hash(runtimeType,mode,origin,last,handle,const DeepCollectionEquality().hash(_startPoints),startBounds,lastClickMs);

@override
String toString() {
  return 'GestureState(mode: $mode, origin: $origin, last: $last, handle: $handle, startPoints: $startPoints, startBounds: $startBounds, lastClickMs: $lastClickMs)';
}


}

/// @nodoc
abstract mixin class _$GestureStateCopyWith<$Res> implements $GestureStateCopyWith<$Res> {
  factory _$GestureStateCopyWith(_GestureState value, $Res Function(_GestureState) _then) = __$GestureStateCopyWithImpl;
@override @useResult
$Res call({
 GestureMode mode, Offset origin, Offset last, int handle, List<Offset> startPoints, Rect startBounds, int lastClickMs
});




}
/// @nodoc
class __$GestureStateCopyWithImpl<$Res>
    implements _$GestureStateCopyWith<$Res> {
  __$GestureStateCopyWithImpl(this._self, this._then);

  final _GestureState _self;
  final $Res Function(_GestureState) _then;

/// Create a copy of GestureState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? origin = null,Object? last = null,Object? handle = null,Object? startPoints = null,Object? startBounds = null,Object? lastClickMs = null,}) {
  return _then(_GestureState(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as GestureMode,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as Offset,last: null == last ? _self.last : last // ignore: cast_nullable_to_non_nullable
as Offset,handle: null == handle ? _self.handle : handle // ignore: cast_nullable_to_non_nullable
as int,startPoints: null == startPoints ? _self._startPoints : startPoints // ignore: cast_nullable_to_non_nullable
as List<Offset>,startBounds: null == startBounds ? _self.startBounds : startBounds // ignore: cast_nullable_to_non_nullable
as Rect,lastClickMs: null == lastClickMs ? _self.lastClickMs : lastClickMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
