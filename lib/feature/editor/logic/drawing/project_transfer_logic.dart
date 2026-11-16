// Project imports:
import '../../../../domain/models/drawing/paint_layer.dart';
import '../../../../domain/models/drawing/project_transfer.dart';
import '../../../../domain/models/shapes/shape.dart';
import '../../bloc/editor_bloc.dart';
import 'editor_ops.dart';

abstract class ProjectTransferLogic {
  ProjectTransferLogic._();

  static EditorState apply(EditorState state, ProjectTransferEvent event) =>
      event is ProjectContentPasted
      ? paste(state, event.transfer, targetLayerIndex: event.targetLayerIndex)
      : importLayers(state, (event as ProjectLayersImported).layers);

  static EditorState paste(
    EditorState state,
    ProjectTransfer transfer, {
    int? targetLayerIndex,
  }) {
    return switch (transfer.kind) {
      ProjectTransferKind.items => _pasteItems(
        state,
        transfer.shapes,
        targetLayerIndex,
      ),
      ProjectTransferKind.group => _pasteGroup(
        state,
        transfer,
        targetLayerIndex,
      ),
      ProjectTransferKind.layer => _pasteLayer(state, transfer.layer),
    };
  }

  static EditorState importLayers(
    EditorState state,
    List<PaintLayer> imported,
  ) {
    if (imported.isEmpty) return state;
    final usedNames = state.drawing.layers.map((layer) => layer.name).toSet();
    final additions = [
      for (final layer in imported)
        layer.copyWith(name: _uniqueName(layer.name, usedNames)),
    ];
    return _appendLayers(state, additions);
  }

  static EditorState _pasteItems(
    EditorState state,
    List<Shape> copied,
    int? targetLayerIndex,
  ) {
    if (copied.isEmpty) return state;
    return _appendShapes(state, [
      for (final shape in copied)
        shape.copyWith(groupId: null, groupName: null),
    ], targetLayerIndex: targetLayerIndex);
  }

  static EditorState _pasteGroup(
    EditorState state,
    ProjectTransfer transfer,
    int? targetLayerIndex,
  ) {
    if (transfer.shapes.isEmpty) return state;
    final groupId = _uniqueGroupId(state);
    return _appendShapes(state, [
      for (final shape in transfer.shapes)
        shape.copyWith(groupId: groupId, groupName: transfer.groupName),
    ], targetLayerIndex: targetLayerIndex);
  }

  static EditorState _pasteLayer(EditorState state, PaintLayer? copied) {
    if (copied == null) return state;
    return _appendLayers(state, [copied]);
  }

  static EditorState _appendShapes(
    EditorState state,
    List<Shape> additions, {
    int? targetLayerIndex,
  }) {
    final layerIndex =
        targetLayerIndex != null &&
            targetLayerIndex >= 0 &&
            targetLayerIndex < state.drawing.layers.length
        ? targetLayerIndex
        : state.layerIndex;
    final targetLayer = state.drawing.layers[layerIndex];
    final firstIndex = targetLayer.shapes.length;
    final updatedLayer = targetLayer.copyWith(
      visible: true,
      shapes: [...targetLayer.shapes, ...additions],
    );
    return state
        .withLayers(replacedAt(state.drawing.layers, layerIndex, updatedLayer))
        .copyWith(layerIndex: layerIndex)
        .selectIndices([
          for (
            var index = firstIndex;
            index < firstIndex + additions.length;
            index++
          )
            index,
        ])
        .commit();
  }

  static EditorState _appendLayers(
    EditorState state,
    List<PaintLayer> additions,
  ) {
    final layers = [...state.drawing.layers, ...additions];
    return state
        .withLayers(layers)
        .copyWith(layerIndex: layers.length - 1, selected: null)
        .commit();
  }

  static String _uniqueGroupId(EditorState state) {
    final usedIds = {
      for (final layer in state.drawing.layers)
        for (final shape in layer.shapes)
          if (shape.groupId != null) shape.groupId,
    };
    var suffix = state.revision + 1;
    var groupId = 'group-$suffix';
    while (usedIds.contains(groupId)) {
      suffix++;
      groupId = 'group-$suffix';
    }
    return groupId;
  }

  static String _uniqueName(String name, Set<String> usedNames) {
    if (usedNames.add(name)) return name;
    var suffix = 2;
    while (!usedNames.add('$name $suffix')) {
      suffix++;
    }
    return '$name $suffix';
  }
}
