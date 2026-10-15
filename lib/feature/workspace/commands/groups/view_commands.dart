// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../core/theme/bloc/theme_bloc.dart';
import '../../../../domain/models/tool.dart';
import '../../../editor/bloc/editor_bloc.dart';
import '../../../editor/widgets/toolbar/tool_info.dart';
import '../app_command.dart';
import '../workspace_commands.dart';

extension ViewCommands on WorkspaceCommands {
  AppCommand get zoomIn => AppCommand(
        label: 'Zoom in',
        icon: Icons.zoom_in,
        onPressed: () => send(ViewZoomed(1.25, viewCenter)),
      );

  AppCommand get zoomOut => AppCommand(
        label: 'Zoom out',
        icon: Icons.zoom_out,
        onPressed: () => send(ViewZoomed(1 / 1.25, viewCenter)),
      );

  AppCommand get zoomFit => AppCommand(
        label: 'Fit to window',
        icon: Icons.fit_screen,
        onPressed: () => send(const FitRequested()),
      );

  String get zoomLabel => '${state.view.zoom.toStringAsFixed(1)}x';

  AppCommand get grid => AppCommand(
        label: 'Grid',
        icon: Icons.grid_on,
        checked: state.view.grid,
        onPressed: () => send(const GridToggled()),
      );

  AppCommand get snap => AppCommand(
        label: 'Snap to grid',
        icon: Icons.straighten,
        checked: state.view.snap,
        onPressed: () => send(const SnapToggled()),
      );

  AppCommand get background => AppCommand(
        label: 'Canvas background',
        icon: Icons.format_color_fill,
        tooltip: 'Cycle the canvas background colour',
        onPressed: () => send(const BackgroundCycled()),
      );

  AppCommand get theme => AppCommand(
        label: dark ? 'Light theme' : 'Dark theme',
        icon: Icons.brightness_6_outlined,
        tooltip: 'Switch between the light and dark theme',
        onPressed: () => themeBloc.add(
          ThemeModeChanged(dark ? ThemeMode.light : ThemeMode.dark),
        ),
      );

  AppCommand tool(Tool t) => AppCommand(
        label: t.label,
        icon: t.icon,
        keys: t.keyLabel,
        checked: state.tool == t,
        onPressed: () => send(ToolSelected(t)),
      );
}
