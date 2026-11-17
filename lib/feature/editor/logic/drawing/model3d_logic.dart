// Project imports:
import '../../../../domain/models/model3d/model3d.dart';
import '../../../../domain/models/model3d/point3.dart';
import '../../../../domain/models/model3d/view_angle.dart';
import '../../bloc/editor_bloc.dart';
import 'editor_ops.dart';

/// Making layers 3D and editing their setup.
abstract class Model3dLogic {
  Model3dLogic._();

  static const double _sideTurn = 0.32;

  /// Makes the active layer 3D, turning around the bottom centre of the canvas.
  static EditorState create(
    EditorState s, {
    required String straight,
    required String left,
    required String right,
  }) {
    if (s.layer.model != null) return s;
    final model = Model3d(
      pivot: Point3(s.drawing.width / 2, s.drawing.height, 0),
      views: [
        ViewAngle(name: straight),
        ViewAngle(name: left, yaw: -_sideTurn),
        ViewAngle(name: right, yaw: _sideTurn),
      ],
    );
    return _withModel(s, model).commit();
  }

  /// Turns the active layer back into a flat one, keeping its shapes.
  static EditorState remove(EditorState s) {
    if (s.layer.model == null) return s;
    return _withModel(s, null).copyWith(previewView: null).commit();
  }

  /// Applies [change] to the 3D setup of the active layer (no history entry).
  static EditorState edit(
    EditorState s,
    Model3d Function(Model3d model) change,
  ) {
    final model = s.layer.model;
    return model == null ? s : _withModel(s, change(model));
  }

  /// Sets depth and thickness on the selected shapes (no history entry).
  static EditorState setDepth(
    EditorState s, {
    double? depth,
    double? thickness,
  }) => s.withShapeChanges({
    for (final index in s.validSelectedIndices)
      index: s.layer.shapes[index].copyWith(
        depth: depth,
        thickness: thickness,
      ),
  });

  static EditorState preview(EditorState s, int? viewIndex) =>
      s.layer.model == null ? s : s.copyWith(previewView: viewIndex);

  static EditorState ghost(EditorState s, int? layerIndex) =>
      s.copyWith(ghostLayer: layerIndex);

  static EditorState _withModel(EditorState s, Model3d? model) => s.withLayers(
    replacedAt(s.drawing.layers, s.layerIndex, s.layer.copyWith(model: model)),
  );
}
