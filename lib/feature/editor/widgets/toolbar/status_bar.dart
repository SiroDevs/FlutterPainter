// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Package imports:
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../../domain/models/app_settings.dart';
import '../../../settings/cubit/settings_cubit.dart';
import '../../bloc/editor_bloc.dart';
import 'tool_hint.dart';

/// Cursor position in design units and a hint for the active tool.
class StatusBar extends StatelessWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall;
    final preview = context.select<SettingsCubit, ColorPreview>(
      (c) => c.state.colorPreview,
    );
    return BlocBuilder<EditorBloc, EditorState>(
      buildWhen: (a, b) => a.cursor != b.cursor || a.tool != b.tool,
      builder: (context, state) {
        final p = state.cursor;
        return Row(children: [
          Text(
            p == null
                ? 'x -   y -'
                : 'x ${p.dx.toStringAsFixed(1)}   y ${p.dy.toStringAsFixed(1)}',
            style: style,
          ).width(150),
          Text(
            '${state.tool.hint}   Scroll or right-drag pans, Ctrl+wheel zooms.',
            style: style,
            overflow: TextOverflow.ellipsis,
          ).expanded(),
          if (preview != ColorPreview.none)
            Text('Preview: ${preview.label}', style: style),
        ]).padding(horizontal: 12, vertical: 4);
      },
    );
  }
}
