// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../cubit/export_cubit.dart';
import 'code_editor.dart';
import 'editor_tabs.dart';
import 'explorer_sidebar.dart';
import 'export_status_bar.dart';
import 'export_top_bar.dart';
import 'vscode_colors.dart';

/// Lays out the export controls, file explorer, editor and status bar.
class ExportWorkspace extends StatefulWidget {
  const ExportWorkspace({
    super.key,
    required this.colors,
    required this.title,
    required this.modifier,
    required this.styleLabel,
    required this.onSaveLocally,
    required this.onSaveArchive,
    required this.onCopy,
    required this.onFormat,
    required this.onRegenerate,
    required this.onClose,
  });

  final VsCodeColors colors;
  final String title;
  final String modifier;
  final String styleLabel;
  final VoidCallback onSaveLocally;
  final VoidCallback onSaveArchive;
  final VoidCallback onCopy;
  final VoidCallback onFormat;
  final VoidCallback onRegenerate;
  final VoidCallback onClose;

  @override
  State<ExportWorkspace> createState() => _ExportWorkspaceState();
}

class _ExportWorkspaceState extends State<ExportWorkspace> {
  final ValueNotifier<CaretInfo> _caret = ValueNotifier(const CaretInfo(1, 1));
  final EditorViewStore _views = EditorViewStore();
  double _sidebarWidth = 250;

  @override
  void dispose() {
    _caret.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors;
    return Column(
      children: [
        ExportTopBar(
          colors: colors,
          title: widget.title,
          modifier: widget.modifier,
          onSaveLocally: widget.onSaveLocally,
          onSaveArchive: widget.onSaveArchive,
          onCopy: widget.onCopy,
          onFormat: widget.onFormat,
          onRegenerate: widget.onRegenerate,
          onClose: widget.onClose,
        ),
        Expanded(
          child: Row(
            children: [
              ActivityBar(colors: colors),
              SizedBox(
                width: _sidebarWidth,
                child: ExplorerSidebar(colors: colors),
              ),
              _splitter(colors),
              Expanded(child: _editorArea(colors)),
            ],
          ),
        ),
        ExportStatusBar(
          colors: colors,
          caret: _caret,
          styleLabel: widget.styleLabel,
        ),
      ],
    );
  }

  Widget _splitter(VsCodeColors colors) => MouseRegion(
    cursor: SystemMouseCursors.resizeColumn,
    child: GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragUpdate: (details) => setState(() {
        _sidebarWidth = (_sidebarWidth + details.delta.dx).clamp(160.0, 420.0);
      }),
      child: Container(width: 4, color: colors.border),
    ),
  );

  Widget _editorArea(VsCodeColors colors) => Column(
    children: [
      EditorTabs(colors: colors),
      Expanded(
        child: BlocBuilder<ExportCubit, ExportState>(
          buildWhen: (before, after) =>
              before.activePath != after.activePath ||
              before.activeFile?.content != after.activeFile?.content,
          builder: (context, state) {
            final file = state.activeFile;
            if (file == null) return _welcome(colors);
            return Column(
              children: [
                _breadcrumb(colors, state.folderName, file.path),
                Expanded(
                  child: CodeEditor(
                    key: ValueKey(file.path),
                    file: file,
                    colors: colors,
                    views: _views,
                    caret: _caret,
                    onChanged: (text) =>
                        context.read<ExportCubit>().edit(file.path, text),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    ],
  );

  Widget _breadcrumb(VsCodeColors colors, String folder, String path) {
    final parts = [folder, ...path.split('/')];
    final style = TextStyle(fontSize: 12, color: colors.tabInactiveText);
    return Container(
      height: 22,
      color: colors.editorBg,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          for (var index = 0; index < parts.length; index++) ...[
            if (index > 0)
              Icon(
                Icons.chevron_right,
                size: 14,
                color: colors.tabInactiveText,
              ),
            Text(
              parts[index],
              style: index == parts.length - 1
                  ? style.copyWith(color: colors.tabActiveText)
                  : style,
            ),
          ],
        ],
      ),
    );
  }

  Widget _welcome(VsCodeColors colors) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.code, size: 72, color: colors.border),
        const SizedBox(height: 12),
        Text(
          'Select a file in the explorer to open it',
          style: TextStyle(color: colors.tabInactiveText),
        ),
      ],
    ),
  );
}
