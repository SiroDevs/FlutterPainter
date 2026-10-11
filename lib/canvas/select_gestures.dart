// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/services.dart';

// Project imports:
import '../editor/editor_controller.dart';
import '../editor/vertex_ops.dart';
import '../editor/view_ops.dart';
import '../model/shape.dart';
import 'draw_math.dart';
import 'selection_handles.dart';

enum _Mode { none, move, scale, vertex }

/// Pointer handling for the Select tool: pick, move, resize by corner handles,
/// drag vertices, double-click an edge to add a point, Alt-click a point to
/// delete it.
class SelectGestures {
  _Mode _mode = _Mode.none;
  Offset _origin = Offset.zero;
  int _handle = -1;
  List<Offset> _startPts = const [];
  Rect _startBounds = Rect.zero;
  DateTime _lastClick = DateTime.fromMillisecondsSinceEpoch(0);

  void down(EditorController c, Offset p) {
    final now = DateTime.now();
    final doubleClick = now.difference(_lastClick).inMilliseconds < 320;
    _lastClick = now;

    final s = c.selectedShape;
    if (s != null) {
      final h = hitHandle(s, p, 8 / c.zoom);
      if (h != null) {
        if (s.usesVertices && HardwareKeyboard.instance.isAltPressed) {
          c.removeVertex(h);
          return;
        }
        _handle = h;
        _grab(s, p);
        _mode = s.usesVertices ? _Mode.vertex : _Mode.scale;
        return;
      }
      if (doubleClick && s.usesVertices && c.insertVertexAt(p, 6 / c.zoom)) return;
    }
    if (c.selectAt(p, 4 / c.zoom)) {
      _grab(c.selectedShape!, p);
      _mode = _Mode.move;
    }
  }

  void _grab(Shape s, Offset p) {
    _origin = p;
    _startPts = List.of(s.points);
    _startBounds = s.bounds;
  }

  void move(EditorController c, Offset p) {
    final s = c.selectedShape;
    if (_mode == _Mode.none || s == null) return;
    switch (_mode) {
      case _Mode.move:
        var delta = p - _origin;
        if (c.snap) delta = c.snapped(delta);
        s.points = [for (final q in _startPts) q + delta];
      case _Mode.scale:
        final to = resizedBox(_startBounds, _handle, c.snapped(p));
        if (to.width < 0.5 || to.height < 0.5) return;
        s.points = Shape.remap(_startPts, _startBounds, to);
      case _Mode.vertex:
        s.points[_handle] = c.snapped(p);
      case _Mode.none:
        return;
    }
    c.touch();
  }

  void up(EditorController c) {
    if (_mode != _Mode.none) c.changed();
    _mode = _Mode.none;
  }
}
