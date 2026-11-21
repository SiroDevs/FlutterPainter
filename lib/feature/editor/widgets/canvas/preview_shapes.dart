// Dart imports:
import 'dart:ui';

// Project imports:
import '../../../../domain/models/shapes/shape.dart';
import '../../../../domain/services/projection/model/exports.dart';
import '../../bloc/editor_bloc.dart';
import '../../logic/drawing/operations/exports.dart';
import 'shape_painter.dart';

const Color _fade = Color.fromRGBO(255, 255, 255, 0.4);

/// The shapes to draw for a layer: projected while the 3D preview is on for
/// the active layer, the drawn shapes otherwise.
List<Shape> shapesToPaint(EditorState state, int layerIndex) {
  final layer = state.drawing.layers[layerIndex];
  final angle = state.previewAngle;
  if (angle == null || layerIndex != state.layerIndex) return layer.shapes;
  return projectLayer(layer, angle);
}

/// While the 3D preview or a working part is on, only the active layer shows.
/// A working part paints that layer itself, through [paintWorkLayer].
bool hiddenByPreview(EditorState state, int layerIndex) {
  if (state.workingPart != null) return true;
  return state.previewAngle != null && layerIndex != state.layerIndex;
}

/// Paints the layer as seen when looking straight at the working part: the
/// other parts faded, the part itself as drawn so tools line up with it.
void paintWorkLayer(Canvas canvas, EditorState state, Paint paint) {
  final id = state.workingPart;
  if (id == null) return;
  canvas.saveLayer(null, Paint()..color = _fade);
  for (final shape in projectContext(state.layer, id)) {
    paintShape(canvas, shape, paint);
  }
  canvas.restore();
  for (final shape in state.layer.shapes) {
    if (shape.visible && shape.groupId == id) paintShape(canvas, shape, paint);
  }
}

/// Paints the comparison layer faded over the preview, hidden or not.
void paintComparison(Canvas canvas, EditorState state, Paint paint) {
  final index = state.ghostLayer;
  if (state.previewAngle == null ||
      index == null ||
      index == state.layerIndex ||
      index >= state.drawing.layers.length) {
    return;
  }
  canvas.saveLayer(null, Paint()..color = _fade);
  for (final shape in state.drawing.layers[index].shapes) {
    if (shape.visible) paintShape(canvas, shape, paint);
  }
  canvas.restore();
}

/// Outlines the selected shapes as the live camera shows them: one line
/// around everything the shape covers, not around each of its pieces.
void paintLiveSelection(Canvas canvas, EditorState state, Color color) {
  final camera = state.camera;
  if (!state.liveMode || camera == null) return;
  final chosen = state.validSelectedIndices.toSet();
  if (chosen.isEmpty) return;
  var covered = Path();
  for (final item in projectLayerSourced(state.layer, camera)) {
    final points = item.shape.points;
    if (!chosen.contains(item.source) || points.length < 3) continue;
    covered = Path.combine(
      PathOperation.union,
      covered,
      Path()..addPolygon(points, true),
    );
  }
  canvas.drawPath(
    covered,
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 / state.view.zoom
      ..color = color,
  );
}
