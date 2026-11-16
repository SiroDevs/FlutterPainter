// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:window_manager/window_manager.dart';

// Project imports:
import '../../common/constants/pref_constants.dart';
import '../../domain/repos/prefs_repo.dart';

/// Restores and saves the desktop window dimensions between launches.
class WindowSizePersistence with WindowListener {
  WindowSizePersistence(this._prefs);

  final PrefsRepo _prefs;
  Timer? _saveTimer;

  Future<void> initialize() async {
    const desktopPlatforms = {
      TargetPlatform.linux,
      TargetPlatform.macOS,
      TargetPlatform.windows,
    };
    if (kIsWeb || !desktopPlatforms.contains(defaultTargetPlatform)) return;
    await windowManager.ensureInitialized();
    final width = _prefs.getPrefInt(PrefConstants.windowWidthKey);
    final height = _prefs.getPrefInt(PrefConstants.windowHeightKey);
    if (width > 0 && height > 0) {
      await windowManager.setSize(Size(width.toDouble(), height.toDouble()));
    }
    windowManager.addListener(this);
  }

  @override
  void onWindowResize() => _scheduleSave();

  @override
  void onWindowUnmaximize() => _scheduleSave();

  void _scheduleSave() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 350), _saveSize);
  }

  Future<void> _saveSize() async {
    if (await windowManager.isMaximized()) return;
    final size = await windowManager.getSize();
    if (size.width <= 0 || size.height <= 0) return;
    await Future.wait([
      _prefs.setPrefInt(PrefConstants.windowWidthKey, size.width.round()),
      _prefs.setPrefInt(PrefConstants.windowHeightKey, size.height.round()),
    ]);
  }
}
