// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/rendering.dart';

// Project imports:
import '../editor/editor_controller.dart';
import '../editor/tool.dart';
import '../model/palette.dart';
import 'selection_handles.dart';

/// Paints the workspace: canvas box, grid, every visible layer, the shape being
/// drawn, and the selection handles. Repaints whenever the controller changes.
class DrawingPainter extends CustomPainter {
  DrawingPainter(this.c) : super(repaint: c);

  final EditorController c;

  static const _accent = Color(0xFF4FC3F7);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFF1E2024));
    canvas.save();
    canvas.translate(c.pan.dx, c.pan.dy);
    canvas.scale(c.zoom);

    final d = c.drawing;
    final box = Rect.fromLTWH(0, 0, d.width, d.height);
    final bg = kCanvasBackgrounds[c.bg % kCanvasBackgrounds.length];
    canvas.drawRect(box, Paint()..color = Color(bg));
    _reference(canvas);
    if (c.grid) _grid(canvas, box);

    final paint = Paint()..isAntiAlias = true;
    for (final layer in d.layers) {
      if (!layer.visible) continue;
      for (final s in layer.shapes) {
        s.draw(canvas, paint);
      }
    }
    _draft(canvas, paint);

    canvas.drawRect(
      box,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1 / c.zoom
        ..color = const Color(0x88FFFFFF),
    );
    _selection(canvas);
    canvas.restore();
  }

  /// The tracing image sits under the grid and shapes and may extend past the
  /// canvas box, so a large photo can be traced a piece at a time.
  void _reference(Canvas canvas) {
    final r = c.drawing.reference;
    final img = c.refImage;
    if (r == null || img == null || !r.visible) return;
    canvas.save();
    canvas.translate(r.x, r.y);
    canvas.scale(r.scale);
    canvas.drawImage(
      img,
      Offset.zero,
      Paint()
        ..filterQuality = FilterQuality.high
        ..color = Color.fromARGB((r.opacity * 255).round(), 255, 255, 255),
    );
    canvas.restore();
  }

  void _grid(Canvas canvas, Rect box) {
    final fine = c.zoom >= 10;
    final line = Paint()..strokeWidth = 1 / c.zoom;
    for (var x = 0; x <= box.width; x++) {
      final major = x % 10 == 0;
      if (!major && !fine) continue;
      line.color = major ? const Color(0x44808080) : const Color(0x1A808080);
      canvas.drawLine(Offset(x.toDouble(), 0), Offset(x.toDouble(), box.height), line);
    }
    for (var y = 0; y <= box.height; y++) {
      final major = y % 10 == 0;
      if (!major && !fine) continue;
      line.color = major ? const Color(0x44808080) : const Color(0x1A808080);
      canvas.drawLine(Offset(0, y.toDouble()), Offset(box.width, y.toDouble()), line);
    }
  }

  void _draft(Canvas canvas, Paint paint) {
    final d = c.draft;
    if (d == null) return;
    if (c.tool != Tool.polygon) {
      d.draw(canvas, paint);
      return;
    }
    // Polygons are previewed as an open outline until they are closed.
    final pts = [...d.points, if (c.hover != null) c.hover!];
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 / c.zoom
      ..color = _accent;
    canvas.drawPoints(PointMode.polygon, pts, line);
    final dot = 3 / c.zoom;
    for (var i = 0; i < d.points.length; i++) {
      canvas.drawCircle(d.points[i], i == 0 ? dot * 1.6 : dot, line);
    }
  }

  void _selection(Canvas canvas) {
    final s = c.selectedShape;
    if (s == null) return;
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1 / c.zoom
      ..color = _accent;
    canvas.drawRect(s.bounds, line);
    final h = 4 / c.zoom;
    final fill = Paint()..color = const Color(0xFFFFFFFF);
    for (final p in handlePoints(s)) {
      final r = Rect.fromCenter(center: p, width: 2 * h, height: 2 * h);
      canvas.drawRect(r, fill);
      canvas.drawRect(r, line);
    }
  }

  @override
  bool shouldRepaint(DrawingPainter old) => true;
}
