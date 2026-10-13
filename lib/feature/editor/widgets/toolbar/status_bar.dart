// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../bloc/editor_bloc.dart';
import 'tool_hint.dart';

/// Cursor position in design units and a hint for the active tool.
class StatusBar extends StatelessWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall;
    return BlocBuilder<EditorBloc, EditorState>(
      buildWhen: (a, b) => a.cursor != b.cursor || a.tool != b.tool,
      builder: (context, state) {
        final p = state.cursor;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(children: [
            SizedBox(
              width: 150,
              child: Text(
                p == null
                    ? 'x -   y -'
                    : 'x ${p.dx.toStringAsFixed(1)}   y ${p.dy.toStringAsFixed(1)}',
                style: style,
              ),
            ),
            Expanded(
              child: Text(
                '${state.tool.hint}   Right-drag pans, wheel zooms.',
                style: style,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ]),
        );
      },
    );
  }
}
