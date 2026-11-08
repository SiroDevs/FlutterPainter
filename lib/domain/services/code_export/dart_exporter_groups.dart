part of 'dart_exporter.dart';

mixin _DartExporterGroupWriter on _DartExporterBase {
  late final List<_ExportGroup> _groups = _buildGroups();

  List<_ExportGroup> get _paintedGroups => [
    for (final group in _groups)
      if (_groupFunctions(group).isNotEmpty) group,
  ];

  List<_ExportGroup> _buildGroups() {
    final groups = <_ExportGroup>[];
    final usedNames = {
      _painterClass,
      for (var index = 0; index < _layers.length; index++) _layerClass(index),
    };
    var defaultNumber = 0;
    for (var layerIndex = 0; layerIndex < _layers.length; layerIndex++) {
      final seenIds = <String>{};
      for (final shape in _layers[layerIndex].shapes) {
        final id = shape.groupId;
        if (id == null || !seenIds.add(id)) continue;
        defaultNumber++;
        final storedName = shape.groupName?.trim();
        final name = storedName == null || storedName.isEmpty
            ? 'Group $defaultNumber'
            : storedName;
        final baseName = pascalCase(name);
        var className = baseName;
        for (var suffix = 2; !usedNames.add(className); suffix++) {
          className = '$baseName$suffix';
        }
        groups.add(
          _ExportGroup(
            layerIndex: layerIndex,
            id: id,
            name: name,
            className: className,
          ),
        );
      }
    }
    return groups;
  }

  List<_ExportGroup> _groupsInLayer(int layerIndex) => [
    for (final group in _groups)
      if (group.layerIndex == layerIndex) group,
  ];

  _ExportGroup? _groupForShape(int layerIndex, Shape shape) {
    final groupId = shape.groupId;
    if (groupId == null) return null;
    for (final group in _groups) {
      if (group.layerIndex == layerIndex && group.id == groupId) return group;
    }
    return null;
  }

  String _groupField(_ExportGroup group) => '_${lowerFirst(group.className)}';

  String _groupFile(_ExportGroup group) =>
      'groups/${snakeCase(group.className)}.dart';

  List<String> _layerMethod(String name, PaintLayer layer, int layerIndex) {
    _resetShader = _hasGradient(layer);
    final functions = {
      for (final function in _shapeFunctions(layer)) function.index: function,
    };
    final body = <String>[];
    final paintedGroups = <String>{};
    for (var index = 0; index < layer.shapes.length; index++) {
      final function = functions[index];
      if (function == null) continue;
      final group = _groupForShape(layerIndex, layer.shapes[index]);
      if (group == null) {
        body.addAll(_shape(layer.shapes[index], comment: true));
      } else if (options.groupMethodsPublic) {
        body.add('${_groupField(group)}.paint${function.name}(canvas);');
      } else if (paintedGroups.add(group.id)) {
        body.add('${_groupField(group)}.paint(canvas);');
      }
    }
    if (body.isEmpty) body.add('// Nothing visible on this layer.');
    return [
      '  /// Layer "${_oneLine(layer.name)}".',
      '  void $name(Canvas canvas) {',
      for (final line in body) '    $line',
      '  }',
    ];
  }

  List<_ShapeFunction> _groupFunctions(_ExportGroup group) {
    final layer = _layers[group.layerIndex];
    return [
      for (final function in _shapeFunctions(layer))
        if (layer.shapes[function.index].groupId == group.id) function,
    ];
  }

  List<String> _groupClassLines(
    _ExportGroup group,
    List<_ShapeFunction> functions,
  ) {
    final layer = _layers[group.layerIndex];
    _resetShader = _hasGradient(layer);
    return [
      '/// Group "${_oneLine(group.name)}".',
      'class ${group.className} {',
      _paintField,
      if (functions.any((function) => function.usesPath))
        '  final Path _path = Path();',
      if (options.groupMethodsPublic) ...[
        for (final function in functions) ...[
          '',
          if (function.doc != null) '  /// ${function.doc}',
          '  void paint${function.name}(Canvas canvas) {',
          for (final line in function.body) '    $line',
          '  }',
        ],
      ] else ...[
        for (final function in functions) ...[
          '',
          if (function.doc != null) '  /// ${function.doc}',
          '  void _draw${function.name}(Canvas canvas) {',
          for (final line in function.body) '    $line',
          '  }',
        ],
        '',
        '  /// Paints every shape in this group.',
        '  void paint(Canvas canvas) {',
        for (final function in functions) '    _draw${function.name}(canvas);',
        '  }',
      ],
      '}',
      '',
    ];
  }

  String _groupSource(_ExportGroup group) {
    final functions = _groupFunctions(group);
    return [
      _generatedLine(),
      "import 'dart:ui';",
      if (options.colorConstants && functions.isNotEmpty) ...[
        '',
        "import '../$_painterFile';",
      ],
      '',
      ..._groupClassLines(group, functions),
    ].join('\n');
  }
}
