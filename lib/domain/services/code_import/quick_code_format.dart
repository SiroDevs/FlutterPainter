// Dart imports:
import 'dart:ui';

// Project imports:
import 'quick_code_points.dart';

enum QuickCodeFormat { dartOffsets, compactCoordinates }

/// Converts point data between Dart Offset lists and compact coordinate text.
abstract class QuickCodeFormatters {
  QuickCodeFormatters._();

  static String format(List<Offset> points) => [
    'const <Offset>[',
    for (final point in points)
      '  Offset(${_number(point.dx)}, ${_number(point.dy)}),',
    '];',
  ].join('\n');

  static String formatCompact(List<Offset> points) => points
      .map((point) => '${_number(point.dx)},${_number(point.dy)}')
      .join(' ');

  static String formatDartShape(QuickCodeShapeData shape) => [
    if (shape.groupName != null) '// Group: ${_commentText(shape.groupName!)}',
    if (shape.name != null) '// Shape: ${_commentText(shape.name!)}',
    format(shape.points),
  ].join('\n');

  static String formatDartShapes(List<QuickCodeShapeData> shapes) =>
      shapes.isEmpty
      ? format(const [])
      : shapes.map(formatDartShape).join('\n\n');

  static String formatCompactShape(QuickCodeShapeData shape) {
    final coordinates = formatCompact(shape.points);
    final record = shape.name == null
        ? coordinates
        : '${shape.name}|$coordinates';
    if (shape.groupName == null) {
      return shape.name == null ? record : _quote(record);
    }
    return [
      '${_quote(shape.groupName!)}: [',
      '  ${_quote(record)},',
      '],',
    ].join('\n');
  }

  static String formatCompactShapes(List<QuickCodeShapeData> shapes) {
    if (shapes.length <= 1) {
      return shapes.isEmpty ? '' : formatCompactShape(shapes.single);
    }
    final groups = <String, List<QuickCodeShapeData>>{};
    for (final shape in shapes) {
      groups.putIfAbsent(shape.groupName ?? '', () => []).add(shape);
    }
    return [
      for (final entry in groups.entries) ...[
        '${_quote(entry.key)}: [',
        for (final shape in entry.value)
          '  ${_quote('${shape.name ?? ''}|${formatCompact(shape.points)}')},',
        '],',
      ],
    ].join('\n');
  }

  static QuickCodeFormat detectFormat(String source) =>
      RegExp(
        r'\bOffset\b|^\s*(?:const|new|\[)',
        multiLine: true,
      ).hasMatch(source)
      ? QuickCodeFormat.dartOffsets
      : QuickCodeFormat.compactCoordinates;

  static String _quote(String value) =>
      "'${value.replaceAll('\\', r'\\').replaceAll("'", r"\'")}'";

  static String _commentText(String value) =>
      value.replaceAll(RegExp(r'[\r\n]+'), ' ').trim();

  static String _number(double value) => value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toString();
}
