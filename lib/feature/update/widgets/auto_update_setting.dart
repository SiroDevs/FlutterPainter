// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../core/utils/l10n_ext.dart';
import '../../../domain/models/editor/app_settings.dart';
import '../../settings/cubit/settings_cubit.dart';

/// Displays the user's automatic update download preference.
class AutoUpdateSetting extends StatelessWidget {
  const AutoUpdateSetting({super.key, required this.settings});

  final AppSettings settings;

  @override
  Widget build(BuildContext context) => SwitchListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(context.l10n.settingsAutoDownloadUpdates),
    subtitle: Text(context.l10n.settingsAutoDownloadUpdatesHelp),
    value: settings.autoDownloadUpdates,
    onChanged: context.read<SettingsCubit>().setAutoDownloadUpdates,
  );
}
