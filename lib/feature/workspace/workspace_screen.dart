// Dart imports:
import 'dart:ui' show AppExitResponse;

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import '../../common/app_router/route_names.dart';
import '../../domain/models/tool.dart';
import '../editor/bloc/editor_bloc.dart';
import '../editor/editor_screen.dart';
import '../editor/widgets/toolbar/tool_info.dart';
import '../export/export_args.dart';
import '../inline_code/widgets/inline_code_host.dart';
import '../settings/widgets/settings_dialog.dart';
import 'cubit/workspace_cubit.dart';
import 'flows/tab_flows.dart';
import 'widgets/menus/app_menu_bar.dart';
import 'widgets/project_tabs.dart';
import 'widgets/ribbon/ribbon.dart';
import 'widgets/toolbar_area.dart';

/// The whole window: menu bar, ribbon, project tabs, and the active tab's
/// editor.
class WorkspaceScreen extends StatefulWidget {
  const WorkspaceScreen({super.key, this.initialPaths = const []});

  /// Files passed on the command line (for example by a file association).
  final List<String> initialPaths;

  @override
  State<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends State<WorkspaceScreen> {
  final FocusNode _focus = FocusNode(debugLabel: 'canvas');
  late final WorkspaceCubit _ws = context.read<WorkspaceCubit>();
  late final AppLifecycleListener _lifecycle;
  final RibbonController _ribbon = RibbonController();
  final ValueNotifier<bool> _inlineCode = ValueNotifier(false);
  bool _dragging = false;

  EditorBloc get _current => _ws.current;

  @override
  void initState() {
    super.initState();
    _ws.init();
    _lifecycle = AppLifecycleListener(onExitRequested: _onExitRequested);
    WidgetsBinding.instance.addPostFrameCallback((_) => _boot());
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _ribbon.dispose();
    _inlineCode.dispose();
    _focus.dispose();
    super.dispose();
  }

  /// Recovery of unsaved work, then any files given at launch.
  Future<void> _boot() async {
    if (!mounted) return;
    await recoverDrafts(context, _ws);
    for (final path in widget.initialPaths) {
      if (!mounted) return;
      await openPath(context, _ws, path);
    }
    _ws.dropPristineFirstTab();
  }

  /// Closing the window asks about each project with unsaved changes.
  Future<AppExitResponse> _onExitRequested() async {
    if (!mounted) return AppExitResponse.exit;
    return await confirmExit(context, _ws) ? AppExitResponse.exit : AppExitResponse.cancel;
  }

  Future<void> _onDrop(DropDoneDetails details) async {
    setState(() => _dragging = false);
    for (final f in details.files) {
      if (!mounted) return;
      await openPath(context, _ws, f.path);
    }
  }

  /// Single-key shortcuts must not fire while a text field has the keyboard.
  bool get _typing =>
      FocusManager.instance.primaryFocus?.context
          ?.findAncestorWidgetOfExactType<EditableText>() !=
      null;

  void _guarded(VoidCallback action) {
    if (!_typing) action();
  }

  Map<ShortcutActivator, VoidCallback> _bindings() {
    final map = <ShortcutActivator, VoidCallback>{};
    void both(LogicalKeyboardKey key, VoidCallback f, {bool shift = false}) {
      map[SingleActivator(key, control: true, shift: shift)] = f;
      map[SingleActivator(key, meta: true, shift: shift)] = f;
    }

    void send(EditorEvent e) => _current.add(e);

    both(LogicalKeyboardKey.keyZ, () => _guarded(() => send(const UndoRequested())));
    both(LogicalKeyboardKey.keyZ, () => _guarded(() => send(const RedoRequested())),
        shift: true);
    both(LogicalKeyboardKey.keyY, () => _guarded(() => send(const RedoRequested())));
    both(LogicalKeyboardKey.keyD, () => _guarded(() => send(const ShapeDuplicated())));
    both(LogicalKeyboardKey.keyS, () => saveTab(context, _ws, _current));
    both(LogicalKeyboardKey.keyS, () => saveTab(context, _ws, _current, saveAs: true),
        shift: true);
    both(LogicalKeyboardKey.keyO, () => openProjectDialog(context, _ws));
    both(LogicalKeyboardKey.keyN, _ws.addBlank);
    both(LogicalKeyboardKey.keyW, () => closeTab(context, _ws, _current));
    both(
      LogicalKeyboardKey.keyE,
      () => context.push(
        RoutePaths.export,
        extra: ExportArgs(_current.state.drawing),
      ),
    );
    both(LogicalKeyboardKey.comma, () => showSettingsDialog(context));

    // One letter per tool, like Photoshop (V select, R rectangle, ...).
    for (final tool in Tool.values) {
      map[SingleActivator(tool.shortcutKey)] =
          () => _guarded(() => send(ToolSelected(tool)));
    }

    map[const SingleActivator(LogicalKeyboardKey.delete)] =
        () => _guarded(() => send(const ShapeDeleted()));
    map[const SingleActivator(LogicalKeyboardKey.backspace)] =
        () => _guarded(() => send(const ShapeDeleted()));
    map[const SingleActivator(LogicalKeyboardKey.enter)] =
        () => _guarded(() => send(const PolygonFinished(closed: false)));
    map[const SingleActivator(LogicalKeyboardKey.enter, shift: true)] =
        () => _guarded(() => send(const PolygonFinished()));
    map[const SingleActivator(LogicalKeyboardKey.escape)] = () => _guarded(() {
          send(const DraftCancelled());
          send(const ToolSelected(Tool.select));
        });
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: _bindings(),
      child: Focus(
        focusNode: _focus,
        autofocus: true,
        child: DropTarget(
          onDragDone: _onDrop,
          onDragEntered: (_) => setState(() => _dragging = true),
          onDragExited: (_) => setState(() => _dragging = false),
          child: Scaffold(
            body: Stack(fit: StackFit.expand, children: [
              BlocBuilder<WorkspaceCubit, WorkspaceState>(
                buildWhen: (a, b) => a.active != b.active || a.tabs.length != b.tabs.length,
                builder: (context, _) {
                  final bloc = _ws.current;
                  // One editor bloc per tab. The provider (and so the menu bar,
                  // which on macOS must exist exactly once) stays put; only the
                  // editor below is keyed, so switching tabs rebuilds it
                  // against the right project.
                  return BlocProvider<EditorBloc>.value(
                    value: bloc,
                    child: AppMenuBar(
                      child: KeyedSubtree(
                        key: ObjectKey(bloc),
                        child: Column(children: [
                          ToolbarArea(ribbon: _ribbon),
                          ProjectTabs(inlineCode: _inlineCode),
                          const Divider(height: 1),
                          Expanded(
                            child: InlineCodeHost(
                              open: _inlineCode,
                              child: EditorScreen(canvasFocus: _focus),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  );
                },
              ),
              if (_dragging) _dropOverlay(),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _dropOverlay() => Positioned.fill(
        child: IgnorePointer(
          child: Container(
            color: const Color(0x99000000),
            alignment: Alignment.center,
            child: const Text(
              'Drop a .flp project to open it in a new tab,\n'
              'or an image to put on the active layer',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      );
}
