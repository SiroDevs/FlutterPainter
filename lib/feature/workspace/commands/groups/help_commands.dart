// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../common/constants/app_constants.dart';
import '../../../../core/utils/l10n_ext.dart';
import '../../../settings/widgets/settings_dialog.dart';
import '../app_command.dart';
import '../workspace_commands.dart';

extension HelpCommands on WorkspaceCommands {
  AppCommand get about => AppCommand(
    label: context.l10n.aboutMenu(AppConstants.appTitle),
    icon: Icons.info_outline,
    onPressed: () =>
        showSettingsDialog(context, initialSection: SettingsSection.about),
  );
}
