part of 'editor_bloc.dart';

/// Everything that can happen in one editor tab. Pointer events carry the
/// position in design units plus the modifier keys, so the widget stays a thin
/// forwarder and all behaviour lives in the bloc.
sealed class EditorEvent {
  const EditorEvent();
}

class PointerPressed extends EditorEvent {
  const PointerPressed(this.point, {this.shift = false, this.alt = false, this.timeMs = 0});

  final Offset point;
  final bool shift;
  final bool alt;
  final int timeMs;
}

class PointerMoved extends EditorEvent {
  const PointerMoved(this.point, {this.shift = false});

  final Offset point;
  final bool shift;
}

class PointerReleased extends EditorEvent {
  const PointerReleased();
}

class PointerHovered extends EditorEvent {
  const PointerHovered(this.point);

  final Offset point;
}

class ViewPanned extends EditorEvent {
  const ViewPanned(this.delta);

  final Offset delta;
}

class ViewZoomed extends EditorEvent {
  const ViewZoomed(this.factor, this.focal);

  final double factor;
  final Offset focal;
}

class ViewportChanged extends EditorEvent {
  const ViewportChanged(this.size);

  final Size size;
}

class FitRequested extends EditorEvent {
  const FitRequested();
}

class GridToggled extends EditorEvent {
  const GridToggled();
}

class SnapToggled extends EditorEvent {
  const SnapToggled();
}

class BackgroundCycled extends EditorEvent {
  const BackgroundCycled();
}

class ToolSelected extends EditorEvent {
  const ToolSelected(this.tool);

  final Tool tool;
}

class PolygonFinished extends EditorEvent {
  const PolygonFinished({this.closed = true});

  final bool closed;
}

class DraftCancelled extends EditorEvent {
  const DraftCancelled();
}

class UndoRequested extends EditorEvent {
  const UndoRequested();
}

class RedoRequested extends EditorEvent {
  const RedoRequested();
}

  /// Pushes the current drawing to the undo history (end of a slider drag).
class ChangesCommitted extends EditorEvent {
  const ChangesCommitted();
}

class StyleTargetChanged extends EditorEvent {
  const StyleTargetChanged(this.editFill);

  final bool editFill;
}

class ColorPicked extends EditorEvent {
  const ColorPicked(this.color);

  final int color;
}

class StrokeColorPicked extends EditorEvent {
  const StrokeColorPicked(this.color);

  final int color;
}

class FillToggled extends EditorEvent {
  const FillToggled(this.on);

  final bool on;
}

class StrokeToggled extends EditorEvent {
  const StrokeToggled(this.on);

  final bool on;
}

class StrokeWidthChanged extends EditorEvent {
  const StrokeWidthChanged(this.width);

  final double width;
}

class RadiusChanged extends EditorEvent {
  const RadiusChanged(this.radius);

  final double radius;
}

class ShapeDeleted extends EditorEvent {
  const ShapeDeleted();
}

class ShapeDuplicated extends EditorEvent {
  const ShapeDuplicated();
}

  /// [direction] +1 draws the shape later (in front), -1 earlier (behind).
class ShapeReordered extends EditorEvent {
  const ShapeReordered(this.direction);

  final int direction;
}

class ShapeMovedToLayer extends EditorEvent {
  const ShapeMovedToLayer(this.layer);

  final int layer;
}

class ShapeRenamed extends EditorEvent {
  const ShapeRenamed(this.name);

  final String name;
}

class ClosedToggled extends EditorEvent {
  const ClosedToggled(this.closed);

  final bool closed;
}

class LayerAdded extends EditorEvent {
  const LayerAdded();
}

class LayerDeleted extends EditorEvent {
  const LayerDeleted(this.index);

  final int index;
}

class LayerRenamed extends EditorEvent {
  const LayerRenamed(this.index, this.name);

  final int index;
  final String name;
}

class LayerVisibilityToggled extends EditorEvent {
  const LayerVisibilityToggled(this.index);

  final int index;
}

  /// [direction] +1 moves the layer up (drawn later), -1 moves it down.
class LayerMoved extends EditorEvent {
  const LayerMoved(this.index, this.direction);

  final int index;
  final int direction;
}

class LayerActivated extends EditorEvent {
  const LayerActivated(this.index);

  final int index;
}

class DrawingRenamed extends EditorEvent {
  const DrawingRenamed(this.name);

  final String name;
}

class CanvasResized extends EditorEvent {
  const CanvasResized(this.width, this.height);

  final double width;
  final double height;
}

  /// The project was written to [path]: remember it and mark the state clean.
class DocumentSaved extends EditorEvent {
  const DocumentSaved(this.path);

  final String path;
}

class ReferenceLoaded extends EditorEvent {
  const ReferenceLoaded(this.bytes);

  final Uint8List bytes;
}

class ReferenceRemoved extends EditorEvent {
  const ReferenceRemoved();
}

class ReferenceFitted extends EditorEvent {
  const ReferenceFitted();
}

class ReferenceVisibilityChanged extends EditorEvent {
  const ReferenceVisibilityChanged(this.visible);

  final bool visible;
}

class ReferenceOpacityChanged extends EditorEvent {
  const ReferenceOpacityChanged(this.opacity);

  final double opacity;
}

class ReferenceScaleChanged extends EditorEvent {
  const ReferenceScaleChanged(this.scale);

  final double scale;
}

  /// Decode the drawing's reference pixels if they are not decoded yet.
class ReferenceSyncRequested extends EditorEvent {
  const ReferenceSyncRequested();
}
