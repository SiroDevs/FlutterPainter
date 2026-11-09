// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../core/utils/l10n_ext.dart';
import '../../bloc/editor_bloc.dart';
import '../../logic/drawing/editor_ops.dart';
import 'shape_actions.dart';

/// A separate inspector section for actions on the selected shape or group.
class ShapeActionsPanel extends StatelessWidget {
  const ShapeActionsPanel({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<EditorBloc, EditorState>(
    buildWhen: (before, after) =>
        before.layerIndex != after.layerIndex ||
        before.selected != after.selected ||
        before.selectedIndices != after.selectedIndices ||
        before.groupClipboard != after.groupClipboard ||
        before.drawing.layers != after.drawing.layers,
    builder: (context, state) {
      final hasSelection = state.validSelectedIndices.isNotEmpty;
      final hasCopiedGroup = state.groupClipboard.isNotEmpty;
      return Column(
        children: [
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 2),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                context.l10n.shapeActionsPanelTitle,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ),
          Expanded(
            child: hasSelection || hasCopiedGroup
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ShapeActions(state: state),
                  )
                : Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        context.l10n.shapeActionsPanelEmpty,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
          ),
        ],
      );
    },
  );
}
