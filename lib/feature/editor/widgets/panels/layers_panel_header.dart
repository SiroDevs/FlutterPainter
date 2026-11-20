// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../../common/widgets/dialogs/app_dialogs.dart';
import '../../../../core/utils/l10n_ext.dart';
import '../../bloc/editor_bloc.dart';
import '../../logic/drawing/editor_ops.dart';

/// Displays the common layer controls above the layer list.
class LayersPanelHeader extends StatelessWidget {
  const LayersPanelHeader({super.key, required this.bloc, required this.state});

  final EditorBloc bloc;
  final EditorState state;

  Future<void> _rename(BuildContext context) async {
    final name = await promptText(
      context,
      title: context.l10n.layerRename,
      initial: state.layer.name,
    );
    if (name != null && name.isNotEmpty) {
      bloc.add(LayerRenamed(state.layerIndex, name));
    }
  }

  @override
  Widget build(BuildContext context) {
    final layers = state.drawing.layers;
    final active = state.layerIndex;
    return Row(
      children: [
        Text(
          context.l10n.layersTitle,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const Spacer(),
        _button(Icons.add, context.l10n.layerAdd, () {
          bloc.add(LayerAdded(context.l10n.defaultLayerName));
        }),
        _button(
          Icons.edit_outlined,
          context.l10n.layerRename,
          () => _rename(context),
        ),
        _button(
          Icons.arrow_upward,
          context.l10n.layerMoveUp,
          () => bloc.add(LayerMoved(active, 1)),
          enabled: active < layers.length - 1,
        ),
        _button(
          Icons.arrow_downward,
          context.l10n.layerMoveDown,
          () => bloc.add(LayerMoved(active, -1)),
          enabled: active > 0,
        ),
        _button(
          Icons.delete_outline,
          context.l10n.layerDelete,
          () => bloc.add(LayerDeleted(active)),
          enabled: layers.length > 1,
        ),
      ],
    ).padding(left: 12);
  }

  Widget _button(
    IconData icon,
    String tooltip,
    VoidCallback onPressed, {
    bool enabled = true,
  }) => IconButton(
    tooltip: tooltip,
    iconSize: 18,
    visualDensity: VisualDensity.compact,
    icon: Icon(icon),
    onPressed: enabled ? onPressed : null,
  );
}
