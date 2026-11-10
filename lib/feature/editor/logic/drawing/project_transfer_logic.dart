// Dart imports:
import 'dart:ui';

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
      ? paste(state, event.transfer)
      : importLayers(state, (event as ProjectLayersImported).layers);

  static EditorState paste(EditorState state, ProjectTransfer transfer) {
    return switch (transfer.kind) {
      ProjectTransferKind.items => _pasteItems(state, transfer.shapes),
      ProjectTransferKind.group => _pasteGroup(state, transfer),
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

  static EditorState _pasteItems(EditorState state, List<Shape> copied) {
    if (copied.isEmpty) return state;
    return _appendShapes(state, [
      for (final shape in copied)
        _offset(shape).copyWith(groupId: null, groupName: null),
    ]);
  }

  static EditorState _pasteGroup(EditorState state, ProjectTransfer transfer) {
    if (transfer.shapes.isEmpty) return state;
    final groupId = _uniqueGroupId(state);
    return _appendShapes(state, [
      for (final shape in transfer.shapes)
        _offset(shape)
            .copyWith(groupId: groupId, groupName: transfer.groupName),
    ]);
  }

  static EditorState _pasteLayer(EditorState state, PaintLayer? copied) {
    if (copied == null) return state;
    final usedNames = state.drawing.layers.map((layer) => layer.name).toSet();
    return _appendLayers(state, [
      copied.copyWith(name: _uniqueName(copied.name, usedNames)),
    ]);
  }

  static EditorState _appendShapes(EditorState state, List<Shape> additions) {
    final firstIndex = state.layer.shapes.length;
    final updatedLayer = state.layer.copyWith(
      visible: true,
      shapes: [...state.layer.shapes, ...additions],
    );
    return state
        .withLayers(
          replacedAt(state.drawing.layers, state.layerIndex, updatedLayer),
        )
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

  static Shape _offset(Shape shape) => shape.copyWith(
    points: [for (final point in shape.points) point + const Offset(3, 3)],
  );

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
