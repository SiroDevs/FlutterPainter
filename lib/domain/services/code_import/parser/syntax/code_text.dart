// Text helpers for reading Dart source without a full parser.

const _openers = '([{';
const _closers = ')]}';

bool _isQuote(String char) => char == "'" || char == '"';

// Index just past the string literal that starts at [start].
int stringEnd(String source, int start) {
  final quote = source[start];
  var index = start + 1;
  while (index < source.length) {
    if (source[index] == '\\') {
      index += 2;
    } else if (source[index] == quote) {
      return index + 1;
    } else {
      index++;
    }
  }
  return source.length;
}

// Removes // and /* */ comments, leaving string literals alone.
String stripComments(String source) {
  final out = StringBuffer();
  var index = 0;
  while (index < source.length) {
    final char = source[index];
    if (_isQuote(char)) {
      final end = stringEnd(source, index);
      out.write(source.substring(index, end));
      index = end;
    } else if (source.startsWith('//', index)) {
      while (index < source.length && source[index] != '\n') {
        index++;
      }
    } else if (source.startsWith('/*', index)) {
      final end = source.indexOf('*/', index + 2);
      index = end < 0 ? source.length : end + 2;
    } else {
      out.write(char);
      index++;
    }
  }
  return out.toString();
}

// Index of the bracket that closes the one at [open], or -1.
int closingIndex(String source, int open) {
  var depth = 0;
  for (var index = open; index < source.length; index++) {
    final char = source[index];
    if (_isQuote(char)) {
      index = stringEnd(source, index) - 1;
    } else if (_openers.contains(char)) {
      depth++;
    } else if (_closers.contains(char)) {
      depth--;
      if (depth == 0) return index;
    }
  }
  return -1;
}

// True when every bracket outside strings is closed in order.
bool hasBalancedBrackets(String source) {
  var depth = 0;
  for (var index = 0; index < source.length; index++) {
    final char = source[index];
    if (_isQuote(char)) {
      index = stringEnd(source, index) - 1;
    } else if (_openers.contains(char)) {
      depth++;
    } else if (_closers.contains(char)) {
      depth--;
      if (depth < 0) return false;
    }
  }
  return depth == 0;
}

// Splits [text] at [separator] where it is not inside brackets or strings.
List<String> splitTopLevel(String text, String separator) {
  final parts = <String>[];
  var depth = 0;
  var start = 0;
  for (var index = 0; index < text.length; index++) {
    final char = text[index];
    if (_isQuote(char)) {
      index = stringEnd(text, index) - 1;
    } else if (_openers.contains(char)) {
      depth++;
    } else if (_closers.contains(char)) {
      depth--;
    } else if (depth == 0 && text.startsWith(separator, index)) {
      parts.add(text.substring(start, index));
      index += separator.length - 1;
      start = index + 1;
    }
  }
  parts.add(text.substring(start));
  return parts;
}

const _controlWords = ['for', 'if', 'while', 'switch', 'else', 'do', 'try'];

bool _startsControl(String statement) {
  final word = RegExp(r'^\s*(\w+)').firstMatch(statement)?.group(1);
  return word != null && _controlWords.contains(word);
}

// Splits a method body into statements. A loop or condition with a block ends
// at its closing brace, so it arrives as one statement.
List<String> splitStatements(String body) {
  final statements = <String>[];
  var depth = 0;
  var start = 0;
  for (var index = 0; index < body.length; index++) {
    final char = body[index];
    if (_isQuote(char)) {
      index = stringEnd(body, index) - 1;
    } else if (_openers.contains(char)) {
      depth++;
    } else if (_closers.contains(char)) {
      depth--;
      if (depth == 0 && char == '}' && _startsControl(body.substring(start))) {
        statements.add(body.substring(start, index + 1));
        start = index + 1;
      }
    } else if (char == ';' && depth == 0) {
      statements.add(body.substring(start, index));
      start = index + 1;
    }
  }
  statements.add(body.substring(start));
  return [
    for (final statement in statements)
      if (statement.trim().isNotEmpty) statement.trim(),
  ];
}

// True for a statement that starts a loop, condition or similar.
bool isControlFlow(String statement) => _startsControl(statement);
