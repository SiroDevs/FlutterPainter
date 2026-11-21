// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/painting.dart';

// Project imports:
import '../../../../domain/models/model3d/world_axis.dart';
import '../../../../domain/services/projection/parts/exports.dart';
import '../../bloc/editor_bloc.dart';
import '../../logic/interaction/live_3d/exports.dart';

const Color _xColor = Color(0xFFE5484D);
const Color _yColor = Color(0xFF30A46C);
const Color _zColor = Color(0xFF3E63DD);

/// Draws the X, Y and Z arrows of the selection in the live 3D view.
void paintLiveGizmo(Canvas canvas, EditorState state) {
  final zoom = state.view.zoom;
  for (final handle in LiveGizmo.handles(state)) {
    final color = _colorOf(handle.axis);
    final fill = handle.usable ? color : color.withValues(alpha: 0.35);
    final direction = handle.tip - handle.origin;
    canvas.drawLine(
      handle.origin,
      handle.tip,
      Paint()
        ..color = fill
        ..strokeWidth = 2 / zoom,
    );
    if (direction.distance < 1e-6) continue;
    final unit = direction / direction.distance;
    final side = Offset(-unit.dy, unit.dx);
    final head = 8 / zoom;
    canvas.drawPath(
      Path()
        ..moveTo(handle.tip.dx, handle.tip.dy)
        ..lineTo(
          handle.tip.dx - unit.dx * head + side.dx * head * 0.45,
          handle.tip.dy - unit.dy * head + side.dy * head * 0.45,
        )
        ..lineTo(
          handle.tip.dx - unit.dx * head - side.dx * head * 0.45,
          handle.tip.dy - unit.dy * head - side.dy * head * 0.45,
        )
        ..close(),
      Paint()..color = fill,
    );
    _paintLetter(canvas, handle, unit, fill, zoom);
  }
}

Color _colorOf(WorldAxis axis) => switch (axis) {
  WorldAxis.x => _xColor,
  WorldAxis.y => _yColor,
  WorldAxis.z => _zColor,
};

void _paintLetter(
  Canvas canvas,
  AxisHandle handle,
  Offset unit,
  Color color,
  double zoom,
) {
  final letter = TextPainter(
    text: TextSpan(
      text: handle.axis.name.toUpperCase(),
      style: TextStyle(color: color, fontSize: 11 / zoom),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  final spot = handle.tip + unit * (6 / zoom);
  letter.paint(
    canvas,
    spot - Offset(letter.width / 2, letter.height / 2),
  );
}
