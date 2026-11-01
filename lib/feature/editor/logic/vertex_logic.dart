// Dart imports:
import 'dart:ui';

// Project imports:
import '../../../domain/models/shape_kind.dart';
import '../../../domain/services/shape_geometry.dart';
import '../bloc/editor_bloc.dart';
import 'editor_ops.dart';

/// Editing the points of a line path or polygon.
abstract class VertexLogic {
  VertexLogic._();

  /// Closes an open path into a fillable polygon, or opens a polygon again.
  static EditorState setClosed(EditorState s, bool closed) {
    final shape = s.selectedShape;
    if (shape == null || !shape.usesVertices) return s;
    if (closed && shape.kind == ShapeKind.line && shape.points.length >= 3) {
      return s
          .withSelectedShape(shape.copyWith(
            kind: ShapeKind.polygon,
            fill: s.style.fillOn ? s.style.fillColor : null,
            gradient: s.style.fillOn ? s.style.fillGradient : null,
          ))
          .commit();
    }
    if (!closed && shape.kind == ShapeKind.polygon) {
      return s
          .withSelectedShape(shape.copyWith(
            kind: ShapeKind.line,
            fill: null,
            gradient: null,
            stroke: shape.stroke ?? s.style.strokeColor,
          ))
          .commit();
    }
    return s;
  }

  /// Adds a point on the selected shape's edge nearest [p], or null if none is
  /// close enough.
  static EditorState? insert(EditorState s, Offset p, double tol) {
    final shape = s.selectedShape;
    if (shape == null || !shape.usesVertices) return null;
    final hit = shape.nearestSegment(p, tol);
    if (hit == null) return null;
    final pts = shape.points;
    final next = [...pts.sublist(0, hit.index + 1), hit.point, ...pts.sublist(hit.index + 1)];
    return s.withSelectedShape(shape.copyWith(points: next)).commit();
  }

  /// Removes point [i]; lines keep at least 2 points and polygons 3.
  static EditorState remove(EditorState s, int i) {
    final shape = s.selectedShape;
    if (shape == null || !shape.usesVertices) return s;
    if (shape.points.length <= (shape.kind == ShapeKind.polygon ? 3 : 2)) return s;
    return s.withSelectedShape(shape.copyWith(points: removedAt(shape.points, i))).commit();
  }
}
