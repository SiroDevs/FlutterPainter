// Package imports:
import 'package:equatable/equatable.dart';

enum SectionKind { box, ellipse, polygon }

/// The side of a shape the cross-section is measured along.
enum SectionAxis { width, height }

/// The form of a shape's thickness: a slab, an ellipse or a regular polygon.
/// Used by 3D layers only; flat drawing ignores it.
class SectionProfile extends Equatable {
  const SectionProfile({
    this.kind = SectionKind.box,
    this.sides = 6,
    this.axis = SectionAxis.width,
  });

  static const SectionProfile box = SectionProfile();
  static const int minSides = 3;
  static const int maxSides = 12;

  final SectionKind kind;
  final int sides;
  final SectionAxis axis;

  bool get isBox => kind == SectionKind.box;

  SectionProfile copyWith({SectionKind? kind, int? sides, SectionAxis? axis}) =>
      SectionProfile(
        kind: kind ?? this.kind,
        sides: sides ?? this.sides,
        axis: axis ?? this.axis,
      );

  @override
  List<Object?> get props => [kind, sides, axis];
}
