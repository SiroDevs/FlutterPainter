/// What a stretch of Dart source is, for syntax colouring.
enum TokenKind { comment, string, keyword, number, type, annotation, function }

class Token {
  const Token(this.start, this.end, this.kind);

  final int start;
  final int end;
  final TokenKind kind;
}

const _keywords = <String>{
  'abstract', 'as', 'assert', 'async', 'await', 'base', 'break', 'case',
  'catch', 'class', 'const', 'continue', 'covariant', 'default', 'deferred',
  'do', 'dynamic', 'else', 'enum', 'export', 'extends', 'extension',
  'external', 'factory', 'false', 'final', 'finally', 'for', 'Function', 'get',
  'hide', 'if', 'implements', 'import', 'in', 'interface', 'is', 'late',
  'library', 'mixin', 'new', 'null', 'on', 'operator', 'part', 'required',
  'rethrow', 'return', 'sealed', 'set', 'show', 'static', 'super', 'switch',
  'sync', 'this', 'throw', 'true', 'try', 'typedef', 'var', 'void', 'when',
  'while', 'with', 'yield',
};

const _builtInTypes = <String>{'int', 'double', 'num', 'bool'};

bool _isIdentStart(int c) =>
    (c >= 0x41 && c <= 0x5A) || (c >= 0x61 && c <= 0x7A) || c == 0x5F || c == 0x24;

bool _isDigit(int c) => c >= 0x30 && c <= 0x39;

bool _isIdentPart(int c) => _isIdentStart(c) || _isDigit(c);

/// Splits Dart source into coloured tokens. Anything not returned is plain
/// text. It is a scanner, not a parser, so it is fast and never fails: odd or
/// half-typed code just gets a slightly different colouring.
List<Token> tokenizeDart(String s) {
  final tokens = <Token>[];
  final n = s.length;
  var i = 0;
  while (i < n) {
    final c = s.codeUnitAt(i);

    if (c == 0x2F && i + 1 < n && s.codeUnitAt(i + 1) == 0x2F) {
      var end = s.indexOf('\n', i);
      if (end < 0) end = n;
      tokens.add(Token(i, end, TokenKind.comment));
      i = end;
      continue;
    }
    if (c == 0x2F && i + 1 < n && s.codeUnitAt(i + 1) == 0x2A) {
      final close = s.indexOf('*/', i + 2);
      final end = close < 0 ? n : close + 2;
      tokens.add(Token(i, end, TokenKind.comment));
      i = end;
      continue;
    }

    final isRaw = c == 0x72 &&
        i + 1 < n &&
        (s[i + 1] == "'" || s[i + 1] == '"') &&
        (i == 0 || !_isIdentPart(s.codeUnitAt(i - 1)));
    if (c == 0x27 || c == 0x22 || isRaw) {
      final end = _stringEnd(s, i, isRaw);
      tokens.add(Token(i, end, TokenKind.string));
      i = end;
      continue;
    }

    if (c == 0x40 && i + 1 < n && _isIdentStart(s.codeUnitAt(i + 1))) {
      var j = i + 1;
      while (j < n && (_isIdentPart(s.codeUnitAt(j)) || s[j] == '.')) {
        j++;
      }
      tokens.add(Token(i, j, TokenKind.annotation));
      i = j;
      continue;
    }

    if (_isDigit(c)) {
      var j = i;
      if (c == 0x30 && i + 1 < n && (s[i + 1] == 'x' || s[i + 1] == 'X')) {
        j = i + 2;
        while (j < n && RegExp(r'[0-9a-fA-F_]').hasMatch(s[j])) {
          j++;
        }
      } else {
        while (j < n && (_isDigit(s.codeUnitAt(j)) || s[j] == '_')) {
          j++;
        }
        if (j + 1 < n && s[j] == '.' && _isDigit(s.codeUnitAt(j + 1))) {
          j++;
          while (j < n && (_isDigit(s.codeUnitAt(j)) || s[j] == '_')) {
            j++;
          }
        }
        if (j < n && (s[j] == 'e' || s[j] == 'E')) {
          var k = j + 1;
          if (k < n && (s[k] == '+' || s[k] == '-')) k++;
          if (k < n && _isDigit(s.codeUnitAt(k))) {
            while (k < n && _isDigit(s.codeUnitAt(k))) {
              k++;
            }
            j = k;
          }
        }
      }
      tokens.add(Token(i, j, TokenKind.number));
      i = j;
      continue;
    }

    if (_isIdentStart(c)) {
      var j = i + 1;
      while (j < n && _isIdentPart(s.codeUnitAt(j))) {
        j++;
      }
      final word = s.substring(i, j);
      final first = word.replaceFirst(RegExp(r'^[_$]+'), '');
      if (_keywords.contains(word)) {
        tokens.add(Token(i, j, TokenKind.keyword));
      } else if (_builtInTypes.contains(word) ||
          (first.isNotEmpty && first[0] != first[0].toLowerCase())) {
        tokens.add(Token(i, j, TokenKind.type));
      } else {
        var k = j;
        while (k < n && (s[k] == ' ' || s[k] == '\t')) {
          k++;
        }
        if (k < n && s[k] == '(') tokens.add(Token(i, j, TokenKind.function));
      }
      i = j;
      continue;
    }
    i++;
  }
  return tokens;
}

/// Index just after the string literal that starts at [start].
int _stringEnd(String s, int start, bool raw) {
  final n = s.length;
  var i = raw ? start + 1 : start;
  final q = s[i];
  final triple = s.startsWith(q * 3, i);
  i += triple ? 3 : 1;
  while (i < n) {
    final c = s[i];
    if (!raw && c == r'\') {
      i += 2;
      continue;
    }
    if (!raw && c == r'$' && i + 1 < n && s[i + 1] == '{') {
      var depth = 1;
      i += 2;
      while (i < n && depth > 0) {
        if (s[i] == '{') depth++;
        if (s[i] == '}') depth--;
        i++;
      }
      continue;
    }
    if (triple) {
      if (s.startsWith(q * 3, i)) return i + 3;
    } else if (c == q) {
      return i + 1;
    } else if (c == '\n') {
      return i; // an unterminated one-line string ends at the line break
    }
    i++;
  }
  return n;
}
