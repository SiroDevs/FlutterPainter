// Project imports:
import 'code_text.dart';
import 'code_values.dart';

enum TokenKind { number, name, text, symbol }

class Token {
  const Token(this.kind, this.text);

  final TokenKind kind;
  final String text;
}

final _numberPattern = RegExp(r'0[xX][0-9a-fA-F]+|\d+\.\d+|\.\d+|\d+');
final _namePattern = RegExp(r'[A-Za-z_$][\w$]*');

// Splits an expression into numbers, names, strings and symbols.
List<Token> tokenize(String source) {
  final tokens = <Token>[];
  var index = 0;
  while (index < source.length) {
    final char = source[index];
    if (char.trim().isEmpty) {
      index++;
      continue;
    }
    if (char == "'" || char == '"') {
      final end = stringEnd(source, index);
      tokens.add(Token(TokenKind.text, source.substring(index + 1, end - 1)));
      index = end;
      continue;
    }
    final number = _numberPattern.matchAsPrefix(source, index);
    final name = _namePattern.matchAsPrefix(source, index);
    if (number != null) {
      tokens.add(Token(TokenKind.number, number.group(0)!));
      index = number.end;
    } else if (name != null) {
      tokens.add(Token(TokenKind.name, name.group(0)!));
      index = name.end;
    } else if (source.startsWith('..', index)) {
      throw const CodeUnsupported('A cascade inside an expression');
    } else {
      tokens.add(Token(TokenKind.symbol, char));
      index++;
    }
  }
  return tokens;
}
