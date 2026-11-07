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

  static EditorState select(EditorState s, int layer, int index) {
    if (layer < 0 || layer >= s.drawing.layers.length) return s;
    final shapes = s.drawing.layers[layer].shapes;
    if (index < 0 || index >= shapes.length) return s;
    final next = s.copyWith(
      layerIndex: layer,
      selected: null,
      selectedIndices: const [],
    );
    return next
        .selectIndices([index], primary: index)
        .copyWith(style: StyleLogic.adopt(s.style, shapes[index]));
  }

  /// Deletes the selected shape, or the selected picture.
  static EditorState delete(EditorState s) {
    if (s.imageSelected) return ImageLogic.remove(s);
    final indices = s.validSelectedIndices;
    if (indices.isEmpty) return s;
    final deleted = indices.toSet();
    final shapes = [
      for (var i = 0; i < s.layer.shapes.length; i++)
        if (!deleted.contains(i)) s.layer.shapes[i],
    ];
    return s.withShapes(shapes).selectIndices(const []).commit();
  }

  static EditorState duplicate(EditorState s) {
    final indices = s.validSelectedIndices;
    if (indices.isEmpty) return s;
    final shapes = [...s.layer.shapes];
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
    return s.withShapes(shapes).selectIndices(copies).commit();
  }

  static EditorState selectAll(EditorState s) =>
      s.selectIndices(List.generate(s.layer.shapes.length, (i) => i));

  static EditorState group(EditorState s) {
    final indices = s.validSelectedIndices;
    if (indices.length < 2) return s;
    final used = s.layer.shapes
        .map((shape) => shape.groupId)
        .whereType<String>()
        .toSet();
    var suffix = s.revision + 1;
    var id = 'group-$suffix';
    while (used.contains(id)) {
      suffix++;
      id = 'group-$suffix';
    }
    final changes = <int, Shape>{
      for (final i in indices) i: s.layer.shapes[i].copyWith(groupId: id),
    };
    return s.withShapeChanges(changes).selectIndices(indices).commit();
  }

  static EditorState ungroup(EditorState s) {
    final indices = s.validSelectedIndices;
    if (indices.isEmpty) return s;
    final ids = {
      for (final i in indices)
        if (s.layer.shapes[i].groupId != null) s.layer.shapes[i].groupId,
    };
    if (ids.isEmpty) return s;
    final changes = <int, Shape>{
      for (var i = 0; i < s.layer.shapes.length; i++)
        if (ids.contains(s.layer.shapes[i].groupId))
          i: s.layer.shapes[i].copyWith(groupId: null),
    };
    return s.withShapeChanges(changes).selectIndices(indices).commit();
  }

  /// [direction] +1 draws the shape later (in front), -1 earlier (behind).
  static EditorState reorder(EditorState s, int direction) {
    final i = s.selected;
    if (i == null || s.selectedShape == null) return s;
    final j = i + direction;
    if (j < 0 || j >= s.layer.shapes.length) return s;
    final shapes = [...s.layer.shapes];
    shapes.insert(j, shapes.removeAt(i));
    return s.withShapes(shapes).copyWith(selected: j).commit();
  }

  static EditorState moveToLayer(EditorState s, int target) {
    final i = s.selected;
    final shape = s.selectedShape;
    final layers = s.drawing.layers;
    if (i == null || shape == null) return s;
    if (target == s.layerIndex || target < 0 || target >= layers.length)
      return s;
    final next = [...layers];
    next[s.layerIndex] = s.layer.copyWith(shapes: removedAt(s.layer.shapes, i));
    final to = next[target];
    next[target] = to.copyWith(visible: true, shapes: [...to.shapes, shape]);
    return s
        .withLayers(next)
        .copyWith(layerIndex: target, selected: next[target].shapes.length - 1)
        .commit();
  }

  static EditorState rename(EditorState s, String name) =>
      s.editSelected((sh) => sh.copyWith(name: name)).commit();
}
