// Project imports:
import '../../../../domain/models/shape.dart';
import '../../bloc/editor_bloc.dart';
import 'editor_ops.dart';

/// Creates, removes and renames shape groups.
abstract class GroupLogic {
  GroupLogic._();

  static EditorState group(EditorState state) {
    final indices = state.validSelectedIndices;
    if (indices.length < 2) return state;
    final currentGroups = {
      for (final index in indices) state.layer.shapes[index].groupId,
    };
    if (currentGroups.length == 1 && currentGroups.single != null) return state;
    final used = state.layer.shapes
        .map((shape) => shape.groupId)
        .whereType<String>()
        .toSet();
    var suffix = state.revision + 1;
    var id = 'group-$suffix';
    while (used.contains(id)) {
      suffix++;
      id = 'group-$suffix';
    }
    final groupName = _nextName(state);
    final changes = <int, Shape>{
      for (final index in indices)
        index: state.layer.shapes[index].copyWith(
          groupId: id,
          groupName: groupName,
        ),
    };
    return state.withShapeChanges(changes).selectIndices(indices).commit();
  }

  static EditorState ungroup(EditorState state) {
    final indices = state.validSelectedIndices;
    if (indices.isEmpty) return state;
    final ids = {
      for (final index in indices)
        if (state.layer.shapes[index].groupId != null)
          state.layer.shapes[index].groupId,
    };
    if (ids.isEmpty) return state;
    final changes = <int, Shape>{
      for (var index = 0; index < state.layer.shapes.length; index++)
        if (ids.contains(state.layer.shapes[index].groupId))
          index: state.layer.shapes[index].copyWith(
            groupId: null,
            groupName: null,
          ),
    };
    return state.withShapeChanges(changes).selectIndices(indices).commit();
  }

  static EditorState rename(
    EditorState state,
    int layerIndex,
    String groupId,
    String name,
  ) {
    if (layerIndex < 0 || layerIndex >= state.drawing.layers.length) {
      return state;
    }
    final shapes = [
      for (final shape in state.drawing.layers[layerIndex].shapes)
        shape.groupId == groupId ? shape.copyWith(groupName: name) : shape,
    ];
    return state
        .withLayers(
          replacedAt(
            state.drawing.layers,
            layerIndex,
            state.drawing.layers[layerIndex].copyWith(shapes: shapes),
          ),
        )
        .commit();
  }

  static String _nextName(EditorState state) {
    final usedNames = <String>{};
    var groupNumber = 0;
    for (final layer in state.drawing.layers) {
      final seenGroups = <String>{};
      for (final shape in layer.shapes) {
        final groupId = shape.groupId;
        if (groupId == null || !seenGroups.add(groupId)) continue;
        groupNumber++;
        usedNames.add(shape.groupName ?? 'Group $groupNumber');
      }
    }
    var candidate = groupNumber + 1;
    while (usedNames.contains('Group $candidate')) {
      candidate++;
    }
    return 'Group $candidate';
  }
}
