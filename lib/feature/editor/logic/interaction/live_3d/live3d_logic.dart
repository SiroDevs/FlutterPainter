// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../../../../domain/models/model3d/space_range.dart';
import '../../../../../domain/models/model3d/world_axis.dart';
import '../../../../../domain/models/shapes/shape.dart';
import '../../../../../domain/services/geometry/shape_geometry.dart';
import '../../../../../domain/services/projection/parts/exports.dart';
import '../../../../../domain/services/projection/model/exports.dart';
import '../../../bloc/editor_bloc.dart';
import '../../../models/gesture_state.dart';
import '../../drawing/operations/exports.dart';
import 'exports.dart';

/// Pointer gestures of the live 3D camera. Empty space turns the view; an
/// arrow moves the selection along X, Y or Z; a shape slides across the
/// drawing, or tilts with alt.
abstract class Live3dLogic {
  Live3dLogic._();

  static const double _radiansPerPixel = 0.005;
  static const double _viewLimit = math.pi;
  static const double _tiltLimit = math.pi;
  static const double _hitReach = 4;
  static const double _minAxisReach = 0.02;
  static const double _minPlaneReach = 0.1;
  static const double _moveStep = 0.5;

  static EditorState pressed(
    EditorState state,
    Offset point, {
    required bool alt,
  }) {
    final handle = LiveGizmo.handleAt(state, point);
    if (handle != null) {
      return state.copyWith(
        gesture: _start(
          state,
          _modeOf(handle.axis),
          point,
          state.validSelectedIndices,
        ),
      );
    }
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
        alt ? GestureMode.tilt : GestureMode.plane,
        point,
        selected.validSelectedIndices,
      ),
    );
  }

  static EditorState moved(EditorState state, Offset point) {
    final gesture = state.gesture;
    final drag = point - gesture.origin;
    final next = switch (gesture.mode) {
      GestureMode.orbit => _orbit(state, point - gesture.last),
      GestureMode.plane => _slide(state, drag),
      GestureMode.tilt => _tilt(state, drag),
      GestureMode.moveX => _along(state, drag, WorldAxis.x),
      GestureMode.moveY => _along(state, drag, WorldAxis.y),
      GestureMode.moveZ => _along(state, drag, WorldAxis.z),
      _ => state,
    };
    return next.copyWith(gesture: next.gesture.copyWith(last: point));
  }

  static EditorState released(EditorState state) {
    final editedShapes = state.gesture.mode != GestureMode.orbit;
    final ended = state.endGesture();
    return editedShapes ? ended.commit() : ended;
  }

  static GestureMode _modeOf(WorldAxis axis) => switch (axis) {
    WorldAxis.x => GestureMode.moveX,
    WorldAxis.y => GestureMode.moveY,
    WorldAxis.z => GestureMode.moveZ,
  };

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

  // Moves the shapes along one axis, as far as the pointer follows it.
  static EditorState _along(EditorState state, Offset drag, WorldAxis axis) {
    final camera = state.camera;
    if (camera == null) return state;
    final onScreen = axisOnScreen(camera, axis);
    final reach = onScreen.distanceSquared;
    if (reach < _minAxisReach) return state;
    var change = (drag.dx * onScreen.dx + drag.dy * onScreen.dy) / reach;
    if (state.view.snap) change = (change / _moveStep).round() * _moveStep;
    return _restart(
      state,
      (start) => switch (axis) {
        WorldAxis.x => _shifted(start, Offset(change, 0)),
        WorldAxis.y => _shifted(start, Offset(0, change)),
        WorldAxis.z => start.copyWith(
          z: _limited(start.z + change, kZRange),
        ),
      },
    );
  }

  // Moves the shapes across the drawing, following the pointer.
  static EditorState _slide(EditorState state, Offset drag) {
    final camera = state.camera;
    if (camera == null) return state;
    final facing = math.cos(camera.yaw) * camera.scale;
    if (facing.abs() < _minPlaneReach) return state;
    var shift = Offset(
      drag.dx / facing,
      (math.cos(camera.yaw) * drag.dy -
              math.sin(camera.yaw) * math.sin(camera.pitch) * drag.dx) /
          (facing * math.cos(camera.pitch)),
    );
    if (!shift.dx.isFinite || !shift.dy.isFinite) return state;
    if (state.view.snap) shift = state.snapped(shift);
    return _restart(state, (start) => _shifted(start, shift));
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

  static Shape _shifted(Shape shape, Offset shift) =>
      shape.copyWith(points: [for (final vertex in shape.points) vertex + shift]);

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
}
