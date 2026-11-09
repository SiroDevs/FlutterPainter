// Dart imports:
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../domain/models/editor/app_settings.dart';
import '../settings/cubit/settings_cubit.dart';
import 'widgets/canvas/canvas_view.dart';
import 'widgets/panels/image_panel.dart';
import 'widgets/panels/layers_panel.dart';
import 'widgets/panels/panel_resize_handle.dart';
import 'widgets/panels/properties_panel.dart';
import 'widgets/toolbar/color_bar.dart';
import 'widgets/toolbar/status_bar.dart';
import 'widgets/toolbar/tool_palette.dart';

/// One project's editor with draggable tool, inspector and color panels.
class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key, required this.canvasFocus});

  final FocusNode canvasFocus;

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  double _toolWidth = 52;
  double _inspectorWidth = 340;
  double? _propertiesWidth;
  double _layersFraction = 0.50;
  double _colorBarHeight = 148;

  @override
  Widget build(BuildContext context) {
    final minimal = context.select<SettingsCubit, bool>(
      (c) => c.state.interfaceMode == InterfaceMode.minimal,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final inspectorMaximum = math.max(
          220.0,
          math.min(640.0, constraints.maxWidth - _toolWidth - 270),
        );
        final inspectorWidth = minimal
            ? 0.0
            : _inspectorWidth.clamp(220.0, inspectorMaximum).toDouble();
        final toolMaximum = math.max(
          52.0,
          math.min(180.0, constraints.maxWidth - inspectorWidth - 250),
        );
        final toolWidth = _toolWidth.clamp(52.0, toolMaximum).toDouble();
        final propertiesMaximum = math.max(220.0, constraints.maxWidth - 520);
        final propertiesWidth = (_propertiesWidth ?? constraints.maxWidth / 2)
            .clamp(220.0, propertiesMaximum)
            .toDouble();
        return Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  ToolPalette(width: toolWidth),
                  PanelResizeHandle(
                    axis: Axis.horizontal,
                    onDragUpdate: (details) => setState(() {
                      _toolWidth = (toolWidth + details.delta.dx)
                          .clamp(52.0, toolMaximum)
                          .toDouble();
                    }),
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(child: CanvasView(focus: widget.canvasFocus)),
                  if (!minimal) ...[
                    const VerticalDivider(width: 1),
                    PanelResizeHandle(
                      axis: Axis.horizontal,
                      onDragUpdate: (details) => setState(() {
                        _inspectorWidth = (_inspectorWidth - details.delta.dx)
                            .clamp(220.0, inspectorMaximum)
                            .toDouble();
                      }),
                    ),
                    SizedBox(width: inspectorWidth, child: _inspector(context)),
                  ],
                ],
              ),
            ),
            const Divider(height: 1),
            PanelResizeHandle(
              axis: Axis.vertical,
              onDragUpdate: (details) => setState(() {
                _colorBarHeight = (_colorBarHeight + details.delta.dy)
                    .clamp(128.0, 280.0)
                    .toDouble();
              }),
            ),
            SizedBox(
              height: _colorBarHeight,
              child: Row(
                children: [
                  Expanded(child: ColorBar(height: _colorBarHeight)),
                  PanelResizeHandle(
                    axis: Axis.horizontal,
                    onDragUpdate: (details) => setState(() {
                      _propertiesWidth = (propertiesWidth - details.delta.dx)
                          .clamp(220.0, propertiesMaximum)
                          .toDouble();
                    }),
                  ),
                  SizedBox(
                    width: propertiesWidth,
                    child: const PropertiesPanel(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            const StatusBar(),
          ],
        );
      },
    );
  }

  Widget _inspector(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final available = math.max(0.0, constraints.maxHeight - 8);
      final minLayers = math.min(120.0, available * 0.28);
      final minImage = math.min(90.0, available * 0.18);
      final maxLayers = math.max(minLayers, available - minImage);
      final layerHeight = (_layersFraction * available)
          .clamp(minLayers, maxLayers)
          .toDouble();
      final layerFlex = available > 0
          ? (layerHeight / available * 1000).round().clamp(1, 999).toInt()
          : 1;
      final imageFlex = 1000 - layerFlex;
      return Column(
        children: [
          Expanded(flex: layerFlex, child: const LayersPanel()),
          PanelResizeHandle(
            axis: Axis.vertical,
            onDragUpdate: (details) => setState(() {
              if (available > 0) {
                _layersFraction =
                    (layerHeight + details.delta.dy)
                        .clamp(minLayers, maxLayers)
                        .toDouble() /
                    available;
              }
            }),
          ),
          Flexible(flex: imageFlex, child: const ImagePanel()),
        ],
      );
    },
  );
}
