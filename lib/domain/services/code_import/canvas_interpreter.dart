// Dart imports:
import 'dart:ui';

// Project imports:
import 'class_scanner.dart';
import 'code_builtins.dart';
import 'code_text.dart';
import 'code_transform.dart';
import 'code_values.dart';
import 'expression_parser.dart';
import 'paint_statements.dart';
import 'shape_collector.dart';

final _declaration = RegExp(
  r'^(?:(?:static|final|const|var|late)\s+)*(?:[A-Za-z_][\w<>?,]*\s+)?'
  r'([A-Za-z_]\w*)\s*=(?!=)\s*([\s\S]*)$',
);
final _receiver = RegExp(r'^(\w+)\s*(\.\.|\.)([\s\S]*)$');

// Runs the statements of a painting method and records what they draw. It
// understands a small, useful part of Dart: declarations, Paint and Path
// building, canvas draw calls, translate/scale/save/restore and calls to other
// methods of the same class. Anything else is counted in [skipped].
class CanvasInterpreter {
  CanvasInterpreter({
    required this.owner,
    required this.palette,
    required this.canvasSize,
    required this.shapeNames,
    required this.collector,
  });

  final CodeClass owner;
  final Map<String, int> palette;
  final Size canvasSize;
  final Map<String, String> shapeNames;
  final ShapeCollector collector;

  final Map<String, Object?> _variables = {};
  final List<CodeTransform> _saved = [];
  CodeTransform _transform = CodeTransform.identity;
  int _depth = 0;

  int skipped = 0;
  final Set<String> notes = {};

  ExpressionScope get _scope =>
      ExpressionScope(variables: _variables, palette: palette);

  void run(CodeMethod entry) {
    owner.fields.forEach(_statement);
    _runMethod(entry, const []);
  }

  void _skip(String note) {
    skipped++;
    notes.add(note);
  }

  void _runMethod(CodeMethod method, List<Object?> arguments) {
    if (++_depth > 24) throw const CodeUnsupported('Calls nest too deeply');
    final outer = Map<String, Object?>.of(_variables);
    final outerName = collector.currentName;
    collector.currentName = shapeNames[method.name] ?? outerName;
    final parameters = parseParameters(method.parameters);
    for (var i = 0; i < parameters.length; i++) {
      final (type, name) = parameters[i];
      if (type == 'Canvas') {
        _variables[name] = const CodeCanvas();
      } else if (type == 'Size') {
        _variables[name] = canvasSize;
      } else if (i < arguments.length) {
        _variables[name] = arguments[i];
      }
    }
    splitStatements(method.body).forEach(_statement);
    _variables
      ..clear()
      ..addAll(outer);
    collector.currentName = outerName;
    _depth--;
  }

  void _statement(String raw) {
    final text = raw.trim();
    if (text.isEmpty || text.startsWith('return')) return;
    if (isControlFlow(text)) {
      _skip('Loops and conditions are not supported');
      return;
    }
    try {
      if (_declare(text) || _onReceiver(text) || _callMethod(text)) return;
      _skip('Could not read: ${text.split('\n').first}');
    } on CodeUnsupported catch (error) {
      _skip(error.message);
    } on RangeError {
      _skip('A call is missing arguments');
    } on TypeError {
      _skip('A value has the wrong type');
    }
  }

  Object? _evaluate(String text) {
    final trimmed = text.trim();
    if (trimmed.startsWith('Paint(')) return _paintFrom(trimmed);
    if (trimmed.startsWith('Path(')) return _pathFrom(trimmed);
    return evaluateExpression(trimmed, _scope);
  }

  CodePaint _paintFrom(String expression) {
    final paint = CodePaint();
    for (final operation in splitTopLevel(expression, '..').skip(1)) {
      applyPaintOperation(paint, operation, _scope);
    }
    return paint;
  }

  CodePath _pathFrom(String expression) {
    final path = CodePath();
    for (final operation in splitTopLevel(expression, '..').skip(1)) {
      applyPathOperation(path, operation, _scope);
    }
    return path;
  }

  bool _declare(String text) {
    final match = _declaration.firstMatch(text);
    if (match == null) return false;
    try {
      _variables[match.group(1)!] = _evaluate(match.group(2)!);
    } on CodeUnknownCall {
      // An object of another class, such as a layer; it holds no drawing.
      _variables[match.group(1)!] = null;
    }
    return true;
  }

  bool _onReceiver(String text) {
    final match = _receiver.firstMatch(text);
    if (match == null) return false;
    final target = _variables[match.group(1)];
    final rest = match.group(3)!;
    final operations = match.group(2) == '..' ? splitTopLevel(rest, '..') : [rest];
    switch (target) {
      case CodeCanvas():
        operations.forEach(_canvasCall);
      case CodePaint():
        for (final operation in operations) {
          applyPaintOperation(target, operation, _scope);
        }
      case CodePath():
        for (final operation in operations) {
          applyPathOperation(target, operation, _scope);
        }
      default:
        // A call on another object, such as `_body.paint(canvas)`.
        return rest.trimLeft().startsWith('paint(');
    }
    return true;
  }

  bool _callMethod(String text) {
    final call = parseCall(text);
    if (call == null) return false;
    final method = owner.method(call.name);
    if (method == null) return false;
    final arguments =
        evaluateArguments(call.arguments, _evaluate).positional;
    _runMethod(method, arguments);
    return true;
  }

  void _canvasCall(String text) {
    final call = parseCall(text);
    if (call == null) throw CodeUnsupported('Could not read: $text');
    final args = evaluateArguments(call.arguments, _evaluate).positional;
    double at(int index) => asDouble(args[index]);
    switch (call.name) {
      case 'save':
        _saved.add(_transform);
      case 'restore':
        if (_saved.isNotEmpty) _transform = _saved.removeLast();
      case 'translate':
        _transform = _transform.translated(at(0), at(1));
      case 'scale':
        _transform = _transform.scaled(at(0), args.length > 1 ? at(1) : at(0));
      case 'drawRect':
        collector.addRect(args[0] as Rect, 0, args[1] as CodePaint, _transform);
      case 'drawRRect':
        final rounded = args[0] as CodeRRect;
        collector.addRect(rounded.rect, rounded.radius, args[1] as CodePaint, _transform);
      case 'drawOval':
        collector.addEllipse(args[0] as Rect, args[1] as CodePaint, _transform);
      case 'drawCircle':
        final center = args[0] as Offset;
        final box = Rect.fromCircle(center: center, radius: at(1));
        collector.addEllipse(box, args[2] as CodePaint, _transform);
      case 'drawLine':
        collector.addLine(args[0] as Offset, args[1] as Offset, args[2] as CodePaint, _transform);
      case 'drawPath':
        collector.addPath((args[0] as CodePath).segments, args[1] as CodePaint, _transform);
      case 'clipRect' || 'clipPath' || 'clipRRect':
        break;
      default:
        _skip('canvas.${call.name} is not supported');
    }
  }
}
