// Project imports:
import '../../models/drawing/paint_layer.dart';
import '../../models/model3d/view_angle.dart';
import '../../models/shapes/shape.dart';
import 'part_transform.dart';
import 'shape_projection.dart';
import 'tyre_projection.dart';
import 'view_transform.dart';

typedef _Part = ({double depth, int order, List<Shape> shapes});

/// Projects a 3D layer at [view] into flat shapes, far parts first.
/// Shapes of one group move together; inside a group your order is kept.
List<Shape> projectLayer(PaintLayer layer, ViewAngle view) {
  final model = layer.model;
  if (model == null) return layer.shapes;
  final transform = ViewTransform(view, model.pivot);
  final parts = <_Part>[];
  final groups = <String, List<Shape>>{};
  for (var index = 0; index < layer.shapes.length; index++) {
    final shape = layer.shapes[index];
    if (!shape.visible) continue;
    groups.putIfAbsent(shape.groupId ?? 'shape-$index', () => []).add(shape);
  }
  for (final entry in groups.entries) {
    if (view.hidden.contains(entry.key)) continue;
    final posed = transform.forPart(
      PartTransform.forPart(entry.key, model, view),
    );
    parts.add((
      depth: _averageDepth(entry.value),
      order: parts.length,
      shapes: [
        for (final member in entry.value) ...projectShape(member, posed),
      ],
    ));
  }
  for (final tyre in model.tyres) {
    if (view.hidden.contains(tyre.partId)) continue;
    parts.add((
      depth: tyre.centre.dz,
      order: parts.length,
      shapes: TyreProjection(
        tyre,
        transform.forPart(PartTransform.forPart(tyre.partId, model, view)),
      ).build(),
    ));
  }
  parts.sort(_farFirst);
  return [for (final part in parts) ...part.shapes];
}

double _averageDepth(List<Shape> shapes) =>
    shapes.fold(0.0, (total, shape) => total + shape.depth) / shapes.length;

int _farFirst(_Part first, _Part second) {
  final byDepth = second.depth.compareTo(first.depth);
  return byDepth != 0 ? byDepth : first.order.compareTo(second.order);
}
