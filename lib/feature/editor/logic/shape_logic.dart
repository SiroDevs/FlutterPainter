// Dart imports:
import 'dart:ui';

// Project imports:
import '../../../domain/models/shape.dart';
import '../bloc/editor_bloc.dart';
import 'editor_ops.dart';
import 'image_logic.dart';
import 'style_logic.dart';

/// Operations on the selected shape: delete, duplicate, order, layer, name.
abstract class ShapeLogic {
  ShapeLogic._();

  static EditorState select(EditorState state, int layer, int index) {
    if (layer < 0 || layer >= state.drawing.layers.length) return state;
    final shapes = state.drawing.layers[layer].shapes;
    if (index < 0 || index >= shapes.length) return state;
    final next = state.copyWith(
      layerIndex: layer,
      selected: null,
      selectedIndices: const [],
    );
    return next
        .selectIndices(groupedShapeIndices(shapes, index), primary: index)
        .copyWith(style: StyleLogic.adopt(state.style, shapes[index]));
  }

  /// Deletes the selected shape, or the selected picture.
  static EditorState delete(EditorState state) {
    if (state.imageSelected) return ImageLogic.remove(state);
    final indices = state.validSelectedIndices;
    if (indices.isEmpty) return state;
    final deleted = indices.toSet();
    final shapes = [
      for (var i = 0; i < state.layer.shapes.length; i++)
        if (!deleted.contains(i)) state.layer.shapes[i],
    ];
    return state.withShapes(shapes).selectIndices(const []).commit();
  }

  static EditorState duplicate(EditorState state) {
    final indices = state.validSelectedIndices;
    if (indices.isEmpty) return state;
    final shapes = [...state.layer.shapes];
    final copies = <int>[];
    for (final i in indices) {
      final shape = shapes[i];
      shapes.add(
        shape.copyWith(
          points: [for (final p in shape.points) p + const Offset(3, 3)],
          name: '${shape.name} copy',
          groupId: null,
        ),
      );
      copies.add(shapes.length - 1);
    }
    return state.withShapes(shapes).selectIndices(copies).commit();
  }

  static EditorState selectAll(EditorState state) => state.selectIndices(
    state.layer.visible
        ? List.generate(state.layer.shapes.length, (index) => index)
        : const [],
  );

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
    final changes = <int, Shape>{
      for (final i in indices) i: state.layer.shapes[i].copyWith(groupId: id),
    };
    return state.withShapeChanges(changes).selectIndices(indices).commit();
  }

  static EditorState ungroup(EditorState state) {
    final indices = state.validSelectedIndices;
    if (indices.isEmpty) return state;
    final ids = {
      for (final i in indices)
        if (state.layer.shapes[i].groupId != null) state.layer.shapes[i].groupId,
    };
    if (ids.isEmpty) return state;
    final changes = <int, Shape>{
      for (var i = 0; i < state.layer.shapes.length; i++)
        if (ids.contains(state.layer.shapes[i].groupId))
          i: state.layer.shapes[i].copyWith(groupId: null),
    };
    return state.withShapeChanges(changes).selectIndices(indices).commit();
  }

  /// [direction] +1 draws the shape later (in front), -1 earlier (behind).
  static EditorState reorder(EditorState state, int direction) {
    final selectedIndex = state.selected;
    if (selectedIndex == null || state.selectedShape == null) return state;
    final nextIndex = selectedIndex + direction;
    if (nextIndex < 0 || nextIndex >= state.layer.shapes.length) return state;
    final shapes = [...state.layer.shapes];
    shapes.insert(nextIndex, shapes.removeAt(selectedIndex));
    return state.withShapes(shapes).copyWith(selected: nextIndex).commit();
  }

  static EditorState moveToLayer(EditorState state, int target) {
    final selectedIndex = state.selected;
    final selectedShape = state.selectedShape;
    final layers = state.drawing.layers;
    if (selectedIndex == null || selectedShape == null) return state;
    if (target == state.layerIndex || target < 0 || target >= layers.length) {
      return state;
    }
    final next = [...layers];
    next[state.layerIndex] = state.layer.copyWith(
      shapes: removedAt(state.layer.shapes, selectedIndex),
    );
    final to = next[target];
    next[target] = to.copyWith(
      visible: true,
      shapes: [...to.shapes, selectedShape],
    );
    return state
        .withLayers(next)
        .copyWith(layerIndex: target, selected: next[target].shapes.length - 1)
        .commit();
  }

  static EditorState rename(EditorState state, String name) =>
      state.editSelected((shape) => shape.copyWith(name: name)).commit();
}
