// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../../../../domain/services/projection/parts/exports.dart';
import '../../../../../domain/services/projection/model/exports.dart';
import '../../../bloc/editor_bloc.dart';
import '../../drawing/operations/exports.dart';

/// The X, Y and Z arrows shown on the selection in the live 3D view.
abstract class LiveGizmo {
  LiveGizmo._();

  static const double lengthPixels = 70;
  static const double reachPixels = 8;

  // Where the middle of the selection is on screen.
  static Offset? centre(EditorState state) {
    final camera = state.camera;
    final chosen = state.validSelectedIndices.toSet();
    if (camera == null || chosen.isEmpty) return null;
    Rect? covered;
    for (final item in projectLayerSourced(state.layer, camera)) {
      if (!chosen.contains(item.source) || item.shape.points.isEmpty) continue;
      final box = item.shape.bounds;
      covered = covered == null ? box : covered.expandToInclude(box);
    }
    return covered?.center;
  }

  static List<AxisHandle> handles(EditorState state) {
    final camera = state.camera;
    final origin = centre(state);
    if (camera == null || origin == null) return const [];
    return axisHandles(camera, origin, lengthPixels / state.view.zoom);
  }

  // The arrow under [point], if any.
  static AxisHandle? handleAt(EditorState state, Offset point) {
    var reach = reachPixels / state.view.zoom;
    AxisHandle? nearest;
    for (final handle in handles(state)) {
      if (!handle.usable) continue;
      final distance = _distanceToArrow(point, handle.origin, handle.tip);
      if (distance <= reach) {
        nearest = handle;
        reach = distance;
      }
    }
    return nearest;
  }

  static double _distanceToArrow(Offset point, Offset start, Offset end) {
    final line = end - start;
    final length = line.distanceSquared;
    if (length == 0) return (point - start).distance;
    final along = ((point - start).dx * line.dx + (point - start).dy * line.dy) /
        length;
    final closest = start + line * math.min(1.0, math.max(0.0, along));
    return (point - closest).distance;
  }
}
