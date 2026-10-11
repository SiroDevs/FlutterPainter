// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:flutter_painter/editor/draw_ops.dart';
import 'package:flutter_painter/editor/editor_controller.dart';
import 'package:flutter_painter/editor/history.dart';
import 'package:flutter_painter/editor/vertex_ops.dart';
import 'package:flutter_painter/model/shape.dart';

EditorController _withPolyline() {
  final c = EditorController();
  c.draft = c.newShape(ShapeKind.polygon, [
    const Offset(0, 0),
    const Offset(20, 0),
    const Offset(20, 20),
  ]);
  c.finishPolygon(closed: false);
  c.selected = 0;
  return c;
}

void main() {
  group('History', () {
    test('tracks which state matches the saved one', () {
      final h = History()..reset('a');
      expect(h.isAtSaved, isTrue);
      h.push('b');
      expect(h.isAtSaved, isFalse);
      h.markSaved();
      expect(h.isAtSaved, isTrue);
      h.push('c');
      expect(h.isAtSaved, isFalse);
      h.undo();
      expect(h.isAtSaved, isTrue, reason: 'undoing back to the saved state is clean');
    });

    test('a recovered draft is never at the saved state', () {
      final h = History()
        ..reset('a')
        ..markUnsaved();
      expect(h.isAtSaved, isFalse);
    });

    test('pushing after undo drops the redo branch and the saved marker with it', () {
      final h = History()..reset('a');
      h.push('b');
      h.markSaved();
      h.undo();
      h.push('c');
      expect(h.canRedo, isFalse);
      expect(h.isAtSaved, isFalse);
    });

    test('pushing an identical state is a no-op', () {
      final h = History()..reset('a');
      expect(h.push('a'), isFalse);
    });
  });

  group('shapes from lines', () {
    test('Enter leaves the polygon tool as an open line path', () {
      final c = _withPolyline();
      expect(c.layer.shapes.single.kind, ShapeKind.line);
      expect(c.layer.shapes.single.points.length, 3);
    });

    test('closing turns a path into a fillable polygon and back', () {
      final c = _withPolyline();
      c.setClosed(true);
      expect(c.selectedShape!.kind, ShapeKind.polygon);
      expect(c.selectedShape!.fill, isNotNull);
      c.setClosed(false);
      expect(c.selectedShape!.kind, ShapeKind.line);
      expect(c.selectedShape!.fill, isNull);
    });

    test('closing finishes a polygon with 3+ points', () {
      final c = EditorController();
      c.draft = c.newShape(ShapeKind.polygon,
          [const Offset(0, 0), const Offset(9, 0), const Offset(9, 9)]);
      c.finishPolygon();
      expect(c.layer.shapes.single.kind, ShapeKind.polygon);
    });

    test('double-clicking an edge inserts a point on it', () {
      final c = _withPolyline();
      expect(c.insertVertexAt(const Offset(10, 0.5), 2), isTrue);
      expect(c.selectedShape!.points[1].dx, closeTo(10, 0.01));
      expect(c.selectedShape!.points.length, 4);
    });

    test('points can be removed down to the minimum', () {
      final c = _withPolyline();
      expect(c.removeVertex(1), isTrue);
      expect(c.selectedShape!.points.length, 2);
      expect(c.removeVertex(0), isFalse, reason: 'a line keeps 2 points');
    });
  });

  group('unsaved changes', () {
    test('a new project is pristine until something is drawn', () {
      final c = EditorController();
      expect(c.dirty, isFalse);
      expect(c.isPristine, isTrue);
      c.draft = c.newShape(ShapeKind.rect, [const Offset(0, 0), const Offset(5, 5)]);
      c.commitDraft();
      expect(c.dirty, isTrue);
      expect(c.isPristine, isFalse);
    });

    test('undo back to the start is clean again', () {
      final c = EditorController();
      c.draft = c.newShape(ShapeKind.rect, [const Offset(0, 0), const Offset(5, 5)]);
      c.commitDraft();
      c.undo();
      expect(c.dirty, isFalse);
    });

    test('revision only moves when something really changed', () {
      final c = EditorController();
      final before = c.revision;
      c.changed();
      expect(c.revision, before);
    });
  });
}
