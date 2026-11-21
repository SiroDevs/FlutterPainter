// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../../../domain/models/model3d/part_rig.dart';
import '../../../../domain/models/model3d/points.dart';
import '../../../../domain/models/shapes/shape.dart';
import '../../../../domain/models/shapes/shape_kind.dart';
import '../../../../domain/services/geometry/hinge_edges.dart';
import '../../bloc/editor_bloc.dart';
import 'draw_logic.dart';
import 'editor_ops.dart';

/// Building an object from faces, the way a box is folded from a net.
abstract class FaceLogic {
  FaceLogic._();

  static const double _sideFold = math.pi / 2;

  /// Adds a square face next to an edge of a part, hinged on that edge and
  /// folded away from the viewer, like a side of a box. The new face is a
  /// part of its own, so it can be folded, bent and worked on.
  static EditorState addOnEdge(
    EditorState s, {
    required String partId,
    required int edgeIndex,
    required String name,
  }) {
    final model = s.layer.model;
    if (model == null) return s;
    final parent = _hingeShape(s, partId);
    if (parent == null) return s;
    final edges = hingeEdgesOf(parent);
    if (edgeIndex < 0 || edgeIndex >= edges.length) return s;
    final edge = edges[edgeIndex];
    final side = (edge.end - edge.start).distance;
    final out = edge.outward * side;
    final corners = [edge.start, edge.end, edge.end + out, edge.start + out];
    final id = _freshId(s);
    final face = _faceShape(s, corners, edge.outward).copyWith(
      name: name,
      groupId: id,
      groupName: name,
      z: parent.z,
    );
    final middle = (edge.start + edge.end) / 2;
    final rig = PartRig(
      pivot: Point3(middle.dx, middle.dy, parent.z),
      parentId: partId,
      axisAngle: math.atan2(edge.outward.dx, -edge.outward.dy),
      fold: _sideFold,
    );
    final shapes = [...s.layer.shapes, face];
    final layer = s.layer.copyWith(
      shapes: shapes,
      model: model.copyWith(rigs: {...model.rigs, id: rig}),
    );
    return s
        .withLayers(replacedAt(s.drawing.layers, s.layerIndex, layer))
        .copyWith(workPart: null)
        .selectIndices([shapes.length - 1])
        .commit();
  }

  static Shape? _hingeShape(EditorState s, String partId) {
    for (final shape in s.layer.shapes) {
      if (shape.groupId == partId && hingeEdgesOf(shape).isNotEmpty) {
        return shape;
      }
    }
    return null;
  }

  static Shape _faceShape(EditorState s, List<Offset> corners, Offset outward) {
    final straight = outward.dx.abs() < 1e-9 || outward.dy.abs() < 1e-9;
    return straight
        ? DrawLogic.newShape(s, ShapeKind.rect, [corners[0], corners[2]])
        : DrawLogic.newShape(s, ShapeKind.polygon, corners);
  }

  static String _freshId(EditorState s) {
    final taken = {for (final shape in s.layer.shapes) shape.groupId};
    var number = taken.length + 1;
    while (taken.contains('part-$number')) {
      number++;
    }
    return 'part-$number';
  }
}
