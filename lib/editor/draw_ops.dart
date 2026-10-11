// Dart imports:
import 'dart:ui';

// Project imports:
import '../model/shape.dart';
import 'editor_controller.dart';

/// Creating shapes: the draft being dragged out, and committing it.
extension DrawOps on EditorController {
  Shape newShape(ShapeKind kind, List<Offset> points) {
    final open = kind == ShapeKind.line || kind == ShapeKind.freehand;
    final count = drawing.layers.fold<int>(0, (n, l) => n + l.shapes.length);
    return Shape(
      kind: kind,
      points: points,
      name: '${kind.name[0].toUpperCase()}${kind.name.substring(1)} ${count + 1}',
      fill: open || !fillOn ? null : fillColor,
      stroke: (strokeOn || open) ? strokeColor : null,
      strokeWidth: strokeWidth,
      radius: kind == ShapeKind.rect ? radius : 0,
    );
  }

  void commitDraft() {
    final s = draft;
    draft = null;
    hover = null;
    if (s == null) return;
    layer.visible = true;
    layer.shapes.add(s);
    selected = null;
    changed();
  }

  void cancelDraft() {
    draft = null;
    hover = null;
    touch();
  }

  /// Ends the polygon tool's click sequence. [closed] makes a filled polygon
  /// (needs 3+ points); otherwise, or with too few points, it becomes an open
  /// line path.
  void finishPolygon({bool closed = true}) {
    final d = draft;
    if (d == null) return;
    if (closed && d.points.length >= 3) {
      commitDraft();
    } else if (d.points.length >= 2) {
      d.kind = ShapeKind.line;
      d.fill = null;
      d.stroke ??= strokeColor;
      commitDraft();
    } else {
      cancelDraft();
    }
  }
}
