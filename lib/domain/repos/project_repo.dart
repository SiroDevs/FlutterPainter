// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import '../../data/mappers/drawing_mapper.dart';
import '../../data/sources/project_file_source.dart';
import '../models/drawing.dart';

/// Opens and saves .flp project files.
@lazySingleton
class ProjectRepo {
  ProjectRepo(this._source);

  final ProjectFileSource _source;

  Future<Drawing> open(String path) async =>
      drawingFromJson(await _source.read(path));

  /// Atomic: a temp file is renamed over [path], so a crash cannot corrupt it.
  Future<void> save(String path, Drawing drawing) =>
      _source.write(path, drawingToJson(drawing, pretty: true));
}
