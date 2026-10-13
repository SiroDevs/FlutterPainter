part of 'editor_bloc.dart';

/// Everything that can happen in one editor tab. Pointer events carry the
/// position in design units plus the modifier keys, so the widget stays a thin
/// forwarder and all behaviour lives in the bloc.
@freezed
sealed class EditorEvent with _$EditorEvent {
  // ---- pointer ----------------------------------------------------------
  const factory EditorEvent.pointerPressed(
    Offset point, {
    @Default(false) bool shift,
    @Default(false) bool alt,
    @Default(0) int timeMs,
  }) = PointerPressed;

  const factory EditorEvent.pointerMoved(
    Offset point, {
    @Default(false) bool shift,
  }) = PointerMoved;

  const factory EditorEvent.pointerReleased() = PointerReleased;

  const factory EditorEvent.pointerHovered(Offset point) = PointerHovered;

  // ---- view -------------------------------------------------------------
  const factory EditorEvent.viewPanned(Offset delta) = ViewPanned;

  const factory EditorEvent.viewZoomed(double factor, Offset focal) = ViewZoomed;

  const factory EditorEvent.viewportChanged(Size size) = ViewportChanged;

  const factory EditorEvent.fitRequested() = FitRequested;

  const factory EditorEvent.gridToggled() = GridToggled;

  const factory EditorEvent.snapToggled() = SnapToggled;

  const factory EditorEvent.backgroundCycled() = BackgroundCycled;

  // ---- tools and drafts -------------------------------------------------
  const factory EditorEvent.toolSelected(Tool tool) = ToolSelected;

  const factory EditorEvent.polygonFinished({
    @Default(true) bool closed,
  }) = PolygonFinished;

  const factory EditorEvent.draftCancelled() = DraftCancelled;

  // ---- history ----------------------------------------------------------
  const factory EditorEvent.undoRequested() = UndoRequested;

  const factory EditorEvent.redoRequested() = RedoRequested;

  /// Pushes the current drawing to the undo history (end of a slider drag).
  const factory EditorEvent.changesCommitted() = ChangesCommitted;

  // ---- style ------------------------------------------------------------
  const factory EditorEvent.styleTargetChanged(bool editFill) = StyleTargetChanged;

  const factory EditorEvent.colorPicked(int color) = ColorPicked;

  const factory EditorEvent.strokeColorPicked(int color) = StrokeColorPicked;

  const factory EditorEvent.fillToggled(bool on) = FillToggled;

  const factory EditorEvent.strokeToggled(bool on) = StrokeToggled;

  const factory EditorEvent.strokeWidthChanged(double width) = StrokeWidthChanged;

  const factory EditorEvent.radiusChanged(double radius) = RadiusChanged;

  // ---- selected shape ---------------------------------------------------
  const factory EditorEvent.shapeDeleted() = ShapeDeleted;

  const factory EditorEvent.shapeDuplicated() = ShapeDuplicated;

  /// [direction] +1 draws the shape later (in front), -1 earlier (behind).
  const factory EditorEvent.shapeReordered(int direction) = ShapeReordered;

  const factory EditorEvent.shapeMovedToLayer(int layer) = ShapeMovedToLayer;

  const factory EditorEvent.shapeRenamed(String name) = ShapeRenamed;

  const factory EditorEvent.closedToggled(bool closed) = ClosedToggled;

  // ---- layers -----------------------------------------------------------
  const factory EditorEvent.layerAdded() = LayerAdded;

  const factory EditorEvent.layerDeleted(int index) = LayerDeleted;

  const factory EditorEvent.layerRenamed(int index, String name) = LayerRenamed;

  const factory EditorEvent.layerVisibilityToggled(int index) =
      LayerVisibilityToggled;

  /// [direction] +1 moves the layer up (drawn later), -1 moves it down.
  const factory EditorEvent.layerMoved(int index, int direction) = LayerMoved;

  const factory EditorEvent.layerActivated(int index) = LayerActivated;

  // ---- document ---------------------------------------------------------
  const factory EditorEvent.drawingRenamed(String name) = DrawingRenamed;

  const factory EditorEvent.canvasResized(double width, double height) =
      CanvasResized;

  /// The project was written to [path]: remember it and mark the state clean.
  const factory EditorEvent.documentSaved(String path) = DocumentSaved;

  // ---- background image -------------------------------------------------
  const factory EditorEvent.referenceLoaded(Uint8List bytes) = ReferenceLoaded;

  const factory EditorEvent.referenceRemoved() = ReferenceRemoved;

  const factory EditorEvent.referenceFitted() = ReferenceFitted;

  const factory EditorEvent.referenceVisibilityChanged(bool visible) =
      ReferenceVisibilityChanged;

  const factory EditorEvent.referenceOpacityChanged(double opacity) =
      ReferenceOpacityChanged;

  const factory EditorEvent.referenceScaleChanged(double scale) =
      ReferenceScaleChanged;

  /// Decode the drawing's reference pixels if they are not decoded yet.
  const factory EditorEvent.referenceSyncRequested() = ReferenceSyncRequested;
}
