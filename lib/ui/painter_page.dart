// Dart imports:
import 'dart:ui' show AppExitResponse;

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:desktop_drop/desktop_drop.dart';

// Project imports:
import '../canvas/canvas_view.dart';
import '../editor/draw_ops.dart';
import '../editor/editor_controller.dart';
import '../editor/layer_ops.dart';
import '../editor/tool.dart';
import '../export/export_dialog.dart';
import '../workspace/tab_actions.dart';
import '../workspace/workspace.dart';
import 'color_bar.dart';
import 'layers_panel.dart';
import 'project_tabs.dart';
import 'properties_panel.dart';
import 'reference_panel.dart';
import 'status_bar.dart';
import 'tool_palette.dart';
import 'top_bar.dart';

class PainterPage extends StatefulWidget {
  const PainterPage({super.key, this.initialPaths = const []});

  /// Files passed on the command line (for example by a file association).
  final List<String> initialPaths;

  @override
  State<PainterPage> createState() => _PainterPageState();
}

class _PainterPageState extends State<PainterPage> {
  final Workspace _ws = Workspace();
  final FocusNode _focus = FocusNode(debugLabel: 'canvas');
  late final AppLifecycleListener _lifecycle;
  bool _dragging = false;

  EditorController get _c => _ws.current;

  @override
  void initState() {
    super.initState();
    _ws.addBlank();
    _lifecycle = AppLifecycleListener(onExitRequested: _onExitRequested);
    WidgetsBinding.instance.addPostFrameCallback((_) => _boot());
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _ws.dispose();
    _focus.dispose();
    super.dispose();
  }

  /// Settings, recovery of unsaved work, then any files given at launch.
  Future<void> _boot() async {
    await _ws.init();
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

    both(LogicalKeyboardKey.keyZ, () => _guarded(_c.undo));
    both(LogicalKeyboardKey.keyZ, () => _guarded(_c.redo), shift: true);
    both(LogicalKeyboardKey.keyY, () => _guarded(_c.redo));
    both(LogicalKeyboardKey.keyD, () => _guarded(_c.duplicateSelected));
    both(LogicalKeyboardKey.keyS, () => saveTab(context, _ws, _c));
    both(LogicalKeyboardKey.keyS, () => saveTab(context, _ws, _c, saveAs: true), shift: true);
    both(LogicalKeyboardKey.keyO, () => openProjectDialog(context, _ws));
    both(LogicalKeyboardKey.keyN, _ws.addBlank);
    both(LogicalKeyboardKey.keyW, () => closeTab(context, _ws, _c));
    both(LogicalKeyboardKey.keyE, () => showExportDialog(context, _c.drawing));

    map[const SingleActivator(LogicalKeyboardKey.delete)] = () => _guarded(_c.deleteSelected);
    map[const SingleActivator(LogicalKeyboardKey.backspace)] = () => _guarded(_c.deleteSelected);
    map[const SingleActivator(LogicalKeyboardKey.enter)] =
        () => _guarded(() => _c.finishPolygon(closed: false));
    map[const SingleActivator(LogicalKeyboardKey.enter, shift: true)] =
        () => _guarded(_c.finishPolygon);
    map[const SingleActivator(LogicalKeyboardKey.escape)] = () => _guarded(() {
          _c.cancelDraft();
          if (_c.tool != Tool.select) _c.setTool(Tool.select);
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
              Column(children: [
                TopBar(workspace: _ws),
                ProjectTabs(
                  workspace: _ws,
                  onClose: (c) => closeTab(context, _ws, c),
                  onNew: _ws.addBlank,
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListenableBuilder(
                    listenable: _ws,
                    builder: (context, _) {
                      final c = _ws.current;
                      return KeyedSubtree(key: ObjectKey(c), child: _editor(c));
                    },
                  ),
                ),
              ]),
              if (_dragging) _dropOverlay(),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _editor(EditorController c) {
    return Column(children: [
      Expanded(
        child: Row(children: [
          ToolPalette(controller: c),
          const VerticalDivider(width: 1),
          Expanded(child: CanvasView(controller: c, focus: _focus)),
          const VerticalDivider(width: 1),
          SizedBox(
            width: 290,
            child: Column(children: [
              Expanded(flex: 2, child: LayersPanel(controller: c)),
              const Divider(height: 1),
              ReferencePanel(controller: c),
              const Divider(height: 1),
              Expanded(flex: 3, child: PropertiesPanel(controller: c)),
            ]),
          ),
        ]),
      ),
      const Divider(height: 1),
      ColorBar(controller: c),
      const Divider(height: 1),
      StatusBar(controller: c),
    ]);
  }

  Widget _dropOverlay() => Positioned.fill(
        child: IgnorePointer(
          child: Container(
            color: const Color(0x99000000),
            alignment: Alignment.center,
            child: const Text(
              'Drop a .flp project to open it in a new tab,\nor an image to use as the background',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      );
}
