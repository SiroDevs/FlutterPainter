part of 'dart_exporter.dart';

mixin _DartExporterLayoutWriter on _DartExporterBase {
  bool get _hasPalette => options.colorConstants && _usedColors.isNotEmpty;

  List<ExportFile> _refactored() {
    final layerFiles = [
      for (var index = 0; index < _layers.length; index++)
        ExportFile(path: _layerFile(index), content: _layerSource(index)),
    ];
    final groupFiles = [
      for (final group in _paintedGroups)
        ExportFile(path: _groupFile(group), content: _groupSource(group)),
    ];
    return [
      ExportFile(path: _painterFile, content: _painterSource()),
      ...groupFiles,
      ...layerFiles,
    ];
  }

  List<ExportFile> _monolithic() {
    final needsPath = [
      for (var index = 0; index < _layers.length; index++)
        ..._shapeFunctions(_layers[index]).where((function) {
          final shape = _layers[index].shapes[function.index];
          return _groupForShape(index, shape) == null && function.usesPath;
        }),
    ].isNotEmpty;
    final groupClasses = [
      for (final group in _paintedGroups)
        ..._groupClassLines(group, _groupFunctions(group)),
    ];
    final body = [
      'class $_painterClass {',
      ..._sizeConstants(),
      if (_hasPalette) '',
      if (_hasPalette) ..._paletteFields(),
      '',
      _paintField,
      for (final group in _paintedGroups)
        '  final ${group.className} ${_groupField(group)} = ${group.className}();',
      if (needsPath) '  final Path _path = Path();',
      '',
      '  void paint(Canvas canvas) {',
      for (final name in _names) '    paint$name(canvas);',
      if (_layers.isEmpty)
        '    // Nothing to paint: every layer is empty or hidden.',
      '  }',
      for (var index = 0; index < _layers.length; index++) ...[
        '',
        ..._layerMethod('paint${_names[index]}', _layers[index], index),
      ],
      '}',
      '',
      ...groupClasses,
    ];
    final lines = [..._header(), "import 'dart:ui';", '', ...body];
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
    if (_hasPalette) '',
    if (_hasPalette) ..._paletteFields(),
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
    final localFunctions = [
      for (final function in functions)
        if (_groupForShape(index, layer.shapes[function.index]) == null)
          function,
    ];
    final groups = [
      for (final group in _groupsInLayer(index))
        if (functions.any(
          (function) => layer.shapes[function.index].groupId == group.id,
        ))
          group,
    ];
    final needsPath = localFunctions.any((function) => function.usesPath);
    final lines = [
      _generatedLine(),
      "import 'dart:ui';",
      if ((options.colorConstants && localFunctions.isNotEmpty) ||
          groups.isNotEmpty) ...[
        '',
      ],
      if (options.colorConstants && localFunctions.isNotEmpty)
        "import '../$_painterFile';",
      for (final group in groups) "import '../${_groupFile(group)}';",
      '',
      '/// Layer "${_oneLine(layer.name)}".',
      'class ${_layerClass(index)} {',
      if (localFunctions.isNotEmpty) _paintField,
      for (final group in groups)
        '  final ${group.className} ${_groupField(group)} = ${group.className}();',
      if (needsPath) '  final Path _path = Path();',
      '',
      '  void paint(Canvas canvas) {',
      ..._layerPaintCalls(index, functions),
      if (functions.isEmpty) '    // Nothing visible on this layer.',
      '  }',
      for (final function in localFunctions) ...[
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

  List<String> _paletteFields() => [
    for (final color in _usedColors)
      '  static const Color ${_colorName(color)} = ${_colorLiteral(color)};',
  ];

  List<String> _layerPaintCalls(
    int layerIndex,
    List<_ShapeFunction> functions,
  ) {
    final layer = _layers[layerIndex];
    final paintedGroups = <String>{};
    final calls = <String>[];
    for (final function in functions) {
      final group = _groupForShape(layerIndex, layer.shapes[function.index]);
      if (group == null) {
        calls.add('    _draw${function.name}(canvas);');
      } else if (options.groupMethodsPublic) {
        calls.add('    ${_groupField(group)}.paint${function.name}(canvas);');
      } else if (paintedGroups.add(group.id)) {
        calls.add('    ${_groupField(group)}.paint(canvas);');
      }
    }
    return calls;
  }

  List<_ShapeFunction> _shapeFunctions(PaintLayer layer) {
    _resetShader = _hasGradient(layer);
    final taken = <String>{};
    final perKind = <ShapeKind, int>{};
    final functions = <_ShapeFunction>[];
    for (var shapeIndex = 0; shapeIndex < layer.shapes.length; shapeIndex++) {
      final shape = layer.shapes[shapeIndex];
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
          index: shapeIndex,
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
