// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../editor/editor_controller.dart';
import '../editor/tool.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({super.key, required this.controller});

  final EditorController controller;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(children: [
        SizedBox(
          width: 150,
          child: ValueListenableBuilder<Offset?>(
            valueListenable: controller.cursor,
            builder: (context, p, _) => Text(
              p == null ? 'x -   y -' : 'x ${p.dx.toStringAsFixed(1)}   y ${p.dy.toStringAsFixed(1)}',
              style: style,
            ),
          ),
        ),
        Expanded(
          child: ListenableBuilder(
            listenable: controller,
            builder: (context, _) => Text(
              '${controller.tool.hint}   Right-drag pans, wheel zooms.',
              style: style,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ]),
    );
  }
}
