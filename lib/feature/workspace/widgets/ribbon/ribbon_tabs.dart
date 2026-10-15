// Flutter imports:
import 'package:flutter/widgets.dart';

// Project imports:
import '../../../../domain/models/tool.dart';
import '../../../editor/logic/editor_ops.dart';
import '../../commands/workspace_commands.dart';
import 'ribbon_parts.dart';

/// The ribbon's tabs, left to right.
enum RibbonTab {
  file('File'),
  home('Home'),
  insert('Insert'),
  layer('Layer'),
  image('Image'),
  view('View');

  const RibbonTab(this.title);

  final String title;
}

/// The groups shown under [tab].
List<Widget> ribbonGroups(RibbonTab tab, WorkspaceCommands c) => switch (tab) {
  RibbonTab.file => _file(c),
  RibbonTab.home => _home(c),
  RibbonTab.insert => _insert(c),
  RibbonTab.layer => _layer(c),
  RibbonTab.image => _image(c),
  RibbonTab.view => _view(c),
};

List<Widget> _file(WorkspaceCommands c) => [
  RibbonGroup(
    label: 'New',
    children: [
      RibbonButton.large(c.newBlank, label: 'Blank canvas'),
      RibbonButton.large(c.newRider),
    ],
  ),
  RibbonGroup(
    label: 'Open',
    children: [RibbonButton.large(c.open, label: 'Open')],
  ),
  RibbonGroup(
    label: 'Save',
    children: [
      RibbonButton.large(c.save),
      RibbonStack(
        children: [
          RibbonButton.small(c.saveAs),
          RibbonButton.small(c.autoSave),
        ],
      ),
    ],
  ),
  RibbonGroup(
    label: 'Export',
    children: [RibbonButton.large(c.exportDart, label: 'Export Dart')],
  ),
  RibbonGroup(
    label: 'Project',
    children: [
      RibbonStack(
        children: [
          RibbonButton.small(c.rename),
          RibbonButton.small(c.canvasSize),
          RibbonButton.small(c.closeProject),
        ],
      ),
    ],
  ),
  RibbonGroup(label: 'App', children: [RibbonButton.large(c.settings)]),
];

List<Widget> _home(WorkspaceCommands c) => [
  RibbonGroup(
    label: 'History',
    children: [RibbonButton.large(c.undo), RibbonButton.large(c.redo)],
  ),
  RibbonGroup(
    label: 'Shape',
    children: [
      RibbonStack(
        children: [
          RibbonButton.small(c.duplicate),
          RibbonButton.small(c.delete),
          RibbonButton.small(c.closedPath),
        ],
      ),
    ],
  ),
  RibbonGroup(
    label: 'Arrange',
    children: [
      RibbonStack(
        children: [
          RibbonButton.small(c.bringForward),
          RibbonButton.small(c.sendBackward),
        ],
      ),
    ],
  ),
  RibbonGroup(
    label: 'Style',
    children: [
      RibbonStack(
        children: [
          RibbonButton.small(c.fillOn),
          RibbonButton.small(c.strokeOn),
        ],
      ),
    ],
  ),
];

List<Widget> _insert(WorkspaceCommands c) => [
  RibbonGroup(
    label: 'Shapes',
    children: [
      RibbonButton.large(c.tool(Tool.rect)),
      RibbonButton.large(c.tool(Tool.ellipse)),
      RibbonButton.large(c.tool(Tool.line)),
    ],
  ),
  RibbonGroup(
    label: 'Paths',
    children: [
      RibbonButton.large(c.tool(Tool.polygon), label: 'Polygon'),
      RibbonButton.large(c.tool(Tool.freehand)),
    ],
  ),
  RibbonGroup(
    label: 'Pictures',
    children: [
      RibbonButton.large(c.imageLoad, label: 'Picture'),
      RibbonButton.large(c.imageLoadNewLayer, label: 'Picture on new layer'),
    ],
  ),
  RibbonGroup(label: 'Layers', children: [RibbonButton.large(c.layerAdd)]),
];

List<Widget> _layer(WorkspaceCommands c) => [
  RibbonGroup(
    label: 'Layers',
    children: [
      RibbonButton.large(c.layerAdd),
      RibbonStack(
        children: [
          RibbonButton.small(c.layerDelete),
          RibbonButton.small(c.layerRename),
          RibbonButton.small(c.layerVisible),
        ],
      ),
    ],
  ),
  RibbonGroup(
    label: 'Order',
    children: [
      RibbonStack(
        children: [
          RibbonButton.small(c.layerUp),
          RibbonButton.small(c.layerDown),
        ],
      ),
    ],
  ),
];

List<Widget> _image(WorkspaceCommands c) {
  final img = c.state.layer.image;
  return [
    RibbonGroup(
      label: 'Picture',
      children: [
        RibbonButton.large(
          c.imageLoad,
          label: img == null ? 'Load' : 'Replace',
        ),
        RibbonButton.large(c.imageLoadNewLayer, label: 'On new layer'),
      ],
    ),
    RibbonGroup(
      label: 'Arrange',
      children: [
        RibbonStack(
          children: [
            RibbonButton.small(c.imageSelect),
            RibbonButton.small(c.imageTool),
            RibbonButton.small(c.imageFit),
          ],
        ),
      ],
    ),
    RibbonGroup(
      label: 'Adjust',
      children: [
        RibbonStack(
          children: [
            RibbonButton.small(c.imageVisible),
            RibbonSlider(
              label: 'Opacity ${((img?.opacity ?? 0.5) * 100).round()}%',
              value: img?.opacity ?? 0.5,
              min: 0.05,
              max: 1,
              onChanged: img == null ? null : c.setImageOpacity,
              onChangeEnd: c.commitChanges,
            ),
            RibbonSlider(
              label: 'Scale ${(img?.scaleX ?? 1).toStringAsFixed(3)}',
              value: img?.scaleX ?? 1,
              min: WorkspaceCommands.scaleMin(img?.scaleX ?? 1),
              max: WorkspaceCommands.scaleMax(img?.scaleX ?? 1),
              onChanged: img == null ? null : c.setImageScale,
              onChangeEnd: c.commitChanges,
            ),
          ],
        ),
      ],
    ),
    RibbonGroup(
      label: 'Remove',
      children: [RibbonButton.large(c.imageRemove, label: 'Remove')],
    ),
  ];
}

List<Widget> _view(WorkspaceCommands c) => [
  RibbonGroup(
    label: 'Zoom',
    children: [
      RibbonButton.large(c.zoomFit, label: 'Fit'),
      RibbonStack(
        children: [
          RibbonButton.small(c.zoomIn),
          RibbonButton.small(c.zoomOut),
          RibbonLabel('Zoom ${c.zoomLabel}'),
        ],
      ),
    ],
  ),
  RibbonGroup(
    label: 'Show',
    children: [
      RibbonStack(
        children: [RibbonButton.small(c.grid), RibbonButton.small(c.snap)],
      ),
    ],
  ),
  RibbonGroup(
    label: 'Canvas',
    children: [
      RibbonStack(
        children: [
          RibbonButton.small(c.background),
          RibbonButton.small(c.canvasSize),
        ],
      ),
    ],
  ),
  RibbonGroup(
    label: 'Appearance',
    children: [RibbonButton.large(c.theme, label: 'Light / dark')],
  ),
];
