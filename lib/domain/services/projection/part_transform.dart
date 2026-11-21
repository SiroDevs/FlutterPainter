// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../models/model3d/model3d.dart';
import '../../models/model3d/part_pose.dart';
import '../../models/model3d/part_rig.dart';
import '../../models/model3d/points.dart';
import '../../models/model3d/view_angle.dart';
import 'matrix3.dart';

typedef _Step = ({Point3 pivot, Matrix3 turn});

/// Moves one part before the camera sees it: it bends, then folds and poses
/// around its own joint, then around every joint it hangs from.
class PartTransform {
  const PartTransform._(this._steps, this._bend);

  static const PartTransform none = PartTransform._([], null);

  static const int _maxChain = 8;

  final List<_Step> _steps;
  final _Bend? _bend;

  /// Whether the part's shapes need extra points to curl smoothly.
  bool get bends => _bend != null;

  /// The movement of [partId] in [view]. [posed] false leaves out the view's
  /// poses, keeping only the folds that build the object. [bounds] is the
  /// part's drawn area, which sets how far a bend reaches.
  factory PartTransform.forPart(
    String partId,
    Model3d model,
    ViewAngle view, {
    bool posed = true,
    Rect? bounds,
  }) {
    final steps = <_Step>[];
    final visited = <String>{};
    _Bend? bend;
    String? current = partId;
    while (current != null &&
        visited.length < _maxChain &&
        visited.add(current)) {
      final rig = model.rigs[current];
      if (rig == null) break;
      if (current == partId && bounds != null) bend = _Bend.of(rig, bounds);
      final turn = _joint(rig, posed ? view.poses[current] : null);
      if (turn != null) steps.add((pivot: rig.pivot, turn: turn));
      current = rig.parentId;
    }
    return steps.isEmpty && bend == null ? none : PartTransform._(steps, bend);
  }

  static Matrix3? _joint(PartRig rig, PartPose? pose) {
    final activePose = pose == null || pose.isRest ? null : pose;
    if (rig.fold == 0 && activePose == null) return null;
    var turn = rig.fold == 0
        ? Matrix3.identity
        : Matrix3.aroundAxis(rig.axis, -rig.fold);
    if (activePose != null) {
      turn =
          Matrix3.pose(
            yaw: activePose.yaw,
            pitch: activePose.pitch,
            roll: activePose.roll,
          ) *
          turn;
    }
    return turn;
  }

  /// Moves a point of the part.
  Point3 apply(Point3 point) {
    var moved = _bend?.apply(point) ?? point;
    for (final step in _steps) {
      moved = step.pivot + step.turn.apply(moved - step.pivot);
    }
    return moved;
  }

  /// Turns a direction, such as the way a surface faces.
  Point3 turn(Point3 direction) {
    var turned = direction;
    for (final step in _steps) {
      turned = step.turn.apply(turned);
    }
    return turned;
  }

  /// The movement that undoes this one, ignoring any bend. Looking through it
  /// shows the object from the part's own point of view.
  PartTransform inverse() => PartTransform._([
    for (final step in _steps.reversed)
      (pivot: step.pivot, turn: step.turn.transposed),
  ], null);

  /// This movement, then [next].
  PartTransform then(PartTransform next) =>
      PartTransform._([..._steps, ...next._steps], _bend);
}

/// Curls a part around its fold line.
class _Bend {
  const _Bend({required this.pivot, required this.across, required this.curl});

  final Point3 pivot;
  final Point3 across;
  final double curl;

  static _Bend? of(PartRig rig, Rect bounds) {
    if (rig.bend == 0) return null;
    final across = Point3(-rig.axis.dy, rig.axis.dx, 0);
    var extent = 0.0;
    for (final corner in [
      bounds.topLeft,
      bounds.topRight,
      bounds.bottomLeft,
      bounds.bottomRight,
    ]) {
      final offset = Point3(corner.dx - rig.pivot.dx, corner.dy - rig.pivot.dy, 0);
      extent = math.max(extent, offset.dot(across).abs());
    }
    if (extent < 1e-6) return null;
    return _Bend(pivot: rig.pivot, across: across, curl: rig.bend / extent);
  }

  Point3 apply(Point3 point) {
    final distance = (point - pivot).dot(across);
    final angle = curl * distance;
    if (angle.abs() < 1e-9) return point;
    final radius = 1 / curl;
    return point +
        across * (radius * math.sin(angle) - distance) +
        Point3(0, 0, radius * (1 - math.cos(angle)));
  }
}
