// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../models/model3d/section_profile.dart';

/// How far a section reaches toward and away from the viewer, from -1 to 1.
typedef SectionRange = ({double near, double far});

const double _edgeTolerance = 1e-9;

/// A cross-section that answers how deep it is at any point across it.
class SectionShape {
  SectionShape(this.profile) : _corners = _cornersOf(profile);

  final SectionProfile profile;
  final List<Offset> _corners;

  /// The reach at [across], where -1 and 1 are the two ends of the section.
  SectionRange rangeAt(double across) {
    final position = across.clamp(-1.0, 1.0).toDouble();
    return switch (profile.kind) {
      SectionKind.box => (near: -1.0, far: 1.0),
      SectionKind.ellipse => _ellipseRange(position),
      SectionKind.polygon => _polygonRange(position),
    };
  }

  SectionRange _ellipseRange(double position) {
    final reach = math.sqrt(math.max(0.0, 1 - position * position));
    return (near: -reach, far: reach);
  }

  SectionRange _polygonRange(double position) {
    var near = double.infinity;
    var far = double.negativeInfinity;
    for (var index = 0; index < _corners.length; index++) {
      final start = _corners[index];
      final end = _corners[(index + 1) % _corners.length];
      if (position < math.min(start.dx, end.dx) - _edgeTolerance ||
          position > math.max(start.dx, end.dx) + _edgeTolerance) {
        continue;
      }
      final span = end.dx - start.dx;
      final upright = span.abs() < _edgeTolerance;
      final fraction = upright
          ? 0.0
          : ((position - start.dx) / span).clamp(0.0, 1.0).toDouble();
      final depth = start.dy + (end.dy - start.dy) * fraction;
      near = math.min(near, upright ? math.min(start.dy, end.dy) : depth);
      far = math.max(far, upright ? math.max(start.dy, end.dy) : depth);
    }
    return near > far ? (near: 0.0, far: 0.0) : (near: near, far: far);
  }

  /// Regular polygon with a flat side, stretched to fill the -1..1 square.
  static List<Offset> _cornersOf(SectionProfile profile) {
    if (profile.kind != SectionKind.polygon) return const [];
    final count = profile.sides.clamp(
      SectionProfile.minSides,
      SectionProfile.maxSides,
    );
    final raw = [
      for (var corner = 0; corner < count; corner++)
        Offset(
          math.cos(-math.pi / 2 + math.pi / count + 2 * math.pi * corner / count),
          math.sin(-math.pi / 2 + math.pi / count + 2 * math.pi * corner / count),
        ),
    ];
    final stretchAcross = 1 / raw.map((corner) => corner.dx.abs()).reduce(math.max);
    final stretchDepth = 1 / raw.map((corner) => corner.dy.abs()).reduce(math.max);
    return [
      for (final corner in raw)
        Offset(corner.dx * stretchAcross, corner.dy * stretchDepth),
    ];
  }
}
