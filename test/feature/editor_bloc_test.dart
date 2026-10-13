// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:flutter_painter/domain/models/drawing.dart';
import 'package:flutter_painter/domain/models/shape_kind.dart';
import 'package:flutter_painter/domain/models/tool.dart';
import 'package:flutter_painter/feature/editor/bloc/editor_bloc.dart';
import 'package:flutter_painter/feature/editor/logic/editor_ops.dart';
import 'package:flutter_painter/feature/editor/models/editor_seed.dart';

EditorBloc _bloc({Drawing? drawing, bool recovered = false}) => EditorBloc(
      EditorSeed(
        tabId: 't1',
        drawing: drawing ?? const Drawing(name: 'Untitled'),
        recovered: recovered,
      ),
    );

/// Sends [events] and waits for the bloc to handle them all.
Future<void> send(EditorBloc bloc, List<EditorEvent> events) async {
  events.forEach(bloc.add);
  await pumpEventQueue();
}

/// Draws a rectangle with the rectangle tool.
Future<void> drawRect(EditorBloc bloc, Offset a, Offset b) => send(bloc, [
      const EditorEvent.toolSelected(Tool.rect),
      EditorEvent.pointerPressed(a),
      EditorEvent.pointerMoved(b),
      const EditorEvent.pointerReleased(),
    ]);

void main() {
  group('drawing', () {
    test('dragging with the rectangle tool adds a snapped rectangle', () async {
      final bloc = _bloc();
      await drawRect(bloc, const Offset(10.2, 9.8), const Offset(30.4, 40.1));
      final shapes = bloc.state.layer.shapes;
      expect(shapes.length, 1);
      expect(shapes.first.kind, ShapeKind.rect);
      expect(shapes.first.bounds, const Rect.fromLTRB(10, 10, 30, 40));
      expect(bloc.state.draft, isNull);
    });

    test('a stray click draws nothing', () async {
      final bloc = _bloc();
      await send(bloc, [
        const EditorEvent.toolSelected(Tool.ellipse),
        const EditorEvent.pointerPressed(Offset(5, 5)),
        const EditorEvent.pointerReleased(),
      ]);
      expect(bloc.state.layer.shapes, isEmpty);
    });

    test('Shift makes a square', () async {
      final bloc = _bloc();
      await send(bloc, [
        const EditorEvent.toolSelected(Tool.rect),
        const EditorEvent.pointerPressed(Offset(10, 10)),
        const EditorEvent.pointerMoved(Offset(30, 20), shift: true),
        const EditorEvent.pointerReleased(),
      ]);
      final b = bloc.state.layer.shapes.single.bounds;
      expect(b.width, b.height);
    });

    test('freehand collects points while dragging', () async {
      final bloc = _bloc();
      await send(bloc, [
        const EditorEvent.toolSelected(Tool.freehand),
        const EditorEvent.pointerPressed(Offset(0, 0)),
        const EditorEvent.pointerMoved(Offset(3, 1)),
        const EditorEvent.pointerMoved(Offset(6, 4)),
        const EditorEvent.pointerReleased(),
      ]);
      final s = bloc.state.layer.shapes.single;
      expect(s.kind, ShapeKind.freehand);
      expect(s.points.length, greaterThan(2));
    });
  });

  group('shapes from lines', () {
    Future<EditorBloc> threePoints() async {
      final bloc = _bloc();
      await send(bloc, [
        const EditorEvent.toolSelected(Tool.polygon),
        const EditorEvent.pointerPressed(Offset(0, 0), timeMs: 1000),
        const EditorEvent.pointerPressed(Offset(20, 0), timeMs: 2000),
        const EditorEvent.pointerPressed(Offset(20, 20), timeMs: 3000),
      ]);
      return bloc;
    }

    test('Enter leaves the path open as a line', () async {
      final bloc = await threePoints();
      await send(bloc, [const EditorEvent.polygonFinished(closed: false)]);
      final s = bloc.state.layer.shapes.single;
      expect(s.kind, ShapeKind.line);
      expect(s.points.length, 3);
      expect(s.fill, isNull);
    });

    test('Shift+Enter closes it into a polygon', () async {
      final bloc = await threePoints();
      await send(bloc, [const EditorEvent.polygonFinished()]);
      expect(bloc.state.layer.shapes.single.kind, ShapeKind.polygon);
    });

    test('clicking the first point closes the polygon', () async {
      final bloc = await threePoints();
      await send(bloc, [const EditorEvent.pointerPressed(Offset(0, 0), timeMs: 4000)]);
      final s = bloc.state.layer.shapes.single;
      expect(s.kind, ShapeKind.polygon);
      expect(s.points.length, 3);
    });

    test('a double-click closes the polygon without adding a point', () async {
      final bloc = await threePoints();
      await send(bloc, [const EditorEvent.pointerPressed(Offset(7, 7), timeMs: 3100)]);
      final s = bloc.state.layer.shapes.single;
      expect(s.kind, ShapeKind.polygon);
      expect(s.points.length, 3);
    });

    test('Esc-style cancel throws the half-drawn shape away', () async {
      final bloc = await threePoints();
      await send(bloc, [const EditorEvent.draftCancelled()]);
      expect(bloc.state.layer.shapes, isEmpty);
      expect(bloc.state.draft, isNull);
    });

    test('a path can be closed and reopened from Properties', () async {
      final bloc = await threePoints();
      await send(bloc, [
        const EditorEvent.polygonFinished(closed: false),
        const EditorEvent.toolSelected(Tool.select),
        const EditorEvent.pointerPressed(Offset(10, 0), timeMs: 9000),
        const EditorEvent.pointerReleased(),
        const EditorEvent.closedToggled(true),
      ]);
      expect(bloc.state.selectedShape!.kind, ShapeKind.polygon);
      await send(bloc, [const EditorEvent.closedToggled(false)]);
      expect(bloc.state.selectedShape!.kind, ShapeKind.line);
    });

    test('double-clicking an edge adds a point; Alt-click removes one', () async {
      final bloc = await threePoints();
      await send(bloc, [
        const EditorEvent.polygonFinished(closed: false),
        const EditorEvent.toolSelected(Tool.select),
        const EditorEvent.pointerPressed(Offset(10, 0), timeMs: 5000),
        const EditorEvent.pointerReleased(),
        const EditorEvent.pointerPressed(Offset(10, 0.4), timeMs: 5100),
        const EditorEvent.pointerReleased(),
      ]);
      expect(bloc.state.selectedShape!.points.length, 4);

      await send(bloc, [
        const EditorEvent.pointerPressed(Offset(20, 20), alt: true, timeMs: 9000),
        const EditorEvent.pointerReleased(),
      ]);
      expect(bloc.state.selectedShape!.points.length, 3);
    });
  });

  group('selecting and editing', () {
    test('dragging a selected shape moves it, and undo puts it back', () async {
      final bloc = _bloc();
      await drawRect(bloc, const Offset(10, 10), const Offset(30, 30));
      await send(bloc, [
        const EditorEvent.toolSelected(Tool.select),
        const EditorEvent.pointerPressed(Offset(20, 20), timeMs: 1000),
        const EditorEvent.pointerMoved(Offset(25, 30)),
        const EditorEvent.pointerReleased(),
      ]);
      expect(bloc.state.selectedShape!.bounds, const Rect.fromLTRB(15, 20, 35, 40));

      await send(bloc, [const EditorEvent.undoRequested()]);
      expect(bloc.state.layer.shapes.single.bounds, const Rect.fromLTRB(10, 10, 30, 30));
      await send(bloc, [const EditorEvent.redoRequested()]);
      expect(bloc.state.layer.shapes.single.bounds, const Rect.fromLTRB(15, 20, 35, 40));
    });

    test('dragging a corner handle resizes', () async {
      final bloc = _bloc();
      await drawRect(bloc, const Offset(10, 10), const Offset(30, 30));
      await send(bloc, [
        const EditorEvent.toolSelected(Tool.select),
        const EditorEvent.pointerPressed(Offset(20, 20), timeMs: 1000),
        const EditorEvent.pointerReleased(),
        const EditorEvent.pointerPressed(Offset(30, 30), timeMs: 5000),
        const EditorEvent.pointerMoved(Offset(40, 50)),
        const EditorEvent.pointerReleased(),
      ]);
      expect(bloc.state.selectedShape!.bounds, const Rect.fromLTRB(10, 10, 40, 50));
    });

    test('picking a colour paints the selected shape', () async {
      final bloc = _bloc();
      await drawRect(bloc, const Offset(10, 10), const Offset(30, 30));
      await send(bloc, [
        const EditorEvent.toolSelected(Tool.select),
        const EditorEvent.pointerPressed(Offset(20, 20), timeMs: 1000),
        const EditorEvent.pointerReleased(),
        const EditorEvent.colorPicked(0xFF00FF00),
        const EditorEvent.strokeToggled(false),
      ]);
      expect(bloc.state.selectedShape!.fill, 0xFF00FF00);
      expect(bloc.state.selectedShape!.stroke, isNull);
    });

    test('slider drags apply at once and are recorded when committed', () async {
      final bloc = _bloc();
      await drawRect(bloc, const Offset(10, 10), const Offset(30, 30));
      await send(bloc, [
        const EditorEvent.toolSelected(Tool.select),
        const EditorEvent.pointerPressed(Offset(20, 20), timeMs: 1000),
        const EditorEvent.pointerReleased(),
        const EditorEvent.strokeWidthChanged(5),
      ]);
      expect(bloc.state.selectedShape!.strokeWidth, 5);
      expect(bloc.state.dirty, isTrue);
      final before = bloc.state.history.states.length;
      await send(bloc, [const EditorEvent.changesCommitted()]);
      expect(bloc.state.history.states.length, before + 1);
    });

    test('delete, duplicate and reorder act on the selection', () async {
      final bloc = _bloc();
      await drawRect(bloc, const Offset(0, 0), const Offset(10, 10));
      await drawRect(bloc, const Offset(20, 20), const Offset(30, 30));
      await send(bloc, [
        const EditorEvent.toolSelected(Tool.select),
        const EditorEvent.pointerPressed(Offset(5, 5), timeMs: 1000),
        const EditorEvent.pointerReleased(),
        const EditorEvent.shapeReordered(1),
      ]);
      expect(bloc.state.layer.shapes.last.bounds, const Rect.fromLTRB(0, 0, 10, 10));

      await send(bloc, [const EditorEvent.shapeDuplicated()]);
      expect(bloc.state.layer.shapes.length, 3);
      await send(bloc, [const EditorEvent.shapeDeleted()]);
      expect(bloc.state.layer.shapes.length, 2);
      expect(bloc.state.selected, isNull);
    });
  });

  group('layers', () {
    test('add, move, rename, hide and delete', () async {
      final bloc = _bloc();
      await send(bloc, [const EditorEvent.layerAdded()]);
      expect(bloc.state.drawing.layers.length, 2);
      expect(bloc.state.layerIndex, 1);

      await send(bloc, [
        const EditorEvent.layerRenamed(1, 'Top'),
        const EditorEvent.layerMoved(1, -1),
      ]);
      expect(bloc.state.drawing.layers.first.name, 'Top');
      expect(bloc.state.layerIndex, 0);

      await send(bloc, [const EditorEvent.layerVisibilityToggled(0)]);
      expect(bloc.state.drawing.layers.first.visible, isFalse);

      await send(bloc, [const EditorEvent.layerDeleted(0)]);
      expect(bloc.state.drawing.layers.length, 1);
      await send(bloc, [const EditorEvent.layerDeleted(0)]);
      expect(bloc.state.drawing.layers.length, 1, reason: 'the last layer stays');
    });

    test('moving a shape to another layer', () async {
      final bloc = _bloc();
      await drawRect(bloc, const Offset(0, 0), const Offset(10, 10));
      await send(bloc, [
        const EditorEvent.layerAdded(),
        const EditorEvent.layerActivated(0),
        const EditorEvent.toolSelected(Tool.select),
        const EditorEvent.pointerPressed(Offset(5, 5), timeMs: 1000),
        const EditorEvent.pointerReleased(),
        const EditorEvent.shapeMovedToLayer(1),
      ]);
      expect(bloc.state.drawing.layers[0].shapes, isEmpty);
      expect(bloc.state.drawing.layers[1].shapes.length, 1);
      expect(bloc.state.layerIndex, 1);
    });
  });

  group('unsaved changes', () {
    test('a new project is pristine until something is drawn', () async {
      final bloc = _bloc();
      expect(bloc.state.dirty, isFalse);
      expect(bloc.state.isPristine, isTrue);
      await drawRect(bloc, const Offset(0, 0), const Offset(5, 5));
      expect(bloc.state.dirty, isTrue);
      expect(bloc.state.isPristine, isFalse);
    });

    test('undo back to the start is clean again', () async {
      final bloc = _bloc();
      await drawRect(bloc, const Offset(0, 0), const Offset(5, 5));
      await send(bloc, [const EditorEvent.undoRequested()]);
      expect(bloc.state.dirty, isFalse);
    });

    test('saving marks everything clean and remembers the file', () async {
      final bloc = _bloc();
      await drawRect(bloc, const Offset(0, 0), const Offset(5, 5));
      await send(bloc, [const EditorEvent.documentSaved('/art/x.flp')]);
      expect(bloc.state.dirty, isFalse);
      expect(bloc.state.filePath, '/art/x.flp');
      expect(bloc.state.overwriteConfirmed, isTrue);

      await drawRect(bloc, const Offset(10, 10), const Offset(20, 20));
      expect(bloc.state.dirty, isTrue);
    });

    test('a recovered draft starts dirty', () {
      expect(_bloc(recovered: true).state.dirty, isTrue);
    });

    test('revision only moves when something really changed', () async {
      final bloc = _bloc();
      final before = bloc.state.revision;
      await send(bloc, [const EditorEvent.changesCommitted()]);
      expect(bloc.state.revision, before);
      await drawRect(bloc, const Offset(0, 0), const Offset(5, 5));
      expect(bloc.state.revision, greaterThan(before));
    });
  });

  group('view', () {
    test('the first viewport size fits the drawing in it', () async {
      final bloc = _bloc();
      await send(bloc, [const EditorEvent.viewportChanged(Size(800, 600))]);
      expect(bloc.state.view.needsFit, isFalse);
      expect(bloc.state.view.zoom, closeTo((600 - 60) / 170, 0.001));
    });

    test('zoom keeps the point under the cursor fixed', () async {
      final bloc = _bloc();
      await send(bloc, [const EditorEvent.viewportChanged(Size(800, 600))]);
      const focal = Offset(300, 200);
      Offset design() => (focal - bloc.state.view.pan) / bloc.state.view.zoom;
      final before = design();
      await send(bloc, [const EditorEvent.viewZoomed(1.5, focal)]);
      expect(design().dx, closeTo(before.dx, 0.001));
      expect(design().dy, closeTo(before.dy, 0.001));
    });

    test('resizing the canvas is an undoable edit', () async {
      final bloc = _bloc();
      await send(bloc, [const EditorEvent.canvasResized(200, 100)]);
      expect(bloc.state.drawing.width, 200);
      await send(bloc, [const EditorEvent.undoRequested()]);
      expect(bloc.state.drawing.width, 120);
    });
  });
}
