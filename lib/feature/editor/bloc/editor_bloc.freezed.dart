// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'editor_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EditorEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditorEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditorEvent()';
}


}

/// @nodoc
class $EditorEventCopyWith<$Res>  {
$EditorEventCopyWith(EditorEvent _, $Res Function(EditorEvent) __);
}


/// Adds pattern-matching-related methods to [EditorEvent].
extension EditorEventPatterns on EditorEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PointerPressed value)?  pointerPressed,TResult Function( PointerMoved value)?  pointerMoved,TResult Function( PointerReleased value)?  pointerReleased,TResult Function( PointerHovered value)?  pointerHovered,TResult Function( ViewPanned value)?  viewPanned,TResult Function( ViewZoomed value)?  viewZoomed,TResult Function( ViewportChanged value)?  viewportChanged,TResult Function( FitRequested value)?  fitRequested,TResult Function( GridToggled value)?  gridToggled,TResult Function( SnapToggled value)?  snapToggled,TResult Function( BackgroundCycled value)?  backgroundCycled,TResult Function( ToolSelected value)?  toolSelected,TResult Function( PolygonFinished value)?  polygonFinished,TResult Function( DraftCancelled value)?  draftCancelled,TResult Function( UndoRequested value)?  undoRequested,TResult Function( RedoRequested value)?  redoRequested,TResult Function( ChangesCommitted value)?  changesCommitted,TResult Function( StyleTargetChanged value)?  styleTargetChanged,TResult Function( ColorPicked value)?  colorPicked,TResult Function( StrokeColorPicked value)?  strokeColorPicked,TResult Function( FillToggled value)?  fillToggled,TResult Function( StrokeToggled value)?  strokeToggled,TResult Function( StrokeWidthChanged value)?  strokeWidthChanged,TResult Function( RadiusChanged value)?  radiusChanged,TResult Function( ShapeDeleted value)?  shapeDeleted,TResult Function( ShapeDuplicated value)?  shapeDuplicated,TResult Function( ShapeReordered value)?  shapeReordered,TResult Function( ShapeMovedToLayer value)?  shapeMovedToLayer,TResult Function( ShapeRenamed value)?  shapeRenamed,TResult Function( ClosedToggled value)?  closedToggled,TResult Function( LayerAdded value)?  layerAdded,TResult Function( LayerDeleted value)?  layerDeleted,TResult Function( LayerRenamed value)?  layerRenamed,TResult Function( LayerVisibilityToggled value)?  layerVisibilityToggled,TResult Function( LayerMoved value)?  layerMoved,TResult Function( LayerActivated value)?  layerActivated,TResult Function( DrawingRenamed value)?  drawingRenamed,TResult Function( CanvasResized value)?  canvasResized,TResult Function( DocumentSaved value)?  documentSaved,TResult Function( ReferenceLoaded value)?  referenceLoaded,TResult Function( ReferenceRemoved value)?  referenceRemoved,TResult Function( ReferenceFitted value)?  referenceFitted,TResult Function( ReferenceVisibilityChanged value)?  referenceVisibilityChanged,TResult Function( ReferenceOpacityChanged value)?  referenceOpacityChanged,TResult Function( ReferenceScaleChanged value)?  referenceScaleChanged,TResult Function( ReferenceSyncRequested value)?  referenceSyncRequested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PointerPressed() when pointerPressed != null:
return pointerPressed(_that);case PointerMoved() when pointerMoved != null:
return pointerMoved(_that);case PointerReleased() when pointerReleased != null:
return pointerReleased(_that);case PointerHovered() when pointerHovered != null:
return pointerHovered(_that);case ViewPanned() when viewPanned != null:
return viewPanned(_that);case ViewZoomed() when viewZoomed != null:
return viewZoomed(_that);case ViewportChanged() when viewportChanged != null:
return viewportChanged(_that);case FitRequested() when fitRequested != null:
return fitRequested(_that);case GridToggled() when gridToggled != null:
return gridToggled(_that);case SnapToggled() when snapToggled != null:
return snapToggled(_that);case BackgroundCycled() when backgroundCycled != null:
return backgroundCycled(_that);case ToolSelected() when toolSelected != null:
return toolSelected(_that);case PolygonFinished() when polygonFinished != null:
return polygonFinished(_that);case DraftCancelled() when draftCancelled != null:
return draftCancelled(_that);case UndoRequested() when undoRequested != null:
return undoRequested(_that);case RedoRequested() when redoRequested != null:
return redoRequested(_that);case ChangesCommitted() when changesCommitted != null:
return changesCommitted(_that);case StyleTargetChanged() when styleTargetChanged != null:
return styleTargetChanged(_that);case ColorPicked() when colorPicked != null:
return colorPicked(_that);case StrokeColorPicked() when strokeColorPicked != null:
return strokeColorPicked(_that);case FillToggled() when fillToggled != null:
return fillToggled(_that);case StrokeToggled() when strokeToggled != null:
return strokeToggled(_that);case StrokeWidthChanged() when strokeWidthChanged != null:
return strokeWidthChanged(_that);case RadiusChanged() when radiusChanged != null:
return radiusChanged(_that);case ShapeDeleted() when shapeDeleted != null:
return shapeDeleted(_that);case ShapeDuplicated() when shapeDuplicated != null:
return shapeDuplicated(_that);case ShapeReordered() when shapeReordered != null:
return shapeReordered(_that);case ShapeMovedToLayer() when shapeMovedToLayer != null:
return shapeMovedToLayer(_that);case ShapeRenamed() when shapeRenamed != null:
return shapeRenamed(_that);case ClosedToggled() when closedToggled != null:
return closedToggled(_that);case LayerAdded() when layerAdded != null:
return layerAdded(_that);case LayerDeleted() when layerDeleted != null:
return layerDeleted(_that);case LayerRenamed() when layerRenamed != null:
return layerRenamed(_that);case LayerVisibilityToggled() when layerVisibilityToggled != null:
return layerVisibilityToggled(_that);case LayerMoved() when layerMoved != null:
return layerMoved(_that);case LayerActivated() when layerActivated != null:
return layerActivated(_that);case DrawingRenamed() when drawingRenamed != null:
return drawingRenamed(_that);case CanvasResized() when canvasResized != null:
return canvasResized(_that);case DocumentSaved() when documentSaved != null:
return documentSaved(_that);case ReferenceLoaded() when referenceLoaded != null:
return referenceLoaded(_that);case ReferenceRemoved() when referenceRemoved != null:
return referenceRemoved(_that);case ReferenceFitted() when referenceFitted != null:
return referenceFitted(_that);case ReferenceVisibilityChanged() when referenceVisibilityChanged != null:
return referenceVisibilityChanged(_that);case ReferenceOpacityChanged() when referenceOpacityChanged != null:
return referenceOpacityChanged(_that);case ReferenceScaleChanged() when referenceScaleChanged != null:
return referenceScaleChanged(_that);case ReferenceSyncRequested() when referenceSyncRequested != null:
return referenceSyncRequested(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PointerPressed value)  pointerPressed,required TResult Function( PointerMoved value)  pointerMoved,required TResult Function( PointerReleased value)  pointerReleased,required TResult Function( PointerHovered value)  pointerHovered,required TResult Function( ViewPanned value)  viewPanned,required TResult Function( ViewZoomed value)  viewZoomed,required TResult Function( ViewportChanged value)  viewportChanged,required TResult Function( FitRequested value)  fitRequested,required TResult Function( GridToggled value)  gridToggled,required TResult Function( SnapToggled value)  snapToggled,required TResult Function( BackgroundCycled value)  backgroundCycled,required TResult Function( ToolSelected value)  toolSelected,required TResult Function( PolygonFinished value)  polygonFinished,required TResult Function( DraftCancelled value)  draftCancelled,required TResult Function( UndoRequested value)  undoRequested,required TResult Function( RedoRequested value)  redoRequested,required TResult Function( ChangesCommitted value)  changesCommitted,required TResult Function( StyleTargetChanged value)  styleTargetChanged,required TResult Function( ColorPicked value)  colorPicked,required TResult Function( StrokeColorPicked value)  strokeColorPicked,required TResult Function( FillToggled value)  fillToggled,required TResult Function( StrokeToggled value)  strokeToggled,required TResult Function( StrokeWidthChanged value)  strokeWidthChanged,required TResult Function( RadiusChanged value)  radiusChanged,required TResult Function( ShapeDeleted value)  shapeDeleted,required TResult Function( ShapeDuplicated value)  shapeDuplicated,required TResult Function( ShapeReordered value)  shapeReordered,required TResult Function( ShapeMovedToLayer value)  shapeMovedToLayer,required TResult Function( ShapeRenamed value)  shapeRenamed,required TResult Function( ClosedToggled value)  closedToggled,required TResult Function( LayerAdded value)  layerAdded,required TResult Function( LayerDeleted value)  layerDeleted,required TResult Function( LayerRenamed value)  layerRenamed,required TResult Function( LayerVisibilityToggled value)  layerVisibilityToggled,required TResult Function( LayerMoved value)  layerMoved,required TResult Function( LayerActivated value)  layerActivated,required TResult Function( DrawingRenamed value)  drawingRenamed,required TResult Function( CanvasResized value)  canvasResized,required TResult Function( DocumentSaved value)  documentSaved,required TResult Function( ReferenceLoaded value)  referenceLoaded,required TResult Function( ReferenceRemoved value)  referenceRemoved,required TResult Function( ReferenceFitted value)  referenceFitted,required TResult Function( ReferenceVisibilityChanged value)  referenceVisibilityChanged,required TResult Function( ReferenceOpacityChanged value)  referenceOpacityChanged,required TResult Function( ReferenceScaleChanged value)  referenceScaleChanged,required TResult Function( ReferenceSyncRequested value)  referenceSyncRequested,}){
final _that = this;
switch (_that) {
case PointerPressed():
return pointerPressed(_that);case PointerMoved():
return pointerMoved(_that);case PointerReleased():
return pointerReleased(_that);case PointerHovered():
return pointerHovered(_that);case ViewPanned():
return viewPanned(_that);case ViewZoomed():
return viewZoomed(_that);case ViewportChanged():
return viewportChanged(_that);case FitRequested():
return fitRequested(_that);case GridToggled():
return gridToggled(_that);case SnapToggled():
return snapToggled(_that);case BackgroundCycled():
return backgroundCycled(_that);case ToolSelected():
return toolSelected(_that);case PolygonFinished():
return polygonFinished(_that);case DraftCancelled():
return draftCancelled(_that);case UndoRequested():
return undoRequested(_that);case RedoRequested():
return redoRequested(_that);case ChangesCommitted():
return changesCommitted(_that);case StyleTargetChanged():
return styleTargetChanged(_that);case ColorPicked():
return colorPicked(_that);case StrokeColorPicked():
return strokeColorPicked(_that);case FillToggled():
return fillToggled(_that);case StrokeToggled():
return strokeToggled(_that);case StrokeWidthChanged():
return strokeWidthChanged(_that);case RadiusChanged():
return radiusChanged(_that);case ShapeDeleted():
return shapeDeleted(_that);case ShapeDuplicated():
return shapeDuplicated(_that);case ShapeReordered():
return shapeReordered(_that);case ShapeMovedToLayer():
return shapeMovedToLayer(_that);case ShapeRenamed():
return shapeRenamed(_that);case ClosedToggled():
return closedToggled(_that);case LayerAdded():
return layerAdded(_that);case LayerDeleted():
return layerDeleted(_that);case LayerRenamed():
return layerRenamed(_that);case LayerVisibilityToggled():
return layerVisibilityToggled(_that);case LayerMoved():
return layerMoved(_that);case LayerActivated():
return layerActivated(_that);case DrawingRenamed():
return drawingRenamed(_that);case CanvasResized():
return canvasResized(_that);case DocumentSaved():
return documentSaved(_that);case ReferenceLoaded():
return referenceLoaded(_that);case ReferenceRemoved():
return referenceRemoved(_that);case ReferenceFitted():
return referenceFitted(_that);case ReferenceVisibilityChanged():
return referenceVisibilityChanged(_that);case ReferenceOpacityChanged():
return referenceOpacityChanged(_that);case ReferenceScaleChanged():
return referenceScaleChanged(_that);case ReferenceSyncRequested():
return referenceSyncRequested(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PointerPressed value)?  pointerPressed,TResult? Function( PointerMoved value)?  pointerMoved,TResult? Function( PointerReleased value)?  pointerReleased,TResult? Function( PointerHovered value)?  pointerHovered,TResult? Function( ViewPanned value)?  viewPanned,TResult? Function( ViewZoomed value)?  viewZoomed,TResult? Function( ViewportChanged value)?  viewportChanged,TResult? Function( FitRequested value)?  fitRequested,TResult? Function( GridToggled value)?  gridToggled,TResult? Function( SnapToggled value)?  snapToggled,TResult? Function( BackgroundCycled value)?  backgroundCycled,TResult? Function( ToolSelected value)?  toolSelected,TResult? Function( PolygonFinished value)?  polygonFinished,TResult? Function( DraftCancelled value)?  draftCancelled,TResult? Function( UndoRequested value)?  undoRequested,TResult? Function( RedoRequested value)?  redoRequested,TResult? Function( ChangesCommitted value)?  changesCommitted,TResult? Function( StyleTargetChanged value)?  styleTargetChanged,TResult? Function( ColorPicked value)?  colorPicked,TResult? Function( StrokeColorPicked value)?  strokeColorPicked,TResult? Function( FillToggled value)?  fillToggled,TResult? Function( StrokeToggled value)?  strokeToggled,TResult? Function( StrokeWidthChanged value)?  strokeWidthChanged,TResult? Function( RadiusChanged value)?  radiusChanged,TResult? Function( ShapeDeleted value)?  shapeDeleted,TResult? Function( ShapeDuplicated value)?  shapeDuplicated,TResult? Function( ShapeReordered value)?  shapeReordered,TResult? Function( ShapeMovedToLayer value)?  shapeMovedToLayer,TResult? Function( ShapeRenamed value)?  shapeRenamed,TResult? Function( ClosedToggled value)?  closedToggled,TResult? Function( LayerAdded value)?  layerAdded,TResult? Function( LayerDeleted value)?  layerDeleted,TResult? Function( LayerRenamed value)?  layerRenamed,TResult? Function( LayerVisibilityToggled value)?  layerVisibilityToggled,TResult? Function( LayerMoved value)?  layerMoved,TResult? Function( LayerActivated value)?  layerActivated,TResult? Function( DrawingRenamed value)?  drawingRenamed,TResult? Function( CanvasResized value)?  canvasResized,TResult? Function( DocumentSaved value)?  documentSaved,TResult? Function( ReferenceLoaded value)?  referenceLoaded,TResult? Function( ReferenceRemoved value)?  referenceRemoved,TResult? Function( ReferenceFitted value)?  referenceFitted,TResult? Function( ReferenceVisibilityChanged value)?  referenceVisibilityChanged,TResult? Function( ReferenceOpacityChanged value)?  referenceOpacityChanged,TResult? Function( ReferenceScaleChanged value)?  referenceScaleChanged,TResult? Function( ReferenceSyncRequested value)?  referenceSyncRequested,}){
final _that = this;
switch (_that) {
case PointerPressed() when pointerPressed != null:
return pointerPressed(_that);case PointerMoved() when pointerMoved != null:
return pointerMoved(_that);case PointerReleased() when pointerReleased != null:
return pointerReleased(_that);case PointerHovered() when pointerHovered != null:
return pointerHovered(_that);case ViewPanned() when viewPanned != null:
return viewPanned(_that);case ViewZoomed() when viewZoomed != null:
return viewZoomed(_that);case ViewportChanged() when viewportChanged != null:
return viewportChanged(_that);case FitRequested() when fitRequested != null:
return fitRequested(_that);case GridToggled() when gridToggled != null:
return gridToggled(_that);case SnapToggled() when snapToggled != null:
return snapToggled(_that);case BackgroundCycled() when backgroundCycled != null:
return backgroundCycled(_that);case ToolSelected() when toolSelected != null:
return toolSelected(_that);case PolygonFinished() when polygonFinished != null:
return polygonFinished(_that);case DraftCancelled() when draftCancelled != null:
return draftCancelled(_that);case UndoRequested() when undoRequested != null:
return undoRequested(_that);case RedoRequested() when redoRequested != null:
return redoRequested(_that);case ChangesCommitted() when changesCommitted != null:
return changesCommitted(_that);case StyleTargetChanged() when styleTargetChanged != null:
return styleTargetChanged(_that);case ColorPicked() when colorPicked != null:
return colorPicked(_that);case StrokeColorPicked() when strokeColorPicked != null:
return strokeColorPicked(_that);case FillToggled() when fillToggled != null:
return fillToggled(_that);case StrokeToggled() when strokeToggled != null:
return strokeToggled(_that);case StrokeWidthChanged() when strokeWidthChanged != null:
return strokeWidthChanged(_that);case RadiusChanged() when radiusChanged != null:
return radiusChanged(_that);case ShapeDeleted() when shapeDeleted != null:
return shapeDeleted(_that);case ShapeDuplicated() when shapeDuplicated != null:
return shapeDuplicated(_that);case ShapeReordered() when shapeReordered != null:
return shapeReordered(_that);case ShapeMovedToLayer() when shapeMovedToLayer != null:
return shapeMovedToLayer(_that);case ShapeRenamed() when shapeRenamed != null:
return shapeRenamed(_that);case ClosedToggled() when closedToggled != null:
return closedToggled(_that);case LayerAdded() when layerAdded != null:
return layerAdded(_that);case LayerDeleted() when layerDeleted != null:
return layerDeleted(_that);case LayerRenamed() when layerRenamed != null:
return layerRenamed(_that);case LayerVisibilityToggled() when layerVisibilityToggled != null:
return layerVisibilityToggled(_that);case LayerMoved() when layerMoved != null:
return layerMoved(_that);case LayerActivated() when layerActivated != null:
return layerActivated(_that);case DrawingRenamed() when drawingRenamed != null:
return drawingRenamed(_that);case CanvasResized() when canvasResized != null:
return canvasResized(_that);case DocumentSaved() when documentSaved != null:
return documentSaved(_that);case ReferenceLoaded() when referenceLoaded != null:
return referenceLoaded(_that);case ReferenceRemoved() when referenceRemoved != null:
return referenceRemoved(_that);case ReferenceFitted() when referenceFitted != null:
return referenceFitted(_that);case ReferenceVisibilityChanged() when referenceVisibilityChanged != null:
return referenceVisibilityChanged(_that);case ReferenceOpacityChanged() when referenceOpacityChanged != null:
return referenceOpacityChanged(_that);case ReferenceScaleChanged() when referenceScaleChanged != null:
return referenceScaleChanged(_that);case ReferenceSyncRequested() when referenceSyncRequested != null:
return referenceSyncRequested(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( Offset point,  bool shift,  bool alt,  int timeMs)?  pointerPressed,TResult Function( Offset point,  bool shift)?  pointerMoved,TResult Function()?  pointerReleased,TResult Function( Offset point)?  pointerHovered,TResult Function( Offset delta)?  viewPanned,TResult Function( double factor,  Offset focal)?  viewZoomed,TResult Function( Size size)?  viewportChanged,TResult Function()?  fitRequested,TResult Function()?  gridToggled,TResult Function()?  snapToggled,TResult Function()?  backgroundCycled,TResult Function( Tool tool)?  toolSelected,TResult Function( bool closed)?  polygonFinished,TResult Function()?  draftCancelled,TResult Function()?  undoRequested,TResult Function()?  redoRequested,TResult Function()?  changesCommitted,TResult Function( bool editFill)?  styleTargetChanged,TResult Function( int color)?  colorPicked,TResult Function( int color)?  strokeColorPicked,TResult Function( bool on)?  fillToggled,TResult Function( bool on)?  strokeToggled,TResult Function( double width)?  strokeWidthChanged,TResult Function( double radius)?  radiusChanged,TResult Function()?  shapeDeleted,TResult Function()?  shapeDuplicated,TResult Function( int direction)?  shapeReordered,TResult Function( int layer)?  shapeMovedToLayer,TResult Function( String name)?  shapeRenamed,TResult Function( bool closed)?  closedToggled,TResult Function()?  layerAdded,TResult Function( int index)?  layerDeleted,TResult Function( int index,  String name)?  layerRenamed,TResult Function( int index)?  layerVisibilityToggled,TResult Function( int index,  int direction)?  layerMoved,TResult Function( int index)?  layerActivated,TResult Function( String name)?  drawingRenamed,TResult Function( double width,  double height)?  canvasResized,TResult Function( String path)?  documentSaved,TResult Function( Uint8List bytes)?  referenceLoaded,TResult Function()?  referenceRemoved,TResult Function()?  referenceFitted,TResult Function( bool visible)?  referenceVisibilityChanged,TResult Function( double opacity)?  referenceOpacityChanged,TResult Function( double scale)?  referenceScaleChanged,TResult Function()?  referenceSyncRequested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PointerPressed() when pointerPressed != null:
return pointerPressed(_that.point,_that.shift,_that.alt,_that.timeMs);case PointerMoved() when pointerMoved != null:
return pointerMoved(_that.point,_that.shift);case PointerReleased() when pointerReleased != null:
return pointerReleased();case PointerHovered() when pointerHovered != null:
return pointerHovered(_that.point);case ViewPanned() when viewPanned != null:
return viewPanned(_that.delta);case ViewZoomed() when viewZoomed != null:
return viewZoomed(_that.factor,_that.focal);case ViewportChanged() when viewportChanged != null:
return viewportChanged(_that.size);case FitRequested() when fitRequested != null:
return fitRequested();case GridToggled() when gridToggled != null:
return gridToggled();case SnapToggled() when snapToggled != null:
return snapToggled();case BackgroundCycled() when backgroundCycled != null:
return backgroundCycled();case ToolSelected() when toolSelected != null:
return toolSelected(_that.tool);case PolygonFinished() when polygonFinished != null:
return polygonFinished(_that.closed);case DraftCancelled() when draftCancelled != null:
return draftCancelled();case UndoRequested() when undoRequested != null:
return undoRequested();case RedoRequested() when redoRequested != null:
return redoRequested();case ChangesCommitted() when changesCommitted != null:
return changesCommitted();case StyleTargetChanged() when styleTargetChanged != null:
return styleTargetChanged(_that.editFill);case ColorPicked() when colorPicked != null:
return colorPicked(_that.color);case StrokeColorPicked() when strokeColorPicked != null:
return strokeColorPicked(_that.color);case FillToggled() when fillToggled != null:
return fillToggled(_that.on);case StrokeToggled() when strokeToggled != null:
return strokeToggled(_that.on);case StrokeWidthChanged() when strokeWidthChanged != null:
return strokeWidthChanged(_that.width);case RadiusChanged() when radiusChanged != null:
return radiusChanged(_that.radius);case ShapeDeleted() when shapeDeleted != null:
return shapeDeleted();case ShapeDuplicated() when shapeDuplicated != null:
return shapeDuplicated();case ShapeReordered() when shapeReordered != null:
return shapeReordered(_that.direction);case ShapeMovedToLayer() when shapeMovedToLayer != null:
return shapeMovedToLayer(_that.layer);case ShapeRenamed() when shapeRenamed != null:
return shapeRenamed(_that.name);case ClosedToggled() when closedToggled != null:
return closedToggled(_that.closed);case LayerAdded() when layerAdded != null:
return layerAdded();case LayerDeleted() when layerDeleted != null:
return layerDeleted(_that.index);case LayerRenamed() when layerRenamed != null:
return layerRenamed(_that.index,_that.name);case LayerVisibilityToggled() when layerVisibilityToggled != null:
return layerVisibilityToggled(_that.index);case LayerMoved() when layerMoved != null:
return layerMoved(_that.index,_that.direction);case LayerActivated() when layerActivated != null:
return layerActivated(_that.index);case DrawingRenamed() when drawingRenamed != null:
return drawingRenamed(_that.name);case CanvasResized() when canvasResized != null:
return canvasResized(_that.width,_that.height);case DocumentSaved() when documentSaved != null:
return documentSaved(_that.path);case ReferenceLoaded() when referenceLoaded != null:
return referenceLoaded(_that.bytes);case ReferenceRemoved() when referenceRemoved != null:
return referenceRemoved();case ReferenceFitted() when referenceFitted != null:
return referenceFitted();case ReferenceVisibilityChanged() when referenceVisibilityChanged != null:
return referenceVisibilityChanged(_that.visible);case ReferenceOpacityChanged() when referenceOpacityChanged != null:
return referenceOpacityChanged(_that.opacity);case ReferenceScaleChanged() when referenceScaleChanged != null:
return referenceScaleChanged(_that.scale);case ReferenceSyncRequested() when referenceSyncRequested != null:
return referenceSyncRequested();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( Offset point,  bool shift,  bool alt,  int timeMs)  pointerPressed,required TResult Function( Offset point,  bool shift)  pointerMoved,required TResult Function()  pointerReleased,required TResult Function( Offset point)  pointerHovered,required TResult Function( Offset delta)  viewPanned,required TResult Function( double factor,  Offset focal)  viewZoomed,required TResult Function( Size size)  viewportChanged,required TResult Function()  fitRequested,required TResult Function()  gridToggled,required TResult Function()  snapToggled,required TResult Function()  backgroundCycled,required TResult Function( Tool tool)  toolSelected,required TResult Function( bool closed)  polygonFinished,required TResult Function()  draftCancelled,required TResult Function()  undoRequested,required TResult Function()  redoRequested,required TResult Function()  changesCommitted,required TResult Function( bool editFill)  styleTargetChanged,required TResult Function( int color)  colorPicked,required TResult Function( int color)  strokeColorPicked,required TResult Function( bool on)  fillToggled,required TResult Function( bool on)  strokeToggled,required TResult Function( double width)  strokeWidthChanged,required TResult Function( double radius)  radiusChanged,required TResult Function()  shapeDeleted,required TResult Function()  shapeDuplicated,required TResult Function( int direction)  shapeReordered,required TResult Function( int layer)  shapeMovedToLayer,required TResult Function( String name)  shapeRenamed,required TResult Function( bool closed)  closedToggled,required TResult Function()  layerAdded,required TResult Function( int index)  layerDeleted,required TResult Function( int index,  String name)  layerRenamed,required TResult Function( int index)  layerVisibilityToggled,required TResult Function( int index,  int direction)  layerMoved,required TResult Function( int index)  layerActivated,required TResult Function( String name)  drawingRenamed,required TResult Function( double width,  double height)  canvasResized,required TResult Function( String path)  documentSaved,required TResult Function( Uint8List bytes)  referenceLoaded,required TResult Function()  referenceRemoved,required TResult Function()  referenceFitted,required TResult Function( bool visible)  referenceVisibilityChanged,required TResult Function( double opacity)  referenceOpacityChanged,required TResult Function( double scale)  referenceScaleChanged,required TResult Function()  referenceSyncRequested,}) {final _that = this;
switch (_that) {
case PointerPressed():
return pointerPressed(_that.point,_that.shift,_that.alt,_that.timeMs);case PointerMoved():
return pointerMoved(_that.point,_that.shift);case PointerReleased():
return pointerReleased();case PointerHovered():
return pointerHovered(_that.point);case ViewPanned():
return viewPanned(_that.delta);case ViewZoomed():
return viewZoomed(_that.factor,_that.focal);case ViewportChanged():
return viewportChanged(_that.size);case FitRequested():
return fitRequested();case GridToggled():
return gridToggled();case SnapToggled():
return snapToggled();case BackgroundCycled():
return backgroundCycled();case ToolSelected():
return toolSelected(_that.tool);case PolygonFinished():
return polygonFinished(_that.closed);case DraftCancelled():
return draftCancelled();case UndoRequested():
return undoRequested();case RedoRequested():
return redoRequested();case ChangesCommitted():
return changesCommitted();case StyleTargetChanged():
return styleTargetChanged(_that.editFill);case ColorPicked():
return colorPicked(_that.color);case StrokeColorPicked():
return strokeColorPicked(_that.color);case FillToggled():
return fillToggled(_that.on);case StrokeToggled():
return strokeToggled(_that.on);case StrokeWidthChanged():
return strokeWidthChanged(_that.width);case RadiusChanged():
return radiusChanged(_that.radius);case ShapeDeleted():
return shapeDeleted();case ShapeDuplicated():
return shapeDuplicated();case ShapeReordered():
return shapeReordered(_that.direction);case ShapeMovedToLayer():
return shapeMovedToLayer(_that.layer);case ShapeRenamed():
return shapeRenamed(_that.name);case ClosedToggled():
return closedToggled(_that.closed);case LayerAdded():
return layerAdded();case LayerDeleted():
return layerDeleted(_that.index);case LayerRenamed():
return layerRenamed(_that.index,_that.name);case LayerVisibilityToggled():
return layerVisibilityToggled(_that.index);case LayerMoved():
return layerMoved(_that.index,_that.direction);case LayerActivated():
return layerActivated(_that.index);case DrawingRenamed():
return drawingRenamed(_that.name);case CanvasResized():
return canvasResized(_that.width,_that.height);case DocumentSaved():
return documentSaved(_that.path);case ReferenceLoaded():
return referenceLoaded(_that.bytes);case ReferenceRemoved():
return referenceRemoved();case ReferenceFitted():
return referenceFitted();case ReferenceVisibilityChanged():
return referenceVisibilityChanged(_that.visible);case ReferenceOpacityChanged():
return referenceOpacityChanged(_that.opacity);case ReferenceScaleChanged():
return referenceScaleChanged(_that.scale);case ReferenceSyncRequested():
return referenceSyncRequested();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( Offset point,  bool shift,  bool alt,  int timeMs)?  pointerPressed,TResult? Function( Offset point,  bool shift)?  pointerMoved,TResult? Function()?  pointerReleased,TResult? Function( Offset point)?  pointerHovered,TResult? Function( Offset delta)?  viewPanned,TResult? Function( double factor,  Offset focal)?  viewZoomed,TResult? Function( Size size)?  viewportChanged,TResult? Function()?  fitRequested,TResult? Function()?  gridToggled,TResult? Function()?  snapToggled,TResult? Function()?  backgroundCycled,TResult? Function( Tool tool)?  toolSelected,TResult? Function( bool closed)?  polygonFinished,TResult? Function()?  draftCancelled,TResult? Function()?  undoRequested,TResult? Function()?  redoRequested,TResult? Function()?  changesCommitted,TResult? Function( bool editFill)?  styleTargetChanged,TResult? Function( int color)?  colorPicked,TResult? Function( int color)?  strokeColorPicked,TResult? Function( bool on)?  fillToggled,TResult? Function( bool on)?  strokeToggled,TResult? Function( double width)?  strokeWidthChanged,TResult? Function( double radius)?  radiusChanged,TResult? Function()?  shapeDeleted,TResult? Function()?  shapeDuplicated,TResult? Function( int direction)?  shapeReordered,TResult? Function( int layer)?  shapeMovedToLayer,TResult? Function( String name)?  shapeRenamed,TResult? Function( bool closed)?  closedToggled,TResult? Function()?  layerAdded,TResult? Function( int index)?  layerDeleted,TResult? Function( int index,  String name)?  layerRenamed,TResult? Function( int index)?  layerVisibilityToggled,TResult? Function( int index,  int direction)?  layerMoved,TResult? Function( int index)?  layerActivated,TResult? Function( String name)?  drawingRenamed,TResult? Function( double width,  double height)?  canvasResized,TResult? Function( String path)?  documentSaved,TResult? Function( Uint8List bytes)?  referenceLoaded,TResult? Function()?  referenceRemoved,TResult? Function()?  referenceFitted,TResult? Function( bool visible)?  referenceVisibilityChanged,TResult? Function( double opacity)?  referenceOpacityChanged,TResult? Function( double scale)?  referenceScaleChanged,TResult? Function()?  referenceSyncRequested,}) {final _that = this;
switch (_that) {
case PointerPressed() when pointerPressed != null:
return pointerPressed(_that.point,_that.shift,_that.alt,_that.timeMs);case PointerMoved() when pointerMoved != null:
return pointerMoved(_that.point,_that.shift);case PointerReleased() when pointerReleased != null:
return pointerReleased();case PointerHovered() when pointerHovered != null:
return pointerHovered(_that.point);case ViewPanned() when viewPanned != null:
return viewPanned(_that.delta);case ViewZoomed() when viewZoomed != null:
return viewZoomed(_that.factor,_that.focal);case ViewportChanged() when viewportChanged != null:
return viewportChanged(_that.size);case FitRequested() when fitRequested != null:
return fitRequested();case GridToggled() when gridToggled != null:
return gridToggled();case SnapToggled() when snapToggled != null:
return snapToggled();case BackgroundCycled() when backgroundCycled != null:
return backgroundCycled();case ToolSelected() when toolSelected != null:
return toolSelected(_that.tool);case PolygonFinished() when polygonFinished != null:
return polygonFinished(_that.closed);case DraftCancelled() when draftCancelled != null:
return draftCancelled();case UndoRequested() when undoRequested != null:
return undoRequested();case RedoRequested() when redoRequested != null:
return redoRequested();case ChangesCommitted() when changesCommitted != null:
return changesCommitted();case StyleTargetChanged() when styleTargetChanged != null:
return styleTargetChanged(_that.editFill);case ColorPicked() when colorPicked != null:
return colorPicked(_that.color);case StrokeColorPicked() when strokeColorPicked != null:
return strokeColorPicked(_that.color);case FillToggled() when fillToggled != null:
return fillToggled(_that.on);case StrokeToggled() when strokeToggled != null:
return strokeToggled(_that.on);case StrokeWidthChanged() when strokeWidthChanged != null:
return strokeWidthChanged(_that.width);case RadiusChanged() when radiusChanged != null:
return radiusChanged(_that.radius);case ShapeDeleted() when shapeDeleted != null:
return shapeDeleted();case ShapeDuplicated() when shapeDuplicated != null:
return shapeDuplicated();case ShapeReordered() when shapeReordered != null:
return shapeReordered(_that.direction);case ShapeMovedToLayer() when shapeMovedToLayer != null:
return shapeMovedToLayer(_that.layer);case ShapeRenamed() when shapeRenamed != null:
return shapeRenamed(_that.name);case ClosedToggled() when closedToggled != null:
return closedToggled(_that.closed);case LayerAdded() when layerAdded != null:
return layerAdded();case LayerDeleted() when layerDeleted != null:
return layerDeleted(_that.index);case LayerRenamed() when layerRenamed != null:
return layerRenamed(_that.index,_that.name);case LayerVisibilityToggled() when layerVisibilityToggled != null:
return layerVisibilityToggled(_that.index);case LayerMoved() when layerMoved != null:
return layerMoved(_that.index,_that.direction);case LayerActivated() when layerActivated != null:
return layerActivated(_that.index);case DrawingRenamed() when drawingRenamed != null:
return drawingRenamed(_that.name);case CanvasResized() when canvasResized != null:
return canvasResized(_that.width,_that.height);case DocumentSaved() when documentSaved != null:
return documentSaved(_that.path);case ReferenceLoaded() when referenceLoaded != null:
return referenceLoaded(_that.bytes);case ReferenceRemoved() when referenceRemoved != null:
return referenceRemoved();case ReferenceFitted() when referenceFitted != null:
return referenceFitted();case ReferenceVisibilityChanged() when referenceVisibilityChanged != null:
return referenceVisibilityChanged(_that.visible);case ReferenceOpacityChanged() when referenceOpacityChanged != null:
return referenceOpacityChanged(_that.opacity);case ReferenceScaleChanged() when referenceScaleChanged != null:
return referenceScaleChanged(_that.scale);case ReferenceSyncRequested() when referenceSyncRequested != null:
return referenceSyncRequested();case _:
  return null;

}
}

}

/// @nodoc


class PointerPressed implements EditorEvent {
  const PointerPressed(this.point, {this.shift = false, this.alt = false, this.timeMs = 0});
  

 final  Offset point;
@JsonKey() final  bool shift;
@JsonKey() final  bool alt;
@JsonKey() final  int timeMs;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PointerPressedCopyWith<PointerPressed> get copyWith => _$PointerPressedCopyWithImpl<PointerPressed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PointerPressed&&(identical(other.point, point) || other.point == point)&&(identical(other.shift, shift) || other.shift == shift)&&(identical(other.alt, alt) || other.alt == alt)&&(identical(other.timeMs, timeMs) || other.timeMs == timeMs));
}


@override
int get hashCode => Object.hash(runtimeType,point,shift,alt,timeMs);

@override
String toString() {
  return 'EditorEvent.pointerPressed(point: $point, shift: $shift, alt: $alt, timeMs: $timeMs)';
}


}

/// @nodoc
abstract mixin class $PointerPressedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $PointerPressedCopyWith(PointerPressed value, $Res Function(PointerPressed) _then) = _$PointerPressedCopyWithImpl;
@useResult
$Res call({
 Offset point, bool shift, bool alt, int timeMs
});




}
/// @nodoc
class _$PointerPressedCopyWithImpl<$Res>
    implements $PointerPressedCopyWith<$Res> {
  _$PointerPressedCopyWithImpl(this._self, this._then);

  final PointerPressed _self;
  final $Res Function(PointerPressed) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? point = null,Object? shift = null,Object? alt = null,Object? timeMs = null,}) {
  return _then(PointerPressed(
null == point ? _self.point : point // ignore: cast_nullable_to_non_nullable
as Offset,shift: null == shift ? _self.shift : shift // ignore: cast_nullable_to_non_nullable
as bool,alt: null == alt ? _self.alt : alt // ignore: cast_nullable_to_non_nullable
as bool,timeMs: null == timeMs ? _self.timeMs : timeMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class PointerMoved implements EditorEvent {
  const PointerMoved(this.point, {this.shift = false});
  

 final  Offset point;
@JsonKey() final  bool shift;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PointerMovedCopyWith<PointerMoved> get copyWith => _$PointerMovedCopyWithImpl<PointerMoved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PointerMoved&&(identical(other.point, point) || other.point == point)&&(identical(other.shift, shift) || other.shift == shift));
}


@override
int get hashCode => Object.hash(runtimeType,point,shift);

@override
String toString() {
  return 'EditorEvent.pointerMoved(point: $point, shift: $shift)';
}


}

/// @nodoc
abstract mixin class $PointerMovedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $PointerMovedCopyWith(PointerMoved value, $Res Function(PointerMoved) _then) = _$PointerMovedCopyWithImpl;
@useResult
$Res call({
 Offset point, bool shift
});




}
/// @nodoc
class _$PointerMovedCopyWithImpl<$Res>
    implements $PointerMovedCopyWith<$Res> {
  _$PointerMovedCopyWithImpl(this._self, this._then);

  final PointerMoved _self;
  final $Res Function(PointerMoved) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? point = null,Object? shift = null,}) {
  return _then(PointerMoved(
null == point ? _self.point : point // ignore: cast_nullable_to_non_nullable
as Offset,shift: null == shift ? _self.shift : shift // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class PointerReleased implements EditorEvent {
  const PointerReleased();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PointerReleased);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditorEvent.pointerReleased()';
}


}




/// @nodoc


class PointerHovered implements EditorEvent {
  const PointerHovered(this.point);
  

 final  Offset point;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PointerHoveredCopyWith<PointerHovered> get copyWith => _$PointerHoveredCopyWithImpl<PointerHovered>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PointerHovered&&(identical(other.point, point) || other.point == point));
}


@override
int get hashCode => Object.hash(runtimeType,point);

@override
String toString() {
  return 'EditorEvent.pointerHovered(point: $point)';
}


}

/// @nodoc
abstract mixin class $PointerHoveredCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $PointerHoveredCopyWith(PointerHovered value, $Res Function(PointerHovered) _then) = _$PointerHoveredCopyWithImpl;
@useResult
$Res call({
 Offset point
});




}
/// @nodoc
class _$PointerHoveredCopyWithImpl<$Res>
    implements $PointerHoveredCopyWith<$Res> {
  _$PointerHoveredCopyWithImpl(this._self, this._then);

  final PointerHovered _self;
  final $Res Function(PointerHovered) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? point = null,}) {
  return _then(PointerHovered(
null == point ? _self.point : point // ignore: cast_nullable_to_non_nullable
as Offset,
  ));
}


}

/// @nodoc


class ViewPanned implements EditorEvent {
  const ViewPanned(this.delta);
  

 final  Offset delta;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ViewPannedCopyWith<ViewPanned> get copyWith => _$ViewPannedCopyWithImpl<ViewPanned>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ViewPanned&&(identical(other.delta, delta) || other.delta == delta));
}


@override
int get hashCode => Object.hash(runtimeType,delta);

@override
String toString() {
  return 'EditorEvent.viewPanned(delta: $delta)';
}


}

/// @nodoc
abstract mixin class $ViewPannedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $ViewPannedCopyWith(ViewPanned value, $Res Function(ViewPanned) _then) = _$ViewPannedCopyWithImpl;
@useResult
$Res call({
 Offset delta
});




}
/// @nodoc
class _$ViewPannedCopyWithImpl<$Res>
    implements $ViewPannedCopyWith<$Res> {
  _$ViewPannedCopyWithImpl(this._self, this._then);

  final ViewPanned _self;
  final $Res Function(ViewPanned) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? delta = null,}) {
  return _then(ViewPanned(
null == delta ? _self.delta : delta // ignore: cast_nullable_to_non_nullable
as Offset,
  ));
}


}

/// @nodoc


class ViewZoomed implements EditorEvent {
  const ViewZoomed(this.factor, this.focal);
  

 final  double factor;
 final  Offset focal;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ViewZoomedCopyWith<ViewZoomed> get copyWith => _$ViewZoomedCopyWithImpl<ViewZoomed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ViewZoomed&&(identical(other.factor, factor) || other.factor == factor)&&(identical(other.focal, focal) || other.focal == focal));
}


@override
int get hashCode => Object.hash(runtimeType,factor,focal);

@override
String toString() {
  return 'EditorEvent.viewZoomed(factor: $factor, focal: $focal)';
}


}

/// @nodoc
abstract mixin class $ViewZoomedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $ViewZoomedCopyWith(ViewZoomed value, $Res Function(ViewZoomed) _then) = _$ViewZoomedCopyWithImpl;
@useResult
$Res call({
 double factor, Offset focal
});




}
/// @nodoc
class _$ViewZoomedCopyWithImpl<$Res>
    implements $ViewZoomedCopyWith<$Res> {
  _$ViewZoomedCopyWithImpl(this._self, this._then);

  final ViewZoomed _self;
  final $Res Function(ViewZoomed) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? factor = null,Object? focal = null,}) {
  return _then(ViewZoomed(
null == factor ? _self.factor : factor // ignore: cast_nullable_to_non_nullable
as double,null == focal ? _self.focal : focal // ignore: cast_nullable_to_non_nullable
as Offset,
  ));
}


}

/// @nodoc


class ViewportChanged implements EditorEvent {
  const ViewportChanged(this.size);
  

 final  Size size;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ViewportChangedCopyWith<ViewportChanged> get copyWith => _$ViewportChangedCopyWithImpl<ViewportChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ViewportChanged&&(identical(other.size, size) || other.size == size));
}


@override
int get hashCode => Object.hash(runtimeType,size);

@override
String toString() {
  return 'EditorEvent.viewportChanged(size: $size)';
}


}

/// @nodoc
abstract mixin class $ViewportChangedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $ViewportChangedCopyWith(ViewportChanged value, $Res Function(ViewportChanged) _then) = _$ViewportChangedCopyWithImpl;
@useResult
$Res call({
 Size size
});




}
/// @nodoc
class _$ViewportChangedCopyWithImpl<$Res>
    implements $ViewportChangedCopyWith<$Res> {
  _$ViewportChangedCopyWithImpl(this._self, this._then);

  final ViewportChanged _self;
  final $Res Function(ViewportChanged) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? size = null,}) {
  return _then(ViewportChanged(
null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as Size,
  ));
}


}

/// @nodoc


class FitRequested implements EditorEvent {
  const FitRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FitRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditorEvent.fitRequested()';
}


}




/// @nodoc


class GridToggled implements EditorEvent {
  const GridToggled();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GridToggled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditorEvent.gridToggled()';
}


}




/// @nodoc


class SnapToggled implements EditorEvent {
  const SnapToggled();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SnapToggled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditorEvent.snapToggled()';
}


}




/// @nodoc


class BackgroundCycled implements EditorEvent {
  const BackgroundCycled();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackgroundCycled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditorEvent.backgroundCycled()';
}


}




/// @nodoc


class ToolSelected implements EditorEvent {
  const ToolSelected(this.tool);
  

 final  Tool tool;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ToolSelectedCopyWith<ToolSelected> get copyWith => _$ToolSelectedCopyWithImpl<ToolSelected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ToolSelected&&(identical(other.tool, tool) || other.tool == tool));
}


@override
int get hashCode => Object.hash(runtimeType,tool);

@override
String toString() {
  return 'EditorEvent.toolSelected(tool: $tool)';
}


}

/// @nodoc
abstract mixin class $ToolSelectedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $ToolSelectedCopyWith(ToolSelected value, $Res Function(ToolSelected) _then) = _$ToolSelectedCopyWithImpl;
@useResult
$Res call({
 Tool tool
});




}
/// @nodoc
class _$ToolSelectedCopyWithImpl<$Res>
    implements $ToolSelectedCopyWith<$Res> {
  _$ToolSelectedCopyWithImpl(this._self, this._then);

  final ToolSelected _self;
  final $Res Function(ToolSelected) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tool = null,}) {
  return _then(ToolSelected(
null == tool ? _self.tool : tool // ignore: cast_nullable_to_non_nullable
as Tool,
  ));
}


}

/// @nodoc


class PolygonFinished implements EditorEvent {
  const PolygonFinished({this.closed = true});
  

@JsonKey() final  bool closed;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PolygonFinishedCopyWith<PolygonFinished> get copyWith => _$PolygonFinishedCopyWithImpl<PolygonFinished>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PolygonFinished&&(identical(other.closed, closed) || other.closed == closed));
}


@override
int get hashCode => Object.hash(runtimeType,closed);

@override
String toString() {
  return 'EditorEvent.polygonFinished(closed: $closed)';
}


}

/// @nodoc
abstract mixin class $PolygonFinishedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $PolygonFinishedCopyWith(PolygonFinished value, $Res Function(PolygonFinished) _then) = _$PolygonFinishedCopyWithImpl;
@useResult
$Res call({
 bool closed
});




}
/// @nodoc
class _$PolygonFinishedCopyWithImpl<$Res>
    implements $PolygonFinishedCopyWith<$Res> {
  _$PolygonFinishedCopyWithImpl(this._self, this._then);

  final PolygonFinished _self;
  final $Res Function(PolygonFinished) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? closed = null,}) {
  return _then(PolygonFinished(
closed: null == closed ? _self.closed : closed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class DraftCancelled implements EditorEvent {
  const DraftCancelled();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DraftCancelled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditorEvent.draftCancelled()';
}


}




/// @nodoc


class UndoRequested implements EditorEvent {
  const UndoRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UndoRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditorEvent.undoRequested()';
}


}




/// @nodoc


class RedoRequested implements EditorEvent {
  const RedoRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RedoRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditorEvent.redoRequested()';
}


}




/// @nodoc


class ChangesCommitted implements EditorEvent {
  const ChangesCommitted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangesCommitted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditorEvent.changesCommitted()';
}


}




/// @nodoc


class StyleTargetChanged implements EditorEvent {
  const StyleTargetChanged(this.editFill);
  

 final  bool editFill;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StyleTargetChangedCopyWith<StyleTargetChanged> get copyWith => _$StyleTargetChangedCopyWithImpl<StyleTargetChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StyleTargetChanged&&(identical(other.editFill, editFill) || other.editFill == editFill));
}


@override
int get hashCode => Object.hash(runtimeType,editFill);

@override
String toString() {
  return 'EditorEvent.styleTargetChanged(editFill: $editFill)';
}


}

/// @nodoc
abstract mixin class $StyleTargetChangedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $StyleTargetChangedCopyWith(StyleTargetChanged value, $Res Function(StyleTargetChanged) _then) = _$StyleTargetChangedCopyWithImpl;
@useResult
$Res call({
 bool editFill
});




}
/// @nodoc
class _$StyleTargetChangedCopyWithImpl<$Res>
    implements $StyleTargetChangedCopyWith<$Res> {
  _$StyleTargetChangedCopyWithImpl(this._self, this._then);

  final StyleTargetChanged _self;
  final $Res Function(StyleTargetChanged) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? editFill = null,}) {
  return _then(StyleTargetChanged(
null == editFill ? _self.editFill : editFill // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class ColorPicked implements EditorEvent {
  const ColorPicked(this.color);
  

 final  int color;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ColorPickedCopyWith<ColorPicked> get copyWith => _$ColorPickedCopyWithImpl<ColorPicked>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ColorPicked&&(identical(other.color, color) || other.color == color));
}


@override
int get hashCode => Object.hash(runtimeType,color);

@override
String toString() {
  return 'EditorEvent.colorPicked(color: $color)';
}


}

/// @nodoc
abstract mixin class $ColorPickedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $ColorPickedCopyWith(ColorPicked value, $Res Function(ColorPicked) _then) = _$ColorPickedCopyWithImpl;
@useResult
$Res call({
 int color
});




}
/// @nodoc
class _$ColorPickedCopyWithImpl<$Res>
    implements $ColorPickedCopyWith<$Res> {
  _$ColorPickedCopyWithImpl(this._self, this._then);

  final ColorPicked _self;
  final $Res Function(ColorPicked) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? color = null,}) {
  return _then(ColorPicked(
null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class StrokeColorPicked implements EditorEvent {
  const StrokeColorPicked(this.color);
  

 final  int color;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StrokeColorPickedCopyWith<StrokeColorPicked> get copyWith => _$StrokeColorPickedCopyWithImpl<StrokeColorPicked>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StrokeColorPicked&&(identical(other.color, color) || other.color == color));
}


@override
int get hashCode => Object.hash(runtimeType,color);

@override
String toString() {
  return 'EditorEvent.strokeColorPicked(color: $color)';
}


}

/// @nodoc
abstract mixin class $StrokeColorPickedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $StrokeColorPickedCopyWith(StrokeColorPicked value, $Res Function(StrokeColorPicked) _then) = _$StrokeColorPickedCopyWithImpl;
@useResult
$Res call({
 int color
});




}
/// @nodoc
class _$StrokeColorPickedCopyWithImpl<$Res>
    implements $StrokeColorPickedCopyWith<$Res> {
  _$StrokeColorPickedCopyWithImpl(this._self, this._then);

  final StrokeColorPicked _self;
  final $Res Function(StrokeColorPicked) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? color = null,}) {
  return _then(StrokeColorPicked(
null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class FillToggled implements EditorEvent {
  const FillToggled(this.on);
  

 final  bool on;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FillToggledCopyWith<FillToggled> get copyWith => _$FillToggledCopyWithImpl<FillToggled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FillToggled&&(identical(other.on, on) || other.on == on));
}


@override
int get hashCode => Object.hash(runtimeType,on);

@override
String toString() {
  return 'EditorEvent.fillToggled(on: $on)';
}


}

/// @nodoc
abstract mixin class $FillToggledCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $FillToggledCopyWith(FillToggled value, $Res Function(FillToggled) _then) = _$FillToggledCopyWithImpl;
@useResult
$Res call({
 bool on
});




}
/// @nodoc
class _$FillToggledCopyWithImpl<$Res>
    implements $FillToggledCopyWith<$Res> {
  _$FillToggledCopyWithImpl(this._self, this._then);

  final FillToggled _self;
  final $Res Function(FillToggled) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? on = null,}) {
  return _then(FillToggled(
null == on ? _self.on : on // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class StrokeToggled implements EditorEvent {
  const StrokeToggled(this.on);
  

 final  bool on;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StrokeToggledCopyWith<StrokeToggled> get copyWith => _$StrokeToggledCopyWithImpl<StrokeToggled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StrokeToggled&&(identical(other.on, on) || other.on == on));
}


@override
int get hashCode => Object.hash(runtimeType,on);

@override
String toString() {
  return 'EditorEvent.strokeToggled(on: $on)';
}


}

/// @nodoc
abstract mixin class $StrokeToggledCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $StrokeToggledCopyWith(StrokeToggled value, $Res Function(StrokeToggled) _then) = _$StrokeToggledCopyWithImpl;
@useResult
$Res call({
 bool on
});




}
/// @nodoc
class _$StrokeToggledCopyWithImpl<$Res>
    implements $StrokeToggledCopyWith<$Res> {
  _$StrokeToggledCopyWithImpl(this._self, this._then);

  final StrokeToggled _self;
  final $Res Function(StrokeToggled) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? on = null,}) {
  return _then(StrokeToggled(
null == on ? _self.on : on // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class StrokeWidthChanged implements EditorEvent {
  const StrokeWidthChanged(this.width);
  

 final  double width;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StrokeWidthChangedCopyWith<StrokeWidthChanged> get copyWith => _$StrokeWidthChangedCopyWithImpl<StrokeWidthChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StrokeWidthChanged&&(identical(other.width, width) || other.width == width));
}


@override
int get hashCode => Object.hash(runtimeType,width);

@override
String toString() {
  return 'EditorEvent.strokeWidthChanged(width: $width)';
}


}

/// @nodoc
abstract mixin class $StrokeWidthChangedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $StrokeWidthChangedCopyWith(StrokeWidthChanged value, $Res Function(StrokeWidthChanged) _then) = _$StrokeWidthChangedCopyWithImpl;
@useResult
$Res call({
 double width
});




}
/// @nodoc
class _$StrokeWidthChangedCopyWithImpl<$Res>
    implements $StrokeWidthChangedCopyWith<$Res> {
  _$StrokeWidthChangedCopyWithImpl(this._self, this._then);

  final StrokeWidthChanged _self;
  final $Res Function(StrokeWidthChanged) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? width = null,}) {
  return _then(StrokeWidthChanged(
null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class RadiusChanged implements EditorEvent {
  const RadiusChanged(this.radius);
  

 final  double radius;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RadiusChangedCopyWith<RadiusChanged> get copyWith => _$RadiusChangedCopyWithImpl<RadiusChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RadiusChanged&&(identical(other.radius, radius) || other.radius == radius));
}


@override
int get hashCode => Object.hash(runtimeType,radius);

@override
String toString() {
  return 'EditorEvent.radiusChanged(radius: $radius)';
}


}

/// @nodoc
abstract mixin class $RadiusChangedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $RadiusChangedCopyWith(RadiusChanged value, $Res Function(RadiusChanged) _then) = _$RadiusChangedCopyWithImpl;
@useResult
$Res call({
 double radius
});




}
/// @nodoc
class _$RadiusChangedCopyWithImpl<$Res>
    implements $RadiusChangedCopyWith<$Res> {
  _$RadiusChangedCopyWithImpl(this._self, this._then);

  final RadiusChanged _self;
  final $Res Function(RadiusChanged) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? radius = null,}) {
  return _then(RadiusChanged(
null == radius ? _self.radius : radius // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class ShapeDeleted implements EditorEvent {
  const ShapeDeleted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShapeDeleted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditorEvent.shapeDeleted()';
}


}




/// @nodoc


class ShapeDuplicated implements EditorEvent {
  const ShapeDuplicated();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShapeDuplicated);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditorEvent.shapeDuplicated()';
}


}




/// @nodoc


class ShapeReordered implements EditorEvent {
  const ShapeReordered(this.direction);
  

 final  int direction;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShapeReorderedCopyWith<ShapeReordered> get copyWith => _$ShapeReorderedCopyWithImpl<ShapeReordered>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShapeReordered&&(identical(other.direction, direction) || other.direction == direction));
}


@override
int get hashCode => Object.hash(runtimeType,direction);

@override
String toString() {
  return 'EditorEvent.shapeReordered(direction: $direction)';
}


}

/// @nodoc
abstract mixin class $ShapeReorderedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $ShapeReorderedCopyWith(ShapeReordered value, $Res Function(ShapeReordered) _then) = _$ShapeReorderedCopyWithImpl;
@useResult
$Res call({
 int direction
});




}
/// @nodoc
class _$ShapeReorderedCopyWithImpl<$Res>
    implements $ShapeReorderedCopyWith<$Res> {
  _$ShapeReorderedCopyWithImpl(this._self, this._then);

  final ShapeReordered _self;
  final $Res Function(ShapeReordered) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? direction = null,}) {
  return _then(ShapeReordered(
null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class ShapeMovedToLayer implements EditorEvent {
  const ShapeMovedToLayer(this.layer);
  

 final  int layer;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShapeMovedToLayerCopyWith<ShapeMovedToLayer> get copyWith => _$ShapeMovedToLayerCopyWithImpl<ShapeMovedToLayer>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShapeMovedToLayer&&(identical(other.layer, layer) || other.layer == layer));
}


@override
int get hashCode => Object.hash(runtimeType,layer);

@override
String toString() {
  return 'EditorEvent.shapeMovedToLayer(layer: $layer)';
}


}

/// @nodoc
abstract mixin class $ShapeMovedToLayerCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $ShapeMovedToLayerCopyWith(ShapeMovedToLayer value, $Res Function(ShapeMovedToLayer) _then) = _$ShapeMovedToLayerCopyWithImpl;
@useResult
$Res call({
 int layer
});




}
/// @nodoc
class _$ShapeMovedToLayerCopyWithImpl<$Res>
    implements $ShapeMovedToLayerCopyWith<$Res> {
  _$ShapeMovedToLayerCopyWithImpl(this._self, this._then);

  final ShapeMovedToLayer _self;
  final $Res Function(ShapeMovedToLayer) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? layer = null,}) {
  return _then(ShapeMovedToLayer(
null == layer ? _self.layer : layer // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class ShapeRenamed implements EditorEvent {
  const ShapeRenamed(this.name);
  

 final  String name;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShapeRenamedCopyWith<ShapeRenamed> get copyWith => _$ShapeRenamedCopyWithImpl<ShapeRenamed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShapeRenamed&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'EditorEvent.shapeRenamed(name: $name)';
}


}

/// @nodoc
abstract mixin class $ShapeRenamedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $ShapeRenamedCopyWith(ShapeRenamed value, $Res Function(ShapeRenamed) _then) = _$ShapeRenamedCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class _$ShapeRenamedCopyWithImpl<$Res>
    implements $ShapeRenamedCopyWith<$Res> {
  _$ShapeRenamedCopyWithImpl(this._self, this._then);

  final ShapeRenamed _self;
  final $Res Function(ShapeRenamed) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(ShapeRenamed(
null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ClosedToggled implements EditorEvent {
  const ClosedToggled(this.closed);
  

 final  bool closed;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClosedToggledCopyWith<ClosedToggled> get copyWith => _$ClosedToggledCopyWithImpl<ClosedToggled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClosedToggled&&(identical(other.closed, closed) || other.closed == closed));
}


@override
int get hashCode => Object.hash(runtimeType,closed);

@override
String toString() {
  return 'EditorEvent.closedToggled(closed: $closed)';
}


}

/// @nodoc
abstract mixin class $ClosedToggledCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $ClosedToggledCopyWith(ClosedToggled value, $Res Function(ClosedToggled) _then) = _$ClosedToggledCopyWithImpl;
@useResult
$Res call({
 bool closed
});




}
/// @nodoc
class _$ClosedToggledCopyWithImpl<$Res>
    implements $ClosedToggledCopyWith<$Res> {
  _$ClosedToggledCopyWithImpl(this._self, this._then);

  final ClosedToggled _self;
  final $Res Function(ClosedToggled) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? closed = null,}) {
  return _then(ClosedToggled(
null == closed ? _self.closed : closed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class LayerAdded implements EditorEvent {
  const LayerAdded();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LayerAdded);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditorEvent.layerAdded()';
}


}




/// @nodoc


class LayerDeleted implements EditorEvent {
  const LayerDeleted(this.index);
  

 final  int index;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LayerDeletedCopyWith<LayerDeleted> get copyWith => _$LayerDeletedCopyWithImpl<LayerDeleted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LayerDeleted&&(identical(other.index, index) || other.index == index));
}


@override
int get hashCode => Object.hash(runtimeType,index);

@override
String toString() {
  return 'EditorEvent.layerDeleted(index: $index)';
}


}

/// @nodoc
abstract mixin class $LayerDeletedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $LayerDeletedCopyWith(LayerDeleted value, $Res Function(LayerDeleted) _then) = _$LayerDeletedCopyWithImpl;
@useResult
$Res call({
 int index
});




}
/// @nodoc
class _$LayerDeletedCopyWithImpl<$Res>
    implements $LayerDeletedCopyWith<$Res> {
  _$LayerDeletedCopyWithImpl(this._self, this._then);

  final LayerDeleted _self;
  final $Res Function(LayerDeleted) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? index = null,}) {
  return _then(LayerDeleted(
null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class LayerRenamed implements EditorEvent {
  const LayerRenamed(this.index, this.name);
  

 final  int index;
 final  String name;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LayerRenamedCopyWith<LayerRenamed> get copyWith => _$LayerRenamedCopyWithImpl<LayerRenamed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LayerRenamed&&(identical(other.index, index) || other.index == index)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,index,name);

@override
String toString() {
  return 'EditorEvent.layerRenamed(index: $index, name: $name)';
}


}

/// @nodoc
abstract mixin class $LayerRenamedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $LayerRenamedCopyWith(LayerRenamed value, $Res Function(LayerRenamed) _then) = _$LayerRenamedCopyWithImpl;
@useResult
$Res call({
 int index, String name
});




}
/// @nodoc
class _$LayerRenamedCopyWithImpl<$Res>
    implements $LayerRenamedCopyWith<$Res> {
  _$LayerRenamedCopyWithImpl(this._self, this._then);

  final LayerRenamed _self;
  final $Res Function(LayerRenamed) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? index = null,Object? name = null,}) {
  return _then(LayerRenamed(
null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class LayerVisibilityToggled implements EditorEvent {
  const LayerVisibilityToggled(this.index);
  

 final  int index;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LayerVisibilityToggledCopyWith<LayerVisibilityToggled> get copyWith => _$LayerVisibilityToggledCopyWithImpl<LayerVisibilityToggled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LayerVisibilityToggled&&(identical(other.index, index) || other.index == index));
}


@override
int get hashCode => Object.hash(runtimeType,index);

@override
String toString() {
  return 'EditorEvent.layerVisibilityToggled(index: $index)';
}


}

/// @nodoc
abstract mixin class $LayerVisibilityToggledCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $LayerVisibilityToggledCopyWith(LayerVisibilityToggled value, $Res Function(LayerVisibilityToggled) _then) = _$LayerVisibilityToggledCopyWithImpl;
@useResult
$Res call({
 int index
});




}
/// @nodoc
class _$LayerVisibilityToggledCopyWithImpl<$Res>
    implements $LayerVisibilityToggledCopyWith<$Res> {
  _$LayerVisibilityToggledCopyWithImpl(this._self, this._then);

  final LayerVisibilityToggled _self;
  final $Res Function(LayerVisibilityToggled) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? index = null,}) {
  return _then(LayerVisibilityToggled(
null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class LayerMoved implements EditorEvent {
  const LayerMoved(this.index, this.direction);
  

 final  int index;
 final  int direction;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LayerMovedCopyWith<LayerMoved> get copyWith => _$LayerMovedCopyWithImpl<LayerMoved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LayerMoved&&(identical(other.index, index) || other.index == index)&&(identical(other.direction, direction) || other.direction == direction));
}


@override
int get hashCode => Object.hash(runtimeType,index,direction);

@override
String toString() {
  return 'EditorEvent.layerMoved(index: $index, direction: $direction)';
}


}

/// @nodoc
abstract mixin class $LayerMovedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $LayerMovedCopyWith(LayerMoved value, $Res Function(LayerMoved) _then) = _$LayerMovedCopyWithImpl;
@useResult
$Res call({
 int index, int direction
});




}
/// @nodoc
class _$LayerMovedCopyWithImpl<$Res>
    implements $LayerMovedCopyWith<$Res> {
  _$LayerMovedCopyWithImpl(this._self, this._then);

  final LayerMoved _self;
  final $Res Function(LayerMoved) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? index = null,Object? direction = null,}) {
  return _then(LayerMoved(
null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class LayerActivated implements EditorEvent {
  const LayerActivated(this.index);
  

 final  int index;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LayerActivatedCopyWith<LayerActivated> get copyWith => _$LayerActivatedCopyWithImpl<LayerActivated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LayerActivated&&(identical(other.index, index) || other.index == index));
}


@override
int get hashCode => Object.hash(runtimeType,index);

@override
String toString() {
  return 'EditorEvent.layerActivated(index: $index)';
}


}

/// @nodoc
abstract mixin class $LayerActivatedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $LayerActivatedCopyWith(LayerActivated value, $Res Function(LayerActivated) _then) = _$LayerActivatedCopyWithImpl;
@useResult
$Res call({
 int index
});




}
/// @nodoc
class _$LayerActivatedCopyWithImpl<$Res>
    implements $LayerActivatedCopyWith<$Res> {
  _$LayerActivatedCopyWithImpl(this._self, this._then);

  final LayerActivated _self;
  final $Res Function(LayerActivated) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? index = null,}) {
  return _then(LayerActivated(
null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class DrawingRenamed implements EditorEvent {
  const DrawingRenamed(this.name);
  

 final  String name;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DrawingRenamedCopyWith<DrawingRenamed> get copyWith => _$DrawingRenamedCopyWithImpl<DrawingRenamed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DrawingRenamed&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'EditorEvent.drawingRenamed(name: $name)';
}


}

/// @nodoc
abstract mixin class $DrawingRenamedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $DrawingRenamedCopyWith(DrawingRenamed value, $Res Function(DrawingRenamed) _then) = _$DrawingRenamedCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class _$DrawingRenamedCopyWithImpl<$Res>
    implements $DrawingRenamedCopyWith<$Res> {
  _$DrawingRenamedCopyWithImpl(this._self, this._then);

  final DrawingRenamed _self;
  final $Res Function(DrawingRenamed) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(DrawingRenamed(
null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class CanvasResized implements EditorEvent {
  const CanvasResized(this.width, this.height);
  

 final  double width;
 final  double height;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CanvasResizedCopyWith<CanvasResized> get copyWith => _$CanvasResizedCopyWithImpl<CanvasResized>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CanvasResized&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}


@override
int get hashCode => Object.hash(runtimeType,width,height);

@override
String toString() {
  return 'EditorEvent.canvasResized(width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class $CanvasResizedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $CanvasResizedCopyWith(CanvasResized value, $Res Function(CanvasResized) _then) = _$CanvasResizedCopyWithImpl;
@useResult
$Res call({
 double width, double height
});




}
/// @nodoc
class _$CanvasResizedCopyWithImpl<$Res>
    implements $CanvasResizedCopyWith<$Res> {
  _$CanvasResizedCopyWithImpl(this._self, this._then);

  final CanvasResized _self;
  final $Res Function(CanvasResized) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? width = null,Object? height = null,}) {
  return _then(CanvasResized(
null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class DocumentSaved implements EditorEvent {
  const DocumentSaved(this.path);
  

 final  String path;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentSavedCopyWith<DocumentSaved> get copyWith => _$DocumentSavedCopyWithImpl<DocumentSaved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentSaved&&(identical(other.path, path) || other.path == path));
}


@override
int get hashCode => Object.hash(runtimeType,path);

@override
String toString() {
  return 'EditorEvent.documentSaved(path: $path)';
}


}

/// @nodoc
abstract mixin class $DocumentSavedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $DocumentSavedCopyWith(DocumentSaved value, $Res Function(DocumentSaved) _then) = _$DocumentSavedCopyWithImpl;
@useResult
$Res call({
 String path
});




}
/// @nodoc
class _$DocumentSavedCopyWithImpl<$Res>
    implements $DocumentSavedCopyWith<$Res> {
  _$DocumentSavedCopyWithImpl(this._self, this._then);

  final DocumentSaved _self;
  final $Res Function(DocumentSaved) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? path = null,}) {
  return _then(DocumentSaved(
null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ReferenceLoaded implements EditorEvent {
  const ReferenceLoaded(this.bytes);
  

 final  Uint8List bytes;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReferenceLoadedCopyWith<ReferenceLoaded> get copyWith => _$ReferenceLoadedCopyWithImpl<ReferenceLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReferenceLoaded&&const DeepCollectionEquality().equals(other.bytes, bytes));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(bytes));

@override
String toString() {
  return 'EditorEvent.referenceLoaded(bytes: $bytes)';
}


}

/// @nodoc
abstract mixin class $ReferenceLoadedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $ReferenceLoadedCopyWith(ReferenceLoaded value, $Res Function(ReferenceLoaded) _then) = _$ReferenceLoadedCopyWithImpl;
@useResult
$Res call({
 Uint8List bytes
});




}
/// @nodoc
class _$ReferenceLoadedCopyWithImpl<$Res>
    implements $ReferenceLoadedCopyWith<$Res> {
  _$ReferenceLoadedCopyWithImpl(this._self, this._then);

  final ReferenceLoaded _self;
  final $Res Function(ReferenceLoaded) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? bytes = null,}) {
  return _then(ReferenceLoaded(
null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as Uint8List,
  ));
}


}

/// @nodoc


class ReferenceRemoved implements EditorEvent {
  const ReferenceRemoved();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReferenceRemoved);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditorEvent.referenceRemoved()';
}


}




/// @nodoc


class ReferenceFitted implements EditorEvent {
  const ReferenceFitted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReferenceFitted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditorEvent.referenceFitted()';
}


}




/// @nodoc


class ReferenceVisibilityChanged implements EditorEvent {
  const ReferenceVisibilityChanged(this.visible);
  

 final  bool visible;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReferenceVisibilityChangedCopyWith<ReferenceVisibilityChanged> get copyWith => _$ReferenceVisibilityChangedCopyWithImpl<ReferenceVisibilityChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReferenceVisibilityChanged&&(identical(other.visible, visible) || other.visible == visible));
}


@override
int get hashCode => Object.hash(runtimeType,visible);

@override
String toString() {
  return 'EditorEvent.referenceVisibilityChanged(visible: $visible)';
}


}

/// @nodoc
abstract mixin class $ReferenceVisibilityChangedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $ReferenceVisibilityChangedCopyWith(ReferenceVisibilityChanged value, $Res Function(ReferenceVisibilityChanged) _then) = _$ReferenceVisibilityChangedCopyWithImpl;
@useResult
$Res call({
 bool visible
});




}
/// @nodoc
class _$ReferenceVisibilityChangedCopyWithImpl<$Res>
    implements $ReferenceVisibilityChangedCopyWith<$Res> {
  _$ReferenceVisibilityChangedCopyWithImpl(this._self, this._then);

  final ReferenceVisibilityChanged _self;
  final $Res Function(ReferenceVisibilityChanged) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? visible = null,}) {
  return _then(ReferenceVisibilityChanged(
null == visible ? _self.visible : visible // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class ReferenceOpacityChanged implements EditorEvent {
  const ReferenceOpacityChanged(this.opacity);
  

 final  double opacity;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReferenceOpacityChangedCopyWith<ReferenceOpacityChanged> get copyWith => _$ReferenceOpacityChangedCopyWithImpl<ReferenceOpacityChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReferenceOpacityChanged&&(identical(other.opacity, opacity) || other.opacity == opacity));
}


@override
int get hashCode => Object.hash(runtimeType,opacity);

@override
String toString() {
  return 'EditorEvent.referenceOpacityChanged(opacity: $opacity)';
}


}

/// @nodoc
abstract mixin class $ReferenceOpacityChangedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $ReferenceOpacityChangedCopyWith(ReferenceOpacityChanged value, $Res Function(ReferenceOpacityChanged) _then) = _$ReferenceOpacityChangedCopyWithImpl;
@useResult
$Res call({
 double opacity
});




}
/// @nodoc
class _$ReferenceOpacityChangedCopyWithImpl<$Res>
    implements $ReferenceOpacityChangedCopyWith<$Res> {
  _$ReferenceOpacityChangedCopyWithImpl(this._self, this._then);

  final ReferenceOpacityChanged _self;
  final $Res Function(ReferenceOpacityChanged) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? opacity = null,}) {
  return _then(ReferenceOpacityChanged(
null == opacity ? _self.opacity : opacity // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class ReferenceScaleChanged implements EditorEvent {
  const ReferenceScaleChanged(this.scale);
  

 final  double scale;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReferenceScaleChangedCopyWith<ReferenceScaleChanged> get copyWith => _$ReferenceScaleChangedCopyWithImpl<ReferenceScaleChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReferenceScaleChanged&&(identical(other.scale, scale) || other.scale == scale));
}


@override
int get hashCode => Object.hash(runtimeType,scale);

@override
String toString() {
  return 'EditorEvent.referenceScaleChanged(scale: $scale)';
}


}

/// @nodoc
abstract mixin class $ReferenceScaleChangedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $ReferenceScaleChangedCopyWith(ReferenceScaleChanged value, $Res Function(ReferenceScaleChanged) _then) = _$ReferenceScaleChangedCopyWithImpl;
@useResult
$Res call({
 double scale
});




}
/// @nodoc
class _$ReferenceScaleChangedCopyWithImpl<$Res>
    implements $ReferenceScaleChangedCopyWith<$Res> {
  _$ReferenceScaleChangedCopyWithImpl(this._self, this._then);

  final ReferenceScaleChanged _self;
  final $Res Function(ReferenceScaleChanged) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? scale = null,}) {
  return _then(ReferenceScaleChanged(
null == scale ? _self.scale : scale // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class ReferenceSyncRequested implements EditorEvent {
  const ReferenceSyncRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReferenceSyncRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditorEvent.referenceSyncRequested()';
}


}




/// @nodoc
mixin _$EditorState {

 String get tabId;/// The document as it is right now (may be ahead of [history] mid-drag).
 Drawing get drawing; EditHistory get history;/// The .flp this project is saved to, or null for a project never saved.
 String? get filePath;/// Whether the user already agreed to overwrite [filePath] this session.
 bool get overwriteConfirmed;/// Bumped on every recorded change; the workspace watches it to write drafts.
 int get revision; Tool get tool; int get layerIndex; int? get selected;/// The shape being drawn right now, plus the rubber-band point for polygons.
 Shape? get draft; Offset? get hover;/// Last pointer position in design units, for the status bar.
 Offset? get cursor; StyleSettings get style; ViewSettings get view; GestureState get gesture;/// The decoded background image and the id of the pixels it came from.
 Image? get refImage; String? get refImageId;
/// Create a copy of EditorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditorStateCopyWith<EditorState> get copyWith => _$EditorStateCopyWithImpl<EditorState>(this as EditorState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditorState&&(identical(other.tabId, tabId) || other.tabId == tabId)&&(identical(other.drawing, drawing) || other.drawing == drawing)&&(identical(other.history, history) || other.history == history)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.overwriteConfirmed, overwriteConfirmed) || other.overwriteConfirmed == overwriteConfirmed)&&(identical(other.revision, revision) || other.revision == revision)&&(identical(other.tool, tool) || other.tool == tool)&&(identical(other.layerIndex, layerIndex) || other.layerIndex == layerIndex)&&(identical(other.selected, selected) || other.selected == selected)&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.hover, hover) || other.hover == hover)&&(identical(other.cursor, cursor) || other.cursor == cursor)&&(identical(other.style, style) || other.style == style)&&(identical(other.view, view) || other.view == view)&&(identical(other.gesture, gesture) || other.gesture == gesture)&&(identical(other.refImage, refImage) || other.refImage == refImage)&&(identical(other.refImageId, refImageId) || other.refImageId == refImageId));
}


@override
int get hashCode => Object.hash(runtimeType,tabId,drawing,history,filePath,overwriteConfirmed,revision,tool,layerIndex,selected,draft,hover,cursor,style,view,gesture,refImage,refImageId);

@override
String toString() {
  return 'EditorState(tabId: $tabId, drawing: $drawing, history: $history, filePath: $filePath, overwriteConfirmed: $overwriteConfirmed, revision: $revision, tool: $tool, layerIndex: $layerIndex, selected: $selected, draft: $draft, hover: $hover, cursor: $cursor, style: $style, view: $view, gesture: $gesture, refImage: $refImage, refImageId: $refImageId)';
}


}

/// @nodoc
abstract mixin class $EditorStateCopyWith<$Res>  {
  factory $EditorStateCopyWith(EditorState value, $Res Function(EditorState) _then) = _$EditorStateCopyWithImpl;
@useResult
$Res call({
 String tabId, Drawing drawing, EditHistory history, String? filePath, bool overwriteConfirmed, int revision, Tool tool, int layerIndex, int? selected, Shape? draft, Offset? hover, Offset? cursor, StyleSettings style, ViewSettings view, GestureState gesture, Image? refImage, String? refImageId
});


$DrawingCopyWith<$Res> get drawing;$EditHistoryCopyWith<$Res> get history;$ShapeCopyWith<$Res>? get draft;$StyleSettingsCopyWith<$Res> get style;$ViewSettingsCopyWith<$Res> get view;$GestureStateCopyWith<$Res> get gesture;

}
/// @nodoc
class _$EditorStateCopyWithImpl<$Res>
    implements $EditorStateCopyWith<$Res> {
  _$EditorStateCopyWithImpl(this._self, this._then);

  final EditorState _self;
  final $Res Function(EditorState) _then;

/// Create a copy of EditorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tabId = null,Object? drawing = null,Object? history = null,Object? filePath = freezed,Object? overwriteConfirmed = null,Object? revision = null,Object? tool = null,Object? layerIndex = null,Object? selected = freezed,Object? draft = freezed,Object? hover = freezed,Object? cursor = freezed,Object? style = null,Object? view = null,Object? gesture = null,Object? refImage = freezed,Object? refImageId = freezed,}) {
  return _then(_self.copyWith(
tabId: null == tabId ? _self.tabId : tabId // ignore: cast_nullable_to_non_nullable
as String,drawing: null == drawing ? _self.drawing : drawing // ignore: cast_nullable_to_non_nullable
as Drawing,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as EditHistory,filePath: freezed == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String?,overwriteConfirmed: null == overwriteConfirmed ? _self.overwriteConfirmed : overwriteConfirmed // ignore: cast_nullable_to_non_nullable
as bool,revision: null == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int,tool: null == tool ? _self.tool : tool // ignore: cast_nullable_to_non_nullable
as Tool,layerIndex: null == layerIndex ? _self.layerIndex : layerIndex // ignore: cast_nullable_to_non_nullable
as int,selected: freezed == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as int?,draft: freezed == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as Shape?,hover: freezed == hover ? _self.hover : hover // ignore: cast_nullable_to_non_nullable
as Offset?,cursor: freezed == cursor ? _self.cursor : cursor // ignore: cast_nullable_to_non_nullable
as Offset?,style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as StyleSettings,view: null == view ? _self.view : view // ignore: cast_nullable_to_non_nullable
as ViewSettings,gesture: null == gesture ? _self.gesture : gesture // ignore: cast_nullable_to_non_nullable
as GestureState,refImage: freezed == refImage ? _self.refImage : refImage // ignore: cast_nullable_to_non_nullable
as Image?,refImageId: freezed == refImageId ? _self.refImageId : refImageId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of EditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DrawingCopyWith<$Res> get drawing {
  
  return $DrawingCopyWith<$Res>(_self.drawing, (value) {
    return _then(_self.copyWith(drawing: value));
  });
}/// Create a copy of EditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EditHistoryCopyWith<$Res> get history {
  
  return $EditHistoryCopyWith<$Res>(_self.history, (value) {
    return _then(_self.copyWith(history: value));
  });
}/// Create a copy of EditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShapeCopyWith<$Res>? get draft {
    if (_self.draft == null) {
    return null;
  }

  return $ShapeCopyWith<$Res>(_self.draft!, (value) {
    return _then(_self.copyWith(draft: value));
  });
}/// Create a copy of EditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StyleSettingsCopyWith<$Res> get style {
  
  return $StyleSettingsCopyWith<$Res>(_self.style, (value) {
    return _then(_self.copyWith(style: value));
  });
}/// Create a copy of EditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ViewSettingsCopyWith<$Res> get view {
  
  return $ViewSettingsCopyWith<$Res>(_self.view, (value) {
    return _then(_self.copyWith(view: value));
  });
}/// Create a copy of EditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GestureStateCopyWith<$Res> get gesture {
  
  return $GestureStateCopyWith<$Res>(_self.gesture, (value) {
    return _then(_self.copyWith(gesture: value));
  });
}
}


/// Adds pattern-matching-related methods to [EditorState].
extension EditorStatePatterns on EditorState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EditorState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditorState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EditorState value)  $default,){
final _that = this;
switch (_that) {
case _EditorState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EditorState value)?  $default,){
final _that = this;
switch (_that) {
case _EditorState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String tabId,  Drawing drawing,  EditHistory history,  String? filePath,  bool overwriteConfirmed,  int revision,  Tool tool,  int layerIndex,  int? selected,  Shape? draft,  Offset? hover,  Offset? cursor,  StyleSettings style,  ViewSettings view,  GestureState gesture,  Image? refImage,  String? refImageId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditorState() when $default != null:
return $default(_that.tabId,_that.drawing,_that.history,_that.filePath,_that.overwriteConfirmed,_that.revision,_that.tool,_that.layerIndex,_that.selected,_that.draft,_that.hover,_that.cursor,_that.style,_that.view,_that.gesture,_that.refImage,_that.refImageId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String tabId,  Drawing drawing,  EditHistory history,  String? filePath,  bool overwriteConfirmed,  int revision,  Tool tool,  int layerIndex,  int? selected,  Shape? draft,  Offset? hover,  Offset? cursor,  StyleSettings style,  ViewSettings view,  GestureState gesture,  Image? refImage,  String? refImageId)  $default,) {final _that = this;
switch (_that) {
case _EditorState():
return $default(_that.tabId,_that.drawing,_that.history,_that.filePath,_that.overwriteConfirmed,_that.revision,_that.tool,_that.layerIndex,_that.selected,_that.draft,_that.hover,_that.cursor,_that.style,_that.view,_that.gesture,_that.refImage,_that.refImageId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String tabId,  Drawing drawing,  EditHistory history,  String? filePath,  bool overwriteConfirmed,  int revision,  Tool tool,  int layerIndex,  int? selected,  Shape? draft,  Offset? hover,  Offset? cursor,  StyleSettings style,  ViewSettings view,  GestureState gesture,  Image? refImage,  String? refImageId)?  $default,) {final _that = this;
switch (_that) {
case _EditorState() when $default != null:
return $default(_that.tabId,_that.drawing,_that.history,_that.filePath,_that.overwriteConfirmed,_that.revision,_that.tool,_that.layerIndex,_that.selected,_that.draft,_that.hover,_that.cursor,_that.style,_that.view,_that.gesture,_that.refImage,_that.refImageId);case _:
  return null;

}
}

}

/// @nodoc


class _EditorState extends EditorState {
  const _EditorState({required this.tabId, required this.drawing, required this.history, this.filePath, this.overwriteConfirmed = false, this.revision = 0, this.tool = Tool.select, this.layerIndex = 0, this.selected, this.draft, this.hover, this.cursor, this.style = const StyleSettings(), this.view = const ViewSettings(), this.gesture = const GestureState(), this.refImage, this.refImageId}): super._();
  

@override final  String tabId;
/// The document as it is right now (may be ahead of [history] mid-drag).
@override final  Drawing drawing;
@override final  EditHistory history;
/// The .flp this project is saved to, or null for a project never saved.
@override final  String? filePath;
/// Whether the user already agreed to overwrite [filePath] this session.
@override@JsonKey() final  bool overwriteConfirmed;
/// Bumped on every recorded change; the workspace watches it to write drafts.
@override@JsonKey() final  int revision;
@override@JsonKey() final  Tool tool;
@override@JsonKey() final  int layerIndex;
@override final  int? selected;
/// The shape being drawn right now, plus the rubber-band point for polygons.
@override final  Shape? draft;
@override final  Offset? hover;
/// Last pointer position in design units, for the status bar.
@override final  Offset? cursor;
@override@JsonKey() final  StyleSettings style;
@override@JsonKey() final  ViewSettings view;
@override@JsonKey() final  GestureState gesture;
/// The decoded background image and the id of the pixels it came from.
@override final  Image? refImage;
@override final  String? refImageId;

/// Create a copy of EditorState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditorStateCopyWith<_EditorState> get copyWith => __$EditorStateCopyWithImpl<_EditorState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditorState&&(identical(other.tabId, tabId) || other.tabId == tabId)&&(identical(other.drawing, drawing) || other.drawing == drawing)&&(identical(other.history, history) || other.history == history)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.overwriteConfirmed, overwriteConfirmed) || other.overwriteConfirmed == overwriteConfirmed)&&(identical(other.revision, revision) || other.revision == revision)&&(identical(other.tool, tool) || other.tool == tool)&&(identical(other.layerIndex, layerIndex) || other.layerIndex == layerIndex)&&(identical(other.selected, selected) || other.selected == selected)&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.hover, hover) || other.hover == hover)&&(identical(other.cursor, cursor) || other.cursor == cursor)&&(identical(other.style, style) || other.style == style)&&(identical(other.view, view) || other.view == view)&&(identical(other.gesture, gesture) || other.gesture == gesture)&&(identical(other.refImage, refImage) || other.refImage == refImage)&&(identical(other.refImageId, refImageId) || other.refImageId == refImageId));
}


@override
int get hashCode => Object.hash(runtimeType,tabId,drawing,history,filePath,overwriteConfirmed,revision,tool,layerIndex,selected,draft,hover,cursor,style,view,gesture,refImage,refImageId);

@override
String toString() {
  return 'EditorState(tabId: $tabId, drawing: $drawing, history: $history, filePath: $filePath, overwriteConfirmed: $overwriteConfirmed, revision: $revision, tool: $tool, layerIndex: $layerIndex, selected: $selected, draft: $draft, hover: $hover, cursor: $cursor, style: $style, view: $view, gesture: $gesture, refImage: $refImage, refImageId: $refImageId)';
}


}

/// @nodoc
abstract mixin class _$EditorStateCopyWith<$Res> implements $EditorStateCopyWith<$Res> {
  factory _$EditorStateCopyWith(_EditorState value, $Res Function(_EditorState) _then) = __$EditorStateCopyWithImpl;
@override @useResult
$Res call({
 String tabId, Drawing drawing, EditHistory history, String? filePath, bool overwriteConfirmed, int revision, Tool tool, int layerIndex, int? selected, Shape? draft, Offset? hover, Offset? cursor, StyleSettings style, ViewSettings view, GestureState gesture, Image? refImage, String? refImageId
});


@override $DrawingCopyWith<$Res> get drawing;@override $EditHistoryCopyWith<$Res> get history;@override $ShapeCopyWith<$Res>? get draft;@override $StyleSettingsCopyWith<$Res> get style;@override $ViewSettingsCopyWith<$Res> get view;@override $GestureStateCopyWith<$Res> get gesture;

}
/// @nodoc
class __$EditorStateCopyWithImpl<$Res>
    implements _$EditorStateCopyWith<$Res> {
  __$EditorStateCopyWithImpl(this._self, this._then);

  final _EditorState _self;
  final $Res Function(_EditorState) _then;

/// Create a copy of EditorState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tabId = null,Object? drawing = null,Object? history = null,Object? filePath = freezed,Object? overwriteConfirmed = null,Object? revision = null,Object? tool = null,Object? layerIndex = null,Object? selected = freezed,Object? draft = freezed,Object? hover = freezed,Object? cursor = freezed,Object? style = null,Object? view = null,Object? gesture = null,Object? refImage = freezed,Object? refImageId = freezed,}) {
  return _then(_EditorState(
tabId: null == tabId ? _self.tabId : tabId // ignore: cast_nullable_to_non_nullable
as String,drawing: null == drawing ? _self.drawing : drawing // ignore: cast_nullable_to_non_nullable
as Drawing,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as EditHistory,filePath: freezed == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String?,overwriteConfirmed: null == overwriteConfirmed ? _self.overwriteConfirmed : overwriteConfirmed // ignore: cast_nullable_to_non_nullable
as bool,revision: null == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int,tool: null == tool ? _self.tool : tool // ignore: cast_nullable_to_non_nullable
as Tool,layerIndex: null == layerIndex ? _self.layerIndex : layerIndex // ignore: cast_nullable_to_non_nullable
as int,selected: freezed == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as int?,draft: freezed == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as Shape?,hover: freezed == hover ? _self.hover : hover // ignore: cast_nullable_to_non_nullable
as Offset?,cursor: freezed == cursor ? _self.cursor : cursor // ignore: cast_nullable_to_non_nullable
as Offset?,style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as StyleSettings,view: null == view ? _self.view : view // ignore: cast_nullable_to_non_nullable
as ViewSettings,gesture: null == gesture ? _self.gesture : gesture // ignore: cast_nullable_to_non_nullable
as GestureState,refImage: freezed == refImage ? _self.refImage : refImage // ignore: cast_nullable_to_non_nullable
as Image?,refImageId: freezed == refImageId ? _self.refImageId : refImageId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of EditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DrawingCopyWith<$Res> get drawing {
  
  return $DrawingCopyWith<$Res>(_self.drawing, (value) {
    return _then(_self.copyWith(drawing: value));
  });
}/// Create a copy of EditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EditHistoryCopyWith<$Res> get history {
  
  return $EditHistoryCopyWith<$Res>(_self.history, (value) {
    return _then(_self.copyWith(history: value));
  });
}/// Create a copy of EditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShapeCopyWith<$Res>? get draft {
    if (_self.draft == null) {
    return null;
  }

  return $ShapeCopyWith<$Res>(_self.draft!, (value) {
    return _then(_self.copyWith(draft: value));
  });
}/// Create a copy of EditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StyleSettingsCopyWith<$Res> get style {
  
  return $StyleSettingsCopyWith<$Res>(_self.style, (value) {
    return _then(_self.copyWith(style: value));
  });
}/// Create a copy of EditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ViewSettingsCopyWith<$Res> get view {
  
  return $ViewSettingsCopyWith<$Res>(_self.view, (value) {
    return _then(_self.copyWith(view: value));
  });
}/// Create a copy of EditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GestureStateCopyWith<$Res> get gesture {
  
  return $GestureStateCopyWith<$Res>(_self.gesture, (value) {
    return _then(_self.copyWith(gesture: value));
  });
}
}

// dart format on
