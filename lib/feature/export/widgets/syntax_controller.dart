// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../domain/services/dart_tokenizer.dart';
import 'vscode_colors.dart';

/// A text controller whose text is drawn with Dart syntax colours. The spans
/// always add up to exactly the text, so the caret and selection stay correct.
class SyntaxController extends TextEditingController {
  SyntaxController({required String text, required this.colors})
      : super(text: text);

  VsCodeColors colors;

  String? _spansFor;
  VsCodeColors? _spansColors;
  List<TextSpan> _spans = const [];

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final src = text;
    // Caret blinks and selection changes ask again with the same text; only
    // re-scan when the text or the colours changed.
    if (_spansFor != src || !identical(_spansColors, colors)) {
      _spans = _build(src);
      _spansFor = src;
      _spansColors = colors;
    }
    return TextSpan(style: style, children: _spans);
  }

  List<TextSpan> _build(String src) {
    final spans = <TextSpan>[];
    var pos = 0;
    for (final token in tokenizeDart(src)) {
      if (token.start > pos) {
        spans.add(TextSpan(text: src.substring(pos, token.start)));
      }
      spans.add(
        TextSpan(
          text: src.substring(token.start, token.end),
          style: TextStyle(color: colors.forToken(token.kind)),
        ),
      );
      pos = token.end;
    }
    if (pos < src.length) spans.add(TextSpan(text: src.substring(pos)));
    return spans;
  }
}
