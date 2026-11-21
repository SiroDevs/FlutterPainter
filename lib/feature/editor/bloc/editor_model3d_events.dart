part of 'editor_bloc.dart';

/// Turns the active layer into a 3D layer, naming its first three views.
class Model3dCreated extends EditorEvent {
  const Model3dCreated({
    required this.front,
    required this.left,
    required this.right,
  });

  final String front;
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

/// Places the selected shapes: [x] and [y] set where their middle is, [z]
/// how far front or back, [thickness] how thick.
class ShapePlaced extends EditorEvent {
  const ShapePlaced({this.x, this.y, this.z, this.thickness});

  final double? x;
  final double? y;
  final double? z;
  final double? thickness;
}

/// Picks the view the canvas previews; null turns the preview off.
class Model3dPreviewChanged extends EditorEvent {
  const Model3dPreviewChanged(this.viewIndex);

  final int? viewIndex;
}

/// Turns the live 3D camera on at [camera], or off with null.
class LiveCameraChanged extends EditorEvent {
  const LiveCameraChanged(this.camera);

  final ViewAngle? camera;
}

/// Changes the cross-section of every selected shape.
class ShapeSectionChanged extends EditorEvent {
  const ShapeSectionChanged(this.change);

  final SectionProfile Function(SectionProfile section) change;
}

/// Changes the tilt of every selected shape.
class ShapeTiltChanged extends EditorEvent {
  const ShapeTiltChanged(this.change);

  final PartPose Function(PartPose tilt) change;
}

/// Picks the layer drawn faded over the preview; null shows none.
class GhostLayerChanged extends EditorEvent {
  const GhostLayerChanged(this.layerIndex);

  final int? layerIndex;
}

/// Starts or stops working on a part: the canvas looks straight at it and
/// tools only touch and add to its shapes.
class WorkPartChanged extends EditorEvent {
  const WorkPartChanged(this.partId);

  final String? partId;
}

/// Adds a face next to an edge of a part, hinged and folded like a box side.
class FaceAdded extends EditorEvent {
  const FaceAdded({
    required this.partId,
    required this.edgeIndex,
    required this.name,
  });

  final String partId;
  final int edgeIndex;
  final String name;
}

extension _EditorModel3dRegistrations on EditorBloc {
  void _registerModel3d() {
    _reduce<Model3dCreated>(
      (s, e) => Model3dLogic.create(
        s,
        front: e.front,
        left: e.left,
        right: e.right,
      ),
    );
    _reduce<Model3dRemoved>((s, e) => Model3dLogic.remove(s));
    _reduce<Model3dEdited>((s, e) => Model3dLogic.edit(s, e.change));
    _reduce<ShapePlaced>(
      (s, e) => Model3dLogic.place(
        s,
        x: e.x,
        y: e.y,
        z: e.z,
        thickness: e.thickness,
      ),
    );
    _reduce<Model3dPreviewChanged>(
      (s, e) => Model3dLogic.preview(s, e.viewIndex),
    );
    _reduce<LiveCameraChanged>((s, e) => Model3dLogic.live(s, e.camera));
    _reduce<ShapeSectionChanged>(
      (s, e) => Shape3dLogic.setSection(s, e.change),
    );
    _reduce<ShapeTiltChanged>((s, e) => Shape3dLogic.setTilt(s, e.change));
    _reduce<GhostLayerChanged>((s, e) => Model3dLogic.ghost(s, e.layerIndex));
    _reduce<WorkPartChanged>((s, e) => Model3dLogic.work(s, e.partId));
    _reduce<FaceAdded>(
      (s, e) => FaceLogic.addOnEdge(
        s,
        partId: e.partId,
        edgeIndex: e.edgeIndex,
        name: e.name,
      ),
    );
  }
}
