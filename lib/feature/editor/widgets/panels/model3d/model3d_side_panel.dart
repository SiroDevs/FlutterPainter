// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../bloc/editor_bloc.dart';
import '../panel_resize_handle.dart';
import 'model3d_panel.dart';

/// The 3D setup beside the toolbar, shown only while the active layer is 3D.
/// [onResize] receives how far the user dragged the edge, left or right.
class Model3dSidePanel extends StatelessWidget {
  const Model3dSidePanel({
    super.key,
    required this.width,
    required this.onResize,
  });

  final double width;
  final ValueChanged<double> onResize;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<EditorBloc, EditorState, bool>(
      selector: (state) => state.layer.model != null,
      builder: (context, isModel) {
        if (!isModel) return const SizedBox.shrink();
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(width: width, child: const Model3dPanel()),
            PanelResizeHandle(
              axis: Axis.horizontal,
              onDragUpdate: (details) => onResize(details.delta.dx),
            ),
            const VerticalDivider(width: 1),
          ],
        );
      },
    );
  }
}
