/// Why a project file could not be understood.
enum ProjectFormatProblem {
  /// Not JSON, or JSON that does not describe a project.
  damaged,

  /// Written by a newer version of the app than this one.
  newerVersion,
}

/// Thrown when a `.flp` file cannot be turned into a drawing. Callers turn the
/// [problem] into a message for the user; [detail] is for logs.
class ProjectFormatException implements Exception {
  const ProjectFormatException(this.problem, [this.detail = '']);

  final ProjectFormatProblem problem;
  final String detail;

  @override
  String toString() =>
      'ProjectFormatException(${problem.name}'
      '${detail.isEmpty ? '' : ': $detail'})';
}
