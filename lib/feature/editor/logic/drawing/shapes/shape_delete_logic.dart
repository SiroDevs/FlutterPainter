// Project imports:
import '../../../bloc/editor_bloc.dart';
import '../../canvas/image_logic.dart';
import '../operations/exports.dart';

/// Removes selected or layer-tree-addressed shapes.
abstract class ShapeDeleteLogic {
  ShapeDeleteLogic._();

  static EditorState delete(EditorState state) {
    if (state.imageSelected) return ImageLogic.remove(state);
    final indices = state.validSelectedIndices;
    if (indices.isEmpty) return state;
    final deleted = indices.toSet();
    final shapes = [
      for (var index = 0; index < state.layer.shapes.length; index++)
        if (!deleted.contains(index)) state.layer.shapes[index],
    ];
    return state.withShapes(shapes).selectIndices(const []).commit();
  }

  static EditorState deleteAt(
    EditorState state,
    int layerIndex,
    int index, {
    bool includeGroup = false,
  }) {
    final layers = state.drawing.layers;
    if (layerIndex < 0 || layerIndex >= layers.length) return state;
    final layer = layers[layerIndex];
    if (index < 0 || index >= layer.shapes.length) return state;
    final deleted =
        (includeGroup ? groupedShapeIndices(layer.shapes, index) : [index])
            .toSet();
    final shapes = [
      for (var shapeIndex = 0; shapeIndex < layer.shapes.length; shapeIndex++)
        if (!deleted.contains(shapeIndex)) layer.shapes[shapeIndex],
    ];
    var next = state.withLayers(
      replacedAt(layers, layerIndex, layer.copyWith(shapes: shapes)),
    );
    if (layerIndex == state.layerIndex) next = next.selectIndices(const []);
    return next.commit();
  }
}
