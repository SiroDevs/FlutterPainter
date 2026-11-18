// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../common/widgets/dialogs/app_dialogs.dart';
import '../../../../core/utils/l10n_ext.dart';
import '../../../../domain/models/drawing/paint_layer.dart';
import '../../../workspace/clipboard/project_transfer_clipboard.dart';
import '../../bloc/editor_bloc.dart';
import 'tree_context_menu.dart';

/// Runs context-menu actions for items, groups, and layers in the tree.
abstract class LayerTreeActions {
  static ProjectTransferClipboard get _clipboard =>
      ProjectTransferClipboard.instance;

  static Future<void> showItem(
    BuildContext context,
    Offset position, {
    required PaintLayer layer,
    required int layerIndex,
    required int index,
  }) async {
    final shape = layer.shapes[index];
    final action = await showTreeContextMenu(context, position, [
      (TreeContextAction.copy, context.l10n.layerCopyItem),
      if (_clipboard.value != null)
        (TreeContextAction.paste, context.l10n.projectPaste),
      (TreeContextAction.duplicate, context.l10n.shapeDuplicate),
      (TreeContextAction.rename, context.l10n.layerEditItem),
      (
        TreeContextAction.visibility,
        shape.visible ? context.l10n.layerHide : context.l10n.layerShow,
      ),
      if (shape.groupId != null)
        (TreeContextAction.ungroup, context.l10n.shapeUngroup),
      (TreeContextAction.delete, context.l10n.shapeDelete),
    ]);
    if (!context.mounted || action == null) return;
    final bloc = context.read<EditorBloc>();
    switch (action) {
      case TreeContextAction.copy:
        _clipboard.copyItem(shape);
      case TreeContextAction.paste:
        _pasteIntoLayer(bloc, layerIndex);
      case TreeContextAction.duplicate:
        _clipboard.copyItem(shape);
        _pasteIntoLayer(bloc, layerIndex);
      case TreeContextAction.rename:
        final name = await promptText(
          context,
          title: context.l10n.layerEditItem,
          initial: shape.name,
        );
        if (name != null) {
          bloc.add(ShapeRenamed(name, layer: layerIndex, index: index));
        }
      case TreeContextAction.visibility:
        bloc.add(ShapeVisibilityToggled(layerIndex, index));
      case TreeContextAction.ungroup:
        bloc.add(ShapeUngroupedAt(layerIndex, index));
      case TreeContextAction.delete:
        bloc.add(ShapeDeletedAt(layerIndex, index));
      case TreeContextAction.moveUp || TreeContextAction.moveDown:
        break;
    }
  }

  static Future<void> showGroup(
    BuildContext context,
    Offset position, {
    required PaintLayer layer,
    required int layerIndex,
    required List<int> indices,
    required String groupId,
    required String name,
    required bool visible,
  }) async {
    final action = await showTreeContextMenu(context, position, [
      (TreeContextAction.copy, context.l10n.shapeCopyGroup),
      if (_clipboard.value != null)
        (TreeContextAction.paste, context.l10n.projectPaste),
      (TreeContextAction.duplicate, context.l10n.shapeDuplicate),
      (TreeContextAction.rename, context.l10n.layerEditGroup),
      (
        TreeContextAction.visibility,
        visible ? context.l10n.layerHide : context.l10n.layerShow,
      ),
      (TreeContextAction.delete, context.l10n.shapeDelete),
    ]);
    if (!context.mounted || action == null) return;
    final bloc = context.read<EditorBloc>();
    switch (action) {
      case TreeContextAction.copy:
      case TreeContextAction.duplicate:
        final painterOrder = [...indices]..sort();
        _clipboard.copyGroupMembers([
          for (final index in painterOrder) layer.shapes[index],
        ]);
        if (action == TreeContextAction.duplicate) {
          _pasteIntoLayer(bloc, layerIndex);
        }
      case TreeContextAction.paste:
        _pasteIntoLayer(bloc, layerIndex);
      case TreeContextAction.rename:
        final newName = await promptText(
          context,
          title: context.l10n.layerEditGroup,
          initial: name,
        );
        if (newName != null && newName.isNotEmpty) {
          bloc.add(GroupRenamed(layerIndex, groupId, newName));
        }
      case TreeContextAction.visibility:
        bloc.add(
          ShapeVisibilityToggled(layerIndex, indices.first, includeGroup: true),
        );
      case TreeContextAction.ungroup:
        break;
      case TreeContextAction.delete:
        bloc.add(ShapeDeletedAt(layerIndex, indices.first, includeGroup: true));
      case TreeContextAction.moveUp || TreeContextAction.moveDown:
        break;
    }
  }

  static Future<void> showLayer(
    BuildContext context,
    Offset position, {
    required PaintLayer layer,
    required int layerIndex,
    required int layerCount,
  }) async {
    final actions = <(TreeContextAction, String)>[
      (TreeContextAction.copy, context.l10n.projectCopyLayer),
      if (_clipboard.value != null)
        (TreeContextAction.paste, context.l10n.projectPaste),
      (TreeContextAction.rename, context.l10n.layerRename),
      (
        TreeContextAction.visibility,
        layer.visible ? context.l10n.layerHide : context.l10n.layerShow,
      ),
      if (layerIndex < layerCount - 1)
        (TreeContextAction.moveUp, context.l10n.layerMoveUp),
      if (layerIndex > 0)
        (TreeContextAction.moveDown, context.l10n.layerMoveDown),
      if (layerCount > 1) (TreeContextAction.delete, context.l10n.layerDelete),
    ];
    final action = await showTreeContextMenu(context, position, actions);
    if (!context.mounted || action == null) return;
    final bloc = context.read<EditorBloc>();
    switch (action) {
      case TreeContextAction.copy:
        _clipboard.copyLayer(layer);
      case TreeContextAction.paste:
        _pasteIntoLayer(bloc, layerIndex);
      case TreeContextAction.rename:
        final name = await promptText(
          context,
          title: context.l10n.layerRename,
          initial: layer.name,
        );
        if (name != null && name.isNotEmpty) {
          bloc.add(LayerRenamed(layerIndex, name));
        }
      case TreeContextAction.visibility:
        bloc.add(LayerVisibilityToggled(layerIndex));
      case TreeContextAction.ungroup:
        break;
      case TreeContextAction.moveUp:
        bloc.add(LayerMoved(layerIndex, 1));
      case TreeContextAction.moveDown:
        bloc.add(LayerMoved(layerIndex, -1));
      case TreeContextAction.delete:
        bloc.add(LayerDeleted(layerIndex));
      case TreeContextAction.duplicate:
        break;
    }
  }

  static void _pasteIntoLayer(EditorBloc bloc, int layerIndex) {
    _clipboard.pasteInto(bloc, targetLayerIndex: layerIndex);
  }
}
