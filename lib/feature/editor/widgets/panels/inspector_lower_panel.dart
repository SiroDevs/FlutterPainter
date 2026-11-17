// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../core/utils/l10n_ext.dart';
import '../../bloc/editor_bloc.dart';
import '../../logic/drawing/editor_ops.dart';
import 'image_panel.dart';
import 'model3d/model3d_panel.dart';

/// The picture panel, with a 3D tab beside it when the active layer is 3D.
class InspectorLowerPanel extends StatelessWidget {
  const InspectorLowerPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<EditorBloc, EditorState, bool>(
      selector: (state) => state.layer.model != null,
      builder: (context, isModel) =>
          isModel ? const _TabbedPanels() : const ImagePanel(),
    );
  }
}

class _TabbedPanels extends StatelessWidget {
  const _TabbedPanels();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(text: context.l10n.model3dTabModel),
              Tab(text: context.l10n.model3dTabImage),
            ],
          ),
          const Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [Model3dPanel(), ImagePanel()],
            ),
          ),
        ],
      ),
    );
  }
}
