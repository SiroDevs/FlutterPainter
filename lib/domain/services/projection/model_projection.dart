// Dart imports:
import 'dart:ui';

// Project imports:
import '../../models/drawing/paint_layer.dart';
import '../../models/model3d/points.dart';
import '../../models/model3d/view_angle.dart';
import '../../models/shapes/shape.dart';
import 'part_transform.dart';
import 'shape_projection.dart';
import 'view_transform.dart';

/// A projected shape and the index of the drawn shape it came from.
typedef SourcedShape = ({int source, Shape shape});

typedef _Part = ({double depth, int order, List<SourcedShape> shapes});

typedef _Movement = PartTransform Function(String partId, Rect bounds);

/// Projects a 3D layer at [view] into flat shapes, far parts first.
/// Shapes of one group move together; inside a group your order is kept.
List<Shape> projectLayer(PaintLayer layer, ViewAngle view) => [
  for (final item in projectLayerSourced(layer, view)) item.shape,
];

/// Like [projectLayer], but each flat shape says which drawn shape made it.
List<SourcedShape> projectLayerSourced(PaintLayer layer, ViewAngle view) {
  final model = layer.model;
  if (model == null) {
    return [
      for (var index = 0; index < layer.shapes.length; index++)
        (source: index, shape: layer.shapes[index]),
    ];
  }
  return _project(
    layer,
    ViewTransform(view, model.pivot),
    (partId, bounds) =>
        PartTransform.forPart(partId, model, view, bounds: bounds),
    include: (partId) => !view.hidden.contains(partId),
  );
}

/// Every part except [workPartId], as seen when looking straight at that
/// part. The part itself needs no projection: it is drawn as it was drawn.
List<Shape> projectContext(PaintLayer layer, String workPartId) {
  final model = layer.model;
  if (model == null) return const [];
  const view = ViewAngle(name: 'work');
  final inverse = PartTransform.forPart(
    workPartId,
    model,
    view,
    posed: false,
  ).inverse();
  return [
    for (final item in _project(
      layer,
      ViewTransform(view, model.pivot),
      (partId, bounds) => PartTransform.forPart(
        partId,
        model,
        view,
        posed: false,
        bounds: bounds,
      ).then(inverse),
      include: (partId) => partId != workPartId,
    ))
      item.shape,
  ];
}

List<SourcedShape> _project(
  PaintLayer layer,
  ViewTransform camera,
  _Movement movement, {
  required bool Function(String partId) include,
}) {
  final groups = <String, List<int>>{};
  for (var index = 0; index < layer.shapes.length; index++) {
    if (!layer.shapes[index].visible) continue;
    final key = layer.shapes[index].groupId ?? 'shape-$index';
    groups.putIfAbsent(key, () => []).add(index);
  }
  final parts = <_Part>[];
  for (final entry in groups.entries) {
    if (!include(entry.key)) continue;
    final members = [for (final index in entry.value) layer.shapes[index]];
    final bounds = _boundsOf(members);
    final moved = movement(entry.key, bounds);
    final posed = camera.forPart(moved);
    parts.add((
      depth: moved
          .apply(
            Point3(
              bounds.center.dx,
              bounds.center.dy,
              _averageZ(members),
            ),
          )
          .dz,
      order: parts.length,
      shapes: [
        for (final index in entry.value)
          for (final flat in projectShape(layer.shapes[index], posed))
            (source: index, shape: flat),
      ],
    ));
  }
  parts.sort(_farFirst);
  return [for (final part in parts) ...part.shapes];
}

Rect _boundsOf(List<Shape> shapes) {
  var bounds = shapes.first.bounds;
  for (final shape in shapes.skip(1)) {
    bounds = bounds.expandToInclude(shape.bounds);
  }
  return bounds;
}

double _averageZ(List<Shape> shapes) =>
    shapes.fold(0.0, (total, shape) => total + shape.z) / shapes.length;

int _farFirst(_Part first, _Part second) {
  final byDepth = second.depth.compareTo(first.depth);
  return byDepth != 0 ? byDepth : first.order.compareTo(second.order);
}
