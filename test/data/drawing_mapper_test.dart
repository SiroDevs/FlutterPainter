// Dart imports:
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:flutter_painter/data/mappers/draft_mapper.dart';
import 'package:flutter_painter/data/mappers/drawing_mapper.dart';
import 'package:flutter_painter/domain/models/draft.dart';
import 'package:flutter_painter/domain/models/drawing.dart';
import 'package:flutter_painter/domain/models/paint_layer.dart';
import 'package:flutter_painter/domain/models/reference_image.dart';
import 'package:flutter_painter/domain/models/shape.dart';
import 'package:flutter_painter/domain/models/shape_kind.dart';

Drawing _sample() => Drawing(name: 'Rider', layers: [
      PaintLayer(name: 'Bike', shapes: [
        Shape(
          kind: ShapeKind.rect,
          name: 'Tyre',
          points: const [Offset(10, 20), Offset(30, 40)],
          fill: 0xFF151518,
          radius: 4,
        ),
      ]),
      PaintLayer(name: 'Body', shapes: [
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
  test('a drawing survives a JSON round trip', () {
    final d = _sample();
    expect(drawingFromJson(drawingToJson(d)), d);
    expect(drawingFromJson(drawingToJson(d, pretty: true)), d);
  });

  test('project files carry the flp format marker', () {
    expect(drawingToMap(_sample())['format'], 'flp');
    expect(drawingToMap(_sample())['version'], flpVersion);
  });

  test('the reference image round trips with its pixels and settings', () {
    final bytes = Uint8List.fromList(List.generate(64, (i) => i));
    final d = _sample().copyWith(
      reference: ReferenceImage.fromBytes(bytes).copyWith(x: 3, scale: 0.5, opacity: 0.25),
    );
    final back = drawingFromJson(drawingToJson(d)).reference!;
    expect(back.bytes, bytes);
    expect(back.x, 3);
    expect(back.scale, 0.5);
    expect(back.opacity, 0.25);
    expect(back.id, d.reference!.id);
  });

  test('a file with no reference has none', () {
    expect(drawingFromJson(drawingToJson(_sample())).reference, isNull);
  });

  test('a draft round trips with its path and time', () {
    final draft = Draft(
      tabId: 'abc-1',
      path: '/art/rider.flp',
      drawing: _sample(),
      savedAt: DateTime.utc(2026, 10, 12, 8, 30),
    );
    final back = draftFromJson(draftToJson(draft));
    expect(back, draft);
    expect(back.title, 'rider');
  });

  test('an unsaved draft is titled after its drawing', () {
    final draft = Draft(tabId: 't', drawing: _sample(), savedAt: DateTime.utc(2026));
    expect(draft.title, 'Rider');
  });

  test('the rider template loads with its five layers', () {
    final d = drawingFromJson(File('assets/templates/rider.json').readAsStringSync());
    expect(d.layers.map((l) => l.name),
        ['Shadow', 'Bike', 'Body', 'Handlebars', 'Helmet']);
    expect(d.layers.fold<int>(0, (n, l) => n + l.shapes.length), 47);
  });
}
