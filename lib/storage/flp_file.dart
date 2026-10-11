// Dart imports:
import 'dart:io';

// Project imports:
import '../model/drawing.dart';

/// Project files are JSON with a `.flp` extension (Flutter Painter project).
const kFlpExtension = 'flp';

/// "C:\art\rider.flp" -> "rider".
String baseNameOf(String path) {
  final file = path.split(RegExp(r'[\\/]')).last;
  final dot = file.lastIndexOf('.');
  return dot > 0 ? file.substring(0, dot) : file;
}

bool isProjectFile(String path) {
  final p = path.toLowerCase();
  return p.endsWith('.$kFlpExtension') || p.endsWith('.json');
}

bool isImageFile(String path) {
  final p = path.toLowerCase();
  return ['.png', '.jpg', '.jpeg', '.webp', '.bmp', '.gif'].any(p.endsWith);
}

Future<Drawing> readFlp(String path) async =>
    Drawing.decode(await File(path).readAsString());

/// Writes next to the target and renames over it, so a crash mid-write can
/// never leave a half-written project behind.
Future<void> writeFlp(String path, Drawing drawing) async {
  final temp = File('$path.tmp');
  await temp.writeAsString(drawing.encodePretty(), flush: true);
  await temp.rename(path);
}
