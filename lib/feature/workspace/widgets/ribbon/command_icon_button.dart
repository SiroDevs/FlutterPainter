// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../commands/app_command.dart';

/// A compact icon-only button for an [AppCommand].
class CommandIconButton extends StatelessWidget {
  const CommandIconButton(this.command, {super.key});

  final AppCommand command;

  @override
  Widget build(BuildContext context) => IconButton(
        tooltip: command.tip,
        iconSize: 18,
        visualDensity: VisualDensity.compact,
        icon: Icon(command.icon),
        onPressed: command.onPressed,
      );
}
