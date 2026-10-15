// Project imports:
import '../models/app_settings.dart';
import '../models/drawing.dart';
import '../models/export_file.dart';
import '../models/export_options.dart';
import '../models/paint_layer.dart';
import '../models/shape.dart';
import '../models/shape_kind.dart';
import 'code_format.dart';

/// Turns a [Drawing] into plain Dart that paints it on a `dart:ui` [Canvas].
/// The output depends on nothing but `dart:ui`, so it can be dropped straight
/// into a game.
///
/// With [CodeStyle.refactored] (the default) the result is several files: a
/// painter that composes the layers, one class per layer in `layers/` with one
/// function per shape, and a palette of the colours used. With
/// [CodeStyle.monolithic] it is one file: a single painter class with a method
/// per layer.
class DartExporter {
  DartExporter(this.drawing, {this.options = const ExportOptions()});

  final Drawing drawing;
  final ExportOptions options;

  static const _paintField = '''
  final Paint _paint = Paint()
    ..isAntiAlias = true
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;''';

  late final List<PaintLayer> _layers = [
    for (final l in drawing.layers)
      if (l.visible && l.shapes.isNotEmpty) l,
  ];
  late final List<String> _names = _uniqueNames();
  late final String _root = pascalCase(drawing.name);

  /// Colours the generated code uses, in order of first use.
  final Set<int> _usedColors = <int>{};

  /// The project folder name, e.g. `rider`.
  String get folderName => snakeCase(_root);

  String get _painterClass => '${_root}Painter';
  String get _paletteClass => '${_root}Palette';
  String get _painterFile => '${folderName}_painter.dart';
  String get _paletteFile => '${folderName}_palette.dart';
  String _layerClass(int i) => '$_root${_names[i]}Layer';
  String _layerFile(int i) => 'layers/${snakeCase(_names[i])}_layer.dart';

  List<ExportFile> generate() {
    _usedColors.clear();
    return options.style == CodeStyle.monolithic
        ? _monolithic()
        : _refactored();
  }

  // ---- the two layouts ----------------------------------------------------

  List<ExportFile> _refactored() {
    // Layers first: generating them is what finds out which colours are used.
    final layerFiles = [
      for (var i = 0; i < _layers.length; i++)
        ExportFile(path: _layerFile(i), content: _layerSource(i)),
    ];
    return [
      ExportFile(path: _painterFile, content: _painterSource()),
      if (_hasPalette)
        ExportFile(path: _paletteFile, content: _paletteSource()),
      ...layerFiles,
    ];
  }

  List<ExportFile> _monolithic() {
    final path = _layers.any(_needsPath);
    final body = [
      'class $_painterClass {',
      ..._sizeConstants(),
      '',
      _paintField,
      if (path) '  final Path _path = Path();',
      '',
      '  void paint(Canvas canvas) {',
      for (final n in _names) '    paint$n(canvas);',
      if (_layers.isEmpty) '    // Nothing to paint: every layer is empty or hidden.',
      '  }',
      for (var i = 0; i < _layers.length; i++) ...[
        '',
        ..._layerMethod('paint${_names[i]}', _layers[i]),
      ],
      '}',
      '',
    ];
    // The palette is known only now that every method has been generated.
    final lines = [
      ..._header(),
      "import 'dart:ui';",
      '',
      if (_hasPalette) ..._paletteLines(),
      ...body,
    ];
    return [ExportFile(path: _painterFile, content: lines.join('\n'))];
  }

  // ---- refactored files ---------------------------------------------------

  String _painterSource() => [
        ..._header(),
        "import 'dart:ui';",
        if (_layers.isNotEmpty) '',
        for (var i = 0; i < _layers.length; i++)
          "import '${_layerFile(i)}';",
        '',
        '/// Paints every layer of "${_label()}", bottom to top.',
        'class $_painterClass {',
        ..._sizeConstants(),
        if (_layers.isNotEmpty) '',
        for (var i = 0; i < _layers.length; i++)
          '  final ${_layerClass(i)} _${lowerFirst(_names[i])} = '
              '${_layerClass(i)}();',
        '',
        '  void paint(Canvas canvas) {',
        for (final n in _names) '    _${lowerFirst(n)}.paint(canvas);',
        if (_layers.isEmpty)
          '    // Nothing to paint: every layer is empty or hidden.',
        '  }',
        '}',
        '',
      ].join('\n');

  String _layerSource(int i) {
    final layer = _layers[i];
    final fns = _shapeFunctions(layer);
    final path = fns.any((f) => f.usesPath);
    final lines = [
      _generatedLine(),
      "import 'dart:ui';",
      // A layer with something to paint always uses at least one colour, so
      // the palette file exists whenever this import does.
      if (options.colorConstants && fns.isNotEmpty) ...[
        '',
        // The palette sits one folder up from `layers/`.
        "import '../$_paletteFile';",
      ],
      '',
      '/// Layer "${_oneLine(layer.name)}".',
      'class ${_layerClass(i)} {',
      _paintField,
      if (path) '  final Path _path = Path();',
      '',
      '  void paint(Canvas canvas) {',
      for (final f in fns) '    _draw${f.name}(canvas);',
      if (fns.isEmpty) '    // Nothing visible on this layer.',
      '  }',
      for (final f in fns) ...[
        '',
        if (f.doc != null) '  /// ${f.doc}',
        '  void _draw${f.name}(Canvas canvas) {',
        for (final line in f.body) '    $line',
        '  }',
      ],
      '}',
      '',
    ];
    return lines.join('\n');
  }

  bool get _hasPalette => options.colorConstants && _usedColors.isNotEmpty;

  String _paletteSource() => [
        _generatedLine(),
        "import 'dart:ui';",
        '',
        ..._paletteLines(),
      ].join('\n');

  List<String> _paletteLines() => [
        '/// Every colour used by "${_label()}".',
        'abstract final class $_paletteClass {',
        for (final c in _usedColors)
          '  static const Color ${_colorName(c)} = ${_colorLiteral(c)};',
        '}',
        '',
      ];

  // ---- shared pieces ------------------------------------------------------

  String _label() => _oneLine(drawing.name);

  String _oneLine(String s) => s.replaceAll(RegExp(r'[\r\n]+'), ' ');

  String _generatedLine() => '// GENERATED by Flutter Painter from "${_label()}".';

  List<String> _header() => [
        _generatedLine(),
        '// Design box: ${fmt(drawing.width)} x ${fmt(drawing.height)} units. '
            'Static artwork: apply lean, bob or steering around each paint call.',
      ];

  List<String> _sizeConstants() => [
        '  static const double width = ${fmt(drawing.width)};',
        '  static const double height = ${fmt(drawing.height)};',
      ];

  /// One layer as a method, with its shapes written out one after another.
  List<String> _layerMethod(String name, PaintLayer layer) {
    final body = <String>[
      for (final s in layer.shapes) ..._shape(s, comment: true),
    ];
    if (body.isEmpty) body.add('// Nothing visible on this layer.');
    return [
      '  /// Layer "${_oneLine(layer.name)}".',
      '  void $name(Canvas canvas) {',
      for (final line in body) '    $line',
      '  }',
    ];
  }

  /// One function per visible shape, named after the shape (or its kind).
  List<_ShapeFunction> _shapeFunctions(PaintLayer layer) {
    final taken = <String>{};
    final perKind = <ShapeKind, int>{};
    final out = <_ShapeFunction>[];
    for (final s in layer.shapes) {
      final body = _shape(s, comment: false);
      if (body.isEmpty) continue;
      // A name with no letters or digits (say, only symbols) cannot become an
      // identifier, so such shapes are named after their kind instead.
      final usable = RegExp(r'[A-Za-z0-9]').hasMatch(s.name);
      final base = usable
          ? pascalCase(s.name)
          : '${_kindLabel(s.kind)}'
              '${perKind.update(s.kind, (v) => v + 1, ifAbsent: () => 1)}';
      var name = base;
      for (var n = 2; !taken.add(name); n++) {
        name = '$base$n';
      }
      out.add(_ShapeFunction(
        name: name,
        doc: s.name.trim().isNotEmpty
            ? 'Shape "${_oneLine(s.name.trim())}".'
            : null,
        body: body,
        usesPath: _usesPath(s),
      ));
    }
    return out;
  }

  String _kindLabel(ShapeKind k) => switch (k) {
        ShapeKind.rect => 'Rect',
        ShapeKind.ellipse => 'Ellipse',
        ShapeKind.line => 'Line',
        ShapeKind.polygon => 'Polygon',
        ShapeKind.freehand => 'Freehand',
      };

  // ---- shapes -------------------------------------------------------------

  bool _needsPath(PaintLayer l) =>
      l.shapes.any((s) => _usesPath(s) && _shape(s, comment: false).isNotEmpty);

  bool _usesPath(Shape s) =>
      s.kind == ShapeKind.polygon ||
      s.kind == ShapeKind.freehand ||
      (s.kind == ShapeKind.line && s.points.length > 2);

  /// The statements that paint [s]; empty when it would draw nothing.
  List<String> _shape(Shape s, {required bool comment}) {
    if (!s.isClosed && s.stroke == null) return const [];
    if (s.isClosed && s.fill == null && s.stroke == null) return const [];
    final out = <String>[];
    if (comment && s.name.isNotEmpty) out.add('// ${_oneLine(s.name)}');
    if (_usesPath(s)) out.addAll(_pathLines(s));
    final call = _drawCall(s);
    if (s.isClosed && s.fill != null) {
      out
        ..addAll(_style('fill', s.fill!))
        ..add(call);
    }
    if (s.stroke != null) {
      out
        ..addAll(_style('stroke', s.stroke!, width: s.strokeWidth))
        ..add(call);
    }
    return out;
  }

  List<String> _style(String mode, int argb, {double? width}) => [
        '_paint',
        '  ..style = PaintingStyle.$mode',
        if (width != null) '  ..strokeWidth = ${fmt(width)}',
        '  ..color = ${_color(argb)};',
      ];

  String _drawCall(Shape s) {
    final b = s.bounds;
    final rect = 'const Rect.fromLTRB(${fmt(b.left)}, ${fmt(b.top)}, '
        '${fmt(b.right)}, ${fmt(b.bottom)})';
    switch (s.kind) {
      case ShapeKind.rect:
        final r = s.effectiveRadius;
        return r > 0
            ? 'canvas.drawRRect(RRect.fromRectXY($rect, ${fmt(r)}, ${fmt(r)}), _paint);'
            : 'canvas.drawRect($rect, _paint);';
      case ShapeKind.ellipse:
        return 'canvas.drawOval($rect, _paint);';
      case ShapeKind.line when s.points.length == 2:
        final a = s.points[0];
        final c = s.points[1];
        return 'canvas.drawLine(const Offset(${fmt(a.dx)}, ${fmt(a.dy)}), '
            'const Offset(${fmt(c.dx)}, ${fmt(c.dy)}), _paint);';
      default:
        return 'canvas.drawPath(_path, _paint);';
    }
  }

  List<String> _pathLines(Shape s) {
    final p = s.points;
    final segs = <String>[
      '..reset()',
      '..moveTo(${fmt(p.first.dx)}, ${fmt(p.first.dy)})',
    ];
    if (s.kind == ShapeKind.freehand && p.length >= 3) {
      for (var i = 1; i < p.length - 1; i++) {
        final mid = (p[i] + p[i + 1]) / 2;
        segs.add('..quadraticBezierTo(${fmt(p[i].dx)}, ${fmt(p[i].dy)}, '
            '${fmt(mid.dx)}, ${fmt(mid.dy)})');
      }
      segs.add('..lineTo(${fmt(p.last.dx)}, ${fmt(p.last.dy)})');
    } else {
      for (final q in p.skip(1)) {
        segs.add('..lineTo(${fmt(q.dx)}, ${fmt(q.dy)})');
      }
    }
    if (s.kind == ShapeKind.polygon) segs.add('..close()');
    return [
      '_path',
      for (var i = 0; i < segs.length; i++)
        '  ${segs[i]}${i == segs.length - 1 ? ';' : ''}',
    ];
  }

  // ---- colours ------------------------------------------------------------

  /// How the generated code refers to [argb]: a palette constant, or the
  /// literal in the chosen format. Either way the colour is recorded as used.
  String _color(int argb) {
    final v = argb & 0xFFFFFFFF;
    _usedColors.add(v);
    return options.colorConstants
        ? '$_paletteClass.${_colorName(v)}'
        : 'const ${_colorLiteral(v)}';
  }

  /// `colorC9222B`, or `colorB0C9222B` when the colour is not fully opaque.
  String _colorName(int argb) {
    final hex = argb.toRadixString(16).padLeft(8, '0').toUpperCase();
    return 'color${hex.startsWith('FF') ? hex.substring(2) : hex}';
  }

  String _colorLiteral(int argb) {
    final a = (argb >> 24) & 0xFF;
    final r = (argb >> 16) & 0xFF;
    final g = (argb >> 8) & 0xFF;
    final b = argb & 0xFF;
    return switch (options.colorFormat) {
      ColorFormat.hex => 'Color(${colorLiteral(argb)})',
      ColorFormat.argb => 'Color.fromARGB($a, $r, $g, $b)',
      ColorFormat.rgbo => 'Color.fromRGBO($r, $g, $b, ${fmtN(a / 255, 3)})',
    };
  }

  // ---- naming -------------------------------------------------------------

  List<String> _uniqueNames() {
    final seen = <String, int>{};
    return [
      for (final l in _layers)
        () {
          final base = pascalCase(l.name);
          final n = seen.update(base, (v) => v + 1, ifAbsent: () => 1);
          return n > 1 ? '$base$n' : base;
        }(),
    ];
  }
}

/// A shape's generated function: its name (without the `_draw` prefix), an
/// optional doc comment, and its statements.
class _ShapeFunction {
  const _ShapeFunction({
    required this.name,
    required this.doc,
    required this.body,
    required this.usesPath,
  });

  final String name;
  final String? doc;
  final List<String> body;
  final bool usesPath;
}
