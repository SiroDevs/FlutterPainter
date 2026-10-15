// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../core/theme/bloc/theme_bloc.dart';
import '../../editor/bloc/editor_bloc.dart';
import '../../editor/logic/editor_ops.dart';
import '../cubit/workspace_cubit.dart';
import 'workspace_commands.dart';

/// Builds [WorkspaceCommands] for the active project and rebuilds only when
/// something that changes a label, an enabled state or a check mark changes.
/// It must sit under the active tab's `EditorBloc` provider.
///
/// [detailed] also reacts to every change of the layer's image (its position,
/// size and opacity), which the ribbon's sliders need but the menus do not.
class CommandsBuilder extends StatelessWidget {
  const CommandsBuilder({
    super.key,
    required this.builder,
    this.detailed = false,
  });

  final Widget Function(BuildContext context, WorkspaceCommands commands)
      builder;
  final bool detailed;

  bool _changed(EditorState a, EditorState b) {
    final ai = a.layer.image;
    final bi = b.layer.image;
    return a.canUndo != b.canUndo ||
        a.canRedo != b.canRedo ||
        a.selected != b.selected ||
        a.layerIndex != b.layerIndex ||
        a.tool != b.tool ||
        a.style != b.style ||
        a.view.grid != b.view.grid ||
        a.view.snap != b.view.snap ||
        a.view.zoom != b.view.zoom ||
        a.drawing.name != b.drawing.name ||
        a.drawing.layers.length != b.drawing.layers.length ||
        a.layer.name != b.layer.name ||
        a.layer.visible != b.layer.visible ||
        (ai == null) != (bi == null) ||
        ai?.visible != bi?.visible ||
        a.selectedShape?.isClosed != b.selectedShape?.isClosed ||
        (detailed && ai != bi);
  }

  @override
  Widget build(BuildContext context) {
    final ws = context.read<WorkspaceCubit>();
    final bloc = context.read<EditorBloc>();
    final themeBloc = context.read<ThemeBloc>();
    // Reading the theme here rebuilds this when it switches light / dark.
    final dark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<WorkspaceCubit, WorkspaceState>(
      buildWhen: (a, b) => a.autoSave != b.autoSave,
      builder: (context, wsState) => BlocBuilder<EditorBloc, EditorState>(
        buildWhen: _changed,
        builder: (context, state) => builder(
          context,
          WorkspaceCommands(
            context: context,
            ws: ws,
            bloc: bloc,
            themeBloc: themeBloc,
            state: state,
            autoSaveOn: wsState.autoSave,
            dark: dark,
          ),
        ),
      ),
    );
  }
}
