// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../common/widgets/dialogs/app_dialogs.dart';
import '../../../core/theme/bloc/theme_bloc.dart';
import '../../editor/bloc/editor_bloc.dart';
import '../../editor/logic/editor_ops.dart';
import '../../export/widgets/export_dialog.dart';
import '../cubit/workspace_cubit.dart';
import '../flows/tab_flows.dart';

/// File actions, undo/redo, zoom and view toggles for the active tab. It sits
/// under the active tab's `EditorBloc` provider.
class TopBar extends StatelessWidget {
  const TopBar({super.key});

  Future<void> _rename(BuildContext context, EditorBloc bloc) async {
    final name = await promptText(
      context,
      title: 'Project name (also used for class names)',
      initial: bloc.state.drawing.name,
    );
    if (name != null && name.isNotEmpty) bloc.add(DrawingRenamed(name));
  }

  Future<void> _resize(BuildContext context, EditorBloc bloc) async {
    final d = bloc.state.drawing;
    final size = await promptSize(context, d.width, d.height);
    if (size != null) bloc.add(CanvasResized(size.$1, size.$2));
  }

  @override
  Widget build(BuildContext context) {
    final ws = context.read<WorkspaceCubit>();
    final bloc = context.read<EditorBloc>();
    return BlocBuilder<EditorBloc, EditorState>(
      buildWhen: (a, b) =>
          a.view != b.view ||
          a.canUndo != b.canUndo ||
          a.canRedo != b.canRedo ||
          a.drawing.name != b.drawing.name,
      builder: (context, state) {
        final v = state.view;
        final center = Offset(v.viewport.width / 2, v.viewport.height / 2);
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(children: [
            PopupMenuButton<String>(
              tooltip: 'New project (Ctrl+N)',
              icon: const Icon(Icons.note_add_outlined),
              onSelected: (choice) => choice == 'rider' ? newRiderTab(ws) : ws.addBlank(),
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'blank', child: Text('Blank canvas')),
                PopupMenuItem(value: 'rider', child: Text('RoadBash rider (template)')),
              ],
            ),
            _btn(Icons.folder_open, 'Open (Ctrl+O)', () => openProjectDialog(context, ws)),
            _btn(Icons.save_outlined, 'Save (Ctrl+S)', () => saveTab(context, ws, bloc)),
            _btn(Icons.save_as_outlined, 'Save as (Ctrl+Shift+S)',
                () => saveTab(context, ws, bloc, saveAs: true)),
            BlocBuilder<WorkspaceCubit, WorkspaceState>(
              buildWhen: (a, b) => a.autoSave != b.autoSave,
              builder: (context, wsState) => Tooltip(
                message: 'Auto-save: write changes straight into the open .flp file.\n'
                    'Off: changes go to a safe side copy until you press Save.',
                child: Row(children: [
                  const Text('Auto-save'),
                  Switch(value: wsState.autoSave, onChanged: ws.setAutoSave),
                ]),
              ),
            ),
            FilledButton.icon(
              onPressed: () => showExportDialog(context, bloc.state.drawing),
              icon: const Icon(Icons.code, size: 18),
              label: const Text('Export Dart'),
            ),
            _divider(),
            _btn(Icons.undo, 'Undo (Ctrl+Z)',
                state.canUndo ? () => bloc.add(const UndoRequested()) : null),
            _btn(Icons.redo, 'Redo (Ctrl+Y)',
                state.canRedo ? () => bloc.add(const RedoRequested()) : null),
            _divider(),
            _btn(Icons.zoom_out, 'Zoom out',
                () => bloc.add(ViewZoomed(1 / 1.25, center))),
            SizedBox(
              width: 48,
              child: Text('${v.zoom.toStringAsFixed(1)}x', textAlign: TextAlign.center),
            ),
            _btn(Icons.zoom_in, 'Zoom in',
                () => bloc.add(ViewZoomed(1.25, center))),
            _btn(Icons.fit_screen, 'Fit to window',
                () => bloc.add(const FitRequested())),
            _divider(),
            _toggle(Icons.grid_on, 'Grid', v.grid,
                () => bloc.add(const GridToggled())),
            _toggle(Icons.straighten, 'Snap to grid', v.snap,
                () => bloc.add(const SnapToggled())),
            _btn(Icons.format_color_fill, 'Cycle canvas background',
                () => bloc.add(const BackgroundCycled())),
            _btn(Icons.aspect_ratio, 'Canvas size', () => _resize(context, bloc)),
            _btn(Icons.brightness_6_outlined, 'Light / dark theme', () {
              final theme = context.read<ThemeBloc>();
              theme.add(ThemeModeChanged(
                theme.state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
              ));
            }),
            TextButton.icon(
              onPressed: () => _rename(context, bloc),
              icon: const Icon(Icons.edit_outlined, size: 16),
              label: Text(state.drawing.name),
            ),
          ]),
        );
      },
    );
  }

  Widget _btn(IconData icon, String tip, VoidCallback? onPressed) =>
      IconButton(tooltip: tip, icon: Icon(icon), onPressed: onPressed);

  Widget _toggle(IconData icon, String tip, bool on, VoidCallback onPressed) =>
      IconButton(tooltip: tip, isSelected: on, icon: Icon(icon), onPressed: onPressed);

  Widget _divider() => const SizedBox(height: 24, child: VerticalDivider(width: 20));
}
