// Dart imports:
import 'dart:ui';

// Project imports:
import '../../../../domain/models/shapes/shape.dart';
import '../../../../domain/services/projection/model_projection.dart';
import '../../bloc/editor_bloc.dart';
import '../../logic/drawing/editor_ops.dart';
import 'shape_painter.dart';

/// The shapes to draw for a layer: projected while the 3D preview is on for
/// the active layer, the drawn shapes otherwise.
List<Shape> shapesToPaint(EditorState state, int layerIndex) {
  final layer = state.drawing.layers[layerIndex];
  final angle = state.previewAngle;
  if (angle == null || layerIndex != state.layerIndex) return layer.shapes;
  return projectLayer(layer, angle);
}

/// While the 3D preview is on only the previewed layer shows; the comparison
/// layer is painted separately, faded, by [paintComparison].
bool hiddenByPreview(EditorState state, int layerIndex) =>
    state.previewAngle != null && layerIndex != state.layerIndex;

/// Paints the comparison layer faded over the preview, hidden or not.
void paintComparison(Canvas canvas, EditorState state, Paint paint) {
  final index = state.ghostLayer;
  if (state.previewAngle == null ||
      index == null ||
      index == state.layerIndex ||
      index >= state.drawing.layers.length) {
    return;
  }
  canvas.saveLayer(null, Paint()..color = const Color.fromRGBO(255, 255, 255, 0.45));
  for (final shape in state.drawing.layers[index].shapes) {
    if (shape.visible) paintShape(canvas, shape, paint);
  }
  canvas.restore();
}
