// Dart imports:
import 'dart:ui';

// Project imports:
import '../../../../../domain/services/geometry/shape_geometry.dart';
import '../../../bloc/controller/editor_bloc.dart';
import '../../drawing/shared/editor_ops.dart';
import '../../drawing/styles/style_logic.dart';

/// Fills the topmost visible closed shape under the pointer.
abstract class PaintBucketLogic {
  PaintBucketLogic._();

  static EditorState pressed(EditorState state, Offset point) {
    final tolerance = 4 / state.view.zoom;
    final layers = state.drawing.layers;
    for (var layerIndex = layers.length - 1; layerIndex >= 0; layerIndex--) {
      final layer = layers[layerIndex];
      if (!layer.visible) continue;
      for (
        var shapeIndex = layer.shapes.length - 1;
        shapeIndex >= 0;
        shapeIndex--
      ) {
        final shape = layer.shapes[shapeIndex];
        if (!shape.visible ||
            !state.canEdit(shape, layerIndex) ||
            !shape.isClosed ||
            !shape.hitTest(point, tolerance)) {
          continue;
        }
        final target = state.copyWith(
          layerIndex: layerIndex,
          selected: shapeIndex,
          selectedIndices: [shapeIndex],
          style: state.style.copyWith(editFill: true),
        );
        return StyleLogic.pickFill(target, target.style.fillColor);
      }
    }
    return state;
  }
}
