// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../domain/models/tool.dart';
import '../../bloc/editor_bloc.dart';

class ToolPalette extends StatelessWidget {
  const ToolPalette({super.key});

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
    return BlocBuilder<EditorBloc, EditorState>(
      buildWhen: (a, b) => a.tool != b.tool,
      builder: (context, state) => SizedBox(
        width: 56,
        child: Column(children: [
          const SizedBox(height: 8),
          for (final (tool, icon, label) in _items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: IconButton(
                tooltip: label,
                icon: Icon(icon),
                onPressed: () =>
                    context.read<EditorBloc>().add(ToolSelected(tool)),
                style: IconButton.styleFrom(
                  backgroundColor: state.tool == tool ? scheme.primaryContainer : null,
                  foregroundColor: state.tool == tool ? scheme.onPrimaryContainer : null,
                ),
              ),
            ),
        ]),
      ),
    );
  }
}
