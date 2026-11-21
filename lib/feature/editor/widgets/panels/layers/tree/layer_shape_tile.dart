// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../../../core/utils/l10n_ext.dart';
import '../../../../../../domain/models/drawing/paint_layer.dart';
import '../../../../../../domain/models/shapes/shape_kind.dart';
import '../../../../bloc/editor_bloc.dart';
import 'exports.dart';
import '../panel/exports.dart';

/// Shows one shape row and its right-click actions in the layer tree.
class LayerShapeTile extends StatelessWidget {
  const LayerShapeTile({
    super.key,
    required this.layer,
    required this.layerIndex,
    required this.index,
    required this.tabId,
    required this.selected,
    required this.grouped,
  });

  final PaintLayer layer;
  final int layerIndex;
  final int index;
  final String tabId;
  final bool selected;
  final bool grouped;

  @override
  Widget build(BuildContext context) {
    final shape = layer.shapes[index];
    final tile = ListTile(
      key: ValueKey('shape-$tabId-$layerIndex-$index'),
      dense: true,
      visualDensity: VisualDensity.compact,
      contentPadding: EdgeInsets.only(left: grouped ? 48 : 32, right: 16),
      leading: Icon(_shapeIcon(shape.kind), size: 16),
      trailing: IconButton(
        tooltip: shape.visible
            ? context.l10n.layerHide
            : context.l10n.layerShow,
        visualDensity: VisualDensity.compact,
        iconSize: 18,
        icon: Icon(shape.visible ? Icons.visibility : Icons.visibility_off),
        onPressed: () => context.read<EditorBloc>().add(
          ShapeVisibilityToggled(layerIndex, index),
        ),
      ),
      title: InlineTreeNameEditor(
        name: shape.name.isEmpty
            ? _shapeLabel(context, shape.kind)
            : shape.name,
        tooltip: context.l10n.layerEditItem,
        style: Theme.of(context).textTheme.bodySmall,
        allowEmpty: true,
        onSaved: (name) => context.read<EditorBloc>().add(
          ShapeRenamed(name, layer: layerIndex, index: index),
        ),
      ),
      selected: selected,
      onTap: () => context.read<EditorBloc>().add(
        ShapeSelectionRequested(layerIndex, index, includeGroup: false),
      ),
    );
    final row = grouped
        ? Tooltip(
            message: context.l10n.canvasSelectGroupMemberHint,
            child: tile,
          )
        : tile;
    return GestureDetector(
      onSecondaryTapUp: (details) => LayerTreeActions.showItem(
        context,
        details.globalPosition,
        layer: layer,
        layerIndex: layerIndex,
        index: index,
      ),
      child: row,
    );
  }

  String _shapeLabel(BuildContext context, ShapeKind kind) => switch (kind) {
    ShapeKind.rect => context.l10n.layerItemRectangle,
    ShapeKind.ellipse => context.l10n.layerItemEllipse,
    ShapeKind.line => context.l10n.layerItemLine,
    ShapeKind.polygon => context.l10n.layerItemPolygon,
    ShapeKind.freehand => context.l10n.layerItemFreehand,
  };

  IconData _shapeIcon(ShapeKind kind) => switch (kind) {
    ShapeKind.rect => Icons.crop_square,
    ShapeKind.ellipse => Icons.circle_outlined,
    ShapeKind.line => Icons.horizontal_rule,
    ShapeKind.polygon => Icons.change_history,
    ShapeKind.freehand => Icons.brush_outlined,
  };
}
