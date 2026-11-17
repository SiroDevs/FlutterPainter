part of 'editor_bloc.dart';

/// Turns the active layer into a 3D layer, naming its first three views.
class Model3dCreated extends EditorEvent {
  const Model3dCreated({
    required this.straight,
    required this.left,
    required this.right,
  });

  final String straight;
  final String left;
  final String right;
}

class Model3dRemoved extends EditorEvent {
  const Model3dRemoved();
}

/// Changes the active layer's 3D setup. Follow it with [ChangesCommitted]
/// when the change is final, so it becomes one undo step.
class Model3dEdited extends EditorEvent {
  const Model3dEdited(this.change);

  final Model3d Function(Model3d model) change;
}

/// Sets depth, thickness or both on every selected shape.
class ShapeDepthChanged extends EditorEvent {
  const ShapeDepthChanged({this.depth, this.thickness});

  final double? depth;
  final double? thickness;
}

/// Picks the view the canvas previews; null turns the preview off.
class Model3dPreviewChanged extends EditorEvent {
  const Model3dPreviewChanged(this.viewIndex);

  final int? viewIndex;
}

/// Picks the layer drawn faded over the preview; null shows none.
class GhostLayerChanged extends EditorEvent {
  const GhostLayerChanged(this.layerIndex);

  final int? layerIndex;
}

extension _EditorModel3dRegistrations on EditorBloc {
  void _registerModel3d() {
    _reduce<Model3dCreated>(
      (s, e) => Model3dLogic.create(
        s,
        straight: e.straight,
        left: e.left,
        right: e.right,
      ),
    );
    _reduce<Model3dRemoved>((s, e) => Model3dLogic.remove(s));
    _reduce<Model3dEdited>((s, e) => Model3dLogic.edit(s, e.change));
    _reduce<ShapeDepthChanged>(
      (s, e) => Model3dLogic.setDepth(
        s,
        depth: e.depth,
        thickness: e.thickness,
      ),
    );
    _reduce<Model3dPreviewChanged>(
      (s, e) => Model3dLogic.preview(s, e.viewIndex),
    );
    _reduce<GhostLayerChanged>((s, e) => Model3dLogic.ghost(s, e.layerIndex));
  }
}
