// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../domain/models/app_settings.dart';
import '../settings/cubit/settings_cubit.dart';
import 'widgets/canvas/canvas_view.dart';
import 'widgets/panels/image_panel.dart';
import 'widgets/panels/layers_panel.dart';
import 'widgets/panels/properties_panel.dart';
import 'widgets/toolbar/color_bar.dart';
import 'widgets/toolbar/status_bar.dart';
import 'widgets/toolbar/tool_palette.dart';

/// One project's editor: tools, canvas, side panels, colour bar and status bar.
/// The minimal interface leaves out the side panels. It expects an
/// `EditorBloc` above it in the tree (one per tab).
class EditorScreen extends StatelessWidget {
  const EditorScreen({super.key, required this.canvasFocus});

  final FocusNode canvasFocus;

  @override
  Widget build(BuildContext context) {
    final minimal = context.select<SettingsCubit, bool>(
      (c) => c.state.interfaceMode == InterfaceMode.minimal,
    );
    return Column(children: [
      Expanded(
        child: Row(children: [
          const ToolPalette(),
          const VerticalDivider(width: 1),
          Expanded(child: CanvasView(focus: canvasFocus)),
          if (!minimal) ...const [
            VerticalDivider(width: 1),
            SizedBox(
              width: 290,
              child: Column(children: [
                Expanded(flex: 2, child: LayersPanel()),
                Divider(height: 1),
                ImagePanel(),
                Divider(height: 1),
                Expanded(flex: 3, child: PropertiesPanel()),
              ]),
            ),
          ],
        ]),
      ),
      const Divider(height: 1),
      const ColorBar(),
      const Divider(height: 1),
      const StatusBar(),
    ]);
  }
}
