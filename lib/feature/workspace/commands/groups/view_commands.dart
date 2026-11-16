// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../core/theme/bloc/theme_bloc.dart';
import '../../../../core/utils/l10n_ext.dart';
import '../../../../domain/models/editor/tool.dart';
import '../../../editor/bloc/editor_bloc.dart';
import '../../../editor/widgets/toolbar/tool_info.dart';
import '../app_command.dart';
import '../workspace_commands.dart';

extension ViewCommands on WorkspaceCommands {
  AppCommand get zoomIn => AppCommand(
    label: context.l10n.viewZoomIn,
    icon: Icons.zoom_in,
    onPressed: () => send(ViewZoomed(1.25, viewCenter)),
  );

  AppCommand get zoomOut => AppCommand(
    label: context.l10n.viewZoomOut,
    icon: Icons.zoom_out,
    onPressed: () => send(ViewZoomed(1 / 1.25, viewCenter)),
  );

  AppCommand get zoomFit => AppCommand(
    label: context.l10n.viewFitWindow,
    icon: Icons.fit_screen,
    onPressed: () => send(const FitRequested()),
  );

  String get zoomLabel => '${state.view.zoom.toStringAsFixed(1)}x';

  AppCommand get grid => AppCommand(
    label: context.l10n.viewGrid,
    icon: Icons.grid_on,
    checked: state.view.grid,
    onPressed: () => send(const GridToggled()),
  );

  AppCommand get snap => AppCommand(
    label: context.l10n.viewSnap,
    icon: Icons.straighten,
    checked: state.view.snap,
    onPressed: () => send(const SnapToggled()),
  );

  AppCommand get background => AppCommand(
    label: context.l10n.viewCanvasBackground,
    icon: Icons.format_color_fill,
    tooltip: context.l10n.viewCanvasBackgroundTooltip,
    onPressed: () => send(const BackgroundCycled()),
  );

  AppCommand get theme => AppCommand(
    label: dark ? context.l10n.viewLightTheme : context.l10n.viewDarkTheme,
    icon: Icons.brightness_6_outlined,
    tooltip: context.l10n.viewThemeTooltip,
    onPressed: () => themeBloc.add(
      ThemeModeChanged(dark ? ThemeMode.light : ThemeMode.dark),
    ),
  );

  AppCommand tool(Tool t) => AppCommand(
    label: t.localizedLabel(context),
    icon: t.icon,
    keys: t.keyLabel,
    checked: state.tool == t,
    onPressed: () => send(ToolSelected(t)),
  );
}
