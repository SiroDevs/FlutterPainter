// Dart imports:
import 'dart:io';
import 'dart:typed_data';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:file_selector/file_selector.dart';

// Project imports:
import '../storage/flp_file.dart';

const _projectFiles = XTypeGroup(
  label: 'Flutter Painter project',
  extensions: [kFlpExtension, 'json'],
);
const _imageFiles = XTypeGroup(
  label: 'Images',
  extensions: ['png', 'jpg', 'jpeg', 'webp', 'bmp', 'gif'],
);

void toast(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

/// Asks where to save a project. Always returns a path ending in .flp.
Future<String?> pickSavePath() async {
  const flpOnly = XTypeGroup(label: 'Flutter Painter project', extensions: [kFlpExtension]);
  final location = await getSaveLocation(acceptedTypeGroups: [flpOnly]);
  if (location == null) return null;
  final path = location.path;
  return path.toLowerCase().endsWith('.$kFlpExtension') ? path : '$path.$kFlpExtension';
}

Future<List<String>> pickProjectPaths() async {
  final files = await openFiles(acceptedTypeGroups: [_projectFiles]);
  return [for (final f in files) f.path];
}

Future<Uint8List?> pickImageBytes() async {
  final file = await openFile(acceptedTypeGroups: [_imageFiles]);
  return file?.readAsBytes();
}

Future<Uint8List> pickBytes(String path) => File(path).readAsBytes();

/// Writes exported code to a file the user picks. Returns the path or null.
Future<String?> saveDartFile(String code) async {
  const dartFiles = XTypeGroup(label: 'Dart', extensions: ['dart']);
  final location = await getSaveLocation(acceptedTypeGroups: [dartFiles]);
  if (location == null) return null;
  var path = location.path;
  if (!path.toLowerCase().endsWith('.dart')) path = '$path.dart';
  await File(path).writeAsString(code);
  return path;
}
