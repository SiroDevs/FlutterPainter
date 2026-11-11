// Dart imports:
import 'dart:ui' show AppExitResponse;

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../editor/bloc/editor_bloc.dart';
import '../editor/editor_screen.dart';
import '../inline_code/widgets/inline_code_host.dart';
import '../quick_code/quick_code_request.dart';
import '../quick_code/widgets/quick_code_host.dart';
import 'cubit/workspace_cubit.dart';
import 'flows/tab_flows.dart';
import 'widgets/menus/app_menu_bar.dart';
import 'widgets/project_tabs.dart';
import 'widgets/ribbon/ribbon.dart';
import 'widgets/toolbar_area.dart';
import 'workspace_shortcuts.dart';

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
  final ValueNotifier<bool> _quickCodeOpen = ValueNotifier(false);
  final ValueNotifier<QuickCodeRequest?> _quickCodeRequest = ValueNotifier(
    null,
  );
  bool _dragging = false;

  // ignore: unused_element
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
    _quickCodeOpen.dispose();
    _quickCodeRequest.dispose();
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
    return await confirmExit(context, _ws)
        ? AppExitResponse.exit
        : AppExitResponse.cancel;
  }

  Future<void> _onDrop(DropDoneDetails details) async {
    setState(() => _dragging = false);
    for (final f in details.files) {
      if (!mounted) return;
      await openPath(context, _ws, f.path);
    }
  }

  void _openQuickCode(QuickCodeRequest request) {
    _inlineCode.value = false;
    _quickCodeRequest.value = request;
    _quickCodeOpen.value = true;
  }

  bool _isTyping() {
    final focusContext = FocusManager.instance.primaryFocus?.context;
    if (focusContext == null) return false;
    if (focusContext.widget is EditableText ||
        focusContext.widget is TextField) {
      return true;
    }
    var hasEditor = false;
    focusContext.visitAncestorElements((element) {
      if (element.widget is EditableText || element.widget is TextField) {
        hasEditor = true;
        return false;
      }
      return true;
    });
    return hasEditor;
  }

  @override
  Widget build(BuildContext context) {
    final shortcuts = WorkspaceShortcuts(
      context: context,
      workspace: _ws,
      isTyping: _isTyping,
    );
    return Focus(
      focusNode: _focus,
      autofocus: true,
      onKeyEvent: shortcuts.handleKey,
      child: Listener(
        onPointerDown: (_) {
          if (!_isTyping()) _focus.requestFocus();
        },
        child: DropTarget(
          onDragDone: _onDrop,
          onDragEntered: (_) => setState(() => _dragging = true),
          onDragExited: (_) => setState(() => _dragging = false),
          child: Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: [
                BlocBuilder<WorkspaceCubit, WorkspaceState>(
                  buildWhen: (a, b) =>
                      a.active != b.active || a.tabs.length != b.tabs.length,
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
                          child: Column(
                            children: [
                              ToolbarArea(ribbon: _ribbon),
                              ProjectTabs(
                                inlineCode: _inlineCode,
                                quickCodeOpen: _quickCodeOpen,
                                quickCodeRequest: _quickCodeRequest,
                              ),
                              const Divider(height: 1),
                              Expanded(
                                child: QuickCodeHost(
                                  open: _quickCodeOpen,
                                  request: _quickCodeRequest,
                                  child: InlineCodeHost(
                                    open: _inlineCode,
                                    child: EditorScreen(
                                      canvasFocus: _focus,
                                      onQuickCodeRequested: _openQuickCode,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                if (_dragging) _dropOverlay(),
              ],
            ),
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
