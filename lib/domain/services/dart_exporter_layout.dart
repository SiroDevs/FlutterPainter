part of 'dart_exporter.dart';

mixin _DartExporterLayoutWriter on _DartExporterBase {
  bool get _hasPalette => options.colorConstants && _usedColors.isNotEmpty;

  List<ExportFile> _refactored() {
    final layerFiles = [
      for (var index = 0; index < _layers.length; index++)
        ExportFile(
          path: _layerFile(index),
          content: _layerSource(index),
        ),
    ];
    return [
      ExportFile(path: _painterFile, content: _painterSource()),
      if (_hasPalette)
        ExportFile(path: _paletteFile, content: _paletteSource()),
      ...layerFiles,
    ];
  }

  List<ExportFile> _monolithic() {
    final needsPath = _layers.any(_needsPath);
    final body = [
      'class $_painterClass {',
      ..._sizeConstants(),
      '',
      _paintField,
      if (needsPath) '  final Path _path = Path();',
      '',
      '  void paint(Canvas canvas) {',
      for (final name in _names) '    paint$name(canvas);',
      if (_layers.isEmpty)
        '    // Nothing to paint: every layer is empty or hidden.',
      '  }',
      for (var index = 0; index < _layers.length; index++) ...[
        '',
        ..._layerMethod('paint${_names[index]}', _layers[index]),
      ],
      '}',
      '',
    ];
    final lines = [
      ..._header(),
      "import 'dart:ui';",
      '',
      if (_hasPalette) ..._paletteLines(),
      ...body,
    ];
    return [ExportFile(path: _painterFile, content: lines.join('\n'))];
  }

  String _painterSource() => [
    ..._header(),
    "import 'dart:ui';",
    if (_layers.isNotEmpty) '',
    for (var index = 0; index < _layers.length; index++)
      "import '${_layerFile(index)}';",
    '',
    '/// Paints every layer of "${_label()}", bottom to top.',
    'class $_painterClass {',
    ..._sizeConstants(),
    if (_layers.isNotEmpty) '',
    for (var index = 0; index < _layers.length; index++)
      '  final ${_layerClass(index)} _${lowerFirst(_names[index])} = '
          '${_layerClass(index)}();',
    '',
    '  void paint(Canvas canvas) {',
    for (final name in _names) '    _${lowerFirst(name)}.paint(canvas);',
    if (_layers.isEmpty)
      '    // Nothing to paint: every layer is empty or hidden.',
    '  }',
    '}',
    '',
  ].join('\n');

  String _layerSource(int index) {
    final layer = _layers[index];
    final functions = _shapeFunctions(layer);
    final needsPath = functions.any((function) => function.usesPath);
    final lines = [
      _generatedLine(),
      "import 'dart:ui';",
      if (options.colorConstants && functions.isNotEmpty) ...[
        '',
        "import '../$_paletteFile';",
      ],
      '',
      '/// Layer "${_oneLine(layer.name)}".',
      'class ${_layerClass(index)} {',
      _paintField,
      if (needsPath) '  final Path _path = Path();',
      '',
      '  void paint(Canvas canvas) {',
      for (final function in functions)
        '    _draw${function.name}(canvas);',
      if (functions.isEmpty) '    // Nothing visible on this layer.',
      '  }',
      for (final function in functions) ...[
        '',
        if (function.doc != null) '  /// ${function.doc}',
        '  void _draw${function.name}(Canvas canvas) {',
        for (final line in function.body) '    $line',
        '  }',
      ],
      '}',
      '',
    ];
    return lines.join('\n');
  }

  String _paletteSource() => [
    _generatedLine(),
    "import 'dart:ui';",
    '',
    ..._paletteLines(),
  ].join('\n');

  List<String> _paletteLines() => [
    '/// Every colour used by "${_label()}".',
    'abstract final class $_paletteClass {',
    for (final color in _usedColors)
      '  static const Color ${_colorName(color)} = ${_colorLiteral(color)};',
    '}',
    '',
  ];

  List<String> _layerMethod(String name, PaintLayer layer) {
    _resetShader = _hasGradient(layer);
    final body = <String>[
      for (final shape in layer.shapes) ..._shape(shape, comment: true),
    ];
    if (body.isEmpty) body.add('// Nothing visible on this layer.');
    return [
      '  /// Layer "${_oneLine(layer.name)}".',
      '  void $name(Canvas canvas) {',
      for (final line in body) '    $line',
      '  }',
    ];
  }

  List<_ShapeFunction> _shapeFunctions(PaintLayer layer) {
    _resetShader = _hasGradient(layer);
    final taken = <String>{};
    final perKind = <ShapeKind, int>{};
    final functions = <_ShapeFunction>[];
    for (final shape in layer.shapes) {
      final body = _shape(shape, comment: false);
      if (body.isEmpty) continue;
      final usableName = RegExp(r'[A-Za-z0-9]').hasMatch(shape.name);
      final baseName = usableName
          ? pascalCase(shape.name)
          : '${_kindLabel(shape.kind)}'
                '${perKind.update(shape.kind, (value) => value + 1, ifAbsent: () => 1)}';
      var name = baseName;
      for (var suffix = 2; !taken.add(name); suffix++) {
        name = '$baseName$suffix';
      }
      functions.add(
        _ShapeFunction(
          name: name,
          doc: shape.name.trim().isNotEmpty
              ? 'Shape "${_oneLine(shape.name.trim())}".'
              : null,
          body: body,
          usesPath: _usesPath(shape),
        ),
      );
    }
    return functions;
  }

  String _kindLabel(ShapeKind kind) => switch (kind) {
    ShapeKind.rect => 'Rect',
    ShapeKind.ellipse => 'Ellipse',
    ShapeKind.line => 'Line',
    ShapeKind.polygon => 'Polygon',
    ShapeKind.freehand => 'Freehand',
  };
}
