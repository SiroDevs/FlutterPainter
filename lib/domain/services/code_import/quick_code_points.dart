// Dart imports:
import 'dart:ui';

// Project imports:
import 'code_text.dart';
import 'expression_parser.dart';
import 'code_values.dart';

/// Parses and formats the coordinate list shown by Quick Code.
abstract class QuickCodePoints {
  QuickCodePoints._();

  static List<Offset> parse(String source) {
    final expression = stripComments(source)
        .trim()
        .replaceFirst(RegExp(r';\s*$'), '');
    final value = evaluateExpression(
      expression,
      ExpressionScope(variables: const {}, palette: const {}),
    );
    if (value is! List) throw const CodeUnsupported('Expected a point list');
    return [for (final point in value) _point(point)];
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

  static String _number(double value) => value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toString();
}
