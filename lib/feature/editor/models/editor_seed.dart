// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import '../../../core/utils/copy_with_util.dart';
import '../../../domain/models/drawing.dart';

/// What a new editor (one tab) starts from. Passed to the bloc as its
/// injectable factory parameter.
class EditorSeed extends Equatable {
  const EditorSeed({
    required this.tabId,
    required this.drawing,
    this.filePath,
    this.recovered = false,
  });

  final String tabId;
  final Drawing drawing;

  /// The .flp this project is saved to, if any.
  final String? filePath;

  /// True for a recovered draft: nothing here matches the file on disk.
  final bool recovered;

  EditorSeed copyWith({
    String? tabId,
    Drawing? drawing,
    Object? filePath = unset,
    bool? recovered,
  }) =>
      EditorSeed(
        tabId: tabId ?? this.tabId,
        drawing: drawing ?? this.drawing,
        filePath: keep<String>(filePath, this.filePath),
        recovered: recovered ?? this.recovered,
      );

  @override
  List<Object?> get props => [tabId, drawing, filePath, recovered];
}
