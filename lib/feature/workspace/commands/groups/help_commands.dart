// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../common/constants/app_constants.dart';
import '../app_command.dart';
import '../workspace_commands.dart';

extension HelpCommands on WorkspaceCommands {
  AppCommand get about => AppCommand(
        label: 'About ${AppConstants.appTitle}',
        icon: Icons.info_outline,
        onPressed: () => showAboutDialog(
          context: context,
          applicationName: AppConstants.appTitle,
        ),
      );
}
