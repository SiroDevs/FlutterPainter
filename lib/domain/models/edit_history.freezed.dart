// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EditHistory {

 List<Drawing> get states; int get index; int get savedIndex;
/// Create a copy of EditHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditHistoryCopyWith<EditHistory> get copyWith => _$EditHistoryCopyWithImpl<EditHistory>(this as EditHistory, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditHistory&&const DeepCollectionEquality().equals(other.states, states)&&(identical(other.index, index) || other.index == index)&&(identical(other.savedIndex, savedIndex) || other.savedIndex == savedIndex));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(states),index,savedIndex);

@override
String toString() {
  return 'EditHistory(states: $states, index: $index, savedIndex: $savedIndex)';
}


}

/// @nodoc
abstract mixin class $EditHistoryCopyWith<$Res>  {
  factory $EditHistoryCopyWith(EditHistory value, $Res Function(EditHistory) _then) = _$EditHistoryCopyWithImpl;
@useResult
$Res call({
 List<Drawing> states, int index, int savedIndex
});




}
/// @nodoc
class _$EditHistoryCopyWithImpl<$Res>
    implements $EditHistoryCopyWith<$Res> {
  _$EditHistoryCopyWithImpl(this._self, this._then);

  final EditHistory _self;
  final $Res Function(EditHistory) _then;

/// Create a copy of EditHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? states = null,Object? index = null,Object? savedIndex = null,}) {
  return _then(_self.copyWith(
states: null == states ? _self.states : states // ignore: cast_nullable_to_non_nullable
as List<Drawing>,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,savedIndex: null == savedIndex ? _self.savedIndex : savedIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [EditHistory].
extension EditHistoryPatterns on EditHistory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EditHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditHistory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EditHistory value)  $default,){
final _that = this;
switch (_that) {
case _EditHistory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EditHistory value)?  $default,){
final _that = this;
switch (_that) {
case _EditHistory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Drawing> states,  int index,  int savedIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditHistory() when $default != null:
return $default(_that.states,_that.index,_that.savedIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Drawing> states,  int index,  int savedIndex)  $default,) {final _that = this;
switch (_that) {
case _EditHistory():
return $default(_that.states,_that.index,_that.savedIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Drawing> states,  int index,  int savedIndex)?  $default,) {final _that = this;
switch (_that) {
case _EditHistory() when $default != null:
return $default(_that.states,_that.index,_that.savedIndex);case _:
  return null;

}
}

}

/// @nodoc


class _EditHistory extends EditHistory {
  const _EditHistory({required final  List<Drawing> states, required this.index, required this.savedIndex}): _states = states,super._();
  

 final  List<Drawing> _states;
@override List<Drawing> get states {
  if (_states is EqualUnmodifiableListView) return _states;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_states);
}

@override final  int index;
@override final  int savedIndex;

/// Create a copy of EditHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditHistoryCopyWith<_EditHistory> get copyWith => __$EditHistoryCopyWithImpl<_EditHistory>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditHistory&&const DeepCollectionEquality().equals(other._states, _states)&&(identical(other.index, index) || other.index == index)&&(identical(other.savedIndex, savedIndex) || other.savedIndex == savedIndex));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_states),index,savedIndex);

@override
String toString() {
  return 'EditHistory(states: $states, index: $index, savedIndex: $savedIndex)';
}


}

/// @nodoc
abstract mixin class _$EditHistoryCopyWith<$Res> implements $EditHistoryCopyWith<$Res> {
  factory _$EditHistoryCopyWith(_EditHistory value, $Res Function(_EditHistory) _then) = __$EditHistoryCopyWithImpl;
@override @useResult
$Res call({
 List<Drawing> states, int index, int savedIndex
});




}
/// @nodoc
class __$EditHistoryCopyWithImpl<$Res>
    implements _$EditHistoryCopyWith<$Res> {
  __$EditHistoryCopyWithImpl(this._self, this._then);

  final _EditHistory _self;
  final $Res Function(_EditHistory) _then;

/// Create a copy of EditHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? states = null,Object? index = null,Object? savedIndex = null,}) {
  return _then(_EditHistory(
states: null == states ? _self._states : states // ignore: cast_nullable_to_non_nullable
as List<Drawing>,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,savedIndex: null == savedIndex ? _self.savedIndex : savedIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
