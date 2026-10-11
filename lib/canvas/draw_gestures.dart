// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/services.dart';

// Project imports:
import '../editor/draw_ops.dart';
import '../editor/editor_controller.dart';
import '../editor/tool.dart';
import '../editor/view_ops.dart';
import '../model/shape.dart';
import 'draw_math.dart';

/// Pointer handling for the drawing tools: rectangle, ellipse, line and
/// freehand are drag-driven; polygon is click-driven.
class DrawGestures {
  bool _active = false;
  Offset _origin = Offset.zero;
  DateTime _lastClick = DateTime.fromMillisecondsSinceEpoch(0);

  void down(EditorController c, Offset p) {
    final snapped = c.snapped(p);
    switch (c.tool) {
      case Tool.rect:
        _begin(c, ShapeKind.rect, snapped);
      case Tool.ellipse:
        _begin(c, ShapeKind.ellipse, snapped);
      case Tool.line:
        _begin(c, ShapeKind.line, snapped);
      case Tool.freehand:
        _begin(c, ShapeKind.freehand, p);
      case Tool.polygon:
        _polygonClick(c, snapped);
      case Tool.select:
      case Tool.reference:
        break;
    }
  }

  void _begin(EditorController c, ShapeKind kind, Offset p) {
    c.draft = c.newShape(kind, kind == ShapeKind.freehand ? [p] : [p, p]);
    _origin = p;
    _active = true;
    c.touch();
  }

  void move(EditorController c, Offset p) {
    final d = c.draft;
    if (!_active || d == null) return;
    if (d.kind == ShapeKind.freehand) {
      if ((p - d.points.last).distance * c.zoom > 3) d.points.add(p);
    } else {
      var q = c.snapped(p);
      if (HardwareKeyboard.instance.isShiftPressed) {
        q = constrainDrag(d.kind, _origin, q);
      }
      d.points[1] = q;
    }
    c.touch();
  }

  void up(EditorController c) {
    if (!_active) return;
    _active = false;
    final d = c.draft;
    if (d == null) return;
    isWorthKeeping(d) ? c.commitDraft() : c.cancelDraft();
  }

  /// Rubber-band line from the last polygon point to the cursor.
  void hover(EditorController c, Offset p) {
    if (c.draft != null && c.tool == Tool.polygon) {
      c.hover = c.snapped(p);
      c.touch();
    }
  }

  /// Each click adds a point. A click near the first point, or a double-click,
  /// closes the polygon; Enter (handled by the page) leaves it open.
  void _polygonClick(EditorController c, Offset p) {
    final now = DateTime.now();
    final doubleClick = now.difference(_lastClick).inMilliseconds < 320;
    _lastClick = now;
    final d = c.draft;
    if (d == null) {
      c.draft = c.newShape(ShapeKind.polygon, [p]);
      c.hover = p;
      c.touch();
      return;
    }
    final onFirst =
        d.points.length >= 3 && (d.points.first - p).distance < 8 / c.zoom;
    if (onFirst || doubleClick) {
      c.finishPolygon();
    } else {
      d.points.add(p);
      c.touch();
    }
  }
}
