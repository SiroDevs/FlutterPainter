// Dart imports:
import 'dart:ui';

// Project imports:
import 'code_text.dart';
import 'expression_parser.dart';
import 'code_values.dart';

enum QuickCodeFormat { dartOffsets, compactCoordinates }

/// Parses and formats the coordinate list shown by Quick Code.
abstract class QuickCodePoints {
  QuickCodePoints._();

  static List<Offset> parse(String source) {
    final expression = stripComments(source)
        .trim()
        .replaceFirst(RegExp(r';\s*$'), '');
    if (expression.isEmpty) return const [];
    Object? value;
    try {
      value = evaluateExpression(
        expression,
        ExpressionScope(variables: const {}, palette: const {}),
      );
    } on CodeUnsupported {
      return _parseCompact(expression);
    }
    if (value is! List) throw const CodeUnsupported('Expected a point list');
    return [for (final point in value) _point(point)];
  }

  static List<Offset> _parseCompact(String source) {
    final pairPattern = RegExp(
      r'[+-]?(?:(?:\d+\.?\d*)|(?:\.\d+))(?:[eE][+-]?\d+)?\s*,\s*'
      r'[+-]?(?:(?:\d+\.?\d*)|(?:\.\d+))(?:[eE][+-]?\d+)?',
    );
    final points = <Offset>[];
    var consumed = 0;
    for (final match in pairPattern.allMatches(source)) {
      final gap = source.substring(consumed, match.start);
      if (gap.trim().isNotEmpty || (points.isNotEmpty && gap.isEmpty)) {
        throw const CodeUnsupported('Separate coordinate pairs with spaces');
      }
      final coordinates = match.group(0)!.split(',');
      final x = double.tryParse(coordinates[0].trim());
      final y = double.tryParse(coordinates[1].trim());
      if (x == null || y == null) {
        throw const CodeUnsupported('Expected numeric coordinates');
      }
      points.add(Offset(x, y));
      consumed = match.end;
    }
    if (points.isEmpty || source.substring(consumed).trim().isNotEmpty) {
      throw const CodeUnsupported('Expected x,y coordinate pairs');
    }
    return points;
  }

  static Offset _point(Object? value) {
    if (value is Offset) return value;
    if (value is List && value.length == 2 && value.every((v) => v is num)) {
      return Offset((value[0] as num).toDouble(), (value[1] as num).toDouble());
    }
    throw const CodeUnsupported('Use Offset(x, y) for each point');
  }

  static String format(List<Offset> points) => [
    'const <Offset>[',
    for (final point in points)
      '  Offset(${_number(point.dx)}, ${_number(point.dy)}),',
    '];',
  ].join('\n');

  static String formatCompact(List<Offset> points) => points
      .map((point) => '${_number(point.dx)},${_number(point.dy)}')
      .join(' ');

  static QuickCodeFormat detectFormat(String source) =>
      RegExp(
        r'\bOffset\b|^\s*(?:const|new|\[)',
        multiLine: true,
      ).hasMatch(source)
      ? QuickCodeFormat.dartOffsets
      : QuickCodeFormat.compactCoordinates;

  static String _number(double value) => value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toString();
}
