import 'dart:ui';

import 'package:flutter_painter/domain/models/drawing/drawing.dart';
import 'package:flutter_painter/domain/models/drawing/paint_layer.dart';
import 'package:flutter_painter/domain/models/shapes/shape.dart';
import 'package:flutter_painter/domain/models/shapes/shape_kind.dart';
import 'package:flutter_painter/feature/editor/bloc/editor_bloc.dart';
import 'package:flutter_painter/feature/editor/logic/exports.dart';
import 'package:flutter_painter/feature/editor/models/editor_seed.dart';
import 'package:flutter_test/flutter_test.dart';

Shape _block(String name) => Shape(
  kind: ShapeKind.rect,
  points: const [Offset(0, 0), Offset(10, 10)],
  name: name,
  fill: 0xFF336699,
);

EditorState _flat() => EditorState.fromSeed(
  EditorSeed(
    tabId: 'test',
    drawing: Drawing(
      name: 'Test',
      layers: [
        PaintLayer(name: 'Layer', shapes: [_block('First'), _block('Second')]),
      ],
    ),
  ),
);

EditorState _model3d() =>
    Model3dLogic.create(_flat(), straight: 'S', left: 'L', right: 'R');

void main() {
  test('making a layer 3D adds three views and one undo step', () {
    final state = _model3d();
    final model = state.layer.model!;
    expect(model.views.map((view) => view.name), ['S', 'L', 'R']);
    expect(model.views[1].yaw, lessThan(0));
    expect(model.views[2].yaw, greaterThan(0));
    expect(model.pivot.dx, state.drawing.width / 2);
    expect(model.pivot.dy, state.drawing.height);
    expect(state.canUndo, isTrue);
  });

  test('making an already 3D layer 3D again changes nothing', () {
    final state = _model3d();
    final again = Model3dLogic.create(state, straight: 'a', left: 'b', right: 'c');
    expect(identical(again, state), isTrue);
  });

  test('going back to flat keeps the shapes and turns the preview off', () {
    final previewing = Model3dLogic.preview(_model3d(), 1);
    final flat = Model3dLogic.remove(previewing);
    expect(flat.layer.model, isNull);
    expect(flat.layer.shapes.length, 2);
    expect(flat.previewView, isNull);
  });

  test('undo takes a layer back from 3D', () {
    final undone = HistoryLogic.undo(_model3d());
    expect(undone.layer.model, isNull);
  });

  test('depth and thickness go to every selected shape only', () {
    final selected = _model3d().selectIndices([1]);
    final changed = Model3dLogic.setDepth(selected, depth: 12, thickness: 4);
    expect(changed.layer.shapes[0].depth, 0);
    expect(changed.layer.shapes[1].depth, 12);
    expect(changed.layer.shapes[1].thickness, 4);
    final onlyDepth = Model3dLogic.setDepth(changed, depth: -3);
    expect(onlyDepth.layer.shapes[1].thickness, 4);
  });

  test('the comparison layer can be picked and cleared', () {
    final picked = Model3dLogic.ghost(_model3d(), 0);
    expect(picked.ghostLayer, 0);
    expect(Model3dLogic.ghost(picked, null).ghostLayer, isNull);
  });

  test('the preview needs a 3D layer and a view to show', () {
    expect(Model3dLogic.preview(_flat(), 0).previewAngle, isNull);
    final state = _model3d();
    expect(Model3dLogic.preview(state, 2).previewAngle?.name, 'R');
    expect(Model3dLogic.preview(state, 9).previewAngle?.name, 'R');
    expect(state.previewAngle, isNull);
    final noViews = Model3dLogic.edit(
      Model3dLogic.preview(state, 0),
      (model) => model.copyWith(views: const []),
    );
    expect(noViews.previewAngle, isNull);
  });
}
