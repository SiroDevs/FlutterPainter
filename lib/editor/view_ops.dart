// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../canvas/draw_math.dart';
import 'editor_controller.dart';

/// Zoom, pan and fit-to-window.
extension ViewOps on EditorController {
  /// [p] rounded to the snap grid when snapping is on.
  Offset snapped(Offset p) => snapPoint(p, enabled: snap, zoom: zoom);

  void zoomAt(double factor, Offset focal) {
    final next = (zoom * factor).clamp(0.5, 60.0).toDouble();
    pan = focal - (focal - pan) * (next / zoom);
    zoom = next;
    touch();
  }

  void panBy(Offset delta) {
    pan += delta;
    touch();
  }

  /// Centres the design box in the viewport. Silent: called during layout.
  void fit() {
    needsFit = false;
    if (viewport.isEmpty) return;
    final z = math.min((viewport.width - 60) / drawing.width,
        (viewport.height - 60) / drawing.height);
    zoom = z.clamp(0.5, 60.0).toDouble();
    pan = Offset((viewport.width - drawing.width * zoom) / 2,
        (viewport.height - drawing.height * zoom) / 2);
  }

  void requestFit() {
    needsFit = true;
    touch();
  }
}
