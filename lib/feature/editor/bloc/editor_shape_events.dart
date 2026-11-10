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

class SelectionScaled extends EditorEvent {
  const SelectionScaled(this.factor);

  final double factor;
}

class SelectionFlipped extends EditorEvent {
  const SelectionFlipped({required this.horizontal});

  final bool horizontal;
}

class GroupRenamed extends EditorEvent {
  const GroupRenamed(this.layer, this.groupId, this.name);

  final int layer;
  final String groupId;
  final String name;
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
  const ShapeReordered(this.direction, {this.toExtreme = false});

  final int direction;
  final bool toExtreme;
}

class ShapeMovedToLayer extends EditorEvent {
  const ShapeMovedToLayer(this.layer);

  final int layer;
}

class ShapeRenamed extends EditorEvent {
  const ShapeRenamed(this.name, {this.layer, this.index});

  final String name;
  final int? layer;
  final int? index;
}

class ShapeSelectionRequested extends EditorEvent {
  const ShapeSelectionRequested(
    this.layer,
    this.index, {
    this.includeGroup = true,
  });

  final int layer;
  final int index;
  final bool includeGroup;
}

class ShapeVisibilityToggled extends EditorEvent {
  const ShapeVisibilityToggled(
    this.layer,
    this.index, {
    this.includeGroup = false,
  });

  final int layer;
  final int index;
  final bool includeGroup;
}

class ClosedToggled extends EditorEvent {
  const ClosedToggled(this.closed);

  final bool closed;
}
