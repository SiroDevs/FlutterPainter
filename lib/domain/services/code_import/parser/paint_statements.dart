// Dart imports:
import 'dart:ui';

// Project imports:
import 'code_builtins.dart';
import 'code_text.dart';
import 'code_values.dart';
import 'expression_parser.dart';

final _assignment = RegExp(r'^(\w+)\s*=\s*([\s\S]+)$');
final _callPattern = RegExp(r'^(\w+)\s*\(([\s\S]*)\)$');

// Reads the arguments of a call such as `drawRect(rect, paint)`.
({List<Object?> positional, Map<String, Object?> named}) evaluateArguments(
  String text,
  Object? Function(String expression) evaluate,
) {
  final positional = <Object?>[];
  final named = <String, Object?>{};
  for (final part in splitTopLevel(text, ',')) {
    if (part.trim().isEmpty) continue;
    final label = RegExp(r'^\s*(\w+)\s*:(?!:)\s*([\s\S]*)$').firstMatch(part);
    if (label == null) {
      positional.add(evaluate(part));
    } else {
      named[label.group(1)!] = evaluate(label.group(2)!);
    }
  }
  return (positional: positional, named: named);
}

// Splits `name(args)` into its name and argument text, or null.
({String name, String arguments})? parseCall(String text) {
  final match = _callPattern.firstMatch(text.trim());
  if (match == null) return null;
  return (name: match.group(1)!, arguments: match.group(2)!);
}

// Applies one cascade item such as `color = Colors.red` to [paint].
void applyPaintOperation(
  CodePaint paint,
  String operation,
  ExpressionScope scope,
) {
  final match = _assignment.firstMatch(operation.trim());
  if (match == null) return;
  final value = match.group(2)!.trim();
  switch (match.group(1)) {
    case 'color':
      final color = evaluateExpression(value, scope);
      if (color is CodeColor) paint.color = color.argb;
    case 'style':
      paint.isFill = !value.contains('stroke');
    case 'strokeWidth':
      paint.strokeWidth = asDouble(evaluateExpression(value, scope));
    case 'shader':
      final shader = value == 'null' ? null : evaluateExpression(value, scope);
      paint.gradient = shader is CodeGradient ? shader : null;
  }
}

// Applies one path call such as `lineTo(1, 2)` to [path].
void applyPathOperation(CodePath path, String operation, ExpressionScope scope) {
  final call = parseCall(operation);
  if (call == null) return;
  final args = evaluateArguments(
    call.arguments,
    (text) => evaluateExpression(text, scope),
  ).positional;
  double at(int index) => asDouble(args[index]);
  Offset last() {
    for (final segment in path.segments.reversed) {
      if (segment.points.isNotEmpty) return segment.points.last;
    }
    return Offset.zero;
  }

  switch (call.name) {
    case 'reset':
      path.segments.clear();
    case 'moveTo':
      path.segments.add(PathSegment(PathOp.move, [Offset(at(0), at(1))]));
    case 'lineTo':
      path.segments.add(PathSegment(PathOp.line, [Offset(at(0), at(1))]));
    case 'relativeMoveTo':
      path.segments.add(PathSegment(PathOp.move, [last() + Offset(at(0), at(1))]));
    case 'relativeLineTo':
      path.segments.add(PathSegment(PathOp.line, [last() + Offset(at(0), at(1))]));
    case 'quadraticBezierTo':
      path.segments.add(PathSegment(
        PathOp.quad,
        [Offset(at(0), at(1)), Offset(at(2), at(3))],
      ));
    case 'cubicTo':
      path.segments.add(PathSegment(
        PathOp.cubic,
        [Offset(at(0), at(1)), Offset(at(2), at(3)), Offset(at(4), at(5))],
      ));
    case 'close':
      path.segments.add(const PathSegment(PathOp.close));
    case 'addRect' || 'addOval':
      final rect = args[0] as Rect;
      path.segments.add(PathSegment(
        call.name == 'addRect' ? PathOp.rect : PathOp.oval,
        [rect.topLeft, rect.bottomRight],
      ));
    default:
      throw CodeUnsupported('Path.${call.name} is not supported');
  }
}
