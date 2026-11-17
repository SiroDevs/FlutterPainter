// Project imports:
import '../../models/drawing/drawing.dart';
import '../../models/drawing/paint_layer.dart';
import '../../models/model3d/view_angle.dart';
import 'model_projection.dart';

/// Swaps every 3D layer for one flat layer per view, ready for export.
Drawing bakeModelLayers(Drawing drawing) {
  if (!drawing.layers.any((layer) => layer.model != null)) return drawing;
  return drawing.copyWith(
    layers: [for (final layer in drawing.layers) ..._bakedLayers(layer)],
  );
}

List<PaintLayer> _bakedLayers(PaintLayer layer) {
  final model = layer.model;
  if (model == null) return [layer];
  final views = model.views.isEmpty
      ? [ViewAngle(name: layer.name)]
      : model.views;
  return [
    for (final view in views)
      PaintLayer(
        name: view.name,
        visible: layer.visible,
        shapes: projectLayer(layer, view),
      ),
  ];
}
