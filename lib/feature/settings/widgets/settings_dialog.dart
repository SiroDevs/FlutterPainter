// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../core/theme/bloc/theme_bloc.dart';
import '../../../domain/models/app_settings.dart';
import '../cubit/settings_cubit.dart';

/// Opens the settings window. Every change applies and is saved at once.
Future<void> showSettingsDialog(BuildContext context) =>
    showDialog<void>(context: context, builder: (_) => const SettingsDialog());

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.read<SettingsCubit>();
    final theme = context.read<ThemeBloc>();
    return AlertDialog(
      title: const Row(children: [
        Icon(Icons.settings_outlined),
        SizedBox(width: 12),
        Text('Settings'),
      ]),
      content: SizedBox(
        width: 580,
        child: SingleChildScrollView(
          child: BlocBuilder<ThemeBloc, ThemeMode>(
            builder: (context, themeMode) =>
                BlocBuilder<SettingsCubit, AppSettings>(
              builder: (context, s) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Section('Appearance'),
                  _Setting(
                    label: 'Theme',
                    help: 'System follows your operating system\'s light or '
                        'dark setting.',
                    child: SegmentedButton<ThemeMode>(
                      showSelectedIcon: false,
                      segments: const [
                        ButtonSegment(
                          value: ThemeMode.light,
                          icon: Icon(Icons.light_mode_outlined),
                          label: Text('Light'),
                        ),
                        ButtonSegment(
                          value: ThemeMode.dark,
                          icon: Icon(Icons.dark_mode_outlined),
                          label: Text('Dark'),
                        ),
                        ButtonSegment(
                          value: ThemeMode.system,
                          icon: Icon(Icons.brightness_auto_outlined),
                          label: Text('System'),
                        ),
                      ],
                      selected: {themeMode},
                      onSelectionChanged: (v) =>
                          theme.add(ThemeModeChanged(v.first)),
                    ),
                  ),
                  _Setting(
                    label: 'Interface',
                    help: 'Advanced shows the ribbon and the layer, image and '
                        'properties panels. Minimal keeps just the canvas, '
                        'tools and colours; every command is still in the '
                        'menus.',
                    child: SegmentedButton<InterfaceMode>(
                      showSelectedIcon: false,
                      segments: const [
                        ButtonSegment(
                          value: InterfaceMode.minimal,
                          icon: Icon(Icons.crop_free),
                          label: Text('Minimal'),
                        ),
                        ButtonSegment(
                          value: InterfaceMode.advanced,
                          icon: Icon(Icons.dashboard_outlined),
                          label: Text('Advanced'),
                        ),
                      ],
                      selected: {s.interfaceMode},
                      onSelectionChanged: (v) =>
                          settings.setInterfaceMode(v.first),
                    ),
                  ),
                  const _Section('Code export'),
                  _Setting(
                    label: 'Code structure',
                    help: s.codeStyle == CodeStyle.refactored
                        ? 'Refactored: a painter, one class per layer in its '
                            'own file with one function per shape, and a '
                            'colour palette.'
                        : 'Monolithic: everything in one file, one painter '
                            'class with a method per layer.',
                    child: SegmentedButton<CodeStyle>(
                      showSelectedIcon: false,
                      segments: const [
                        ButtonSegment(
                          value: CodeStyle.refactored,
                          icon: Icon(Icons.account_tree_outlined),
                          label: Text('Refactored'),
                        ),
                        ButtonSegment(
                          value: CodeStyle.monolithic,
                          icon: Icon(Icons.article_outlined),
                          label: Text('Monolithic'),
                        ),
                      ],
                      selected: {s.codeStyle},
                      onSelectionChanged: (v) => settings.setCodeStyle(v.first),
                    ),
                  ),
                  const _Section('Colour management'),
                  _Setting(
                    label: 'Colour vision preview',
                    help: 'Shows the canvas as someone with a colour-vision '
                        'difference might see it (an approximation). It only '
                        'changes the screen, never the project or the '
                        'exported code.',
                    child: DropdownButton<ColorPreview>(
                      isExpanded: true,
                      value: s.colorPreview,
                      items: [
                        for (final v in ColorPreview.values)
                          DropdownMenuItem(value: v, child: Text(v.label)),
                      ],
                      onChanged: (v) {
                        if (v != null) settings.setColorPreview(v);
                      },
                    ),
                  ),
                  _Setting(
                    label: 'Colour format in exported code',
                    help: 'How each colour is written in the generated Dart.',
                    child: DropdownButton<ColorFormat>(
                      isExpanded: true,
                      value: s.colorFormat,
                      items: [
                        for (final v in ColorFormat.values)
                          DropdownMenuItem(value: v, child: Text(v.label)),
                      ],
                      onChanged: (v) {
                        if (v != null) settings.setColorFormat(v);
                      },
                    ),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Collect colours into named constants'),
                    subtitle: const Text(
                      'Each distinct colour is written once, as a constant '
                      '(a palette), and the shapes refer to it.',
                    ),
                    value: s.colorConstants,
                    onChanged: settings.setColorConstants,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            settings.resetToDefaults();
            theme.add(const ThemeModeChanged(ThemeMode.system));
          },
          child: const Text('Reset to defaults'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Done'),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 4),
        child: Text(
          title.toUpperCase(),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: 0.8,
              ),
        ),
      );
}

class _Setting extends StatelessWidget {
  const _Setting({required this.label, required this.child, this.help});

  final String label;
  final String? help;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: text.titleSmall),
        if (help != null)
          Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 6),
            child: Text(
              help!,
              style: text.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          )
        else
          const SizedBox(height: 6),
        child,
      ]),
    );
  }
}
