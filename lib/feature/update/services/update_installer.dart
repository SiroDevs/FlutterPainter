// Dart imports:
import 'dart:io';

/// Opens the downloaded package with the operating system's installer.
class UpdateInstaller {
  static Future<void> open(File installer) async {
    final command = Platform.isWindows
        ? installer.path
        : Platform.isMacOS
        ? 'open'
        : 'xdg-open';
    final arguments = Platform.isWindows ? <String>[] : [installer.path];
    await Process.start(command, arguments, mode: ProcessStartMode.detached);
  }
}
