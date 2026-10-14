// Dart imports:
import 'dart:ui';

// Project imports:
import '../../../domain/models/drawing.dart';
import '../../../domain/models/paint_layer.dart';
import '../../../domain/models/reference_image.dart';
import '../../../domain/models/shape.dart';
import '../../../domain/models/tool.dart';
import '../../../domain/services/geometry_utils.dart';
import '../bloc/editor_bloc.dart';
import '../models/gesture_state.dart';

/// Value of [EditorState.selected] that means "the active layer's picture".
const int kImageSlot = -1;

/// A copy of [list] with the item at [index] replaced.
List<T> replacedAt<T>(List<T> list, int index, T value) =>
    [...list.sublist(0, index), value, ...list.sublist(index + 1)];

/// A copy of [list] without the item at [index].
List<T> removedAt<T>(List<T> list, int index) =>
    [...list.sublist(0, index), ...list.sublist(index + 1)];

/// Small helpers shared by every logic class.
extension EditorStateOps on EditorState {
  PaintLayer get layer => drawing.layers[layerIndex];

  Shape? get selectedShape {
    final i = selected;
    if (i == null || i < 0) return null;
    final shapes = layer.shapes;
    return i < shapes.length ? shapes[i] : null;
  }

  /// The picture on the active layer, if any.
  ReferenceImage? get activeImage => layer.image;

  /// Where the active layer's picture sits, in design units. Null when the
  /// layer has no picture or its pixels are not decoded yet.
  Rect? get imageBounds {
    final r = layer.image;
    if (r == null) return null;
    final pixels = images[r.id];
    if (pixels == null) return null;
    return Rect.fromLTWH(
      r.x,
      r.y,
      pixels.width * r.scaleX,
      pixels.height * r.scaleY,
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

  /// [p] rounded to the snap grid when snapping is on.
  Offset snapped(Offset p) =>
      snapPoint(p, enabled: view.snap, zoom: view.zoom);

  /// Ends the current pointer gesture but keeps the last-click time, so a
  /// double-click is still recognised on the next press.
  EditorState endGesture() => copyWith(
        gesture: gesture.copyWith(
          mode: GestureMode.none,
          handle: -1,
          startPoints: const <Offset>[],
          startBounds: Rect.zero,
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

  EditorState withDrawing(Drawing d) => copyWith(drawing: d);

  EditorState withLayers(List<PaintLayer> layers) =>
      copyWith(drawing: drawing.copyWith(layers: layers));

  /// Replaces the shapes of the active layer.
  EditorState withShapes(List<Shape> shapes) => withLayers(
        replacedAt(drawing.layers, layerIndex, layer.copyWith(shapes: shapes)),
      );

  /// Replaces the selected shape (no history entry).
  EditorState withSelectedShape(Shape shape) {
    final i = selected;
    if (i == null || selectedShape == null) return this;
    return withShapes(replacedAt(layer.shapes, i, shape));
  }

  /// Applies [change] to the selected shape, if there is one (no history entry).
  EditorState editSelected(Shape Function(Shape shape) change) {
    final s = selectedShape;
    return s == null ? this : withSelectedShape(change(s));
  }
}
