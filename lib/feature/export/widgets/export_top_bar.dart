// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:styled_widget/styled_widget.dart';

// Project imports:
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
  }) =>
      Tooltip(
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
    return Row(children: [
      Icon(Icons.code, size: 18, color: colors.accent),
      const SizedBox(width: 8),
      Text(
        title,
        style: TextStyle(fontSize: 12.5, color: colors.titleText),
      ),
      const SizedBox(width: 12),
      _button(
        Icons.save_alt,
        'Save locally',
        onSaveLocally,
        tooltip: 'Save all files into a folder ($modifier+S)',
      ),
      _button(
        Icons.archive_outlined,
        'Save as an archive',
        onSaveArchive,
        tooltip: 'Save all files as one .zip ($modifier+Shift+S)',
      ),
      _button(Icons.copy_all_outlined, 'Copy', onCopy,
          tooltip: 'Copy the open file to the clipboard'),
      _button(
        Icons.format_align_left,
        'Format document',
        onFormat,
        tooltip: 'Format the open file (Shift+Alt+F)',
      ),
      _button(
        Icons.refresh,
        'Regenerate',
        onRegenerate,
        tooltip: 'Build the files again from the drawing (drops your edits)',
      ),
      const Spacer(),
      _button(
        Icons.close,
        'Close code editor',
        onClose,
        tooltip: 'Back to the drawing',
      ),
    ]).padding(horizontal: 8).backgroundColor(colors.titleBar).height(36);
  }
}
