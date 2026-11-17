// Dart imports:
import 'dart:ffi';
import 'dart:io';

/// Selects the release asset matching the current desktop system.
class UpdateAssetSelector {
  static Future<String?> select(String version) async {
    if (Platform.isWindows) {
      return 'FlutterPainter_${version}_x64.exe';
    }
    final architecture = _architecture();
    if (architecture == null) return null;
    if (Platform.isMacOS) {
      return 'FlutterPainter_${version}_$architecture.dmg';
    }
    if (!Platform.isLinux) return null;

    final extension = await _linuxPackageExtension();
    return 'FlutterPainter_${version}_$architecture.$extension';
  }

  static String? _architecture() => switch (Abi.current()) {
    Abi.linuxArm64 || Abi.macosArm64 => 'arm64',
    Abi.linuxX64 || Abi.macosX64 => 'x64',
    _ => null,
  };

  static Future<String> _linuxPackageExtension() async {
    final releaseInfo = await File('/etc/os-release')
        .readAsString()
        .catchError((_) => '');
    final details = releaseInfo.toLowerCase();
    if (RegExp(r'^id_like=.*debian', multiLine: true).hasMatch(details)) {
      return 'deb';
    }
    if (RegExp(r'^id=(ubuntu|debian)', multiLine: true).hasMatch(details)) {
      return 'deb';
    }
    if (RegExp(
          r'^id=(fedora|rhel|centos|rocky|almalinux|opensuse)',
          multiLine: true,
        ).hasMatch(details) ||
        RegExp(
          r'^id_like=.*(fedora|rhel|suse)',
          multiLine: true,
        ).hasMatch(details)) {
      return 'rpm';
    }
    return 'tar.gz';
  }
}
