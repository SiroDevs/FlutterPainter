// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../editor/layer_ops.dart';
import '../editor/view_ops.dart';
import '../export/export_dialog.dart';
import '../workspace/tab_actions.dart';
import '../workspace/workspace.dart';
import 'dialogs.dart';

/// File actions, undo/redo, zoom and view toggles for the active tab.
class TopBar extends StatelessWidget {
  const TopBar({super.key, required this.workspace});

  final Workspace workspace;

  Future<void> _rename(BuildContext context) async {
    final c = workspace.current;
    final name = await promptText(context,
        title: 'Project name (also used for class names)', initial: c.drawing.name);
    if (name != null && name.isNotEmpty) c.renameDrawing(name);
  }

  Future<void> _resize(BuildContext context) async {
    final c = workspace.current;
    final size = await promptSize(context, c.drawing.width, c.drawing.height);
    if (size != null) c.setCanvasSize(size.$1, size.$2);
  }

  @override
  Widget build(BuildContext context) {
    final ws = workspace;
    return ListenableBuilder(
      listenable: Listenable.merge([ws, ws.current]),
      builder: (context, _) {
        final c = ws.current;
        final center = Offset(c.viewport.width / 2, c.viewport.height / 2);
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(children: [
            PopupMenuButton<String>(
              tooltip: 'New project (Ctrl+N)',
              icon: const Icon(Icons.note_add_outlined),
              onSelected: (v) => v == 'rider' ? newRiderTab(ws) : ws.addBlank(),
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'blank', child: Text('Blank canvas')),
                PopupMenuItem(value: 'rider', child: Text('RoadBash rider (template)')),
              ],
            ),
            _btn(Icons.folder_open, 'Open (Ctrl+O)', () => openProjectDialog(context, ws)),
            _btn(Icons.save_outlined, 'Save (Ctrl+S)', () => saveTab(context, ws, c)),
            _btn(Icons.save_as_outlined, 'Save as (Ctrl+Shift+S)',
                () => saveTab(context, ws, c, saveAs: true)),
            Tooltip(
              message: 'Auto-save: write changes straight into the open .flp file.\n'
                  'Off: changes go to a safe side copy until you press Save.',
              child: Row(children: [
                const Text('Auto-save'),
                Switch(value: ws.autoSave, onChanged: ws.setAutoSave),
              ]),
            ),
            FilledButton.icon(
              onPressed: () => showExportDialog(context, c.drawing),
              icon: const Icon(Icons.code, size: 18),
              label: const Text('Export Dart'),
            ),
            _divider(),
            _btn(Icons.undo, 'Undo (Ctrl+Z)', c.canUndo ? c.undo : null),
            _btn(Icons.redo, 'Redo (Ctrl+Y)', c.canRedo ? c.redo : null),
            _divider(),
            _btn(Icons.zoom_out, 'Zoom out', () => c.zoomAt(1 / 1.25, center)),
            SizedBox(
              width: 48,
              child: Text('${c.zoom.toStringAsFixed(1)}x', textAlign: TextAlign.center),
            ),
            _btn(Icons.zoom_in, 'Zoom in', () => c.zoomAt(1.25, center)),
            _btn(Icons.fit_screen, 'Fit to window', c.requestFit),
            _divider(),
            _toggle(Icons.grid_on, 'Grid', c.grid, () {
              c.grid = !c.grid;
              c.touch();
            }),
            _toggle(Icons.straighten, 'Snap to grid', c.snap, () {
              c.snap = !c.snap;
              c.touch();
            }),
            _btn(Icons.format_color_fill, 'Cycle canvas background', () {
              c.bg++;
              c.touch();
            }),
            _btn(Icons.aspect_ratio, 'Canvas size', () => _resize(context)),
            TextButton.icon(
              onPressed: () => _rename(context),
              icon: const Icon(Icons.edit_outlined, size: 16),
              label: Text(c.drawing.name),
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
