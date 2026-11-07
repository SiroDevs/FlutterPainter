// Dart imports:
import 'dart:ui';

// Project imports:
import '../../../../domain/models/shape_kind.dart';
import '../../../../domain/services/shape_geometry.dart';
import '../../bloc/editor_bloc.dart';
import 'editor_ops.dart';

/// Edits points on line paths and polygons.
abstract class VertexLogic {
  VertexLogic._();

  static EditorState setClosed(EditorState state, bool closed) {
    final shape = state.selectedShape;
    if (shape == null || !shape.usesVertices) return state;
    if (closed && shape.kind == ShapeKind.line && shape.points.length >= 3) {
      return state
          .withSelectedShape(
            shape.copyWith(
              kind: ShapeKind.polygon,
              fill: state.style.fillOn ? state.style.fillColor : null,
              gradient: state.style.fillOn ? state.style.fillGradient : null,
            ),
          )
          .commit();
    }
    if (!closed && shape.kind == ShapeKind.polygon) {
      return state
          .withSelectedShape(
            shape.copyWith(
              kind: ShapeKind.line,
              fill: null,
              gradient: null,
              stroke: shape.stroke ?? state.style.strokeColor,
            ),
          )
          .commit();
    }
    return state;
  }

  static EditorState? insert(
    EditorState state,
    Offset point,
    double tolerance,
  ) {
    final shape = state.selectedShape;
    if (shape == null || !shape.usesVertices) return null;
    final hit = shape.nearestSegment(point, tolerance);
    if (hit == null) return null;
    final points = shape.points;
    final updated = [
      ...points.sublist(0, hit.index + 1),
      hit.point,
      ...points.sublist(hit.index + 1),
    ];
    return state.withSelectedShape(shape.copyWith(points: updated)).commit();
  }

  static EditorState remove(EditorState state, int pointIndex) {
    final shape = state.selectedShape;
    if (shape == null || !shape.usesVertices) return state;
    if (pointIndex < 0 || pointIndex >= shape.points.length) return state;
    final minimumPoints = shape.kind == ShapeKind.polygon ? 3 : 2;
    if (shape.points.length <= minimumPoints) return state;
    final updated = removedAt(shape.points, pointIndex);
    return state.withSelectedShape(shape.copyWith(points: updated)).commit();
  }

  static EditorState split(EditorState state, int pointIndex) {
    final shape = state.selectedShape;
    if (shape == null || !shape.usesVertices || shape.points.length < 2) {
      return state;
    }
    final points = shape.points;
    if (pointIndex < 0 || pointIndex >= points.length) return state;
    final nextIndex = shape.kind == ShapeKind.polygon
        ? (pointIndex + 1) % points.length
        : pointIndex == points.length - 1
        ? pointIndex - 1
        : pointIndex + 1;
    final midpoint = (points[pointIndex] + points[nextIndex]) / 2;
    final insertionIndex = shape.kind == ShapeKind.polygon
        ? pointIndex + 1
        : pointIndex == points.length - 1
        ? pointIndex
        : pointIndex + 1;
    final updated = [
      ...points.sublist(0, insertionIndex),
      midpoint,
      ...points.sublist(insertionIndex),
    ];
    return state.withSelectedShape(shape.copyWith(points: updated)).commit();
  }
}
