// Project imports:
import '../../../../domain/models/editor/tool.dart';
import '../../../../domain/models/shapes/shape.dart';
import '../../../../domain/models/shapes/shape_kind.dart';
import '../../../../domain/services/code_import/quick_code_points.dart';
import '../../bloc/editor_bloc.dart';
import 'draw_logic.dart';
import 'editor_ops.dart';

/// Applies point-list edits from the Quick Code panel.
abstract class QuickCodeLogic {
  QuickCodeLogic._();

  static EditorState previewShapes(
    EditorState state,
    List<QuickCodeShapeData> data,
  ) => state.copyWith(
    draft: null,
    hover: null,
    quickCodePreviews: _buildShapes(state, data),
  );

  static EditorState addPolygons(
    EditorState state,
    List<QuickCodeShapeData> data,
  ) {
    final additions = _buildShapes(state, data);
    if (additions.isEmpty) return state.copyWith(quickCodePreviews: const []);
    final index = state.layer.shapes.length;
    final layer = state.layer.copyWith(
      visible: true,
      shapes: [...state.layer.shapes, ...additions],
    );
    final indices = [for (var i = 0; i < additions.length; i++) index + i];
    return state
        .withLayers(replacedAt(state.drawing.layers, state.layerIndex, layer))
        .copyWith(
          tool: Tool.select,
          draft: null,
          hover: null,
          quickCodePreviews: const [],
        )
        .selectIndices(indices)
        .commit();
  }

  static List<Shape> _buildShapes(
    EditorState state,
    List<QuickCodeShapeData> data,
  ) {
    final groupIds = <String, String>{};
    final usedIds = state.drawing.layers
        .expand((layer) => layer.shapes)
        .map((shape) => shape.groupId)
        .whereType<String>()
        .toSet();
    var groupNumber = state.revision + 1;
    final shapeCount = state.drawing.layers.fold<int>(
      0,
      (count, layer) => count + layer.shapes.length,
    );
    return [
      for (var index = 0; index < data.length; index++)
        _buildShape(state, data[index], shapeCount + index + 1, groupIds, () {
          var id = 'quick-code-$groupNumber';
          while (usedIds.contains(id)) {
            groupNumber++;
            id = 'quick-code-$groupNumber';
          }
          groupNumber++;
          usedIds.add(id);
          return id;
        }),
    ];
  }

  static Shape _buildShape(
    EditorState state,
    QuickCodeShapeData data,
    int defaultNameNumber,
    Map<String, String> groupIds,
    String Function() createGroupId,
  ) {
    final groupName = data.groupName;
    final groupId = groupName == null
        ? null
        : groupIds.putIfAbsent(groupName, createGroupId);
    final fallback = DrawLogic.newShape(state, ShapeKind.polygon, data.points);
    final name = data.name?.trim();
    return fallback.copyWith(
      name: name == null || name.isEmpty ? 'Polygon $defaultNameNumber' : name,
      groupId: groupId,
      groupName: groupName,
    );
  }

  static EditorState changeShapePoints(
    EditorState state,
    QuickCodeShapePointsChanged event,
  ) {
    if (event.layerIndex < 0 ||
        event.layerIndex >= state.drawing.layers.length) {
      return state;
    }
    final layer = state.drawing.layers[event.layerIndex];
    if (event.shapeIndex < 0 || event.shapeIndex >= layer.shapes.length) {
      return state;
    }
    final original = layer.shapes[event.shapeIndex];
    final shape = original.copyWith(
      points: event.points,
      name: event.name ?? original.name,
    );
    final shapes = [...layer.shapes]..[event.shapeIndex] = shape;
    final next = state.withLayers(
      replacedAt(
        state.drawing.layers,
        event.layerIndex,
        layer.copyWith(shapes: shapes),
      ),
    );
    return event.commit ? next.commit() : next;
  }
}
