part of 'editor_bloc.dart';

extension _EditorShapeRegistrations on EditorBloc {
  void _registerShapes() {
    _reduce<ShapeDeleted>((s, e) => ShapeLogic.delete(s));
    _reduce<ShapeDuplicated>((s, e) => ShapeLogic.duplicate(s));
    _reduce<SelectAllRequested>((s, e) => ShapeLogic.selectAll(s));
    _reduce<ShapesGrouped>((s, e) => GroupLogic.group(s));
    _reduce<ShapesUngrouped>((s, e) => GroupLogic.ungroup(s));
    _reduce<SelectionScaled>((s, e) => ShapeLogic.scale(s, e.factor));
    _reduce<SelectionFlipped>(
      (s, e) => ShapeLogic.flip(s, horizontal: e.horizontal),
    );
    _reduce<GroupRenamed>(
      (s, e) => GroupLogic.rename(s, e.layer, e.groupId, e.name),
    );
    _reduce<VertexPointDeleted>((s, e) => VertexLogic.remove(s, e.index));
    _reduce<VertexSegmentSplit>((s, e) => VertexLogic.split(s, e.index));
    _reduce<ShapeReordered>(
      (s, e) => ShapeLogic.reorder(s, e.direction, toExtreme: e.toExtreme),
    );
    _reduce<ShapeMovedToLayer>((s, e) => ShapeLogic.moveToLayer(s, e.layer));
    _reduce<ShapeRenamed>(
      (s, e) => ShapeLogic.rename(s, e.name, layer: e.layer, index: e.index),
    );
    _reduce<ShapeSelectionRequested>(
      (s, e) =>
          ShapeLogic.select(s, e.layer, e.index, includeGroup: e.includeGroup),
    );
    _reduce<ShapeVisibilityToggled>(
      (s, e) => ShapeLogic.toggleVisibility(
        s,
        e.layer,
        e.index,
        includeGroup: e.includeGroup,
      ),
    );
    _reduce<ClosedToggled>((s, e) => VertexLogic.setClosed(s, e.closed));
    _reduce<QuickCodePolygonPreviewChanged>(
      (s, e) => QuickCodeLogic.previewPolygon(s, e.points),
    );
    _reduce<QuickCodePolygonApplied>(
      (s, e) => QuickCodeLogic.addPolygon(s, e.points),
    );
    _reduce<QuickCodeShapePointsChanged>(
      (s, e) => QuickCodeLogic.changeShapePoints(s, e),
    );
  }
}
