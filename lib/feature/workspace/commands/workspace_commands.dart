// Dart imports:
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import '../../../common/constants/app_constants.dart';
import '../../../common/widgets/dialogs/app_dialogs.dart';
import '../../../common/app_router/route_names.dart';
import '../../../core/theme/bloc/theme_bloc.dart';
import '../../../domain/models/tool.dart';
import '../../editor/bloc/editor_bloc.dart';
import '../../editor/flows/image_flow.dart';
import '../../editor/logic/editor_ops.dart';
import '../../editor/widgets/toolbar/tool_info.dart';
import '../../export/export_args.dart';
import '../../settings/widgets/settings_dialog.dart';
import '../cubit/workspace_cubit.dart';
import '../flows/tab_flows.dart';
import 'app_command.dart';

/// Every action of the active project, as [AppCommand]s. The ribbon, the
/// native or in-window menus and the keyboard shortcuts all read from here, so
/// a label, an icon or an enabled state is defined once.
///
/// It is a snapshot: [CommandsBuilder] makes a new one whenever something that
/// changes an enabled or checked state changes. Handlers read the live state
/// from [bloc] when they run, never from the snapshot.
class WorkspaceCommands {
  WorkspaceCommands({
    required this.context,
    required this.ws,
    required this.bloc,
    required this.themeBloc,
    required this.state,
    required this.autoSaveOn,
    required this.dark,
  });

  final BuildContext context;
  final WorkspaceCubit ws;
  final EditorBloc bloc;
  final ThemeBloc themeBloc;
  final EditorState state;
  final bool autoSaveOn;
  final bool dark;

  bool get _hasShape => state.selectedShape != null;
  bool get _hasImage => state.layer.image != null;

  void _send(EditorEvent e) => bloc.add(e);

  Offset get _viewCenter {
    final v = bloc.state.view.viewport;
    return Offset(v.width / 2, v.height / 2);
  }

  // ---- file ---------------------------------------------------------------

  AppCommand get newBlank => AppCommand(
        label: 'New blank canvas',
        icon: Icons.note_add_outlined,
        shortcut: primaryShortcut(LogicalKeyboardKey.keyN),
        onPressed: ws.addBlank,
      );

  AppCommand get newRider => AppCommand(
        label: 'RoadBash rider',
        icon: Icons.two_wheeler,
        tooltip: 'New project from the RoadBash rider template',
        onPressed: () => newRiderTab(ws),
      );

  AppCommand get open => AppCommand(
        label: 'Open…',
        icon: Icons.folder_open,
        shortcut: primaryShortcut(LogicalKeyboardKey.keyO),
        onPressed: () => openProjectDialog(context, ws),
      );

  AppCommand get save => AppCommand(
        label: 'Save',
        icon: Icons.save_outlined,
        shortcut: primaryShortcut(LogicalKeyboardKey.keyS),
        onPressed: () => saveTab(context, ws, bloc),
      );

  AppCommand get saveAs => AppCommand(
        label: 'Save as…',
        icon: Icons.save_as_outlined,
        shortcut: primaryShortcut(LogicalKeyboardKey.keyS, shift: true),
        onPressed: () => saveTab(context, ws, bloc, saveAs: true),
      );

  AppCommand get autoSave => AppCommand(
        label: 'Auto-save',
        icon: Icons.autorenew,
        tooltip: 'Auto-save: write changes straight into the open .flp file. '
            'Off: changes go to a safe side copy until you press Save.',
        checked: autoSaveOn,
        onPressed: () => ws.setAutoSave(!autoSaveOn),
      );

  /// Opens the code editor as a page of its own, over the workspace.
  AppCommand get exportDart => AppCommand(
        label: 'Export Dart…',
        icon: Icons.code,
        tooltip: 'Open the code editor',
        shortcut: primaryShortcut(LogicalKeyboardKey.keyE),
        onPressed: () => context.push(
          RoutePaths.export,
          extra: ExportArgs(bloc.state.drawing),
        ),
      );

  AppCommand get settings => AppCommand(
        label: 'Settings…',
        icon: Icons.settings_outlined,
        shortcut: primaryShortcut(LogicalKeyboardKey.comma),
        onPressed: () => showSettingsDialog(context),
      );

  AppCommand get rename => AppCommand(
        label: 'Rename project…',
        icon: Icons.edit_outlined,
        tooltip: 'Project name (also used for class names)',
        onPressed: () async {
          final name = await promptText(
            context,
            title: 'Project name (also used for class names)',
            initial: bloc.state.drawing.name,
          );
          if (name != null && name.isNotEmpty) _send(DrawingRenamed(name));
        },
      );

  AppCommand get canvasSize => AppCommand(
        label: 'Canvas size…',
        icon: Icons.aspect_ratio,
        onPressed: () async {
          final d = bloc.state.drawing;
          final size = await promptSize(context, d.width, d.height);
          if (size != null) _send(CanvasResized(size.$1, size.$2));
        },
      );

  AppCommand get closeProject => AppCommand(
        label: 'Close project',
        icon: Icons.close,
        shortcut: primaryShortcut(LogicalKeyboardKey.keyW),
        onPressed: () => closeTab(context, ws, bloc),
      );

  /// Quits through the normal exit request, so unsaved work is still asked
  /// about. (macOS has its own Quit item in the application menu.)
  AppCommand get exitApp => AppCommand(
        label: 'Exit',
        icon: Icons.exit_to_app,
        onPressed: () =>
            ServicesBinding.instance.exitApplication(AppExitType.cancelable),
      );

  // ---- edit ---------------------------------------------------------------

  AppCommand get undo => AppCommand(
        label: 'Undo',
        icon: Icons.undo,
        shortcut: primaryShortcut(LogicalKeyboardKey.keyZ),
        onPressed: state.canUndo ? () => _send(const UndoRequested()) : null,
      );

  AppCommand get redo => AppCommand(
        label: 'Redo',
        icon: Icons.redo,
        shortcut: isMacOS
            ? primaryShortcut(LogicalKeyboardKey.keyZ, shift: true)
            : primaryShortcut(LogicalKeyboardKey.keyY),
        onPressed: state.canRedo ? () => _send(const RedoRequested()) : null,
      );

  AppCommand get duplicate => AppCommand(
        label: 'Duplicate',
        icon: Icons.content_copy,
        shortcut: primaryShortcut(LogicalKeyboardKey.keyD),
        onPressed: _hasShape ? () => _send(const ShapeDuplicated()) : null,
      );

  AppCommand get delete => AppCommand(
        label: 'Delete',
        icon: Icons.delete_outline,
        tooltip: 'Delete the selected shape or image',
        keys: 'Del',
        onPressed: (_hasShape || state.imageSelected)
            ? () => _send(const ShapeDeleted())
            : null,
      );

  AppCommand get bringForward => AppCommand(
        label: 'Bring forward',
        icon: Icons.flip_to_front,
        onPressed: _hasShape ? () => _send(const ShapeReordered(1)) : null,
      );

  AppCommand get sendBackward => AppCommand(
        label: 'Send backward',
        icon: Icons.flip_to_back,
        onPressed: _hasShape ? () => _send(const ShapeReordered(-1)) : null,
      );

  AppCommand get closedPath {
    final shape = state.selectedShape;
    return AppCommand(
      label: 'Closed path',
      icon: Icons.polyline_outlined,
      tooltip: 'Close or open the selected polygon / line path',
      checked: shape?.isClosed ?? false,
      onPressed: (shape != null && shape.usesVertices)
          ? () => _send(ClosedToggled(!shape.isClosed))
          : null,
    );
  }

  AppCommand get fillOn => AppCommand(
        label: 'Fill',
        icon: Icons.format_color_fill,
        checked: state.style.fillOn,
        onPressed: () => _send(FillToggled(!state.style.fillOn)),
      );

  AppCommand get strokeOn => AppCommand(
        label: 'Outline',
        icon: Icons.border_color,
        tooltip: 'Stroke (outline)',
        checked: state.style.strokeOn,
        onPressed: () => _send(StrokeToggled(!state.style.strokeOn)),
      );

  // ---- layers -------------------------------------------------------------

  AppCommand get layerAdd => AppCommand(
        label: 'New layer',
        icon: Icons.add_box_outlined,
        onPressed: () => _send(const LayerAdded()),
      );

  AppCommand get layerDelete => AppCommand(
        label: 'Delete layer',
        icon: Icons.delete_outline,
        onPressed: state.drawing.layers.length > 1
            ? () => _send(LayerDeleted(bloc.state.layerIndex))
            : null,
      );

  AppCommand get layerRename => AppCommand(
        label: 'Rename layer…',
        icon: Icons.edit_outlined,
        onPressed: () async {
          final s = bloc.state;
          final name = await promptText(
            context,
            title: 'Rename layer',
            initial: s.layer.name,
          );
          if (name != null && name.isNotEmpty) {
            _send(LayerRenamed(s.layerIndex, name));
          }
        },
      );

  AppCommand get layerUp => AppCommand(
        label: 'Move layer up',
        icon: Icons.arrow_upward,
        onPressed: state.layerIndex < state.drawing.layers.length - 1
            ? () => _send(LayerMoved(bloc.state.layerIndex, 1))
            : null,
      );

  AppCommand get layerDown => AppCommand(
        label: 'Move layer down',
        icon: Icons.arrow_downward,
        onPressed: state.layerIndex > 0
            ? () => _send(LayerMoved(bloc.state.layerIndex, -1))
            : null,
      );

  AppCommand get layerVisible => AppCommand(
        label: 'Show layer',
        icon: Icons.visibility,
        checked: state.layer.visible,
        onPressed: () => _send(LayerVisibilityToggled(bloc.state.layerIndex)),
      );

  // ---- layer image --------------------------------------------------------

  AppCommand get imageLoad => AppCommand(
        label: _hasImage ? 'Replace image…' : 'Load image…',
        icon: Icons.add_photo_alternate_outlined,
        tooltip: 'Put a picture on this layer',
        onPressed: () => chooseLayerImage(context, bloc),
      );

  AppCommand get imageLoadNewLayer => AppCommand(
        label: 'Image on new layer…',
        icon: Icons.library_add_outlined,
        tooltip: 'Load a picture onto a new layer',
        onPressed: () => chooseLayerImage(context, bloc, onNewLayer: true),
      );

  AppCommand get imageSelect => AppCommand(
        label: 'Select image',
        icon: Icons.crop_free,
        tooltip: 'Select this layer\'s image (shows resize handles)',
        onPressed: _hasImage ? () => _send(const ImageSelected()) : null,
      );

  AppCommand get imageTool => AppCommand(
        label: 'Move / resize image',
        icon: Icons.open_with,
        tooltip: 'Move / resize image tool',
        keys: Tool.reference.keyLabel,
        checked: state.tool == Tool.reference,
        onPressed: _hasImage ? () => _send(const ToolSelected(Tool.reference)) : null,
      );

  AppCommand get imageFit => AppCommand(
        label: 'Fit image to canvas',
        icon: Icons.fit_screen,
        tooltip: 'Fit the image to the canvas (resets stretch)',
        onPressed: _hasImage ? () => _send(const ImageFitted()) : null,
      );

  AppCommand get imageVisible => AppCommand(
        label: 'Show image',
        icon: Icons.image_outlined,
        checked: state.layer.image?.visible ?? false,
        onPressed: _hasImage
            ? () => _send(ImageVisibilityChanged(
                  !(bloc.state.layer.image?.visible ?? true),
                ))
            : null,
      );

  AppCommand get imageRemove => AppCommand(
        label: 'Remove image',
        icon: Icons.hide_image_outlined,
        onPressed: _hasImage ? () => _send(const ImageRemoved()) : null,
      );

  /// Slider drags apply at once; this records the history entry afterwards.
  void commitChanges() => _send(const ChangesCommitted());
  void setImageOpacity(double v) => _send(ImageOpacityChanged(v));
  void setImageScale(double v) => _send(ImageScaleChanged(v));

  // ---- view ---------------------------------------------------------------

  AppCommand get zoomIn => AppCommand(
        label: 'Zoom in',
        icon: Icons.zoom_in,
        onPressed: () => _send(ViewZoomed(1.25, _viewCenter)),
      );

  AppCommand get zoomOut => AppCommand(
        label: 'Zoom out',
        icon: Icons.zoom_out,
        onPressed: () => _send(ViewZoomed(1 / 1.25, _viewCenter)),
      );

  AppCommand get zoomFit => AppCommand(
        label: 'Fit to window',
        icon: Icons.fit_screen,
        onPressed: () => _send(const FitRequested()),
      );

  String get zoomLabel => '${state.view.zoom.toStringAsFixed(1)}x';

  AppCommand get grid => AppCommand(
        label: 'Grid',
        icon: Icons.grid_on,
        checked: state.view.grid,
        onPressed: () => _send(const GridToggled()),
      );

  AppCommand get snap => AppCommand(
        label: 'Snap to grid',
        icon: Icons.straighten,
        checked: state.view.snap,
        onPressed: () => _send(const SnapToggled()),
      );

  AppCommand get background => AppCommand(
        label: 'Canvas background',
        icon: Icons.format_color_fill,
        tooltip: 'Cycle the canvas background colour',
        onPressed: () => _send(const BackgroundCycled()),
      );

  AppCommand get theme => AppCommand(
        label: dark ? 'Light theme' : 'Dark theme',
        icon: Icons.brightness_6_outlined,
        tooltip: 'Switch between the light and dark theme',
        onPressed: () => themeBloc.add(
          ThemeModeChanged(dark ? ThemeMode.light : ThemeMode.dark),
        ),
      );

  // ---- tools --------------------------------------------------------------

  AppCommand tool(Tool t) => AppCommand(
        label: t.label,
        icon: t.icon,
        keys: t.keyLabel,
        checked: state.tool == t,
        onPressed: () => _send(ToolSelected(t)),
      );

  // ---- help ---------------------------------------------------------------

  AppCommand get about => AppCommand(
        label: 'About ${AppConstants.appTitle}',
        icon: Icons.info_outline,
        onPressed: () => showAboutDialog(
          context: context,
          applicationName: AppConstants.appTitle,
        ),
      );

  /// Used by the image slider ranges so the thumb is always inside them.
  static double scaleMin(double scale) => math.min(0.01, scale);
  static double scaleMax(double scale) => math.max(4.0, scale * 1.5);
}
