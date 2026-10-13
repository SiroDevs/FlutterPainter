// Dart imports:
import 'dart:ui' show AppExitResponse;

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../domain/models/tool.dart';
import '../editor/bloc/editor_bloc.dart';
import '../editor/editor_screen.dart';
import '../export/widgets/export_dialog.dart';
import 'cubit/workspace_cubit.dart';
import 'flows/tab_flows.dart';
import 'widgets/project_tabs.dart';
import 'widgets/top_bar.dart';

/// The whole window: top bar, project tabs, and the active tab's editor.
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
    both(LogicalKeyboardKey.keyE, () => showExportDialog(context, _current.state.drawing));

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
                  // One editor bloc per tab, keyed so switching tabs rebuilds
                  // the whole editor against the right project.
                  return BlocProvider<EditorBloc>.value(
                    key: ObjectKey(bloc),
                    value: bloc,
                    child: Column(children: [
                      const TopBar(),
                      const ProjectTabs(),
                      const Divider(height: 1),
                      Expanded(child: EditorScreen(canvasFocus: _focus)),
                    ]),
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
              'or an image to use as the background',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      );
}
