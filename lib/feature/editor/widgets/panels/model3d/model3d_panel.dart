// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../../../core/utils/l10n_ext.dart';
import '../../../bloc/editor_bloc.dart';
import '../../../logic/drawing/editor_ops.dart';
import 'model3d_edits.dart';
import 'model3d_parts.dart';
import 'model3d_parts_section.dart';
import 'model3d_shape_section.dart';
import 'model3d_tyres_section.dart';
import 'model3d_views_section.dart';

/// The 3D setup of the active layer: preview, views, depth, tyres and pivot.
class Model3dPanel extends StatefulWidget {
  const Model3dPanel({super.key});

  @override
  State<Model3dPanel> createState() => _Model3dPanelState();
}

class _Model3dPanelState extends State<Model3dPanel> {
  int _viewIndex = 0;
  int _tyreIndex = 0;
  int _partIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditorBloc, EditorState>(
      buildWhen: (before, after) =>
          !identical(before.drawing, after.drawing) ||
          before.layerIndex != after.layerIndex ||
          before.previewView != after.previewView ||
          before.ghostLayer != after.ghostLayer ||
          before.selectedIndices != after.selectedIndices,
      builder: (context, state) {
        final model = state.layer.model;
        if (model == null) return const SizedBox.shrink();
        final viewIndex = clampedIndex(_viewIndex, model.views.length);
        final canvasSize = Size(state.drawing.width, state.drawing.height);
        final parts = listParts(state.layer, model);
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.model3dTitle(state.layer.name),
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              _previewToggle(context, state, viewIndex),
              const SizedBox(height: 8),
              Model3dViewsSection(
                model: model,
                selected: viewIndex,
                onSelected: (index) => _selectView(context, index),
              ),
              const SizedBox(height: 8),
              Model3dPartsSection(
                model: model,
                parts: parts,
                selected: clampedIndex(_partIndex, parts.length),
                viewIndex: viewIndex,
                canvasSize: canvasSize,
                onSelected: (index) => setState(() => _partIndex = index),
              ),
              const SizedBox(height: 8),
              Model3dShapeSection(shape: state.selectedShape),
              const SizedBox(height: 8),
              Model3dTyresSection(
                model: model,
                selected: clampedIndex(_tyreIndex, model.tyres.length),
                canvasSize: canvasSize,
                onSelected: (index) => setState(() => _tyreIndex = index),
              ),
              const SizedBox(height: 8),
              Model3dPivotSection(model: model, canvasSize: canvasSize),
            ],
          ).padding(horizontal: 12, vertical: 8),
        );
      },
    );
  }

  Widget _previewToggle(BuildContext context, EditorState state, int index) {
    final previewing = state.previewAngle != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: previewing,
              onChanged: (on) => context.read<EditorBloc>().add(
                Model3dPreviewChanged(on == true ? index : null),
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
          _comparisonPicker(context, state),
        ],
      ],
    );
  }

  Widget _comparisonPicker(BuildContext context, EditorState state) {
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

  void _selectView(BuildContext context, int index) {
    setState(() => _viewIndex = index);
    final bloc = context.read<EditorBloc>();
    if (bloc.state.previewView != null) bloc.add(Model3dPreviewChanged(index));
  }
}
