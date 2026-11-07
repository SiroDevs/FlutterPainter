/// A light-weight Dart formatter for the code editor's "Format document".
///
/// It is not `dart format`: it does not wrap long lines, add trailing commas or
/// rewrite expressions. It fixes what is cheap to fix and safe on any code:
///
/// * re-indents every line by its bracket nesting (two spaces per level),
///   indenting `case` bodies, cascades (`..`) and wrapped statements;
/// * strips trailing whitespace and turns tabs into indentation;
/// * collapses runs of blank lines to one and drops them at the top;
/// * ends the file with exactly one newline.
///
/// Text inside multi-line strings is left exactly as written. For byte-exact
/// `dart format` output, run `dart format` on the saved files (or swap this for
/// the `dart_style` package).
String formatDart(String source) {
  final text = source.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
  final scanner = _Scanner();
  final out = <String>[];
  // One entry per open bracket: the number of the line that opened it. The
  // indent is the number of distinct lines with a bracket still open, so
  // `Column(children: [` indents its children by one level, not two.
  final open = <int>[];
  // Levels whose `case` / `default` label is active, so the statements under
  // the label are indented one more level.
  final caseLevels = <int>[];
  var pendingBlank = false;
  String? prevText;
  String? prevLast;
  var lineNo = 0;

  for (final raw in text.split('\n')) {
    lineNo++;
    if (scanner.inVerbatim) {
      // Inside a multi-line string or block comment: keep the line as it is
      // (only a comment may lose its trailing spaces; a string may not).
      final wasString = scanner.inString;
      final info = scanner.scan(raw);
      out.add(wasString ? raw : raw.trimRight());
      _apply(open, info.brackets, lineNo);
      pendingBlank = false;
      if (!scanner.inVerbatim && info.lastSig != null) {
        prevText = raw.trim();
        prevLast = info.lastSig;
      }
      continue;
    }

    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      pendingBlank = out.isNotEmpty;
      continue;
    }
    if (pendingBlank) {
      out.add('');
      pendingBlank = false;
    }

    final info = scanner.scan(trimmed);
    final isLabel = !info.commentOnly &&
        (trimmed.startsWith('case ') ||
            trimmed.startsWith('default:') ||
            trimmed.startsWith('default :'));

    // A line that starts with closing brackets sits at the level of the line
    // that opened them.
    final base = _levelOf(open, info.lead);
    caseLevels.removeWhere((level) => level > base);
    final extra = caseLevels.where((l) => isLabel ? l < base : l <= base).length;

    final cont = info.commentOnly || info.lead > 0
        ? 0
        : _continuation(trimmed, prevText, prevLast);

    out.add('${' ' * (2 * (base + extra) + cont)}$trimmed');

    if (isLabel && !caseLevels.contains(base)) caseLevels.add(base);
    _apply(open, info.brackets, lineNo);
    if (!info.commentOnly) {
      prevText = trimmed;
      prevLast = info.lastSig;
    }
  }

  while (out.isNotEmpty && out.last.isEmpty) {
    out.removeLast();
  }
  return out.isEmpty ? '' : '${out.join('\n')}\n';
}

/// The indent level of a line that starts with [lead] closing brackets: the
/// number of distinct lines with a bracket open, not counting the lines those
/// closing brackets belong to.
int _levelOf(List<int> open, int lead) {
  final cut = lead > open.length ? open.length : lead;
  final closing = open.sublist(open.length - cut).toSet();
  final lines = <int>{};
  for (final line in open) {
    if (!closing.contains(line)) lines.add(line);
  }
  return lines.length;
}

/// Opens or closes brackets as listed in [brackets] ('o' open, 'c' close).
void _apply(List<int> open, String brackets, int lineNo) {
  for (var i = 0; i < brackets.length; i++) {
    if (brackets[i] == 'o') {
      open.add(lineNo);
    } else if (open.isNotEmpty) {
      open.removeLast();
    }
  }
}

final _annotation = RegExp(r'^@[\w.]+(\(.*\))?$');
final _control = RegExp(r'^(if|for|while|else|do)\b');

/// Extra indent for a line that continues the previous statement: 2 for a
/// cascade or the body of a brace-less `if`, 4 for any other wrapped line.
int _continuation(String line, String? prevText, String? prevLast) {
  if (prevText == null || prevLast == null) return 0;
  if (';{},(['.contains(prevLast)) return 0;
  if (_annotation.hasMatch(prevText)) return 0;
  final prevIsLabel = prevText.startsWith('case ') ||
      prevText.startsWith('default:') ||
      prevText.startsWith('default :');
  if (prevLast == ':' && prevIsLabel) return 0;
  if (line.startsWith('..')) return 2;
  if (_control.hasMatch(prevText)) return 2;
  return 4;
}

/// What one line contributes: its brackets in order ('o' open, 'c' close), how
/// many closing brackets it starts with, whether it is only a comment, and its
/// last significant character.
class _LineInfo {
  const _LineInfo({
    required this.brackets,
    required this.lead,
    required this.commentOnly,
    required this.lastSig,
  });

  final String brackets;
  final int lead;
  final bool commentOnly;
  final String? lastSig;
}

/// Reads lines one after another, remembering an open block comment or
/// multi-line string between them.
class _Scanner {
  bool inBlock = false;
  String? triple;

  bool get inString => triple != null;
  bool get inVerbatim => inBlock || triple != null;

  _LineInfo scan(String s) {
    final n = s.length;
    var i = 0;
    final brackets = StringBuffer();
    var lead = 0;
    var seenToken = false;
    var sawCode = false;
    String? lastSig;

    // A line that starts inside a comment or string first finds where it ends.
    if (inBlock) {
      final end = s.indexOf('*/');
      if (end < 0) {
        return const _LineInfo(brackets: '', lead: 0, commentOnly: true, lastSig: null);
      }
      inBlock = false;
      i = end + 2;
    } else if (triple != null) {
      final q = triple!;
      final end = _tripleEnd(s, 0, q);
      if (end < 0) {
        return const _LineInfo(brackets: '', lead: 0, commentOnly: false, lastSig: null);
      }
      triple = null;
      i = end;
      sawCode = true;
      seenToken = true;
      lastSig = q[0];
    }

    while (i < n) {
      final c = s[i];
      if (c == ' ' || c == '\t') {
        i++;
        continue;
      }
      if (c == '/' && i + 1 < n && s[i + 1] == '/') break;
      if (c == '/' && i + 1 < n && s[i + 1] == '*') {
        final end = s.indexOf('*/', i + 2);
        if (end < 0) {
          inBlock = true;
          break;
        }
        i = end + 2;
        continue;
      }
      final isRawString = c == 'r' &&
          i + 1 < n &&
          (s[i + 1] == "'" || s[i + 1] == '"') &&
          (i == 0 || !_isIdentChar(s[i - 1]));
      if (c == "'" || c == '"' || isRawString) {
        sawCode = true;
        seenToken = true;
        i = _skipString(s, i, raw: isRawString);
        lastSig = isRawString ? s[i - 1] : (i > 0 ? s[i - 1] : c);
        continue;
      }
      sawCode = true;
      if (c == '(' || c == '[' || c == '{') {
        brackets.write('o');
        seenToken = true;
      } else if (c == ')' || c == ']' || c == '}') {
        brackets.write('c');
        if (!seenToken) lead++;
      } else {
        seenToken = true;
      }
      lastSig = c;
      i++;
    }
    return _LineInfo(
      brackets: brackets.toString(),
      lead: lead,
      commentOnly: !sawCode,
      lastSig: lastSig,
    );
  }

  /// Index just after the string that starts at [start]. A triple-quoted
  /// string that does not end on this line leaves the scanner inside it.
  int _skipString(String s, int start, {required bool raw}) {
    final n = s.length;
    var i = raw ? start + 1 : start;
    final q = s[i];
    final isTriple = s.startsWith(q * 3, i);
    i += isTriple ? 3 : 1;
    while (i < n) {
      final c = s[i];
      if (!raw && c == r'\') {
        i += 2;
        continue;
      }
      if (!raw && c == r'$' && i + 1 < n && s[i + 1] == '{') {
        i = _skipInterpolation(s, i + 2);
        continue;
      }
      if (isTriple) {
        if (s.startsWith(q * 3, i)) return i + 3;
      } else if (c == q) {
        return i + 1;
      }
      i++;
    }
    if (isTriple) triple = q * 3;
    return n;
  }

  int _skipInterpolation(String s, int start) {
    var depth = 1;
    var i = start;
    while (i < s.length) {
      final c = s[i];
      if (c == '{') {
        depth++;
      } else if (c == '}') {
        depth--;
        if (depth == 0) return i + 1;
      } else if (c == "'" || c == '"') {
        i = _skipString(s, i, raw: false);
        continue;
      }
      i++;
    }
    return s.length;
  }

  /// Index just after the closing delimiter [q] (three quotes) at or after
  /// [from], or -1.
  int _tripleEnd(String s, int from, String q) {
    var i = from;
    while (i < s.length) {
      if (s[i] == r'\') {
        i += 2;
        continue;
      }
      if (s.startsWith(q, i)) return i + 3;
      i++;
    }
    return -1;
  }

  static bool _isIdentChar(String c) => RegExp(r'[A-Za-z0-9_$]').hasMatch(c);
}
