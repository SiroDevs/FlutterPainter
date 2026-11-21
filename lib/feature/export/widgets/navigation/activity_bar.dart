// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../core/utils/l10n_ext.dart';
import '../../../settings/widgets/settings_dialog.dart';
import '../theme/vscode_colors.dart';

/// Shows the explorer shortcut and settings gear beside the export sidebar.
class ActivityBar extends StatelessWidget {
  const ActivityBar({super.key, required this.colors, this.projectName});

  final VsCodeColors colors;
  final String? projectName;

  @override
  Widget build(BuildContext context) => Container(
    width: 48,
    color: colors.activityBar,
    child: Column(
      children: [
        Container(
          height: 48,
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: colors.activityIconActive, width: 2),
            ),
          ),
          child: Tooltip(
            message: context.l10n.exportExplorer,
            child: Icon(
              Icons.file_copy_outlined,
              size: 24,
              color: colors.activityIconActive,
            ),
          ),
        ),
        const Spacer(),
        IconButton(
          tooltip: context.l10n.exportSettingsLabel,
          iconSize: 24,
          color: colors.activityIcon,
          hoverColor: colors.hover.withAlpha(60),
          icon: const Icon(Icons.settings_outlined),
          onPressed: () =>
              showSettingsDialog(context, projectName: projectName),
        ),
        const SizedBox(height: 8),
      ],
    ),
  );
}
