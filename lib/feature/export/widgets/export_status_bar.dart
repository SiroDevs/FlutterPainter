// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../cubit/export_cubit.dart';
import 'code_editor.dart';
import 'vscode_colors.dart';

/// The blue status bar along the bottom: caret position, line count, the last
/// thing that happened, and the file's encoding, line ending and language.
class ExportStatusBar extends StatelessWidget {
  const ExportStatusBar({
    super.key,
    required this.colors,
    required this.caret,
    required this.styleLabel,
  });

  final VsCodeColors colors;
  final ValueNotifier<CaretInfo> caret;

  /// "Refactored" or "Monolithic".
  final String styleLabel;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontSize: 12, color: colors.statusText);
    Widget gap() => const SizedBox(width: 16);
    return Container(
      height: 22,
      color: colors.statusBar,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: BlocBuilder<ExportCubit, ExportState>(
        buildWhen: (a, b) =>
            a.status != b.status ||
            a.activePath != b.activePath ||
            a.activeFile?.content != b.activeFile?.content,
        builder: (context, state) {
          final file = state.activeFile;
          final lines =
              file == null ? 0 : '\n'.allMatches(file.content).length + 1;
          return Row(children: [
            if (file != null) ...[
              ValueListenableBuilder<CaretInfo>(
                valueListenable: caret,
                builder: (context, c, _) => Text(
                  c.selected > 0
                      ? 'Ln ${c.line}, Col ${c.column} (${c.selected} selected)'
                      : 'Ln ${c.line}, Col ${c.column}',
                  style: style,
                ),
              ),
              gap(),
              Text('$lines lines', style: style),
              gap(),
            ],
            Expanded(
              child: Text(
                state.status,
                overflow: TextOverflow.ellipsis,
                style: style,
              ),
            ),
            Text('Spaces: 2', style: style),
            gap(),
            Text('UTF-8', style: style),
            gap(),
            Text('LF', style: style),
            gap(),
            Text('Dart', style: style),
            gap(),
            Text(styleLabel, style: style),
          ]);
        },
      ),
    );
  }
}
