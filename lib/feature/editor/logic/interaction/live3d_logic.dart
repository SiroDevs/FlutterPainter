// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../../../domain/models/model3d/depth_range.dart';
import '../../../../domain/models/shapes/shape.dart';
import '../../../../domain/services/geometry/shape_geometry.dart';
import '../../../../domain/services/projection/model_projection.dart';
import '../../bloc/editor_bloc.dart';
import '../../models/gesture_state.dart';
import '../drawing/editor_ops.dart';

/// Pointer gestures of the live 3D camera: turn the view, push shapes in
/// depth, tilt them.
abstract class Live3dLogic {
  Live3dLogic._();

  static const double _radiansPerPixel = 0.005;
  static const double _viewLimit = 1.48;
  static const double _tiltLimit = math.pi;
  static const double _hitReach = 4;
  static const double _minAxisReach = 0.02;

  // Empty space turns the view; a shape is pushed, or tilted with alt.
  static EditorState pressed(
    EditorState state,
    Offset point, {
    required bool alt,
  }) {
    final hit = _sourceAt(state, point);
    if (hit == null) {
      final cleared = state.selectIndices(const []);
      return cleared.copyWith(
        gesture: _start(cleared, GestureMode.orbit, point, const []),
      );
    }
    final shapes = state.layer.shapes;
    final selected = state.validSelectedIndices.contains(hit)
        ? state
        : state.selectIndices([
            for (final index in groupedShapeIndices(shapes, hit))
              if (shapes[index].visible) index,
          ], primary: hit);
    return selected.copyWith(
      gesture: _start(
        selected,
        alt ? GestureMode.tilt : GestureMode.depth,
        point,
        selected.validSelectedIndices,
      ),
    );
  }

  static EditorState moved(EditorState state, Offset point) {
    final gesture = state.gesture;
    final next = switch (gesture.mode) {
      GestureMode.orbit => _orbit(state, point - gesture.last),
      GestureMode.depth => _push(state, point - gesture.origin),
      GestureMode.tilt => _tilt(state, point - gesture.origin),
      _ => state,
    };
    return next.copyWith(gesture: next.gesture.copyWith(last: point));
  }

  static EditorState released(EditorState state) {
    final editedShapes =
        state.gesture.mode == GestureMode.depth ||
        state.gesture.mode == GestureMode.tilt;
    final ended = state.endGesture();
    return editedShapes ? ended.commit() : ended;
  }

  static GestureState _start(
    EditorState state,
    GestureMode mode,
    Offset point,
    List<int> indices,
  ) => state.gesture.copyWith(
    mode: mode,
    origin: point,
    last: point,
    startIndices: indices,
    startShapes: [for (final index in indices) state.layer.shapes[index]],
  );

  static int? _sourceAt(EditorState state, Offset point) {
    final camera = state.camera;
    if (camera == null) return null;
    final flat = projectLayerSourced(state.layer, camera);
    final reach = _hitReach / state.view.zoom;
    for (var index = flat.length - 1; index >= 0; index--) {
      if (flat[index].shape.hitTest(point, reach)) return flat[index].source;
    }
    return null;
  }

  static EditorState _orbit(EditorState state, Offset delta) {
    final camera = state.camera;
    if (camera == null) return state;
    final turn = delta * (state.view.zoom * _radiansPerPixel);
    return state.copyWith(
      camera: camera.copyWith(
        yaw: _limited(camera.yaw - turn.dx, _viewLimit),
        pitch: _limited(camera.pitch + turn.dy, _viewLimit),
      ),
    );
  }

  // Moves the shapes along the depth axis as it appears on screen.
  static EditorState _push(EditorState state, Offset drag) {
    final camera = state.camera;
    if (camera == null) return state;
    final depthOnScreen =
        Offset(
          math.sin(camera.yaw),
          -math.cos(camera.yaw) * math.sin(camera.pitch),
        ) *
        camera.scale;
    final reach = depthOnScreen.distanceSquared;
    if (reach < _minAxisReach) return state;
    final change =
        (drag.dx * depthOnScreen.dx + drag.dy * depthOnScreen.dy) / reach;
    return _restart(
      state,
      (start) => start.copyWith(
        depth: _snapped(
          state,
          _limited(start.depth + change, kDepthRange),
        ),
      ),
    );
  }

  static EditorState _tilt(EditorState state, Offset drag) {
    final turn = drag * (state.view.zoom * _radiansPerPixel);
    return _restart(
      state,
      (start) => start.copyWith(
        tilt: start.tilt.copyWith(
          yaw: _limited(start.tilt.yaw - turn.dx, _tiltLimit),
          pitch: _limited(start.tilt.pitch + turn.dy, _tiltLimit),
        ),
      ),
    );
  }

  // Rebuilds each gesture shape from how it was when the drag began.
  static EditorState _restart(
    EditorState state,
    Shape Function(Shape start) change,
  ) => state.withShapeChanges({
    for (var item = 0; item < state.gesture.startIndices.length; item++)
      state.gesture.startIndices[item]: change(
        state.gesture.startShapes[item],
      ),
  });

  static double _limited(double value, double limit) =>
      value.clamp(-limit, limit).toDouble();

  static double _snapped(EditorState state, double value) =>
      state.view.snap ? (value * 2).round() / 2 : value;
}
