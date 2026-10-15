// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../domain/models/app_settings.dart';
import '../../settings/cubit/settings_cubit.dart';
import '../commands/commands_builder.dart';
import 'ribbon/ribbon_parts.dart';

/// The slim bar of the minimal interface, standing in for the ribbon: the
/// everyday actions and a way back to the advanced interface. Every other
/// command is in the menus.
class MinimalBar extends StatelessWidget {
  const MinimalBar({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainer,
      child: CommandsBuilder(
        builder: (context, c) => Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(
            height: 40,
            child: Row(children: [
              const SizedBox(width: 6),
              CommandIconButton(c.newBlank),
              CommandIconButton(c.open),
              CommandIconButton(c.save),
              const VerticalDivider(width: 12, indent: 10, endIndent: 10),
              CommandIconButton(c.undo),
              CommandIconButton(c.redo),
              const SizedBox(width: 8),
              Flexible(
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                  onPressed: c.rename.onPressed,
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: Text(
                    c.state.drawing.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const Spacer(),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
                onPressed: c.exportDart.onPressed,
                icon: const Icon(Icons.code, size: 18),
                label: const Text('Export'),
              ),
              CommandIconButton(c.settings),
              IconButton(
                tooltip: 'Switch to the advanced interface',
                iconSize: 18,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.dashboard_outlined),
                onPressed: () => context
                    .read<SettingsCubit>()
                    .setInterfaceMode(InterfaceMode.advanced),
              ),
              const SizedBox(width: 6),
            ]),
          ),
          const Divider(height: 1),
        ]),
      ),
    );
  }
}
