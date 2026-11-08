part of 'dart_exporter.dart';

mixin _DartExporterShapeWriter on _DartExporterBase {
  @override
  bool _hasGradient(PaintLayer layer) =>
      layer.shapes.any((shape) => shape.gradient != null);

  @override
  bool _usesPath(Shape shape) =>
      shape.kind == ShapeKind.polygon ||
      shape.kind == ShapeKind.freehand ||
      (shape.kind == ShapeKind.line && shape.points.length > 2);

  @override
  List<String> _shape(Shape shape, {required bool comment}) {
    if (!shape.isClosed && shape.stroke == null) return const [];
    if (shape.isClosed && shape.fill == null && shape.stroke == null) {
      return const [];
    }
    final lines = <String>[];
    if (comment && shape.name.isNotEmpty) {
      lines.add('// ${_oneLine(shape.name)}');
    }
    if (_usesPath(shape)) lines.addAll(_pathLines(shape));
    final drawCall = _drawCall(shape);
    if (shape.isClosed && shape.fill != null) {
      final gradient = shape.gradient;
      lines
        ..addAll(
          gradient == null
              ? _style('fill', shape.fill!)
              : gradientFillLines(gradient, shape.unrotatedBounds, _color),
        )
        ..add(drawCall);
    }
    if (shape.stroke != null) {
      lines
        ..addAll(_style('stroke', shape.stroke!, width: shape.strokeWidth))
        ..add(drawCall);
    }
    if (shape.rotation != 0) {
      final center = shape.unrotatedBounds.center;
      final commentIndex = comment && shape.name.isNotEmpty ? 1 : 0;
      lines.insertAll(commentIndex, [
        'canvas.save();',
        'canvas.translate(${fmt(center.dx)}, ${fmt(center.dy)});',
        'canvas.rotate(${fmt(shape.rotation)});',
        'canvas.translate(${fmt(-center.dx)}, ${fmt(-center.dy)});',
      ]);
      lines.add('canvas.restore();');
    }
    return lines;
  }

  List<String> _style(String mode, int color, {double? width}) => [
    '_paint',
    '  ..style = PaintingStyle.$mode',
    if (_resetShader) '  ..shader = null',
    if (width != null) '  ..strokeWidth = ${fmt(width)}',
    '  ..color = ${_color(color)};',
  ];

  String _drawCall(Shape shape) {
    final bounds = shape.unrotatedBounds;
    final rect =
        'const Rect.fromLTRB(${fmt(bounds.left)}, ${fmt(bounds.top)}, '
        '${fmt(bounds.right)}, ${fmt(bounds.bottom)})';
    switch (shape.kind) {
      case ShapeKind.rect:
        final radius = shape.effectiveRadius;
        return radius > 0
            ? 'canvas.drawRRect(RRect.fromRectXY($rect, ${fmt(radius)}, ${fmt(radius)}), _paint);'
            : 'canvas.drawRect($rect, _paint);';
      case ShapeKind.ellipse:
        return 'canvas.drawOval($rect, _paint);';
      case ShapeKind.line when shape.points.length == 2:
        final start = shape.points[0];
        final end = shape.points[1];
        return 'canvas.drawLine(const Offset(${fmt(start.dx)}, ${fmt(start.dy)}), '
            'const Offset(${fmt(end.dx)}, ${fmt(end.dy)}), _paint);';
      default:
        return 'canvas.drawPath(_path, _paint);';
    }
  }

  List<String> _pathLines(Shape shape) {
    final points = shape.points;
    final segments = <String>[
      '..reset()',
      '..moveTo(${fmt(points.first.dx)}, ${fmt(points.first.dy)})',
    ];
    if (shape.kind == ShapeKind.freehand && points.length >= 3) {
      for (var index = 1; index < points.length - 1; index++) {
        final midpoint = (points[index] + points[index + 1]) / 2;
        segments.add(
          '..quadraticBezierTo(${fmt(points[index].dx)}, ${fmt(points[index].dy)}, '
          '${fmt(midpoint.dx)}, ${fmt(midpoint.dy)})',
        );
      }
      segments.add('..lineTo(${fmt(points.last.dx)}, ${fmt(points.last.dy)})');
    } else {
      for (final point in points.skip(1)) {
        segments.add('..lineTo(${fmt(point.dx)}, ${fmt(point.dy)})');
      }
    }
    if (shape.kind == ShapeKind.polygon) segments.add('..close()');
    return [
      '_path',
      for (var index = 0; index < segments.length; index++)
        '  ${segments[index]}${index == segments.length - 1 ? ';' : ''}',
    ];
  }

  String _color(int argb) {
    final value = argb & 0xFFFFFFFF;
    _usedColors.add(value);
    return options.colorConstants
        ? '$_painterClass.${_colorName(value)}'
        : 'const ${_colorLiteral(value)}';
  }

  @override
  String _colorName(int argb) {
    final hex = argb.toRadixString(16).padLeft(8, '0').toUpperCase();
    return 'color${hex.startsWith('FF') ? hex.substring(2) : hex}';
  }

  @override
  String _colorLiteral(int argb) {
    final alpha = (argb >> 24) & 0xFF;
    final red = (argb >> 16) & 0xFF;
    final green = (argb >> 8) & 0xFF;
    final blue = argb & 0xFF;
    return switch (options.colorFormat) {
      ColorFormat.hex => 'Color(${colorLiteral(argb)})',
      ColorFormat.argb => 'Color.fromARGB($alpha, $red, $green, $blue)',
      ColorFormat.rgbo =>
        'Color.fromRGBO($red, $green, $blue, ${fmtN(alpha / 255, 3)})',
    };
  }
}
