// Dart imports:
import 'dart:async';
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../common/constants/pref_constants.dart';
import '../../../core/utils/l10n_ext.dart';
import '../../../domain/models/editor/app_settings.dart';
import '../../../domain/repos/prefs_repo.dart';
import '../../settings/cubit/settings_cubit.dart';
import '../models/update_release.dart';
import '../services/update_installer.dart';
import '../services/update_service.dart';

/// Checks for releases and presents downloaded updates to the user.
class UpdatePromptHost extends StatefulWidget {
  const UpdatePromptHost({
    super.key,
    required this.child,
    required this.service,
    required this.preferences,
    required this.settings,
  });

  final Widget child;
  final UpdateService service;
  final PrefsRepo preferences;
  final SettingsCubit settings;

  @override
  State<UpdatePromptHost> createState() => _UpdatePromptHostState();
}

class _UpdatePromptHostState extends State<UpdatePromptHost> {
  static const _checkInterval = Duration(hours: 12);
  late final Future<void> _initialization;
  late final Timer _timer;
  late final StreamSubscription<AppSettings> _settingsSubscription;
  late bool _autoDownloadUpdates;
  bool _initializationStarted = false;
  String? _installRequestedVersion;
  bool _checking = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(_checkInterval, (_) => _checkForUpdate());
    _autoDownloadUpdates = widget.settings.state.autoDownloadUpdates;
    _settingsSubscription = widget.settings.stream.listen((settings) {
      if (_autoDownloadUpdates == settings.autoDownloadUpdates) return;
      _autoDownloadUpdates = settings.autoDownloadUpdates;
      _checkForUpdate();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkForUpdate());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initializationStarted) return;
    _initializationStarted = true;
    _initialization = widget.service
        .initialize(context.l10n.updateOpenReleaseAction)
        .catchError((_) {});
  }

  @override
  void dispose() {
    _timer.cancel();
    _settingsSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;

  Future<void> _checkForUpdate() async {
    if (_checking || !mounted) return;
    _checking = true;
    try {
      await _initialization;
      final update = await widget.service.checkForUpdate();
      if (update == null || !mounted) return;
      if (widget.settings.state.autoDownloadUpdates) {
        await _downloadAndPrompt(update);
      } else {
        await _notifyIfNew(update);
      }
    } catch (_) {
      // The next scheduled check retries network and download failures.
    } finally {
      _checking = false;
    }
  }

  Future<void> _downloadAndPrompt(UpdateRelease update) async {
    if (_installRequestedVersion == update.version) return;
    final dismissed = widget.preferences.getPrefString(
      PrefConstants.dismissedUpdateKey,
    );
    if (dismissed == update.version) return;
    late final File installer;
    try {
      installer = await widget.service.download(update);
    } on Object {
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(dialogContext.l10n.updateNotificationTitle),
          content: Text(dialogContext.l10n.updateDownloadFailed),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(dialogContext.l10n.updateLaterAction),
            ),
          ],
        ),
      );
      return;
    }
    if (!mounted) return;

    final shouldInstall = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(dialogContext.l10n.updateInstallTitle),
        content: Text(dialogContext.l10n.updateInstallBody(update.version)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(dialogContext.l10n.updateLaterAction),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(dialogContext.l10n.updateInstallAction),
          ),
        ],
      ),
    );
    if (shouldInstall != true) {
      widget.preferences.setPrefString(
        PrefConstants.dismissedUpdateKey,
        update.version,
      );
      return;
    }
    try {
      await UpdateInstaller.open(installer);
      _installRequestedVersion = update.version;
    } on ProcessException {
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(dialogContext.l10n.updateInstallTitle),
          content: Text(dialogContext.l10n.updateInstallerFailed),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(dialogContext.l10n.updateLaterAction),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _notifyIfNew(UpdateRelease update) async {
    if (widget.preferences.getPrefString(PrefConstants.lastNotifiedUpdateKey) ==
        update.version) {
      return;
    }
    await widget.service.showNotification(
      context.l10n.updateNotificationTitle,
      context.l10n.updateNotificationBody(update.version),
      update.releaseUrl,
    );
    widget.preferences.setPrefString(
      PrefConstants.lastNotifiedUpdateKey,
      update.version,
    );
  }
}
