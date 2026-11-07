// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../../domain/models/shape.dart';
import '../../../domain/models/shape_kind.dart';
import '../../../domain/services/geometry_utils.dart';
import '../bloc/editor_bloc.dart';
import '../models/gesture_state.dart';
import 'editor_ops.dart';

/// Applies pointer movement to the current selection gesture.
abstract class SelectionTransformLogic {
  SelectionTransformLogic._();

  static EditorState moved(
    EditorState state,
    Offset point, {
    required bool shift,
  }) {
    final gesture = state.gesture;
    final selected = state.selectedShape;
    switch (gesture.mode) {
      case GestureMode.move:
        if (gesture.startIndices.isEmpty) return state;
        var delta = point - gesture.origin;
        if (state.view.snap) delta = state.snapped(delta);
        return state.withShapeChanges({
          for (var index = 0; index < gesture.startIndices.length; index++)
            gesture.startIndices[index]: gesture.startShapes[index].copyWith(
              points: [
                for (final vertex in gesture.startShapes[index].points)
                  vertex + delta,
              ],
            ),
        });
      case GestureMode.scale:
        if (selected == null) return state;
        final target = resizedBox(
          gesture.startBounds,
          gesture.handle,
          Shape.rotatePoint(
            state.snapped(point),
            -selected.rotation,
            gesture.startBounds.center,
          ),
        );
        if (target.width < 0.5 || target.height < 0.5) return state;
        return state.withSelectedShape(
          selected.copyWith(
            points: remapPoints(
              gesture.startPoints,
              gesture.startBounds,
              target,
            ),
          ),
        );
      case GestureMode.rotate:
        return _rotate(state, gesture, point, shift);
      case GestureMode.vertex:
        if (selected == null) return state;
        return state.withSelectedShape(
          selected.copyWith(
            points: replacedAt(
              selected.points,
              gesture.handle,
              state.snapped(point),
            ),
          ),
        );
      case GestureMode.marquee:
        return state.copyWith(
          gesture: gesture.copyWith(
            startBounds: Rect.fromPoints(gesture.origin, point),
          ),
        );
      case GestureMode.none:
      case GestureMode.draw:
      case GestureMode.imageMove:
      case GestureMode.imageScale:
        return state;
    }
  }

  static EditorState _rotate(
    EditorState state,
    GestureState gesture,
    Offset point,
    bool snap,
  ) {
    if (gesture.startShapes.isEmpty) return state;
    final pivot = gesture.startBounds.center;
    final from = gesture.origin - pivot;
    final to = point - pivot;
    if (from.distance < 0.001 || to.distance < 0.001) return state;
    var angle = math.atan2(to.dy, to.dx) - math.atan2(from.dy, from.dx);
    if (snap) {
      const increment = math.pi / 12;
      angle = (angle / increment).round() * increment;
    }
    return state.withShapeChanges({
      for (var index = 0; index < gesture.startIndices.length; index++)
        gesture.startIndices[index]: _rotatedShape(
          gesture.startShapes[index],
          angle,
          pivot,
        ),
    });
  }

  static Shape _rotatedShape(Shape shape, double angle, Offset pivot) {
    if (shape.kind == ShapeKind.rect || shape.kind == ShapeKind.ellipse) {
      final bounds = shape.unrotatedBounds;
      final center = Shape.rotatePoint(bounds.center, angle, pivot);
      final rotatedBounds = Rect.fromCenter(
        center: center,
        width: bounds.width,
        height: bounds.height,
      );
      return shape.copyWith(
        points: [rotatedBounds.topLeft, rotatedBounds.bottomRight],
        rotation: shape.rotation + angle,
      );
    }
    return shape.copyWith(
      points: [
        for (final vertex in shape.points)
          Shape.rotatePoint(vertex, angle, pivot),
      ],
    );
  }

  static EditorState released(EditorState state) {
    final gesture = state.gesture;
    if (gesture.mode != GestureMode.marquee) return state.endGesture().commit();

    final area = gesture.startBounds;
    final selected = <int>{};
    if (state.layer.visible &&
        (area.width >= 2 / state.view.zoom ||
            area.height >= 2 / state.view.zoom)) {
      for (var index = 0; index < state.layer.shapes.length; index++) {
        final bounds = state.layer.shapes[index].bounds;
        if (bounds.overlaps(area) || area.contains(bounds.center))
          selected.add(index);
      }
    }
    for (final index in [...selected]) {
      final groupId = state.layer.shapes[index].groupId;
      if (groupId == null) continue;
      for (var other = 0; other < state.layer.shapes.length; other++) {
        if (state.layer.shapes[other].groupId == groupId) selected.add(other);
      }
    }
    if (gesture.additiveSelection) selected.addAll(gesture.selectionAtStart);
    return state.selectIndices(selected.toList()).endGesture();
  }

  static Offset rotationHandle(Rect bounds, double zoom) =>
      Offset(bounds.center.dx, bounds.top - 22 / zoom);
}
