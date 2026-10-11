// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

// Project imports:
import '../editor/editor_controller.dart';
import '../editor/reference_ops.dart';
import '../editor/tool.dart';
import '../editor/view_ops.dart';
import 'draw_gestures.dart';
import 'drawing_painter.dart';
import 'select_gestures.dart';

/// The drawing surface. Raw pointer events (no gesture arena) so drawing starts
/// instantly: left button uses the tool, right or middle button pans, and the
/// wheel zooms around the cursor.
class CanvasView extends StatefulWidget {
  const CanvasView({super.key, required this.controller, required this.focus});

  final EditorController controller;
  final FocusNode focus;

  @override
  State<CanvasView> createState() => _CanvasViewState();
}

class _CanvasViewState extends State<CanvasView> {
  EditorController get c => widget.controller;

  final DrawGestures _draw = DrawGestures();
  final SelectGestures _select = SelectGestures();
  bool _panning = false;
  bool _movingImage = false;

  Offset _design(Offset local) => (local - c.pan) / c.zoom;

  MouseCursor get _cursor => switch (c.tool) {
        Tool.select => SystemMouseCursors.basic,
        Tool.reference => SystemMouseCursors.grab,
        _ => SystemMouseCursors.precise,
      };

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: c,
      builder: (context, _) => LayoutBuilder(builder: (context, box) {
        c.viewport = box.biggest;
        if (c.needsFit) c.fit();
        return MouseRegion(
          cursor: _cursor,
          child: Listener(
            behavior: HitTestBehavior.opaque,
            onPointerDown: _down,
            onPointerMove: _move,
            onPointerUp: _up,
            onPointerCancel: (_) => _reset(),
            onPointerHover: _hover,
            onPointerSignal: _signal,
            child: ClipRect(
              child: CustomPaint(
                painter: DrawingPainter(c),
                size: Size.infinite,
              ),
            ),
          ),
        );
      }),
    );
  }

  void _reset() {
    _panning = false;
    _movingImage = false;
  }

  void _down(PointerDownEvent e) {
    widget.focus.requestFocus();
    if ((e.buttons & (kSecondaryButton | kMiddleMouseButton)) != 0) {
      _panning = true;
      return;
    }
    if ((e.buttons & kPrimaryButton) == 0) return;
    final p = _design(e.localPosition);
    switch (c.tool) {
      case Tool.select:
        _select.down(c, p);
      case Tool.reference:
        _movingImage = c.drawing.reference != null;
      default:
        _draw.down(c, p);
    }
  }

  void _move(PointerMoveEvent e) {
    c.cursor.value = _design(e.localPosition);
    if (_panning) {
      c.panBy(e.delta);
    } else if (_movingImage) {
      c.moveReferenceBy(e.delta / c.zoom);
    } else {
      final p = _design(e.localPosition);
      _select.move(c, p);
      _draw.move(c, p);
    }
  }

  void _up(PointerUpEvent e) {
    if (_movingImage) c.changed();
    _select.up(c);
    _draw.up(c);
    _reset();
  }

  void _hover(PointerHoverEvent e) {
    final p = _design(e.localPosition);
    c.cursor.value = p;
    _draw.hover(c, p);
  }

  void _signal(PointerSignalEvent e) {
    if (e is PointerScrollEvent) {
      c.zoomAt(e.scrollDelta.dy < 0 ? 1.12 : 1 / 1.12, e.localPosition);
    }
  }
}
