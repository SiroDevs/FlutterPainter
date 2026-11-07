// Dart imports:
import 'dart:ui';

// Project imports:
import '../../../../domain/models/drawing/drawing.dart';
import '../../../../domain/models/drawing/paint_layer.dart';
import '../../../../domain/models/drawing/reference_image.dart';
import '../../../../domain/models/shapes/shape.dart';
import '../../../../domain/models/editor/tool.dart';
import '../../../../domain/services/geometry/geometry_utils.dart';
import '../../bloc/editor_bloc.dart';
import '../../models/gesture_state.dart';

/// Value of [EditorState.selected] that means "the active layer's picture".
const int kImageSlot = -1;

/// A copy of [list] with the item at [index] replaced.
List<T> replacedAt<T>(List<T> list, int index, T value) => [
  ...list.sublist(0, index),
  value,
  ...list.sublist(index + 1),
];

/// A copy of [list] without the item at [index].
List<T> removedAt<T>(List<T> list, int index) => [
  ...list.sublist(0, index),
  ...list.sublist(index + 1),
];

/// Returns the shape indices that belong to [index]'s group.
List<int> groupedShapeIndices(List<Shape> shapes, int index) {
  final groupId = shapes[index].groupId;
  if (groupId == null) return [index];
  return [
    for (var shapeIndex = 0; shapeIndex < shapes.length; shapeIndex++)
      if (shapes[shapeIndex].groupId == groupId) shapeIndex,
  ];
}

/// Small helpers shared by every logic class.
extension EditorStateOps on EditorState {
  PaintLayer get layer => drawing.layers[layerIndex];

  Shape? get selectedShape {
    final index = selected;
    if (index == null || index < 0) return null;
    final shapes = layer.shapes;
    return index < shapes.length ? shapes[index] : null;
  }

  List<int> get validSelectedIndices => [
    for (final i in selectedIndices)
      if (i >= 0 && i < layer.shapes.length) i,
  ];

  List<Shape> get selectedShapes => [
    for (final i in validSelectedIndices) layer.shapes[i],
  ];

  Rect? get selectedBounds {
    final shapes = selectedShapes;
    if (shapes.isEmpty) return null;
    var bounds = shapes.first.bounds;
    for (final shape in shapes.skip(1)) {
      bounds = bounds.expandToInclude(shape.bounds);
    }
    return bounds;
  }

  EditorState selectIndices(List<int> indices, {int? primary}) {
    final sorted = indices.toSet().toList()..sort();
    final valid = [
      for (final i in sorted)
        if (i >= 0 && i < layer.shapes.length) i,
    ];
    final chosen = primary != null && valid.contains(primary)
        ? primary
        : valid.isEmpty
        ? null
        : valid.last;
    return copyWith(selected: chosen, selectedIndices: valid);
  }

  /// The picture on the active layer, if any.
  ReferenceImage? get activeImage => layer.image;

  /// Where the active layer's picture sits, in design units. Null when the
  /// layer has no picture or its pixels are not decoded yet.
  Rect? get imageBounds {
    final reference = layer.image;
    if (reference == null) return null;
    final pixels = images[reference.id];
    if (pixels == null) return null;
    return Rect.fromLTWH(
      reference.x,
      reference.y,
      pixels.width * reference.scaleX,
      pixels.height * reference.scaleY,
    );
  }

  /// True when the active layer's picture is the selection.
  bool get imageSelected => selected == kImageSlot && layer.image != null;

  /// The picture gets resize handles when it is selected, or while the
  /// "Move / resize layer image" tool is active.
  bool get showImageHandles =>
      layer.image != null && (imageSelected || tool == Tool.reference);

  /// Replaces (or with null removes) the active layer's picture, with no
  /// history entry.
  EditorState withImage(ReferenceImage? image) => withLayers(
    replacedAt(drawing.layers, layerIndex, layer.copyWith(image: image)),
  );

  /// Rounds a point to the snap grid when snapping is on.
  Offset snapped(Offset point) =>
      snapPoint(point, enabled: view.snap, zoom: view.zoom);

  /// Ends the current pointer gesture but keeps the last-click time, so a
  /// double-click is still recognised on the next press.
  EditorState endGesture() => copyWith(
    gesture: gesture.copyWith(
      mode: GestureMode.none,
      handle: -1,
      startPoints: const <Offset>[],
      startBounds: Rect.zero,
      startShapes: const <Shape>[],
      startIndices: const <int>[],
      selectionAtStart: const <int>[],
      additiveSelection: false,
    ),
  );

  bool get canUndo => history.canUndo;
  bool get canRedo => history.canRedo;

  /// True when the drawing differs from what was last saved to [filePath].
  /// A drawing that is not the history's current snapshot is mid-edit.
  bool get dirty => !identical(drawing, history.current) || !history.isAtSaved;

  /// A project with no file, no edits and no shapes or pictures: nothing to
  /// lose.
  bool get isPristine => filePath == null && !dirty && !drawing.hasContent;

  /// Records the current drawing in the undo history. If nothing really changed
  /// the history stays as it was.
  EditorState commit() {
    final next = history.push(drawing);
    if (identical(next, history)) return copyWith(drawing: history.current);
    return copyWith(history: next, revision: revision + 1);
  }

  EditorState withDrawing(Drawing drawing) => copyWith(drawing: drawing);

  EditorState withLayers(List<PaintLayer> layers) =>
      copyWith(drawing: drawing.copyWith(layers: layers));

  /// Replaces the shapes of the active layer.
  EditorState withShapes(List<Shape> shapes) => withLayers(
    replacedAt(drawing.layers, layerIndex, layer.copyWith(shapes: shapes)),
  );

  /// Replaces the selected shape (no history entry).
  EditorState withSelectedShape(Shape shape) {
    final index = selected;
    if (index == null || selectedShape == null) return this;
    return withShapes(replacedAt(layer.shapes, index, shape));
  }

  EditorState withShapeChanges(Map<int, Shape> changes) {
    if (changes.isEmpty) return this;
    final shapes = [...layer.shapes];
    for (final entry in changes.entries) {
      if (entry.key >= 0 && entry.key < shapes.length) {
        shapes[entry.key] = entry.value;
      }
    }
    return withShapes(shapes);
  }

  /// Applies [change] to the selected shape, if there is one (no history entry).
  EditorState editSelected(Shape Function(Shape shape) change) {
    final shape = selectedShape;
    return shape == null ? this : withSelectedShape(change(shape));
  }
}
