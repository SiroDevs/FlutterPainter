// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../domain/models/app_settings.dart';
import '../../settings/cubit/settings_cubit.dart';
import 'minimal_bar.dart';
import 'ribbon/ribbon.dart';

/// The ribbon in the advanced interface, the slim bar in the minimal one.
class ToolbarArea extends StatelessWidget {
  const ToolbarArea({super.key, required this.ribbon});

  final RibbonController ribbon;

  @override
  Widget build(BuildContext context) {
    final minimal = context.select<SettingsCubit, bool>(
      (c) => c.state.interfaceMode == InterfaceMode.minimal,
    );
    return minimal ? const MinimalBar() : Ribbon(controller: ribbon);
  }
}
