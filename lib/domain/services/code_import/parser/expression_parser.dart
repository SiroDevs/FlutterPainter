// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import 'code_builtins.dart';
import 'code_tokens.dart';
import 'code_values.dart';
import 'named_colors.dart';

// What names mean while an expression is evaluated.
class ExpressionScope {
  ExpressionScope({required this.variables, required this.palette});

  final Map<String, Object?> variables;
  final Map<String, int> palette;
}

// Evaluates one Dart expression made of numbers, offsets, rectangles, colours,
// gradients and arithmetic. Anything else throws [CodeUnsupported].
Object? evaluateExpression(String source, ExpressionScope scope) {
  final parser = _Parser(tokenize(source), scope);
  final value = parser.parseExpression();
  if (!parser.atEnd) throw const CodeUnsupported('Unexpected text');
  return value;
}

class _Parser {
  _Parser(this.tokens, this.scope);

  final List<Token> tokens;
  final ExpressionScope scope;
  int _index = 0;

  bool get atEnd => _index >= tokens.length;

  Token? _at(int offset) =>
      _index + offset < tokens.length ? tokens[_index + offset] : null;

  bool _isSymbol(String symbol, [int offset = 0]) {
    final token = _at(offset);
    return token != null &&
        token.kind == TokenKind.symbol &&
        token.text == symbol;
  }

  void _expect(String symbol) {
    if (!_isSymbol(symbol)) throw CodeUnsupported('Expected $symbol');
    _index++;
  }

  Object? parseExpression() => _additive();

  Object? _additive() {
    var value = _term();
    while (_isSymbol('+') || _isSymbol('-')) {
      final operator = tokens[_index++].text;
      value = combineValues(value, _term(), operator);
    }
    return value;
  }

  Object? _term() {
    var value = _unary();
    while (_isSymbol('*') || _isSymbol('/')) {
      final operator = tokens[_index++].text;
      value = combineValues(value, _unary(), operator);
    }
    return value;
  }

  Object? _unary() {
    if (_isSymbol('-')) {
      _index++;
      return combineValues(0, _unary(), '-');
    }
    if (_isSymbol('+')) _index++;
    return _postfix(_primary());
  }

  Object? _postfix(Object? start) {
    var value = start;
    while (_isSymbol('.') && _at(1)?.kind == TokenKind.name) {
      final name = _at(1)!.text;
      _index += 2;
      if (_isSymbol('(')) {
        final arguments = _arguments();
        value = callMethod(value, name, arguments.positional, arguments.named);
      } else {
        value = readProperty(value, name);
      }
    }
    return value;
  }

  Object? _primary() {
    final token = _at(0);
    if (token == null) throw const CodeUnsupported('Missing value');
    switch (token.kind) {
      case TokenKind.number:
        _index++;
        return token.text.startsWith('0x') || token.text.startsWith('0X')
            ? int.parse(token.text.substring(2), radix: 16)
            : num.parse(token.text);
      case TokenKind.text:
        _index++;
        return token.text;
      case TokenKind.name:
        if (token.text == 'true' || token.text == 'false') {
          _index++;
          return token.text == 'true';
        }
        if (token.text == 'const' || token.text == 'new') {
          _index++;
          return _primary();
        }
        return _nameChain();
      case TokenKind.symbol:
        if (_isSymbol('(')) {
          _index++;
          final value = parseExpression();
          _expect(')');
          return value;
        }
        if (_isSymbol('<')) _skipTypeArguments();
        if (_isSymbol('[')) return _list();
    }
    throw CodeUnsupported('Unexpected ${token.text}');
  }

  void _skipTypeArguments() {
    while (!atEnd && !_isSymbol('>')) {
      _index++;
    }
    _expect('>');
  }

  List<Object?> _list() {
    _expect('[');
    final items = <Object?>[];
    while (!_isSymbol(']')) {
      items.add(parseExpression());
      if (_isSymbol(',')) {
        _index++;
      } else {
        break;
      }
    }
    _expect(']');
    return items;
  }

  ({List<Object?> positional, Map<String, Object?> named}) _arguments() {
    _expect('(');
    final positional = <Object?>[];
    final named = <String, Object?>{};
    while (!_isSymbol(')')) {
      if (_at(0)?.kind == TokenKind.name && _isSymbol(':', 1)) {
        final name = tokens[_index].text;
        _index += 2;
        named[name] = parseExpression();
      } else {
        positional.add(parseExpression());
      }
      if (_isSymbol(',')) {
        _index++;
      } else {
        break;
      }
    }
    _expect(')');
    return (positional: positional, named: named);
  }

  Object? _nameChain() {
    final parts = [tokens[_index++].text];
    while (_isSymbol('.') && _at(1)?.kind == TokenKind.name) {
      parts.add(_at(1)!.text);
      _index += 2;
    }
    if (!_isSymbol('(')) return _resolve(parts);
    final arguments = _arguments();
    try {
      return callStatic(parts.join('.'), arguments.positional, arguments.named);
    } on CodeUnknownCall {
      if (parts.length < 2) rethrow;
      final receiver = _resolve(parts.sublist(0, parts.length - 1));
      return callMethod(
        receiver,
        parts.last,
        arguments.positional,
        arguments.named,
      );
    }
  }

  Object? _resolve(List<String> parts) {
    final head = parts.first;
    var next = 1;
    Object? value;
    if (scope.variables.containsKey(head)) {
      value = scope.variables[head];
    } else if (head == 'Colors' && parts.length >= 2) {
      value = namedColor(parts[1]);
      next = 2;
    } else if (parts.last == 'pi' && (parts.length == 1 || head == 'math')) {
      return math.pi;
    } else if (parts.join('.') == 'Offset.zero') {
      return Offset.zero;
    } else if (scope.palette.containsKey(parts.last)) {
      return CodeColor(scope.palette[parts.last]!);
    }
    if (value == null) throw CodeUnsupported('Unknown name ${parts.join('.')}');
    for (; next < parts.length; next++) {
      value = readProperty(value, parts[next]);
    }
    return value;
  }
}
