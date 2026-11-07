part of 'editor_bloc.dart';

/// Events sent to the editor bloc.
sealed class EditorEvent {
  const EditorEvent();
}

class PointerPressed extends EditorEvent {
  const PointerPressed(
    this.point, {
    this.shift = false,
    this.alt = false,
    this.timeMs = 0,
  });

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
