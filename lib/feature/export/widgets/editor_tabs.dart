// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../cubit/export_cubit.dart';
import 'vscode_colors.dart';

/// The row of open files above the editor. Every tab has an X to close it
/// (middle-click works too); a dot marks a file with unsaved edits.
class EditorTabs extends StatelessWidget {
  const EditorTabs({super.key, required this.colors});

  final VsCodeColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      color: colors.tabBar,
      child: BlocBuilder<ExportCubit, ExportState>(
        buildWhen: (a, b) =>
            a.activePath != b.activePath ||
            !listEquals(a.openPaths, b.openPaths) ||
            !setEquals(a.modifiedPaths, b.modifiedPaths),
        builder: (context, state) {
          final cubit = context.read<ExportCubit>();
          return ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (final path in state.openPaths)
                _Tab(
                  colors: colors,
                  name: state.fileAt(path)?.name ?? path,
                  active: path == state.activePath,
                  modified: state.isModified(path),
                  onSelect: () => cubit.select(path),
                  onClose: () => cubit.close(path),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.colors,
    required this.name,
    required this.active,
    required this.modified,
    required this.onSelect,
    required this.onClose,
  });

  final VsCodeColors colors;
  final String name;
  final bool active;
  final bool modified;
  final VoidCallback onSelect;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final fg = active ? colors.tabActiveText : colors.tabInactiveText;
    return Listener(
      onPointerDown: (e) {
        if (e.buttons == kMiddleMouseButton) onClose();
      },
      child: InkWell(
        onTap: onSelect,
        hoverColor: colors.hover,
        child: Container(
          padding: const EdgeInsets.only(left: 12, right: 4),
          decoration: BoxDecoration(
            color: active ? colors.editorBg : colors.tabInactive,
            border: Border(
              top: BorderSide(
                color: active ? colors.accent : Colors.transparent,
                width: 1,
              ),
              right: BorderSide(color: colors.border),
            ),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.flutter_dash, size: 16, color: Color(0xFF42A5F5)),
            const SizedBox(width: 6),
            Text(
              name,
              style: TextStyle(
                fontSize: 13,
                color: fg,
                fontStyle: modified ? FontStyle.italic : FontStyle.normal,
              ),
            ),
            if (modified) ...[
              const SizedBox(width: 6),
              const Icon(Icons.circle, size: 8, color: Color(0xFFE2C08D)),
            ],
            const SizedBox(width: 4),
            Tooltip(
              message: 'Close',
              child: InkResponse(
                onTap: onClose,
                radius: 12,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(Icons.close, size: 16, color: fg),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
