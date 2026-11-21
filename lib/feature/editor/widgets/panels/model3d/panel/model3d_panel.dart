// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../../../../core/utils/l10n_ext.dart';
import '../../../../../../domain/models/model3d/model3d.dart';
import '../../../../bloc/controller/editor_bloc.dart';
import '../../../../logic/drawing/shared/editor_ops.dart';
import '../support/model3d_edits.dart';
import '../sections/model3d_form_section.dart';
import '../sections/model3d_live_section.dart';
import '../support/model3d_parts.dart';
import '../sections/model3d_parts_section.dart';
import '../sections/model3d_preview_section.dart';
import '../sections/model3d_shape_section.dart';
import '../sections/model3d_views_section.dart';

const int _previewTab = 0;
const int _liveTab = 1;

/// The 3D setup of the active layer, in two tabs: previewing saved views,
/// and working live on the canvas.
class Model3dPanel extends StatefulWidget {
  const Model3dPanel({super.key});

  @override
  State<Model3dPanel> createState() => _Model3dPanelState();
}

class _Model3dPanelState extends State<Model3dPanel>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  int _viewIndex = 0;
  int _partIndex = 0;

  @override
  void initState() {
    super.initState();
    final live = context.read<EditorBloc>().state.liveMode;
    _tabs = TabController(
      length: 2,
      vsync: this,
      initialIndex: live ? _liveTab : _previewTab,
    )..addListener(_tabChanged);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  void _tabChanged() {
    if (!_tabs.indexIsChanging) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditorBloc, EditorState>(
      buildWhen: (before, after) =>
          !identical(before.drawing, after.drawing) ||
          before.layerIndex != after.layerIndex ||
          before.previewView != after.previewView ||
          before.ghostLayer != after.ghostLayer ||
          before.workPart != after.workPart ||
          (before.camera == null) != (after.camera == null) ||
          before.selectedIndices != after.selectedIndices,
      builder: (context, state) {
        final model = state.layer.model;
        if (model == null) return const SizedBox.shrink();
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.model3dTitle(state.layer.name),
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              TabBar(
                controller: _tabs,
                tabs: [
                  Tab(text: context.l10n.model3dTabPreview),
                  Tab(text: context.l10n.model3dTabLive),
                ],
              ),
              const SizedBox(height: 8),
              ...(_tabs.index == _liveTab
                  ? _liveControls(state, model)
                  : _previewControls(state, model)),
            ],
          ).padding(horizontal: 12, vertical: 8),
        );
      },
    );
  }

  List<Widget> _previewControls(EditorState state, Model3d model) {
    final viewIndex = clampedIndex(_viewIndex, model.views.length);
    final parts = listParts(state.layer, model);
    return [
      Model3dPreviewSection(state: state, viewIndex: viewIndex),
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
        shapes: state.layer.shapes,
        workingPart: state.workingPart,
        selected: clampedIndex(_partIndex, parts.length),
        viewIndex: viewIndex,
        canvasSize: _canvasSize(state),
        onSelected: (index) => setState(() => _partIndex = index),
      ),
      const SizedBox(height: 8),
      Model3dPivotSection(model: model, canvasSize: _canvasSize(state)),
    ];
  }

  List<Widget> _liveControls(EditorState state, Model3d model) => [
    Model3dLiveSection(camera: state.camera, model: model),
    const SizedBox(height: 8),
    Model3dShapeSection(
      shape: state.selectedShape,
      bounds: state.selectedBounds,
      canvasSize: _canvasSize(state),
    ),
    const SizedBox(height: 8),
    Model3dFormSection(shape: state.selectedShape),
    const SizedBox(height: 8),
    Model3dPivotSection(model: model, canvasSize: _canvasSize(state)),
  ];

  Size _canvasSize(EditorState state) =>
      Size(state.drawing.width, state.drawing.height);

  void _selectView(BuildContext context, int index) {
    setState(() => _viewIndex = index);
    final bloc = context.read<EditorBloc>();
    if (bloc.state.previewView != null) bloc.add(Model3dPreviewChanged(index));
  }
}
