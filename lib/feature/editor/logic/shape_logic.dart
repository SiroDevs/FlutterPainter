// Dart imports:
import 'dart:ui';

// Project imports:
import '../bloc/editor_bloc.dart';
import 'editor_ops.dart';

/// Operations on the selected shape: delete, duplicate, order, layer, name.
abstract class ShapeLogic {
  ShapeLogic._();

  static EditorState delete(EditorState s) {
    final i = s.selected;
    if (i == null || s.selectedShape == null) return s;
    return s.withShapes(removedAt(s.layer.shapes, i)).copyWith(selected: null).commit();
  }

  static EditorState duplicate(EditorState s) {
    final shape = s.selectedShape;
    if (shape == null) return s;
    final copy = shape.copyWith(
      points: [for (final p in shape.points) p + const Offset(3, 3)],
      name: '${shape.name} copy',
    );
    final shapes = [...s.layer.shapes, copy];
    return s.withShapes(shapes).copyWith(selected: shapes.length - 1).commit();
  }

  /// [direction] +1 draws the shape later (in front), -1 earlier (behind).
  static EditorState reorder(EditorState s, int direction) {
    final i = s.selected;
    if (i == null || s.selectedShape == null) return s;
    final j = i + direction;
    if (j < 0 || j >= s.layer.shapes.length) return s;
    final shapes = [...s.layer.shapes];
    shapes.insert(j, shapes.removeAt(i));
    return s.withShapes(shapes).copyWith(selected: j).commit();
  }

  static EditorState moveToLayer(EditorState s, int target) {
    final i = s.selected;
    final shape = s.selectedShape;
    final layers = s.drawing.layers;
    if (i == null || shape == null) return s;
    if (target == s.layerIndex || target < 0 || target >= layers.length) return s;
    final next = [...layers];
    next[s.layerIndex] = s.layer.copyWith(shapes: removedAt(s.layer.shapes, i));
    final to = next[target];
    next[target] = to.copyWith(visible: true, shapes: [...to.shapes, shape]);
    return s
        .withLayers(next)
        .copyWith(layerIndex: target, selected: next[target].shapes.length - 1)
        .commit();
  }

  static EditorState rename(EditorState s, String name) =>
      s.editSelected((sh) => sh.copyWith(name: name)).commit();
}
