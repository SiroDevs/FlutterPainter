// Dart imports:
import 'dart:ui';

// Project imports:
import '../../../../domain/services/geometry/shape_geometry.dart';
import '../../bloc/editor_bloc.dart';
import '../drawing/editor_ops.dart';

/// Finds visible shapes and updates additive canvas selections.
abstract class SelectionHitLogic {
  SelectionHitLogic._();

  static int? hitInActiveLayer(EditorState state, Offset point) {
    if (!state.layer.visible) return null;
    final shapes = state.layer.shapes;
    final tolerance = 4 / state.view.zoom;
    for (var index = shapes.length - 1; index >= 0; index--) {
      final shape = shapes[index];
      if (shape.visible && shape.hitTest(point, tolerance)) return index;
    }
    return null;
  }

  static EditorState toggle(EditorState state, int index) {
    final grouped = groupedShapeIndices(
      state.layer.shapes,
      index,
    ).where((shapeIndex) => state.layer.shapes[shapeIndex].visible).toSet();
    final old = state.validSelectedIndices.toSet();
    final next = old.contains(index)
        ? old.difference(grouped)
        : old.union(grouped);
    return state.selectIndices(
      next.toList(),
      primary: next.contains(index) ? index : null,
    );
  }
}
