// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../core/utils/l10n_ext.dart';
import '../../bloc/editor_bloc.dart';

/// Shows vertex editing actions for a right-clicked polygon or line point.
abstract class CanvasContextMenu {
  CanvasContextMenu._();

  static bool showVertexMenu(
    BuildContext context,
    EditorBloc bloc,
    Offset point,
    Offset global,
  ) {
    final state = bloc.state;
    final tolerance = 10 / state.view.zoom;
    for (
      var layerIndex = state.drawing.layers.length - 1;
      layerIndex >= 0;
      layerIndex--
    ) {
      final layer = state.drawing.layers[layerIndex];
      if (!layer.visible) continue;
      for (
        var shapeIndex = layer.shapes.length - 1;
        shapeIndex >= 0;
        shapeIndex--
      ) {
        final shape = layer.shapes[shapeIndex];
        if (!shape.visible || !shape.usesVertices) continue;
        for (
          var pointIndex = 0;
          pointIndex < shape.points.length;
          pointIndex++
        ) {
          if ((shape.points[pointIndex] - point).distance > tolerance) continue;
          bloc.add(
            ShapeSelectionRequested(
              layerIndex,
              shapeIndex,
              includeGroup: false,
            ),
          );
          _openVertexMenu(context, bloc, global, pointIndex);
          return true;
        }
      }
    }
    return false;
  }

  static Future<void> _openVertexMenu(
    BuildContext context,
    EditorBloc bloc,
    Offset global,
    int index,
  ) async {
    final size = MediaQuery.sizeOf(context);
    final action = await showMenu<int>(
      context: context,
      position: RelativeRect.fromLTRB(
        global.dx,
        global.dy,
        size.width - global.dx,
        size.height - global.dy,
      ),
      items: [
        PopupMenuItem(value: 0, child: Text(context.l10n.vertexDelete)),
        PopupMenuItem(value: 1, child: Text(context.l10n.vertexSplit)),
      ],
    );
    if (!context.mounted || action == null) return;
    bloc.add(
      action == 0 ? VertexPointDeleted(index) : VertexSegmentSplit(index),
    );
  }
}
