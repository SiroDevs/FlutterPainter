// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import '../../common/app_router/route_names.dart';
import '../../domain/models/app_settings.dart';
import '../../domain/models/export_options.dart';
import '../settings/cubit/settings_cubit.dart';
import 'cubit/export_cubit.dart';
import 'export_args.dart';
import 'flows/export_flows.dart';
import 'widgets/code_editor.dart';
import 'widgets/editor_tabs.dart';
import 'widgets/explorer_sidebar.dart';
import 'widgets/export_status_bar.dart';
import 'widgets/export_top_bar.dart';
import 'widgets/vscode_colors.dart';

/// The code editor, a page of its own laid out like VS Code: a menu bar across
/// the top, an activity bar and file explorer on the left, tabs and the editor
/// in the middle, and a status bar along the bottom. The files exist only in
/// memory until saved.
class ExportScreen extends StatefulWidget {
  const ExportScreen({super.key, required this.args});

  final ExportArgs args;

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  late final ExportCubit _cubit;
  final ValueNotifier<CaretInfo> _caret = ValueNotifier(const CaretInfo(1, 1));
  final EditorViewStore _views = EditorViewStore();
  double _sidebarWidth = 250;

  ExportOptions get _options =>
      ExportOptions.fromSettings(context.read<SettingsCubit>().state);

  @override
  void initState() {
    super.initState();
    _cubit = ExportCubit(widget.args.drawing, _options);
  }

  @override
  void dispose() {
    _cubit.close();
    _caret.dispose();
    super.dispose();
  }

  Future<void> _close() async {
    if (_cubit.state.hasEdits) {
      final ok = await confirm(
        context,
        title: 'Close the code editor?',
        message: 'Your edits to the generated files have not been saved and '
            'will be lost.',
        confirmLabel: 'Close',
      );
      if (!ok || !mounted) return;
    }
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(RoutePaths.workspace);
    }
  }

  Future<void> _regenerate() async {
    if (_cubit.state.hasEdits) {
      final ok = await confirm(
        context,
        title: 'Regenerate the files?',
        message: 'This rebuilds every file from the drawing and drops your '
            'edits.',
        confirmLabel: 'Regenerate',
      );
      if (!ok || !mounted) return;
    }
    _cubit.regenerate(_options);
  }

  /// The export settings changed while the editor was open.
  void _onSettingsChanged(AppSettings settings) {
    if (!_cubit.state.hasEdits) {
      _cubit.regenerate(ExportOptions.fromSettings(settings));
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text(
            'Export settings changed. Regenerate to apply them (this drops '
            'your edits).',
          ),
          action: SnackBarAction(label: 'Regenerate', onPressed: _regenerate),
        ),
      );
  }

  Map<ShortcutActivator, VoidCallback> _bindings() {
    final map = <ShortcutActivator, VoidCallback>{};
    void both(LogicalKeyboardKey key, VoidCallback f, {bool shift = false}) {
      map[SingleActivator(key, control: true, shift: shift)] = f;
      map[SingleActivator(key, meta: true, shift: shift)] = f;
    }

    both(LogicalKeyboardKey.keyS, () => saveLocally(context, _cubit));
    both(LogicalKeyboardKey.keyS, () => saveArchive(context, _cubit), shift: true);
    both(LogicalKeyboardKey.keyW, () {
      final active = _cubit.state.activePath;
      if (active != null) _cubit.closeTab(active);
    });
    map[const SingleActivator(LogicalKeyboardKey.keyF, shift: true, alt: true)] =
        _cubit.formatActive;
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final colors = VsCodeColors.of(Theme.of(context).brightness);
    final isMac = Theme.of(context).platform == TargetPlatform.macOS;
    final style = context.select<SettingsCubit, CodeStyle>(
      (c) => c.state.codeStyle,
    );

    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<SettingsCubit, AppSettings>(
        listenWhen: (a, b) =>
            ExportOptions.fromSettings(a) != ExportOptions.fromSettings(b),
        listener: (context, settings) => _onSettingsChanged(settings),
        child: Scaffold(
          backgroundColor: colors.editorBg,
          body: CallbackShortcuts(
            bindings: _bindings(),
            child: Focus(
              autofocus: true,
              child: Column(children: [
                ExportTopBar(
                  colors: colors,
                  title: 'Code editor \u2014 ${widget.args.drawing.name}',
                  modifier: isMac ? '\u2318' : 'Ctrl',
                  onSaveLocally: () => saveLocally(context, _cubit),
                  onSaveArchive: () => saveArchive(context, _cubit),
                  onCopy: _cubit.copyActive,
                  onFormat: _cubit.formatActive,
                  onRegenerate: _regenerate,
                  onClose: _close,
                ),
                Expanded(
                  child: Row(children: [
                    ActivityBar(colors: colors),
                    SizedBox(
                      width: _sidebarWidth,
                      child: ExplorerSidebar(colors: colors),
                    ),
                    _splitter(colors),
                    Expanded(child: _editorArea(colors)),
                  ]),
                ),
                ExportStatusBar(
                  colors: colors,
                  caret: _caret,
                  styleLabel: style.label,
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  /// A thin, draggable divider between the explorer and the editor.
  Widget _splitter(VsCodeColors colors) => MouseRegion(
        cursor: SystemMouseCursors.resizeColumn,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalDragUpdate: (d) => setState(() {
            _sidebarWidth = (_sidebarWidth + d.delta.dx).clamp(160.0, 420.0);
          }),
          child: Container(width: 4, color: colors.border),
        ),
      );

  Widget _editorArea(VsCodeColors colors) {
    return Column(children: [
      EditorTabs(colors: colors),
      Expanded(
        child: BlocBuilder<ExportCubit, ExportState>(
          buildWhen: (a, b) =>
              a.activePath != b.activePath ||
              a.activeFile?.content != b.activeFile?.content,
          builder: (context, state) {
            final file = state.activeFile;
            if (file == null) return _welcome(colors);
            return Column(children: [
              _breadcrumb(colors, state.folderName, file.path),
              Expanded(
                child: CodeEditor(
                  key: ValueKey(file.path),
                  file: file,
                  colors: colors,
                  views: _views,
                  caret: _caret,
                  onChanged: (text) => _cubit.edit(file.path, text),
                ),
              ),
            ]);
          },
        ),
      ),
    ]);
  }

  Widget _breadcrumb(VsCodeColors colors, String folder, String path) {
    final parts = [folder, ...path.split('/')];
    final style = TextStyle(fontSize: 12, color: colors.tabInactiveText);
    return Container(
      height: 22,
      color: colors.editorBg,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      child: Row(children: [
        for (var i = 0; i < parts.length; i++) ...[
          if (i > 0)
            Icon(Icons.chevron_right, size: 14, color: colors.tabInactiveText),
          Text(
            parts[i],
            style: i == parts.length - 1
                ? style.copyWith(color: colors.tabActiveText)
                : style,
          ),
        ],
      ]),
    );
  }

  Widget _welcome(VsCodeColors colors) => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.code, size: 72, color: colors.border),
          const SizedBox(height: 12),
          Text(
            'Select a file in the explorer to open it',
            style: TextStyle(color: colors.tabInactiveText),
          ),
        ]),
      );
}
