// Flutter imports:
import 'package:flutter/material.dart';

/// A subtle drag target for resizing adjacent editor panels.
class PanelResizeHandle extends StatelessWidget {
  const PanelResizeHandle({
    super.key,
    required this.axis,
    required this.onDragUpdate,
  });

  /// The direction in which dragging changes the panel size.
  final Axis axis;
  final ValueChanged<DragUpdateDetails> onDragUpdate;

  @override
  Widget build(BuildContext context) {
    final horizontal = axis == Axis.horizontal;
    final outline = Theme.of(context).colorScheme.outlineVariant;
    return MouseRegion(
      cursor: horizontal
          ? SystemMouseCursors.resizeLeftRight
          : SystemMouseCursors.resizeUpDown,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragUpdate: horizontal ? onDragUpdate : null,
        onVerticalDragUpdate: horizontal ? null : onDragUpdate,
        child: SizedBox(
          width: horizontal ? 8 : double.infinity,
          height: horizontal ? double.infinity : 8,
          child: Center(
            child: Container(
              width: horizontal ? 1 : 32,
              height: horizontal ? 32 : 1,
              color: outline,
            ),
          ),
        ),
      ),
    );
  }
}
