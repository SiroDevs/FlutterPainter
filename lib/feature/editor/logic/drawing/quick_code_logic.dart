// Dart imports:
import 'dart:ui';

// Project imports:
import '../../../../domain/models/shapes/shape_kind.dart';
import '../../bloc/editor_bloc.dart';
import 'draw_logic.dart';
import 'editor_ops.dart';

/// Applies point-list edits from the Quick Code panel.
abstract class QuickCodeLogic {
  QuickCodeLogic._();

  static EditorState previewPolygon(EditorState state, List<Offset> points) {
    if (points.isEmpty) return state.copyWith(draft: null, hover: null);
    return state.copyWith(
      draft: DrawLogic.newShape(state, ShapeKind.polygon, points),
      hover: null,
    );
  }

  static EditorState addPolygon(EditorState state, List<Offset> points) {
    final shape = DrawLogic.newShape(state, ShapeKind.polygon, points);
    final index = state.layer.shapes.length;
    final layer = state.layer.copyWith(
      visible: true,
      shapes: [...state.layer.shapes, shape],
    );
    return state
        .withLayers(replacedAt(state.drawing.layers, state.layerIndex, layer))
        .copyWith(draft: null, hover: null)
        .selectIndices([index])
        .commit();
  }

  static EditorState changeShapePoints(
    EditorState state,
    QuickCodeShapePointsChanged event,
  ) {
    if (event.layerIndex < 0 ||
        event.layerIndex >= state.drawing.layers.length) {
      return state;
    }
    final layer = state.drawing.layers[event.layerIndex];
    if (event.shapeIndex < 0 || event.shapeIndex >= layer.shapes.length) {
      return state;
    }
    final shape = layer.shapes[event.shapeIndex].copyWith(points: event.points);
    final shapes = [...layer.shapes]..[event.shapeIndex] = shape;
    final next = state.withLayers(
      replacedAt(
        state.drawing.layers,
        event.layerIndex,
        layer.copyWith(shapes: shapes),
      ),
    );
    return event.commit ? next.commit() : next;
  }
}
