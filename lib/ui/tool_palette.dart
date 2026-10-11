// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../editor/editor_controller.dart';
import '../editor/tool.dart';

class ToolPalette extends StatelessWidget {
  const ToolPalette({super.key, required this.controller});

  final EditorController controller;

  static const _items = <(Tool, IconData, String)>[
    (Tool.select, Icons.near_me, 'Select / move'),
    (Tool.rect, Icons.crop_square, 'Rectangle'),
    (Tool.ellipse, Icons.circle_outlined, 'Ellipse'),
    (Tool.line, Icons.horizontal_rule, 'Line'),
    (Tool.polygon, Icons.change_history, 'Polygon / line path'),
    (Tool.freehand, Icons.brush, 'Freehand'),
    (Tool.reference, Icons.image_outlined, 'Move background image'),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => SizedBox(
        width: 56,
        child: Column(children: [
          const SizedBox(height: 8),
          for (final (tool, icon, label) in _items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: IconButton(
                tooltip: label,
                icon: Icon(icon),
                onPressed: () => controller.setTool(tool),
                style: IconButton.styleFrom(
                  backgroundColor:
                      controller.tool == tool ? scheme.primaryContainer : null,
                  foregroundColor:
                      controller.tool == tool ? scheme.onPrimaryContainer : null,
                ),
              ),
            ),
        ]),
      ),
    );
  }
}
