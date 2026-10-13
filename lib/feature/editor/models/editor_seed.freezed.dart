// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'editor_seed.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EditorSeed {

 String get tabId; Drawing get drawing;/// The .flp this project is saved to, if any.
 String? get filePath;/// True for a recovered draft: nothing here matches the file on disk.
 bool get recovered;
/// Create a copy of EditorSeed
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditorSeedCopyWith<EditorSeed> get copyWith => _$EditorSeedCopyWithImpl<EditorSeed>(this as EditorSeed, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditorSeed&&(identical(other.tabId, tabId) || other.tabId == tabId)&&(identical(other.drawing, drawing) || other.drawing == drawing)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.recovered, recovered) || other.recovered == recovered));
}


@override
int get hashCode => Object.hash(runtimeType,tabId,drawing,filePath,recovered);

@override
String toString() {
  return 'EditorSeed(tabId: $tabId, drawing: $drawing, filePath: $filePath, recovered: $recovered)';
}


}

/// @nodoc
abstract mixin class $EditorSeedCopyWith<$Res>  {
  factory $EditorSeedCopyWith(EditorSeed value, $Res Function(EditorSeed) _then) = _$EditorSeedCopyWithImpl;
@useResult
$Res call({
 String tabId, Drawing drawing, String? filePath, bool recovered
});


$DrawingCopyWith<$Res> get drawing;

}
/// @nodoc
class _$EditorSeedCopyWithImpl<$Res>
    implements $EditorSeedCopyWith<$Res> {
  _$EditorSeedCopyWithImpl(this._self, this._then);

  final EditorSeed _self;
  final $Res Function(EditorSeed) _then;

/// Create a copy of EditorSeed
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tabId = null,Object? drawing = null,Object? filePath = freezed,Object? recovered = null,}) {
  return _then(_self.copyWith(
tabId: null == tabId ? _self.tabId : tabId // ignore: cast_nullable_to_non_nullable
as String,drawing: null == drawing ? _self.drawing : drawing // ignore: cast_nullable_to_non_nullable
as Drawing,filePath: freezed == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String?,recovered: null == recovered ? _self.recovered : recovered // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of EditorSeed
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DrawingCopyWith<$Res> get drawing {
  
  return $DrawingCopyWith<$Res>(_self.drawing, (value) {
    return _then(_self.copyWith(drawing: value));
  });
}
}


/// Adds pattern-matching-related methods to [EditorSeed].
extension EditorSeedPatterns on EditorSeed {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EditorSeed value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditorSeed() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EditorSeed value)  $default,){
final _that = this;
switch (_that) {
case _EditorSeed():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EditorSeed value)?  $default,){
final _that = this;
switch (_that) {
case _EditorSeed() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String tabId,  Drawing drawing,  String? filePath,  bool recovered)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditorSeed() when $default != null:
return $default(_that.tabId,_that.drawing,_that.filePath,_that.recovered);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String tabId,  Drawing drawing,  String? filePath,  bool recovered)  $default,) {final _that = this;
switch (_that) {
case _EditorSeed():
return $default(_that.tabId,_that.drawing,_that.filePath,_that.recovered);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String tabId,  Drawing drawing,  String? filePath,  bool recovered)?  $default,) {final _that = this;
switch (_that) {
case _EditorSeed() when $default != null:
return $default(_that.tabId,_that.drawing,_that.filePath,_that.recovered);case _:
  return null;

}
}

}

/// @nodoc


class _EditorSeed implements EditorSeed {
  const _EditorSeed({required this.tabId, required this.drawing, this.filePath, this.recovered = false});
  

@override final  String tabId;
@override final  Drawing drawing;
/// The .flp this project is saved to, if any.
@override final  String? filePath;
/// True for a recovered draft: nothing here matches the file on disk.
@override@JsonKey() final  bool recovered;

/// Create a copy of EditorSeed
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditorSeedCopyWith<_EditorSeed> get copyWith => __$EditorSeedCopyWithImpl<_EditorSeed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditorSeed&&(identical(other.tabId, tabId) || other.tabId == tabId)&&(identical(other.drawing, drawing) || other.drawing == drawing)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.recovered, recovered) || other.recovered == recovered));
}


@override
int get hashCode => Object.hash(runtimeType,tabId,drawing,filePath,recovered);

@override
String toString() {
  return 'EditorSeed(tabId: $tabId, drawing: $drawing, filePath: $filePath, recovered: $recovered)';
}


}

/// @nodoc
abstract mixin class _$EditorSeedCopyWith<$Res> implements $EditorSeedCopyWith<$Res> {
  factory _$EditorSeedCopyWith(_EditorSeed value, $Res Function(_EditorSeed) _then) = __$EditorSeedCopyWithImpl;
@override @useResult
$Res call({
 String tabId, Drawing drawing, String? filePath, bool recovered
});


@override $DrawingCopyWith<$Res> get drawing;

}
/// @nodoc
class __$EditorSeedCopyWithImpl<$Res>
    implements _$EditorSeedCopyWith<$Res> {
  __$EditorSeedCopyWithImpl(this._self, this._then);

  final _EditorSeed _self;
  final $Res Function(_EditorSeed) _then;

/// Create a copy of EditorSeed
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tabId = null,Object? drawing = null,Object? filePath = freezed,Object? recovered = null,}) {
  return _then(_EditorSeed(
tabId: null == tabId ? _self.tabId : tabId // ignore: cast_nullable_to_non_nullable
as String,drawing: null == drawing ? _self.drawing : drawing // ignore: cast_nullable_to_non_nullable
as Drawing,filePath: freezed == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String?,recovered: null == recovered ? _self.recovered : recovered // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of EditorSeed
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DrawingCopyWith<$Res> get drawing {
  
  return $DrawingCopyWith<$Res>(_self.drawing, (value) {
    return _then(_self.copyWith(drawing: value));
  });
}
}

// dart format on
