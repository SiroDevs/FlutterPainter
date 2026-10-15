// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../settings/widgets/settings_dialog.dart';
import '../cubit/export_cubit.dart';
import 'vscode_colors.dart';

/// The narrow icon strip at the far left, like VS Code's activity bar: the
/// explorer on top and the settings gear at the bottom.
class ActivityBar extends StatelessWidget {
  const ActivityBar({super.key, required this.colors});

  final VsCodeColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      color: colors.activityBar,
      child: Column(children: [
        // The explorer is the only view, so it is always the active one.
        Container(
          height: 48,
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: colors.activityIconActive, width: 2),
            ),
          ),
          child: Tooltip(
            message: 'Explorer',
            child: Icon(
              Icons.file_copy_outlined,
              size: 24,
              color: colors.activityIconActive,
            ),
          ),
        ),
        const Spacer(),
        IconButton(
          tooltip: 'Settings',
          iconSize: 24,
          color: colors.activityIcon,
          hoverColor: colors.hover.withAlpha(60),
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => showSettingsDialog(context),
        ),
        const SizedBox(height: 8),
      ]),
    );
  }
}

/// The file explorer: every generated file, in folders, with the active one
/// highlighted. A click opens the file in a tab.
class ExplorerSidebar extends StatefulWidget {
  const ExplorerSidebar({super.key, required this.colors});

  final VsCodeColors colors;

  @override
  State<ExplorerSidebar> createState() => _ExplorerSidebarState();
}

class _Folder {
  _Folder(this.name);

  final String name;
  final List<_Folder> folders = [];
  final List<String> files = []; // full paths

  _Folder folder(String child) {
    for (final f in folders) {
      if (f.name == child) return f;
    }
    final created = _Folder(child);
    folders.add(created);
    return created;
  }
}

class _ExplorerSidebarState extends State<ExplorerSidebar> {
  /// Folders the user collapsed, by their path (the root is the empty path).
  final Set<String> _collapsed = {};

  _Folder _tree(ExportState state) {
    final root = _Folder('');
    for (final file in state.files) {
      var folder = root;
      for (final name in file.folders) {
        folder = folder.folder(name);
      }
      folder.files.add(file.path);
    }
    return root;
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.colors;
    return Material(
      color: c.sideBar,
      child: BlocBuilder<ExportCubit, ExportState>(
        buildWhen: (a, b) =>
            a.activePath != b.activePath ||
            !listEquals(
              [for (final f in a.files) f.path],
              [for (final f in b.files) f.path],
            ) ||
            !setEquals(a.modifiedPaths, b.modifiedPaths),
        builder: (context, state) {
          final root = _tree(state);
          final rootCollapsed = _collapsed.contains('');
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 8, 6),
              child: Text(
                'EXPLORER',
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 0.6,
                  color: c.sideBarHeader,
                ),
              ),
            ),
            _row(
              depth: 0,
              icon: rootCollapsed ? Icons.chevron_right : Icons.expand_more,
              label: state.folderName.toUpperCase(),
              bold: true,
              onTap: () => setState(() => _toggle('')),
            ),
            if (!rootCollapsed)
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: _children(root, '', 1, state),
                ),
              ),
          ]);
        },
      ),
    );
  }

  void _toggle(String path) {
    if (!_collapsed.remove(path)) _collapsed.add(path);
  }

  List<Widget> _children(_Folder folder, String path, int depth, ExportState state) {
    final out = <Widget>[];
    final folders = [...folder.folders]..sort((a, b) => a.name.compareTo(b.name));
    for (final sub in folders) {
      final subPath = path.isEmpty ? sub.name : '$path/${sub.name}';
      final collapsed = _collapsed.contains(subPath);
      out.add(_row(
        depth: depth,
        icon: collapsed ? Icons.chevron_right : Icons.expand_more,
        label: sub.name,
        onTap: () => setState(() => _toggle(subPath)),
      ));
      if (!collapsed) out.addAll(_children(sub, subPath, depth + 1, state));
    }
    final files = [...folder.files]..sort();
    for (final path in files) {
      final file = state.fileAt(path)!;
      out.add(_row(
        depth: depth,
        icon: Icons.flutter_dash,
        iconColor: const Color(0xFF42A5F5),
        label: file.name,
        active: state.activePath == path,
        modified: state.isModified(path),
        onTap: () => context.read<ExportCubit>().open(path),
      ));
    }
    return out;
  }

  Widget _row({
    required int depth,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? iconColor,
    bool bold = false,
    bool active = false,
    bool modified = false,
  }) {
    final c = widget.colors;
    return InkWell(
      onTap: onTap,
      hoverColor: c.hover,
      child: Container(
        height: 22,
        color: active ? c.selection : null,
        padding: EdgeInsets.only(left: 8.0 + depth * 12, right: 8),
        child: Row(children: [
          Icon(icon, size: 16, color: iconColor ?? c.sideBarText),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
                color: c.sideBarText,
              ),
            ),
          ),
          if (modified)
            const Icon(Icons.circle, size: 8, color: Color(0xFFE2C08D)),
        ]),
      ),
    );
  }
}
