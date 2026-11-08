// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import '../../../core/utils/zip_writer.dart';
import '../../../data/mappers/drawing_mapper.dart';
import '../../../domain/models/drawing/drawing.dart';
import '../../../domain/models/drawing/paint_layer.dart';
import '../../../domain/models/editor/app_settings.dart';
import '../../../domain/models/export/export_file.dart';
import '../../../domain/models/export/export_options.dart';
import '../../../domain/services/code_export/dart_exporter.dart';

typedef GeneratedExport = ({String folderName, List<ExportFile> files});

/// Generates export files outside the UI isolate.
Future<GeneratedExport> generateExportFiles(
  Drawing drawing,
  ExportOptions options,
) async {
  final exportDrawing = drawing.copyWith(
    layers: [
      for (final layer in drawing.layers)
        PaintLayer(
          name: layer.name,
          visible: layer.visible,
          shapes: layer.shapes,
        ),
    ],
  );
  final result = await compute<Map<String, Object>, Map<String, Object>>(
    _generateExport,
    {
      'drawing': drawingToJson(exportDrawing),
      'style': options.style.name,
      'colorFormat': options.colorFormat.name,
      'colorConstants': options.colorConstants,
      'groupMethodsPublic': options.groupMethodsPublic,
    },
  );
  final records = result['files'] as List;
  return (
    folderName: result['folderName'] as String,
    files: [
      for (final record in records)
        ExportFile(
          path: (record as Map)['path'] as String,
          content: record['content'] as String,
        ),
    ],
  );
}

/// Generates code from a serializable drawing payload.
Map<String, Object> _generateExport(Map<String, Object> payload) {
  final drawing = drawingFromJson(payload['drawing'] as String);
  final options = ExportOptions(
    style: CodeStyle.values.byName(payload['style'] as String),
    colorFormat: ColorFormat.values.byName(payload['colorFormat'] as String),
    colorConstants: payload['colorConstants'] as bool,
    groupMethodsPublic: payload['groupMethodsPublic'] as bool,
  );
  final exporter = DartExporter(drawing, options: options);
  return {
    'folderName': exporter.folderName,
    'files': [
      for (final file in exporter.generate())
        {'path': file.path, 'content': file.content},
    ],
  };
}

/// Builds a ZIP archive outside the UI isolate.
Future<Uint8List> buildExportArchive(
  String folderName,
  List<ExportFile> files,
) => compute<Map<String, Object>, Uint8List>(_buildArchive, {
  'folderName': folderName,
  'files': [
    for (final file in files) {'path': file.path, 'content': file.content},
  ],
});

/// Builds archive bytes from serializable file records.
Uint8List _buildArchive(Map<String, Object> payload) {
  final folderName = payload['folderName'] as String;
  final records = payload['files'] as List;
  return buildZip([
    for (final record in records)
      ZipItem(
        '$folderName/${(record as Map)['path'] as String}',
        Uint8List.fromList(utf8.encode(record['content'] as String)),
      ),
  ]);
}
