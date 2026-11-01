// Dart imports:
import 'dart:ui';

// Project imports:
import '../../models/shape.dart';
import 'canvas_interpreter.dart';
import 'class_scanner.dart';
import 'code_text.dart';
import 'code_values.dart';
import 'expression_parser.dart';
import 'shape_collector.dart';

// What reading one file of code produced. [error] is set when the file cannot
// be read at all yet (for example while a bracket is still open).
class FileImport {
  const FileImport({
    this.shapes = const [],
    this.skipped = 0,
    this.notes = const [],
    this.hasPaintCode = false,
    this.layerName = '',
    this.error,
  });

  final List<Shape> shapes;
  final int skipped;
  final List<String> notes;
  final bool hasPaintCode;
  final String layerName;
  final String? error;

  bool get isReadable => error == null;
}

final _paletteEntry = RegExp(r'static\s+const\s+Color\s+(\w+)\s*=\s*([^;]+);');
final _shapeDoc = RegExp(r'///\s*Shape\s+"(.*?)"\.\s*\n\s*(?:void\s+)?(\w+)\s*\(');

// The colours a palette file defines, by name.
Map<String, int> readPalette(Iterable<String> sources) {
  final palette = <String, int>{};
  final scope = ExpressionScope(variables: {}, palette: palette);
  for (final source in sources) {
    for (final match in _paletteEntry.allMatches(stripComments(source))) {
      try {
        final color = evaluateExpression(match.group(2)!, scope);
        if (color is CodeColor) palette[match.group(1)!] = color.argb;
      } on CodeUnsupported {
        continue;
      }
    }
  }
  return palette;
}

// Reads the drawing calls in [content] and returns the shapes they paint.
FileImport importCode(
  String content, {
  required Map<String, int> palette,
  required Size canvasSize,
}) {
  final source = stripComments(content);
  if (!hasBalancedBrackets(source)) {
    return const FileImport(error: 'The brackets do not match yet');
  }
  final shapeNames = {
    for (final match in _shapeDoc.allMatches(content))
      match.group(2)!: match.group(1)!,
  };
  final collector = ShapeCollector();
  var skipped = 0;
  var hasPaintCode = false;
  var layerName = '';
  final notes = <String>{};
  for (final owner in scanClasses(source)) {
    for (final entry in _entryPoints(owner)) {
      hasPaintCode = true;
      if (owner.name.isNotEmpty) layerName = owner.name;
      final interpreter = CanvasInterpreter(
        owner: owner,
        palette: palette,
        canvasSize: canvasSize,
        shapeNames: shapeNames,
        collector: collector,
      );
      try {
        interpreter.run(entry);
      } on CodeUnsupported catch (error) {
        interpreter.skipped++;
        interpreter.notes.add(error.message);
      }
      skipped += interpreter.skipped;
      notes.addAll(interpreter.notes);
    }
  }
  return FileImport(
    shapes: collector.shapes,
    skipped: skipped,
    notes: notes.toList(),
    hasPaintCode: hasPaintCode,
    layerName: layerName,
  );
}

// The methods to run: `paint`, or else every method that takes a Canvas and is
// not called by another method of the same class.
List<CodeMethod> _entryPoints(CodeClass owner) {
  final paint = owner.method('paint');
  if (paint != null) return [paint];
  final bodies = owner.methods.map((m) => m.body).join('\n');
  return [
    for (final method in owner.methods)
      if (method.parameters.contains('Canvas') &&
          !RegExp('\\b${method.name}\\s*\\(').hasMatch(bodies))
        method,
  ];
}
