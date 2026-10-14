// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/rendering.dart';

// Project imports:
import '../../../../common/constants/palette_constants.dart';
import '../../../../core/theme/theme_colors.dart';
import '../../../../domain/models/reference_image.dart';
import '../../../../domain/models/tool.dart';
import '../../../../domain/services/geometry_utils.dart';
import '../../../../domain/services/image_geometry.dart';
import '../../bloc/editor_bloc.dart';
import '../../logic/editor_ops.dart';
import 'shape_painter.dart';

/// Paints the workspace: canvas box, grid, every visible layer (its picture
/// first, then its shapes), the shape being drawn, and the selection handles.
class DrawingPainter extends CustomPainter {
  DrawingPainter(this.state);

  final EditorState state;

  @override
  void paint(Canvas canvas, Size size) {
    final v = state.view;
    canvas.drawRect(Offset.zero & size, Paint()..color = ThemeColors.workspace);
    canvas.save();
    canvas.translate(v.pan.dx, v.pan.dy);
    canvas.scale(v.zoom);

    final d = state.drawing;
    final box = Rect.fromLTWH(0, 0, d.width, d.height);
    final bg = kCanvasBackgrounds[v.background % kCanvasBackgrounds.length];
    canvas.drawRect(box, Paint()..color = Color(bg));
    if (v.grid) _grid(canvas, box);

    final paint = Paint()..isAntiAlias = true;
    for (final layer in d.layers) {
      if (!layer.visible) continue;
      _image(canvas, layer.image);
      for (final shape in layer.shapes) {
        paintShape(canvas, shape, paint);
      }
    }
    _draft(canvas, paint);

    canvas.drawRect(
      box,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1 / v.zoom
        ..color = ThemeColors.canvasEdge,
    );
    _selection(canvas);
    _imageSelection(canvas);
    canvas.restore();
  }

  /// A layer's picture sits under that layer's shapes. It may extend past the
  /// canvas box, so a large photo can be traced a piece at a time.
  void _image(Canvas canvas, ReferenceImage? r) {
    if (r == null || !r.visible) return;
    final pixels = state.images[r.id];
    if (pixels == null) return;
    canvas.save();
    canvas.translate(r.x, r.y);
    canvas.scale(r.scaleX, r.scaleY);
    canvas.drawImage(
      pixels,
      Offset.zero,
      Paint()
        ..filterQuality = FilterQuality.high
        ..color = Color.fromARGB((r.opacity * 255).round(), 255, 255, 255),
    );
    canvas.restore();
  }

  void _grid(Canvas canvas, Rect box) {
    final fine = state.view.zoom >= 10;
    final line = Paint()..strokeWidth = 1 / state.view.zoom;
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
    final d = state.draft;
    if (d == null) return;
    if (state.tool != Tool.polygon) {
      paintShape(canvas, d, paint);
      return;
    }
    // Polygons are previewed as an open outline until they are closed.
    final hover = state.hover;
    final pts = [...d.points, if (hover != null) hover];
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 / state.view.zoom
      ..color = ThemeColors.selection;
    canvas.drawPoints(PointMode.polygon, pts, line);
    final dot = 3 / state.view.zoom;
    for (var i = 0; i < d.points.length; i++) {
      canvas.drawCircle(d.points[i], i == 0 ? dot * 1.6 : dot, line);
    }
  }

  void _selection(Canvas canvas) {
    final s = state.selectedShape;
    if (s == null) return;
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1 / state.view.zoom
      ..color = ThemeColors.selection;
    canvas.drawRect(s.bounds, line);
    final h = 4 / state.view.zoom;
    final fill = Paint()..color = const Color(0xFFFFFFFF);
    for (final p in handlePoints(s)) {
      final r = Rect.fromCenter(center: p, width: 2 * h, height: 2 * h);
      canvas.drawRect(r, fill);
      canvas.drawRect(r, line);
    }
  }

  /// The outline and eight resize handles of the selected picture (corners
  /// keep proportions, edges stretch one side).
  void _imageSelection(Canvas canvas) {
    final box = state.imageBounds;
    if (box == null || !state.showImageHandles) return;
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1 / state.view.zoom
      ..color = ThemeColors.selection;
    canvas.drawRect(box, line);
    final h = 4 / state.view.zoom;
    final fill = Paint()..color = const Color(0xFFFFFFFF);
    for (final p in imageHandlePoints(box)) {
      final r = Rect.fromCenter(center: p, width: 2 * h, height: 2 * h);
      canvas.drawRect(r, fill);
      canvas.drawRect(r, line);
    }
  }

  @override
  bool shouldRepaint(DrawingPainter old) => !identical(old.state, state);
}
