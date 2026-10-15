// Dart imports:
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Project imports:
import '../../../domain/models/export_file.dart';
import 'syntax_controller.dart';
import 'vscode_colors.dart';

/// Where the caret is, for the status bar ("Ln 3, Col 14").
class CaretInfo {
  const CaretInfo(this.line, this.column, [this.selected = 0]);

  final int line;
  final int column;

  /// How many characters are selected.
  final int selected;

  @override
  bool operator ==(Object other) =>
      other is CaretInfo &&
      other.line == line &&
      other.column == column &&
      other.selected == selected;

  @override
  int get hashCode => Object.hash(line, column, selected);
}

/// Remembers each file's scroll position and selection while its tab is not
/// the one on screen, so switching tabs puts you back where you were.
class EditorViewStore {
  final Map<String, ({double scroll, TextSelection selection})> _views = {};

  void save(String path, {required double scroll, required TextSelection selection}) =>
      _views[path] = (scroll: scroll, selection: selection);

  ({double scroll, TextSelection selection})? restore(String path) => _views[path];
}

/// An editable, syntax-coloured view of one file with a line-number gutter, like
/// VS Code's editor: no wrapping, Tab indents, Enter keeps the indentation.
class CodeEditor extends StatefulWidget {
  const CodeEditor({
    super.key,
    required this.file,
    required this.colors,
    required this.views,
    required this.caret,
    required this.onChanged,
  });

  final ExportFile file;
  final VsCodeColors colors;
  final EditorViewStore views;
  final ValueNotifier<CaretInfo> caret;
  final ValueChanged<String> onChanged;

  @override
  State<CodeEditor> createState() => _CodeEditorState();
}

class _CodeEditorState extends State<CodeEditor> {
  static const double _fontSize = 13;
  static const double _lineHeight = 1.5;
  static const double _topPadding = 8;

  late final SyntaxController _controller;
  late final ScrollController _vertical;
  final ScrollController _horizontal = ScrollController();
  final FocusNode _focus = FocusNode();

  double? _charWidth;

  // Gutter and width, recomputed only when the text changes.
  String? _layoutFor;
  int _lineCount = 1;
  int _maxColumns = 0;
  String _gutter = '1';

  @override
  void initState() {
    super.initState();
    final saved = widget.views.restore(widget.file.path);
    _controller = SyntaxController(
      text: widget.file.content,
      colors: widget.colors,
    );
    if (saved != null &&
        saved.selection.isValid &&
        saved.selection.end <= widget.file.content.length) {
      _controller.selection = saved.selection;
    }
    _vertical = ScrollController(initialScrollOffset: saved?.scroll ?? 0);
    _controller.addListener(_reportCaret);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _reportCaret();
      _focus.requestFocus();
    });
  }

  @override
  void didUpdateWidget(CodeEditor old) {
    super.didUpdateWidget(old);
    _controller.colors = widget.colors;
    final content = widget.file.content;
    // The text changed from outside (Format, Regenerate); typing already keeps
    // the two equal, so this does not fire for the user's own edits.
    if (content != _controller.text) {
      final at = _controller.selection.isValid
          ? _controller.selection.baseOffset
          : 0;
      _controller.value = TextEditingValue(
        text: content,
        selection: TextSelection.collapsed(
          offset: math.max(0, math.min(at, content.length)),
        ),
      );
    }
  }

  @override
  void dispose() {
    widget.views.save(
      widget.file.path,
      scroll: _vertical.hasClients ? _vertical.offset : 0,
      selection: _controller.selection,
    );
    _controller.removeListener(_reportCaret);
    _controller.dispose();
    _vertical.dispose();
    _horizontal.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _reportCaret() {
    final sel = _controller.selection;
    if (!sel.isValid) return;
    final text = _controller.text;
    final offset = math.min(math.max(sel.extentOffset, 0), text.length);
    var line = 1;
    var lineStart = 0;
    for (var i = 0; i < offset; i++) {
      if (text.codeUnitAt(i) == 10) {
        line++;
        lineStart = i + 1;
      }
    }
    widget.caret.value = CaretInfo(line, offset - lineStart + 1, sel.end - sel.start);
  }

  void _layout(String text) {
    if (_layoutFor == text) return;
    _layoutFor = text;
    var lines = 1;
    var column = 0;
    var longest = 0;
    for (var i = 0; i < text.length; i++) {
      if (text.codeUnitAt(i) == 10) {
        lines++;
        longest = math.max(longest, column);
        column = 0;
      } else {
        column++;
      }
    }
    _lineCount = lines;
    _maxColumns = math.max(longest, column);
    _gutter = List.generate(lines, (i) => '${i + 1}').join('\n');
  }

  double _measure(TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: 'MMMMMMMMMM', style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    return painter.width / 10;
  }

  // ---- editing helpers -------------------------------------------------------

  int _lineStart(String text, int offset) =>
      offset <= 0 ? 0 : text.lastIndexOf('\n', offset - 1) + 1;

  void _apply(String text, TextSelection selection) {
    _controller.value = TextEditingValue(text: text, selection: selection);
    widget.onChanged(text);
  }

  /// Enter: a new line that starts at the same indentation, one level deeper
  /// after an opening bracket.
  void _newline() {
    final sel = _controller.selection;
    if (!sel.isValid) return;
    final text = _controller.text;
    final before = text.substring(_lineStart(text, sel.start), sel.start);
    final indent = RegExp(r'^[ \t]*').firstMatch(before)!.group(0)!;
    final opens = RegExp(r'[{(\[]\s*$').hasMatch(before);
    final insert = '\n$indent${opens ? '  ' : ''}';
    _apply(
      text.replaceRange(sel.start, sel.end, insert),
      TextSelection.collapsed(offset: sel.start + insert.length),
    );
  }

  /// Tab: two spaces at the caret, or one more level for every selected line.
  void _indent() {
    final sel = _controller.selection;
    if (!sel.isValid) return;
    final text = _controller.text;
    if (!text.substring(sel.start, sel.end).contains('\n')) {
      _apply(
        text.replaceRange(sel.start, sel.end, '  '),
        TextSelection.collapsed(offset: sel.start + 2),
      );
      return;
    }
    final start = _lineStart(text, sel.start);
    final lines = text.substring(start, sel.end).split('\n');
    var added = 0;
    final out = <String>[];
    for (var i = 0; i < lines.length; i++) {
      // A selection that ends at the very start of a line leaves that line be.
      final skip = i == lines.length - 1 && lines[i].isEmpty;
      out.add(skip ? lines[i] : '  ${lines[i]}');
      if (!skip) added += 2;
    }
    _apply(
      text.replaceRange(start, sel.end, out.join('\n')),
      TextSelection(baseOffset: sel.start + 2, extentOffset: sel.end + added),
    );
  }

  /// Shift+Tab: one level less for the current or selected lines.
  void _outdent() {
    final sel = _controller.selection;
    if (!sel.isValid) return;
    final text = _controller.text;
    final start = _lineStart(text, sel.start);
    var end = sel.end;
    if (sel.isCollapsed) {
      end = text.indexOf('\n', sel.end);
      if (end < 0) end = text.length;
    }
    final lines = text.substring(start, end).split('\n');
    var removedFirst = 0;
    var removedAll = 0;
    for (var i = 0; i < lines.length; i++) {
      final l = lines[i];
      final r = l.startsWith('  ') ? 2 : (l.startsWith(' ') || l.startsWith('\t') ? 1 : 0);
      lines[i] = l.substring(r);
      removedAll += r;
      if (i == 0) removedFirst = r;
    }
    final base = math.max(start, sel.start - removedFirst);
    final extent = math.max(base, sel.end - removedAll);
    _apply(
      text.replaceRange(start, end, lines.join('\n')),
      TextSelection(baseOffset: base, extentOffset: extent),
    );
  }

  // ---- build ---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final c = widget.colors;
    final style = TextStyle(
      fontFamily: VsCodeColors.fontFamily,
      fontFamilyFallback: VsCodeColors.fontFallback,
      fontSize: _fontSize,
      height: _lineHeight,
      color: c.editorText,
    );
    // The same forced line height in the gutter and the text keeps every line
    // number level with its line.
    const strut = StrutStyle(
      fontFamily: VsCodeColors.fontFamily,
      fontFamilyFallback: VsCodeColors.fontFallback,
      fontSize: _fontSize,
      height: _lineHeight,
      forceStrutHeight: true,
    );
    final charWidth = _charWidth ??= _measure(style);

    return ColoredBox(
      color: c.editorBg,
      child: LayoutBuilder(
        builder: (context, box) => ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            _layout(_controller.text);
            final digits = math.max(3, _lineCount.toString().length);
            final gutterWidth = digits * charWidth + 32;
            final textWidth = math.max(
              box.maxWidth - gutterWidth,
              (_maxColumns + 8) * charWidth + 24,
            );
            return Scrollbar(
              controller: _vertical,
              child: SingleChildScrollView(
                controller: _vertical,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: box.maxHeight),
                  child: GestureDetector(
                    // A click below the last line puts the caret at the end.
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      _focus.requestFocus();
                      _controller.selection = TextSelection.collapsed(
                        offset: _controller.text.length,
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: gutterWidth,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: _topPadding,
                              right: 16,
                            ),
                            child: Text(
                              _gutter,
                              textAlign: TextAlign.right,
                              style: style.copyWith(color: c.lineNumber),
                              strutStyle: strut,
                            ),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _horizontal,
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: textWidth,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: _topPadding,
                                  bottom: 32,
                                ),
                                child: _field(style, strut, c),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _field(TextStyle style, StrutStyle strut, VsCodeColors c) {
    return TextSelectionTheme(
      data: TextSelectionThemeData(
        cursorColor: c.editorText,
        selectionColor: c.editorSelection,
      ),
      child: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.tab): _indent,
          const SingleActivator(LogicalKeyboardKey.tab, shift: true): _outdent,
          const SingleActivator(LogicalKeyboardKey.enter): _newline,
        },
        child: TextField(
          controller: _controller,
          focusNode: _focus,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          style: style,
          strutStyle: strut,
          autocorrect: false,
          enableSuggestions: false,
          smartDashesType: SmartDashesType.disabled,
          smartQuotesType: SmartQuotesType.disabled,
          scrollPhysics: const NeverScrollableScrollPhysics(),
          decoration: const InputDecoration.collapsed(hintText: null),
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
