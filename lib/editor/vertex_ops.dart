// Dart imports:
import 'dart:ui';

// Project imports:
import '../model/shape.dart';
import 'editor_controller.dart';

/// Editing the points of a line path or polygon.
extension VertexOps on EditorController {
  /// Closes an open path into a fillable polygon, or opens a polygon again.
  void setClosed(bool closed) {
    final s = selectedShape;
    if (s == null || !s.usesVertices) return;
    if (closed && s.kind == ShapeKind.line && s.points.length >= 3) {
      s.kind = ShapeKind.polygon;
      s.fill = fillOn ? fillColor : null;
    } else if (!closed && s.kind == ShapeKind.polygon) {
      s.kind = ShapeKind.line;
      s.fill = null;
      s.stroke ??= strokeColor;
    }
    changed();
  }

  /// Adds a point on the selected shape's edge nearest [p]. True if one was added.
  bool insertVertexAt(Offset p, double tol) {
    final s = selectedShape;
    if (s == null || !s.usesVertices) return false;
    final hit = s.nearestSegment(p, tol);
    if (hit == null) return false;
    s.points.insert(hit.index + 1, hit.point);
    changed();
    return true;
  }

  /// Removes point [i]; lines keep at least 2 points and polygons 3.
  bool removeVertex(int i) {
    final s = selectedShape;
    if (s == null || !s.usesVertices) return false;
    if (s.points.length <= (s.kind == ShapeKind.polygon ? 3 : 2)) return false;
    s.points.removeAt(i);
    changed();
    return true;
  }
}
