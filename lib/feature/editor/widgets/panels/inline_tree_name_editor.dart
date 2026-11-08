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
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.name);
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
    super.dispose();
  }

  void _startEditing() {
    _controller.text = widget.name;
    setState(() => _editing = true);
  }

  void _finishEditing({required bool save}) {
    if (!_editing) return;
    final name = _controller.text.trim();
    setState(() => _editing = false);
    if (save &&
        (name.isNotEmpty || widget.allowEmpty) &&
        name != widget.name) {
      widget.onSaved(name);
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
                  if (!focused) _finishEditing(save: true);
                },
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  maxLines: 1,
                  style: widget.style,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 4),
                  ),
                  onSubmitted: (_) => _finishEditing(save: true),
                ),
              )
            : Text(widget.name, style: widget.style),
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
