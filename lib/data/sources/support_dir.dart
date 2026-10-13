// Dart imports:
import 'dart:io';

// Package imports:
import 'package:path_provider/path_provider.dart';

/// A folder under the app's private support directory, created on demand.
/// Null if the platform refuses (the app then simply runs without drafts).
Future<Directory?> supportDir([String sub = '']) async {
  try {
    final base = await getApplicationSupportDirectory();
    final dir = Directory(sub.isEmpty ? base.path : '${base.path}/$sub');
    await dir.create(recursive: true);
    return dir;
  } catch (_) {
    return null;
  }
}
