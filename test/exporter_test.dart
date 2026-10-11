// Dart imports:
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:flutter_painter/export/code_format.dart';
import 'package:flutter_painter/export/dart_exporter.dart';
import 'package:flutter_painter/model/drawing.dart';
import 'package:flutter_painter/model/reference_image.dart';
import 'package:flutter_painter/model/shape.dart';

Drawing _sample() => Drawing(name: 'Rider', layers: [
      Layer(name: 'Bike', shapes: [
        Shape(
          kind: ShapeKind.rect,
          name: 'Tyre',
          points: const [Offset(10, 20), Offset(30, 40)],
          fill: 0xFF151518,
          radius: 4,
        ),
      ]),
      Layer(name: 'Body', shapes: [
        Shape(
          kind: ShapeKind.polygon,
          points: const [Offset(0, 0), Offset(10, 0), Offset(5, 8)],
          fill: 0xFFC63F96,
          stroke: 0xFF000000,
          strokeWidth: 2,
        ),
      ]),
    ]);

void main() {
  test('fmt always produces a double literal', () {
    expect(fmt(120), '120.0');
    expect(fmt(10.5), '10.5');
    expect(fmt(3.456), '3.46');
    expect(fmt(-0.001), '0.0');
  });

  test('drawing survives a JSON round trip', () {
    final d = _sample();
    expect(Drawing.decode(d.encode()).encode(), d.encode());
  });

  test('project files carry the flp format marker', () {
    expect(_sample().toJson()['format'], 'flp');
  });

  test('reference image round trips with and without pixel data', () {
    final bytes = Uint8List.fromList(List.generate(64, (i) => i));
    final d = _sample()..reference = ReferenceImage.fromBytes(bytes);
    d.reference!
      ..x = 3
      ..scale = 0.5
      ..opacity = 0.25;

    final full = Drawing.decode(d.encode());
    expect(full.reference!.bytes, bytes);
    expect(full.reference!.opacity, 0.25);

    // Undo snapshots omit the pixels; they come back through the lookup.
    final light = d.encode(withImage: false);
    expect(light.contains('"data"'), isFalse);
    final restored = Drawing.decode(light, lookup: (id) => bytes);
    expect(restored.reference!.bytes, bytes);
    expect(Drawing.decode(light).reference, isNull);
  });

  test('class-per-layer export names classes after the layers', () {
    final code = DartExporter(_sample(), classPerLayer: true).generate();
    expect(code, contains('class RiderBike {'));
    expect(code, contains('class RiderBody {'));
    expect(code, contains('class RiderPainter {'));
    expect(
      code,
      contains('canvas.drawRRect(RRect.fromRectXY('
          'const Rect.fromLTRB(10.0, 20.0, 30.0, 40.0), 4.0, 4.0), _paint);'),
    );
    expect(code, contains('..color = const Color(0xFF151518);'));
    expect(code, contains('..close();'));
  });

  test('open line paths export without close()', () {
    final d = Drawing(name: 'Path', layers: [
      Layer(name: 'Main', shapes: [
        Shape(
          kind: ShapeKind.line,
          points: const [Offset(0, 0), Offset(5, 5), Offset(9, 1)],
          stroke: 0xFF000000,
        ),
      ]),
    ]);
    final code = DartExporter(d).generate();
    expect(code, contains('..lineTo(9.0, 1.0);'));
    expect(code, isNot(contains('..close()')));
  });

  test('single-class export has one method per layer', () {
    final code = DartExporter(_sample()).generate();
    expect(code, contains('void paintBike(Canvas canvas)'));
    expect(code, contains('void paintBody(Canvas canvas)'));
    expect(code, isNot(contains('class RiderBike')));
  });

  test('hidden layers are not exported', () {
    final d = _sample()..layers[0].visible = false;
    expect(DartExporter(d).generate(), isNot(contains('paintBike')));
  });

  test('the rider template loads and exports every layer', () {
    final text = File('assets/templates/rider.json').readAsStringSync();
    final d = Drawing.decode(text);
    expect(d.layers.map((l) => l.name),
        ['Shadow', 'Bike', 'Body', 'Handlebars', 'Helmet']);
    final code = DartExporter(d, classPerLayer: true).generate();
    for (final n in ['Shadow', 'Bike', 'Body', 'Handlebars', 'Helmet']) {
      expect(code, contains('class Rider$n {'));
    }
  });
}
