import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/l10n_ext.dart';
import '../cubit/settings_cubit.dart';

class GroupMethodsSetting extends StatelessWidget {
  const GroupMethodsSetting({super.key, required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) => SwitchListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(context.l10n.groupMethodsPublic),
    subtitle: Text(context.l10n.groupMethodsPublicHelp),
    value: enabled,
    onChanged: context.read<SettingsCubit>().setGroupMethodsPublic,
  );
}
