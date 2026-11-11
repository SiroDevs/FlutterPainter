// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../core/theme/bloc/theme_bloc.dart';
import '../../../core/utils/l10n_ext.dart';
import '../../../domain/models/editor/app_settings.dart';
import '../cubit/settings_cubit.dart';
import 'group_methods_setting.dart';
import 'setting_field.dart';

/// Shows application-wide appearance, language, and export preferences.
class GeneralSettingsPage extends StatelessWidget {
  const GeneralSettingsPage({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<ThemeBloc, ThemeMode>(
    builder: (context, themeMode) => BlocBuilder<SettingsCubit, AppSettings>(
      builder: (context, settings) => SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Section(context.l10n.settingsAppearance),
            _languageField(context, settings),
            _themeField(context, themeMode),
            _interfaceField(context, settings),
            _Section(context.l10n.settingsCodeExport),
            _codeField(context, settings),
            GroupMethodsSetting(enabled: settings.groupMethodsPublic),
            _Section(context.l10n.settingsColourManagement),
            _colorVisionField(context, settings),
            _colorFormatField(context, settings),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(context.l10n.settingsColourConstants),
              subtitle: Text(context.l10n.settingsColourConstantsHelp),
              value: settings.colorConstants,
              onChanged: context.read<SettingsCubit>().setColorConstants,
            ),
          ],
        ),
      ),
    ),
  );

  Widget _languageField(BuildContext context, AppSettings settings) =>
      SettingField(
        label: context.l10n.settingsLanguage,
        help: context.l10n.settingsLanguageHelp,
        child: DropdownButton<String>(
          isExpanded: true,
          value: settings.languageCode,
          items: [
            DropdownMenuItem(
              value: 'en',
              child: Text(context.l10n.languageEnglish),
            ),
            DropdownMenuItem(
              value: 'fr',
              child: Text(context.l10n.languageFrench),
            ),
            DropdownMenuItem(
              value: 'sw',
              child: Text(context.l10n.languageSwahili),
            ),
          ],
          onChanged: (value) {
            if (value != null) context.read<SettingsCubit>().setLanguage(value);
          },
        ),
      );

  Widget _themeField(BuildContext context, ThemeMode themeMode) => SettingField(
    label: context.l10n.settingsTheme,
    child: SegmentedButton<ThemeMode>(
      showSelectedIcon: false,
      segments: [
        ButtonSegment(
          value: ThemeMode.light,
          label: Text(context.l10n.themeLight),
        ),
        ButtonSegment(
          value: ThemeMode.dark,
          label: Text(context.l10n.themeDark),
        ),
        ButtonSegment(
          value: ThemeMode.system,
          label: Text(context.l10n.themeSystem),
        ),
      ],
      selected: {themeMode},
      onSelectionChanged: (value) =>
          context.read<ThemeBloc>().add(ThemeModeChanged(value.first)),
    ),
  );

  Widget _interfaceField(BuildContext context, AppSettings settings) =>
      SettingField(
        label: context.l10n.settingsInterface,
        help: context.l10n.interfaceHelp,
        child: SegmentedButton<InterfaceMode>(
          showSelectedIcon: false,
          segments: [
            ButtonSegment(
              value: InterfaceMode.minimal,
              label: Text(context.l10n.interfaceMinimal),
            ),
            ButtonSegment(
              value: InterfaceMode.advanced,
              label: Text(context.l10n.interfaceAdvanced),
            ),
          ],
          selected: {settings.interfaceMode},
          onSelectionChanged: (value) =>
              context.read<SettingsCubit>().setInterfaceMode(value.first),
        ),
      );

  Widget _codeField(BuildContext context, AppSettings settings) => SettingField(
    label: context.l10n.settingsCodeStructure,
    help: settings.codeStyle == CodeStyle.refactored
        ? context.l10n.codeRefactoredHelp
        : context.l10n.codeMonolithicHelp,
    child: SegmentedButton<CodeStyle>(
      showSelectedIcon: false,
      segments: [
        ButtonSegment(
          value: CodeStyle.refactored,
          label: Text(context.l10n.codeRefactored),
        ),
        ButtonSegment(
          value: CodeStyle.monolithic,
          label: Text(context.l10n.codeMonolithic),
        ),
      ],
      selected: {settings.codeStyle},
      onSelectionChanged: (value) =>
          context.read<SettingsCubit>().setCodeStyle(value.first),
    ),
  );

  Widget _colorVisionField(BuildContext context, AppSettings settings) =>
      SettingField(
        label: context.l10n.settingsColourVision,
        help: context.l10n.settingsColourVisionHelp,
        child: DropdownButton<ColorPreview>(
          isExpanded: true,
          value: settings.colorPreview,
          items: [
            for (final value in ColorPreview.values)
              DropdownMenuItem(
                value: value,
                child: Text(_previewLabel(context, value)),
              ),
          ],
          onChanged: (value) {
            if (value != null) {
              context.read<SettingsCubit>().setColorPreview(value);
            }
          },
        ),
      );

  Widget _colorFormatField(BuildContext context, AppSettings settings) =>
      SettingField(
        label: context.l10n.settingsColourFormat,
        help: context.l10n.settingsColourFormatHelp,
        child: DropdownButton<ColorFormat>(
          isExpanded: true,
          value: settings.colorFormat,
          items: [
            for (final value in ColorFormat.values)
              DropdownMenuItem(value: value, child: Text(value.label)),
          ],
          onChanged: (value) {
            if (value != null) {
              context.read<SettingsCubit>().setColorFormat(value);
            }
          },
        ),
      );

  String _previewLabel(BuildContext context, ColorPreview value) =>
      switch (value) {
        ColorPreview.none => context.l10n.previewNone,
        ColorPreview.grayscale => context.l10n.previewGrayscale,
        ColorPreview.protanopia => context.l10n.previewProtanopia,
        ColorPreview.deuteranopia => context.l10n.previewDeuteranopia,
        ColorPreview.tritanopia => context.l10n.previewTritanopia,
      };
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
