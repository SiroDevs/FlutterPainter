// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Displays a tree name with an inline edit mode.
class InlineTreeNameEditor extends StatefulWidget {
  const InlineTreeNameEditor({
    super.key,
    required this.name,
    required this.tooltip,
    required this.onSaved,
    this.style,
    this.allowEmpty = false,
  });

  final String name;
  final String tooltip;
  final ValueChanged<String> onSaved;
  final TextStyle? style;
  final bool allowEmpty;

  @override
  State<InlineTreeNameEditor> createState() => _InlineTreeNameEditorState();
}

class _InlineTreeNameEditorState extends State<InlineTreeNameEditor> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.name);
    _focusNode = FocusNode(debugLabel: 'Inline tree name editor');
  }

  @override
  void didUpdateWidget(InlineTreeNameEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_editing && oldWidget.name != widget.name) {
      _controller.text = widget.name;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _startEditing() {
    _controller.text = widget.name;
    setState(() => _editing = true);
  }

  void _finishEditing({required bool save}) {
    if (!_editing || !mounted) return;
    final name = _controller.text.trim();
    final shouldSave =
        save && (name.isNotEmpty || widget.allowEmpty) && name != widget.name;
    final onSaved = widget.onSaved;
    setState(() => _editing = false);
    if (shouldSave) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) onSaved(name);
      });
    }
  }

  KeyEventResult _handleKey(FocusNode _, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape) {
      _finishEditing(save: false);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: _editing
            ? Focus(
                onKeyEvent: _handleKey,
                onFocusChange: (focused) {
                  if (!focused) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted && _editing) _finishEditing(save: true);
                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: EditableText(
                    controller: _controller,
                    focusNode: _focusNode,
                    autofocus: true,
                    maxLines: 1,
                    style: DefaultTextStyle.of(context).style
                        .merge(widget.style),
                    cursorColor: Theme.of(context).colorScheme.primary,
                    backgroundCursorColor: Theme.of(context)
                        .colorScheme
                        .onSurface,
                    selectionColor:
                        Theme.of(context).textSelectionTheme.selectionColor ??
                        Theme.of(context).colorScheme.primary.withAlpha(100),
                    mouseCursor: SystemMouseCursors.text,
                    textInputAction: TextInputAction.done,
                    onTapOutside: (_) => _finishEditing(save: true),
                    onSubmitted: (_) => _finishEditing(save: true),
                  ),
                ),
              )
            : Text(
                widget.name,
                style: widget.style,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
      ),
      if (!_editing)
        IconButton(
          tooltip: widget.tooltip,
          iconSize: 16,
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.edit_outlined),
          onPressed: _startEditing,
        ),
    ],
  );
}
