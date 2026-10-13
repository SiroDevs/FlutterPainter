// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import '../../core/utils/copy_with_util.dart';
import '../../core/utils/path_util.dart';
import 'drawing.dart';

/// A side copy of a project with unsaved changes, kept so a crash loses nothing.
class Draft extends Equatable {
  const Draft({
    required this.tabId,
    required this.drawing,
    required this.savedAt,
    this.path,
  });

  final String tabId;
  final Drawing drawing;
  final DateTime savedAt;

  /// The project file this draft belongs to, if it was ever saved.
  final String? path;

  String get title => path != null ? baseNameOf(path!) : drawing.name;

  Draft copyWith({
    String? tabId,
    Drawing? drawing,
    DateTime? savedAt,
    Object? path = unset,
  }) =>
      Draft(
        tabId: tabId ?? this.tabId,
        drawing: drawing ?? this.drawing,
        savedAt: savedAt ?? this.savedAt,
        path: keep<String>(path, this.path),
      );

  @override
  List<Object?> get props => [tabId, drawing, savedAt, path];
}
