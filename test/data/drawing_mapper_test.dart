// Dart imports:
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:flutter_painter/data/mappers/drawing_mapper.dart';
import 'package:flutter_painter/domain/models/drawing/drawing.dart';
import 'package:flutter_painter/domain/models/drawing/paint_layer.dart';
import 'package:flutter_painter/domain/models/drawing/project_format_exception.dart';
import 'package:flutter_painter/domain/models/drawing/reference_image.dart';
import 'package:flutter_painter/domain/models/shapes/shape.dart';
import 'package:flutter_painter/domain/models/shapes/shape_gradient.dart';
import 'package:flutter_painter/domain/models/shapes/shape_kind.dart';

Drawing _sample() => Drawing(
  name: 'Rider',
  width: 100,
  height: 150,
  layers: [
    PaintLayer(
      name: 'Body',
      shapes: [
        const Shape(
          kind: ShapeKind.rect,
          points: [Offset(1, 2), Offset(30, 40)],
          name: 'torso',
          fill: 0xFFFF0000,
          stroke: 0xFF000000,
          strokeWidth: 2,
          radius: 3,
          rotation: 0.5,
        ),
        Shape(
          kind: ShapeKind.polygon,
          points: const [Offset(0, 0), Offset(10, 0), Offset(5, 8)],
          fill: 0xFF00FF00,
          groupId: 'g1',
          groupName: 'Helmet',
          visible: false,
          gradient: ShapeGradient.initial(
            GradientKind.linear,
            0xFF00FF00,
            0xFF0000FF,
          ),
        ),
        const Shape(
          kind: ShapeKind.freehand,
          points: [Offset(0, 0), Offset(1, 1), Offset(2, 0)],
          stroke: 0xFF123456,
        ),
      ],
    ),
    PaintLayer(
      name: 'Trace',
      visible: false,
      image: ReferenceImage.fromBytes(Uint8List.fromList([1, 2, 3, 4, 5])),
    ),
  ],
);

void main() {
  group('.flp mapping', () {
    test('round-trips a drawing exactly', () {
      final d = _sample();
      expect(drawingFromJson(drawingToJson(d)), d);
    });

    test('pretty and compact JSON decode to the same drawing', () {
      final d = _sample();
      expect(
        drawingFromJson(drawingToJson(d, pretty: true)),
        drawingFromJson(drawingToJson(d)),
      );
    });

    test('writes format and version', () {
      final map = drawingToMap(_sample());
      expect(map['format'], flpFormat);
      expect(map['version'], flpVersion);
    });

    test('keeps image bytes through the round trip', () {
      final back = drawingFromJson(drawingToJson(_sample()));
      expect(back.layers[1].image!.bytes, [1, 2, 3, 4, 5]);
    });

    test('fills in defaults for missing optional fields', () {
      final d = drawingFromMap({
        'layers': [
          {
            'name': 'L',
            'shapes': [
              {
                'kind': 'line',
                'points': [
                  [0, 0],
                  [1, 1],
                ],
              },
            ],
          },
        ],
      });
      expect(d.name, 'Untitled');
      expect(d.width, 120);
      expect(d.height, 170);
      final s = d.layers.single.shapes.single;
      expect(s.strokeWidth, 1);
      expect(s.visible, isTrue);
      expect(s.rotation, 0);
      expect(d.layers.single.visible, isTrue);
    });

    test('version 1 background picture moves onto the bottom layer', () {
      final d = drawingFromMap({
        'layers': [
          {'name': 'Bottom', 'shapes': []},
          {'name': 'Top', 'shapes': []},
        ],
        'reference': {'data': base64Encode([9, 9, 9])},
      });
      expect(d.layers.first.image, isNotNull);
      expect(d.layers.last.image, isNull);
    });

    test('a picture without data is ignored', () {
      expect(referenceFromJson({'x': 1}), isNull);
    });

    Matcher problem(ProjectFormatProblem p) => throwsA(
      isA<ProjectFormatException>().having((e) => e.problem, 'problem', p),
    );

    test('unknown shape kinds are reported as a damaged project', () {
      expect(
        () => drawingFromMap({
          'layers': [
            {
              'name': 'L',
              'shapes': [
                {'kind': 'bezier', 'points': []},
              ],
            },
          ],
        }),
        problem(ProjectFormatProblem.damaged),
      );
    });

    test('text that is not JSON is reported as damaged', () {
      expect(
        () => drawingFromJson('not json'),
        problem(ProjectFormatProblem.damaged),
      );
    });

    test('JSON that is not an object is reported as damaged', () {
      expect(
        () => drawingFromJson('[1, 2]'),
        problem(ProjectFormatProblem.damaged),
      );
    });

    test('a project with no layers is reported as damaged', () {
      expect(
        () => drawingFromJson('{}'),
        problem(ProjectFormatProblem.damaged),
      );
    });

    test('wrongly typed fields are reported as damaged', () {
      expect(
        () => drawingFromMap({'layers': 'oops'}),
        problem(ProjectFormatProblem.damaged),
      );
    });

    test('another format is refused', () {
      expect(
        () => drawingFromMap({'format': 'svg', 'layers': []}),
        problem(ProjectFormatProblem.damaged),
      );
    });

    test('a file from a newer version is refused with its own problem', () {
      expect(
        () => drawingFromMap({
          'format': flpFormat,
          'version': flpVersion + 1,
          'layers': [],
        }),
        problem(ProjectFormatProblem.newerVersion),
      );
    });

    test('the current and older versions still load', () {
      for (final v in [1, flpVersion]) {
        expect(
          drawingFromMap({'format': flpFormat, 'version': v, 'layers': []}),
          isA<Drawing>(),
        );
      }
    });
  });
}
