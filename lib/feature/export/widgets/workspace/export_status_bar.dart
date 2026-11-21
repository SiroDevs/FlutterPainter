// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../../core/utils/l10n_ext.dart';
import '../../cubit/export_cubit.dart';
import '../code_editor/exports.dart';
import '../exports.dart';

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
    return BlocBuilder<ExportCubit, ExportState>(
      buildWhen: (a, b) =>
          a.status != b.status ||
          a.generationFailed != b.generationFailed ||
          a.activePath != b.activePath ||
          a.activeFile?.content != b.activeFile?.content,
      builder: (context, state) {
        final file = state.activeFile;
        final lines = file == null
            ? 0
            : '\n'.allMatches(file.content).length + 1;
        return Row(
          children: [
            if (file != null) ...[
              ValueListenableBuilder<CaretInfo>(
                valueListenable: caret,
                builder: (context, c, _) => Text(
                  c.selected > 0
                      ? context.l10n.editorCaretSelection(
                          c.line,
                          c.column,
                          c.selected,
                        )
                      : context.l10n.editorCaret(c.line, c.column),
                  style: style,
                ),
              ),
              gap(),
              Text(context.l10n.editorLineCount(lines), style: style),
              gap(),
            ],
            Text(
              state.generationFailed
                  ? context.l10n.exportGenerationFailed
                  : _localizedStatus(context, state.status),
              overflow: TextOverflow.ellipsis,
              style: style,
            ).expanded(),
            Text(context.l10n.editorSpaceCount(2), style: style),
            gap(),
            Text('UTF-8', style: style),
            gap(),
            Text('LF', style: style),
            gap(),
            Text('Dart', style: style),
            gap(),
            Text(styleLabel, style: style),
          ],
        );
      },
    ).padding(horizontal: 12).backgroundColor(colors.statusBar).height(22);
  }

  String _localizedStatus(BuildContext context, String status) {
    final regenerated = RegExp(r'^Regenerated (\d+)').firstMatch(status);
    if (regenerated != null) {
      return context.l10n.exportRegenerated(int.parse(regenerated.group(1)!));
    }
    if (status.startsWith('Formatted ')) {
      return context.l10n.exportFormatted(
        status.substring('Formatted '.length),
      );
    }
    if (status.startsWith('Copied ') && status.endsWith(' to the clipboard')) {
      final name = status.substring(
        'Copied '.length,
        status.length - ' to the clipboard'.length,
      );
      return context.l10n.exportCopied(name);
    }
    return status;
  }
}
