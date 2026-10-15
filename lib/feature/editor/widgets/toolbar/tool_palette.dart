// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../domain/models/tool.dart';
import '../../bloc/editor_bloc.dart';
import 'tool_info.dart';

/// The toolbox, laid out like Photoshop's: a narrow column where related tools
/// share one slot. The slot shows the tool you used last; a small triangle in
/// its corner means there are more, and right-click or press-and-hold opens a
/// flyout with the others. Thin lines separate the groups.
class ToolPalette extends StatelessWidget {
  const ToolPalette({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainer,
      child: BlocBuilder<EditorBloc, EditorState>(
        buildWhen: (a, b) => a.tool != b.tool,
        builder: (context, state) => SizedBox(
          width: 52,
          child: Column(children: [
            const SizedBox(height: 6),
            for (var g = 0; g < kToolGroups.length; g++) ...[
              if (g > 0)
                Divider(
                  height: 13,
                  indent: 10,
                  endIndent: 10,
                  color: scheme.outlineVariant,
                ),
              _ToolSlot(group: kToolGroups[g], active: state.tool),
            ],
          ]),
        ),
      ),
    );
  }
}

class _ToolSlot extends StatefulWidget {
  const _ToolSlot({required this.group, required this.active});

  final List<Tool> group;
  final Tool active;

  @override
  State<_ToolSlot> createState() => _ToolSlotState();
}

class _ToolSlotState extends State<_ToolSlot> {
  final MenuController _menu = MenuController();

  /// The tool this slot shows and activates when clicked.
  late Tool _shown = widget.group.first;

  void _choose(Tool tool) {
    setState(() => _shown = tool);
    context.read<EditorBloc>().add(ToolSelected(tool));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final group = widget.group;
    final inGroup = group.contains(widget.active);
    if (inGroup) _shown = widget.active;
    final hasMore = group.length > 1;

    final button = SizedBox(
      width: 44,
      height: 44,
      child: Stack(children: [
        Center(
          child: Tooltip(
            message: '${_shown.label} (${_shown.keyLabel})'
                '${hasMore ? '\nRight-click or hold for related tools' : ''}',
            child: IconButton(
              icon: Icon(_shown.icon),
              onPressed: () => _choose(_shown),
              style: IconButton.styleFrom(
                backgroundColor: inGroup ? scheme.primaryContainer : null,
                foregroundColor: inGroup ? scheme.onPrimaryContainer : null,
              ),
            ),
          ),
        ),
        if (hasMore)
          Positioned(
            right: 3,
            bottom: 3,
            child: IgnorePointer(
              child: CustomPaint(
                size: const Size(7, 7),
                painter: _CornerMark(scheme.onSurfaceVariant),
              ),
            ),
          ),
      ]),
    );

    if (!hasMore) return button;
    return MenuAnchor(
      controller: _menu,
      // Open to the right of the slot, level with it.
      alignmentOffset: const Offset(46, -44),
      menuChildren: [
        for (final t in group)
          MenuItemButton(
            leadingIcon: Icon(t.icon, size: 20),
            trailingIcon: Text(t.keyLabel),
            onPressed: () => _choose(t),
            child: Text(t.label),
          ),
      ],
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onSecondaryTapDown: (_) => _menu.open(),
        onLongPress: _menu.open,
        child: button,
      ),
    );
  }
}

/// The small right-angled triangle in a slot's corner that marks a flyout.
class _CornerMark extends CustomPainter {
  const _CornerMark(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_CornerMark old) => old.color != color;
}
