// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../../core/utils/l10n_ext.dart';
import '../../../bloc/editor_bloc.dart';
import '../../../logic/drawing/editor_ops.dart';

/// Switch for previewing a saved view on the canvas, and what to compare it
/// with.
class Model3dPreviewSection extends StatelessWidget {
  const Model3dPreviewSection({
    super.key,
    required this.state,
    required this.viewIndex,
  });

  final EditorState state;
  final int viewIndex;

  @override
  Widget build(BuildContext context) {
    final previewing = state.previewAngle != null && !state.liveMode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: previewing,
              onChanged: (on) => context.read<EditorBloc>().add(
                Model3dPreviewChanged(on == true ? viewIndex : null),
              ),
            ),
            Expanded(child: Text(context.l10n.model3dPreview)),
          ],
        ),
        if (previewing) ...[
          Text(
            context.l10n.model3dPreviewNote,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          _comparisonPicker(context),
        ],
      ],
    );
  }

  Widget _comparisonPicker(BuildContext context) {
    final layers = state.drawing.layers;
    final choices = [
      for (var index = 0; index < layers.length; index++)
        if (index != state.layerIndex) index,
    ];
    return Row(
      children: [
        Text(context.l10n.model3dGhost),
        const SizedBox(width: 8),
        DropdownButton<int?>(
          isDense: true,
          value: choices.contains(state.ghostLayer) ? state.ghostLayer : null,
          items: [
            DropdownMenuItem<int?>(
              value: null,
              child: Text(context.l10n.model3dGhostNone),
            ),
            for (final index in choices)
              DropdownMenuItem<int?>(
                value: index,
                child: Text(layers[index].name),
              ),
          ],
          onChanged: (index) =>
              context.read<EditorBloc>().add(GhostLayerChanged(index)),
        ),
      ],
    );
  }
}
