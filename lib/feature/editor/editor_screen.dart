// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'widgets/canvas/canvas_view.dart';
import 'widgets/panels/layers_panel.dart';
import 'widgets/panels/properties_panel.dart';
import 'widgets/panels/reference_panel.dart';
import 'widgets/toolbar/color_bar.dart';
import 'widgets/toolbar/status_bar.dart';
import 'widgets/toolbar/tool_palette.dart';

/// One project's editor: tools, canvas, side panels, colour bar and status bar.
/// It expects an `EditorBloc` above it in the tree (one per tab).
class EditorScreen extends StatelessWidget {
  const EditorScreen({super.key, required this.canvasFocus});

  final FocusNode canvasFocus;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: Row(children: [
          const ToolPalette(),
          const VerticalDivider(width: 1),
          Expanded(child: CanvasView(focus: canvasFocus)),
          const VerticalDivider(width: 1),
          const SizedBox(
            width: 290,
            child: Column(children: [
              Expanded(flex: 2, child: LayersPanel()),
              Divider(height: 1),
              ReferencePanel(),
              Divider(height: 1),
              Expanded(flex: 3, child: PropertiesPanel()),
            ]),
          ),
        ]),
      ),
      const Divider(height: 1),
      const ColorBar(),
      const Divider(height: 1),
      const StatusBar(),
    ]);
  }
}
