// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../core/utils/l10n_ext.dart';
import 'vscode_colors.dart';

/// The menu bar across the top of the code editor: save, archive, copy, format
/// and regenerate on the left, and "Close code editor" on the far right.
class ExportTopBar extends StatelessWidget {
  const ExportTopBar({
    super.key,
    required this.colors,
    required this.title,
    required this.onSaveLocally,
    required this.onSaveArchive,
    required this.onCopy,
    required this.onFormat,
    required this.onRegenerate,
    required this.onClose,
    required this.modifier,
  });

  final VsCodeColors colors;
  final String title;
  final VoidCallback onSaveLocally;
  final VoidCallback onSaveArchive;
  final VoidCallback onCopy;
  final VoidCallback onFormat;
  final VoidCallback onRegenerate;
  final VoidCallback onClose;

  /// "Ctrl" or "⌘", for the shortcut hints in the tooltips.
  final String modifier;

  Widget _button(
    IconData icon,
    String label,
    VoidCallback onPressed, {
    String? tooltip,
  }) => Tooltip(
    message: tooltip ?? label,
    child: TextButton.icon(
      style: TextButton.styleFrom(
        foregroundColor: colors.titleText,
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        textStyle: const TextStyle(fontSize: 12.5),
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.code, size: 18, color: colors.accent),
        const SizedBox(width: 8),
        Text(title, style: TextStyle(fontSize: 12.5, color: colors.titleText)),
        const SizedBox(width: 12),
        _button(
          Icons.save_alt,
          context.l10n.exportSaveFolder,
          onSaveLocally,
          tooltip: context.l10n.exportSaveFolderTooltip(modifier),
        ),
        _button(
          Icons.archive_outlined,
          context.l10n.exportSaveArchive,
          onSaveArchive,
          tooltip: context.l10n.exportSaveArchiveTooltip(modifier),
        ),
        _button(
          Icons.copy_all_outlined,
          context.l10n.exportCopy,
          onCopy,
          tooltip: context.l10n.exportCopyTooltip,
        ),
        _button(
          Icons.format_align_left,
          context.l10n.exportFormatDocument,
          onFormat,
          tooltip: context.l10n.exportFormatTooltip,
        ),
        _button(
          Icons.refresh,
          context.l10n.exportBuildAgain,
          onRegenerate,
          tooltip: context.l10n.exportBuildAgainTooltip,
        ),
        const Spacer(),
        _button(
          Icons.close,
          context.l10n.exportClose,
          onClose,
          tooltip: context.l10n.exportBackToDrawing,
        ),
      ],
    ).padding(horizontal: 8).backgroundColor(colors.titleBar).height(36);
  }
}
