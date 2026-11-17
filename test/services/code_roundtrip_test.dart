// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:flutter_painter/domain/models/drawing/drawing.dart';
import 'package:flutter_painter/domain/models/drawing/paint_layer.dart';
import 'package:flutter_painter/domain/models/editor/app_settings.dart';
import 'package:flutter_painter/domain/models/export/export_options.dart';
import 'package:flutter_painter/domain/models/shapes/shape.dart';
import 'package:flutter_painter/domain/models/shapes/shape_kind.dart';
import 'package:flutter_painter/domain/services/code_export/dart_exporter.dart';
import 'package:flutter_painter/domain/services/code_import/code_importer.dart';

// NOTE: these exercise exporter -> importer. If one fails, either the
// exporter or the importer has drifted; both are worth knowing about.

const _shapes = [
  Shape(
    kind: ShapeKind.rect,
    points: [Offset(1, 2), Offset(30, 40)],
    fill: 0xFFFF0000,
    stroke: 0xFF000000,
    strokeWidth: 2,
  ),
  Shape(
    kind: ShapeKind.ellipse,
    points: [Offset(5, 5), Offset(25, 15)],
    fill: 0xFF00FF00,
  ),
  Shape(
    kind: ShapeKind.polygon,
    points: [Offset(0, 0), Offset(10, 0), Offset(5, 8)],
    fill: 0xFF0000FF,
  ),
];

void main() {
  const size = Size(100, 150);
  final drawing = Drawing(
    name: 'Rider',
    width: 100,
    height: 150,
    layers: const [PaintLayer(name: 'Body', shapes: _shapes)],
  );

  test('monolithic export is recognised as paint code', () {
    final code = DartExporter(
      drawing,
      options: const ExportOptions(
        style: CodeStyle.monolithic,
        colorConstants: false,
      ),
    ).generate().single.content;

    final result = importCode(code, palette: const {}, canvasSize: size);
    expect(result.isReadable, isTrue);
    expect(result.hasPaintCode, isTrue);
    expect(result.shapes, hasLength(_shapes.length));
    expect(result.skipped, 0);
  });

  test('imported shapes keep their kinds and colours', () {
    final code = DartExporter(
      drawing,
      options: const ExportOptions(
        style: CodeStyle.monolithic,
        colorConstants: false,
      ),
    ).generate().single.content;

    final shapes = importCode(code, palette: const {}, canvasSize: size).shapes;
    expect(shapes.map((s) => s.kind), _shapes.map((s) => s.kind));
    expect(shapes.map((s) => s.fill), _shapes.map((s) => s.fill));
  });

  test('unbalanced brackets are reported, not thrown', () {
    final result = importCode(
      'class A { void paint(Canvas c) {',
      palette: const {},
      canvasSize: size,
    );
    expect(result.isReadable, isFalse);
    expect(result.shapes, isEmpty);
  });

  test('plain text with no paint code imports nothing', () {
    final result = importCode(
      'class A { int x = 1; }',
      palette: const {},
      canvasSize: size,
    );
    expect(result.hasPaintCode, isFalse);
    expect(result.shapes, isEmpty);
  });

  test('readPalette picks up named colour constants', () {
    final palette = readPalette([
      'class P { static const Color red = Color(0xFFFF0000); }',
    ]);
    expect(palette['red'], 0xFFFF0000);
  });
}
