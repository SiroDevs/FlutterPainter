part of 'editor_bloc.dart';

class ShapeDeleted extends EditorEvent {
  const ShapeDeleted();
}

class ShapeDuplicated extends EditorEvent {
  const ShapeDuplicated();
}

class SelectAllRequested extends EditorEvent {
  const SelectAllRequested();
}

class ShapesGrouped extends EditorEvent {
  const ShapesGrouped();
}

class ShapesUngrouped extends EditorEvent {
  const ShapesUngrouped();
}

class VertexPointDeleted extends EditorEvent {
  const VertexPointDeleted(this.index);

  final int index;
}

class VertexSegmentSplit extends EditorEvent {
  const VertexSegmentSplit(this.index);

  final int index;
}

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

class ShapeSelectionRequested extends EditorEvent {
  const ShapeSelectionRequested(this.layer, this.index);

  final int layer;
  final int index;
}

class ClosedToggled extends EditorEvent {
  const ClosedToggled(this.closed);

  final bool closed;
}
