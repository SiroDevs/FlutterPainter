// Dart imports:
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../core/theme/bloc/theme_bloc.dart';
import '../../../core/utils/l10n_ext.dart';
import '../../editor/bloc/editor_bloc.dart';
import '../cubit/settings_cubit.dart';
import 'about_settings_page.dart';
import 'general_settings_page.dart';
import 'project_settings_page.dart';

enum SettingsSection { general, project, about }

/// Opens the application and active-project settings window.
Future<void> showSettingsDialog(
  BuildContext context, {
  SettingsSection initialSection = SettingsSection.general,
  String? projectName,
}) {
  EditorBloc? editor;
  try {
    editor = BlocProvider.of<EditorBloc>(context, listen: false);
  } on ProviderNotFoundException {
    editor = null;
  }
  return showDialog<void>(
    context: context,
    builder: (_) => SettingsDialog(
      editor: editor,
      projectName: projectName,
      initialSection: initialSection,
    ),
  );
}

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({
    super.key,
    this.editor,
    this.projectName,
    this.initialSection = SettingsSection.general,
  });

  final EditorBloc? editor;
  final String? projectName;
  final SettingsSection initialSection;

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late SettingsSection _section = widget.initialSection;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Dialog(
      child: SizedBox(
        width: math.min(980, size.width - 64),
        height: math.min(700, size.height - 64),
        child: Row(
          children: [
            SizedBox(width: 230, child: _sidebar(context)),
            const VerticalDivider(width: 1),
            Expanded(child: _page(context)),
          ],
        ),
      ),
    );
  }

  Widget _sidebar(BuildContext context) => widget.editor == null
      ? _sidebarContent(context)
      : BlocBuilder<EditorBloc, EditorState>(
          bloc: widget.editor,
          builder: (context, _) => _sidebarContent(context),
        );

  Widget _sidebarContent(BuildContext context) => ColoredBox(
    color: Theme.of(context).colorScheme.surfaceContainerLow,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 22, 12, 18),
          child: Text(
            context.l10n.settingsTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        _navigationItem(context, SettingsSection.general),
        _navigationItem(context, SettingsSection.project),
        _navigationItem(context, SettingsSection.about),
      ],
    ),
  );

  Widget _navigationItem(BuildContext context, SettingsSection section) {
    final label = switch (section) {
      SettingsSection.general => context.l10n.settingsGeneral,
      SettingsSection.project => context.l10n.settingsProject,
      SettingsSection.about => context.l10n.settingsAbout,
    };
    final icon = switch (section) {
      SettingsSection.general => Icons.tune,
      SettingsSection.project => Icons.folder_outlined,
      SettingsSection.about => Icons.info_outline,
    };
    final projectName =
        widget.editor?.state.drawing.name ??
        widget.projectName ??
        context.l10n.projectUnavailable;
    return ListTile(
      selected: _section == section,
      leading: Icon(icon),
      title: Text(label),
      subtitle: section == SettingsSection.project
          ? Text(projectName, maxLines: 1, overflow: TextOverflow.ellipsis)
          : null,
      onTap: () => setState(() => _section = section),
    );
  }

  Widget _page(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(24, 14, 12, 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _pageTitle(context),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            IconButton(
              tooltip: context.l10n.settingsDone,
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      ),
      const Divider(height: 1),
      Expanded(
        child: IndexedStack(
          index: _section.index,
          children: [
            const GeneralSettingsPage(),
            ProjectSettingsPage(
              editor: widget.editor,
              projectName: widget.projectName,
            ),
            const AboutSettingsPage(),
          ],
        ),
      ),
      const Divider(height: 1),
      Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            TextButton(
              onPressed: () {
                context.read<SettingsCubit>().resetToDefaults();
                context.read<ThemeBloc>().add(
                  const ThemeModeChanged(ThemeMode.system),
                );
              },
              child: Text(context.l10n.settingsReset),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.l10n.settingsDone),
            ),
          ],
        ),
      ),
    ],
  );

  String _pageTitle(BuildContext context) => switch (_section) {
    SettingsSection.general => context.l10n.settingsGeneral,
    SettingsSection.project => context.l10n.settingsProject,
    SettingsSection.about => context.l10n.settingsAbout,
  };
}
