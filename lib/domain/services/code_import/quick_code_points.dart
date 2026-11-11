// Dart imports:
import 'dart:ui';

// Project imports:
import 'code_text.dart';
import 'expression_parser.dart';
import 'code_values.dart';

class QuickCodeShapeData {
  const QuickCodeShapeData({required this.points, this.name, this.groupName});

  final List<Offset> points;
  final String? name;
  final String? groupName;
}

/// Parses and formats the coordinate list shown by Quick Code.
abstract class QuickCodePoints {
  QuickCodePoints._();

  static List<Offset> parse(String source) {
    final expression = stripComments(source)
        .trim()
        .replaceFirst(RegExp(r';\s*$'), '');
    if (expression.isEmpty) return const [];
    Object? value;
    try {
      value = evaluateExpression(
        expression,
        ExpressionScope(variables: const {}, palette: const {}),
      );
    } on CodeUnsupported {
      return _parseCompact(expression);
    }
    if (value is! List) throw const CodeUnsupported('Expected a point list');
    return [for (final point in value) _point(point)];
  }

  static List<QuickCodeShapeData> parseShapes(String source) {
    final expression = stripComments(source)
        .trim()
        .replaceFirst(RegExp(r';\s*$'), '');
    if (expression.isEmpty) return const [];
    final grouped = _parseGroups(expression);
    if (grouped != null) return grouped;
    final dartShapes = _parseDartShapes(source);
    if (dartShapes != null) return dartShapes;

    final quoted = RegExp(r'''(['"])(.*?)\1''', dotAll: true)
        .allMatches(expression)
        .map((match) => match.group(2)!.trim())
        .where((record) => record.contains('|'))
        .toList();
    if (quoted.isNotEmpty) {
      return [for (final record in quoted) _namedShape(record)];
    }

    final lines = expression
        .split(RegExp(r'[\r\n]+'))
        .map(_unwrapRecord)
        .where((line) => line.isNotEmpty)
        .toList();
    if (lines.isNotEmpty && lines.every((line) => line.contains('|'))) {
      return [for (final line in lines) _namedShape(line)];
    }

    final name = _metadata(source, 'Shape');
    final group = _metadata(source, 'Group');
    return [
      QuickCodeShapeData(
        points: parse(expression),
        name: name,
        groupName: group,
      ),
    ];
  }

  static List<QuickCodeShapeData>? _parseGroups(String source) {
    final groups = RegExp(r'''(['"])([^'"]*)\1\s*:\s*\[([\s\S]*?)\]\s*,?''')
        .allMatches(source);
    if (groups.isEmpty) return null;
    final shapes = <QuickCodeShapeData>[];
    final strings = RegExp(r'''(['"])(.*?)\1''', dotAll: true);
    for (final group in groups) {
      final rawGroupName = group.group(2)!.trim();
      final groupName = rawGroupName.isEmpty ? null : rawGroupName;
      final entries = strings.allMatches(group.group(3)!);
      for (final entry in entries) {
        shapes.add(_namedShape(entry.group(2)!, groupName: groupName));
      }
    }
    if (shapes.isEmpty) throw const CodeUnsupported('No named shapes found');
    return shapes;
  }

  static List<QuickCodeShapeData>? _parseDartShapes(String source) {
    final matches = RegExp(r'<Offset>\s*\[').allMatches(source).toList();
    if (matches.isEmpty) return null;
    final shapes = <QuickCodeShapeData>[];
    var priorEnd = 0;
    for (final match in matches) {
      final open = match.end - 1;
      final close = closingIndex(source, open);
      if (close < 0) return null;
      final points = parse('${source.substring(match.start, close + 1)};');
      final header = source.substring(priorEnd, match.start);
      shapes.add(
        QuickCodeShapeData(
          points: points,
          name: _metadata(header, 'Shape'),
          groupName: _metadata(header, 'Group'),
        ),
      );
      priorEnd = close + 1;
    }
    return shapes;
  }

  static QuickCodeShapeData _namedShape(String source, {String? groupName}) {
    final record = _unwrapRecord(source);
    final separator = record.indexOf('|');
    final name = separator < 0 ? null : record.substring(0, separator).trim();
    final coordinates = separator < 0
        ? record
        : record.substring(separator + 1);
    return QuickCodeShapeData(
      points: parse(coordinates),
      name: name == null || name.isEmpty ? null : name,
      groupName: groupName,
    );
  }

  static String _unwrapRecord(String source) {
    var record = source.trim().replaceFirst(RegExp(r'[,;]\s*$'), '').trim();
    if (record.length >= 2 &&
        (record.startsWith("'") && record.endsWith("'") ||
            record.startsWith('"') && record.endsWith('"'))) {
      record = record.substring(1, record.length - 1);
    }
    return record.trim();
  }

  static String? _metadata(String source, String key) {
    final matches = RegExp(
      r'^\s*//\s*' + RegExp.escape(key) + r':\s*(.+)$',
      multiLine: true,
    ).allMatches(source);
    return matches.isEmpty ? null : matches.last.group(1)?.trim();
  }

  static List<Offset> _parseCompact(String source) {
    final pairPattern = RegExp(
      r'[+-]?(?:(?:\d+\.?\d*)|(?:\.\d+))(?:[eE][+-]?\d+)?\s*,\s*'
      r'[+-]?(?:(?:\d+\.?\d*)|(?:\.\d+))(?:[eE][+-]?\d+)?',
    );
    final points = <Offset>[];
    var consumed = 0;
    for (final match in pairPattern.allMatches(source)) {
      final gap = source.substring(consumed, match.start);
      if (gap.trim().isNotEmpty || (points.isNotEmpty && gap.isEmpty)) {
        throw const CodeUnsupported('Separate coordinate pairs with spaces');
      }
      final coordinates = match.group(0)!.split(',');
      final x = double.tryParse(coordinates[0].trim());
      final y = double.tryParse(coordinates[1].trim());
      if (x == null || y == null) {
        throw const CodeUnsupported('Expected numeric coordinates');
      }
      points.add(Offset(x, y));
      consumed = match.end;
    }
    if (points.isEmpty || source.substring(consumed).trim().isNotEmpty) {
      throw const CodeUnsupported('Expected x,y coordinate pairs');
    }
    return points;
  }

  static Offset _point(Object? value) {
    if (value is Offset) return value;
    if (value is List && value.length == 2 && value.every((v) => v is num)) {
      return Offset((value[0] as num).toDouble(), (value[1] as num).toDouble());
    }
    throw const CodeUnsupported('Use Offset(x, y) for each point');
  }
}
