// Project imports:
import 'code_text.dart';

// One method (or top-level function): its name, parameter list and body.
class CodeMethod {
  const CodeMethod(this.name, this.parameters, this.body);

  final String name;
  final String parameters;
  final String body;
}

// One class, or the top level of a file (name is empty): its methods and the
// statements declared directly in it, such as fields.
class CodeClass {
  const CodeClass(this.name, this.methods, this.fields);

  final String name;
  final List<CodeMethod> methods;
  final List<String> fields;

  CodeMethod? method(String methodName) {
    for (final candidate in methods) {
      if (candidate.name == methodName) return candidate;
    }
    return null;
  }
}

// The (type, name) pairs of a parameter list such as `Canvas canvas, Size size`.
List<(String, String)> parseParameters(String text) {
  final cleaned = text.replaceAll(RegExp(r'[\[\]{}]'), '').replaceAll('required ', '');
  return [
    for (final part in splitTopLevel(cleaned, ','))
      if (part.trim().isNotEmpty)
        () {
          final words = part.trim().split(RegExp(r'\s+'));
          final name = words.last.replaceFirst('this.', '');
          return (words.length > 1 ? words.first : '', name);
        }(),
  ];
}

final _classHead = RegExp(r'(?:^|\s)class\s+(\w+)');
final _methodHead = RegExp(r'^([^(]*?)(\w+)\s*\(([\s\S]*)\)\s*(?:async\s*)?$');

// Finds the classes in [source] (comments already removed). The first entry is
// the file's top level; the classes follow in order.
List<CodeClass> scanClasses(String source) {
  final classes = <CodeClass>[];
  final topLevel = _scanBody('', source, classes);
  return [topLevel, ...classes];
}

CodeClass _scanBody(String name, String text, List<CodeClass> classes) {
  final methods = <CodeMethod>[];
  final fields = <String>[];
  var start = 0;
  var index = 0;
  while (index < text.length) {
    final char = text[index];
    if (char == "'" || char == '"') {
      index = stringEnd(text, index);
    } else if (char == '(' || char == '[') {
      final close = closingIndex(text, index);
      if (close < 0) break;
      index = close + 1;
    } else if (char == ';') {
      final field = text.substring(start, index).trim();
      if (field.isNotEmpty) fields.add(field);
      start = ++index;
    } else if (char == '{') {
      final close = closingIndex(text, index);
      if (close < 0) break;
      final head = text.substring(start, index).trim();
      final block = text.substring(index + 1, close);
      final classMatch = head.contains('(') ? null : _classHead.firstMatch(head);
      final methodMatch = _methodHead.firstMatch(head);
      if (classMatch != null) {
        classes.add(_scanBody(classMatch.group(1)!, block, classes));
      } else if (methodMatch != null) {
        methods.add(CodeMethod(
          methodMatch.group(2)!,
          methodMatch.group(3)!,
          block,
        ));
      }
      index = close + 1;
      start = index;
    } else {
      index++;
    }
  }
  return CodeClass(name, methods, fields);
}
