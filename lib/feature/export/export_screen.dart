// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import '../../common/app_router/route_names.dart';
import '../../core/utils/l10n_ext.dart';
import '../../domain/models/editor/app_settings.dart';
import '../../domain/models/export/export_options.dart';
import '../settings/cubit/settings_cubit.dart';
import 'cubit/export_cubit.dart';
import 'export_args.dart';
import 'flows/export_flows.dart';
import 'widgets/export_loading_overlay.dart';
import 'widgets/export_workspace.dart';
import 'widgets/vscode_colors.dart';

/// The code editor, a page of its own laid out like VS Code: a menu bar across
/// the top, an activity bar and file explorer on the left, tabs and the editor
/// in the middle, and a status bar along the bottom. The files exist only in
/// memory until saved.
class ExportScreen extends StatefulWidget {
  const ExportScreen({super.key, required this.args});

  final ExportArgs args;

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  late final ExportCubit _cubit;

  ExportOptions get _options =>
      ExportOptions.fromSettings(context.read<SettingsCubit>().state);

  @override
  void initState() {
    super.initState();
    _cubit = ExportCubit(widget.args.drawing, _options);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Future<void> _close() async {
    if (_cubit.state.hasEdits) {
      final ok = await confirm(
        context,
        title: 'Close the code editor?',
        message:
            'Your edits to the generated files have not been saved and '
            'will be lost.',
        confirmLabel: 'Close',
      );
      if (!ok || !mounted) return;
    }
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(RoutePaths.workspace);
    }
  }

  Future<void> _regenerate() async {
    if (_cubit.state.hasEdits) {
      final ok = await confirm(
        context,
        title: 'Regenerate the files?',
        message:
            'This rebuilds every file from the drawing and drops your '
            'edits.',
        confirmLabel: 'Regenerate',
      );
      if (!ok || !mounted) return;
    }
    unawaited(_cubit.regenerate(_options));
  }

  /// The export settings changed while the editor was open.
  void _onSettingsChanged(AppSettings settings) {
    if (!_cubit.state.hasEdits) {
      unawaited(_cubit.regenerate(ExportOptions.fromSettings(settings)));
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text(
            'Export settings changed. Regenerate to apply them (this drops '
            'your edits).',
          ),
          action: SnackBarAction(label: 'Regenerate', onPressed: _regenerate),
        ),
      );
  }

  Map<ShortcutActivator, VoidCallback> _bindings() {
    final map = <ShortcutActivator, VoidCallback>{};
    void both(LogicalKeyboardKey key, VoidCallback f, {bool shift = false}) {
      map[SingleActivator(key, control: true, shift: shift)] = f;
      map[SingleActivator(key, meta: true, shift: shift)] = f;
    }

    both(LogicalKeyboardKey.keyS, () => saveLocally(context, _cubit));
    both(
      LogicalKeyboardKey.keyS,
      () => saveArchive(context, _cubit),
      shift: true,
    );
    both(LogicalKeyboardKey.keyW, () {
      final active = _cubit.state.activePath;
      if (active != null) _cubit.closeTab(active);
    });
    map[const SingleActivator(
          LogicalKeyboardKey.keyF,
          shift: true,
          alt: true,
        )] =
        _cubit.formatActive;
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final colors = VsCodeColors.of(Theme.of(context).brightness);
    final isMac = Theme.of(context).platform == TargetPlatform.macOS;
    final style = context.select<SettingsCubit, CodeStyle>(
      (c) => c.state.codeStyle,
    );

    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<SettingsCubit, AppSettings>(
        listenWhen: (a, b) =>
            ExportOptions.fromSettings(a) != ExportOptions.fromSettings(b),
        listener: (context, settings) => _onSettingsChanged(settings),
        child: Scaffold(
          backgroundColor: colors.editorBg,
          body: CallbackShortcuts(
            bindings: _bindings(),
            child: Focus(
              autofocus: true,
              child: BlocBuilder<ExportCubit, ExportState>(
                buildWhen: (before, after) =>
                    before.isBusy != after.isBusy ||
                    before.isGenerating != after.isGenerating,
                builder: (context, state) => Stack(
                  fit: StackFit.expand,
                  children: [
                    AbsorbPointer(
                      absorbing: state.isBusy,
                      child: ExportWorkspace(
                        colors: colors,
                        title: 'Code editor \u2014 ${widget.args.drawing.name}',
                        modifier: isMac ? '\u2318' : 'Ctrl',
                        styleLabel: style.label,
                        onSaveLocally: () => saveLocally(context, _cubit),
                        onSaveArchive: () => saveArchive(context, _cubit),
                        onCopy: _cubit.copyActive,
                        onFormat: _cubit.formatActive,
                        onRegenerate: _regenerate,
                        onClose: _close,
                      ),
                    ),
                    ExportLoadingOverlay(
                      active: state.isBusy,
                      label: state.isGenerating
                          ? context.l10n.exportGenerating
                          : context.l10n.exportSaving,
                      colors: colors,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
