// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'point3.dart';
import 'tyre_style.dart';

/// A tyre described by numbers. Its axle runs left to right through [centre].
///
/// - radius / width: outer size in design units.
/// - treadCount: blocks around the tyre; treadCover is the share of each
///   slot a block fills, treadSpan the share of the flat top it spans.
/// - shoulder: how round the edges are, from 0 (square) to 1 (fully round).
/// - sidewallShare / hubShare: size of the sidewall disc and the hub disc.
/// - spin: rotation of the treads around the axle, in radians.
class TyreSpec extends Equatable {
  const TyreSpec({
    required this.name,
    required this.centre,
    required this.radius,
    required this.width,
    this.groupName,
    this.treadCount = 16,
    this.treadCover = 0.5,
    this.treadSpan = 0.8,
    this.treadHeight = 0,
    this.shoulder = 0.3,
    this.sidewallShare = 0.95,
    this.hubShare = 0.4,
    this.spin = 0,
    this.style = const TyreStyle(),
  });

  final String name;
  final Point3 centre;
  final double radius;
  final double width;
  final String? groupName;
  final int treadCount;
  final double treadCover;
  final double treadSpan;
  final double treadHeight;
  final double shoulder;
  final double sidewallShare;
  final double hubShare;
  final double spin;
  final TyreStyle style;

  /// The id that rigs and poses use for this tyre.
  String get partId => 'tyre-$name';

  TyreSpec copyWith({
    String? name,
    Point3? centre,
    double? radius,
    double? width,
    String? groupName,
    int? treadCount,
    double? treadCover,
    double? treadSpan,
    double? treadHeight,
    double? shoulder,
    double? sidewallShare,
    double? hubShare,
    double? spin,
    TyreStyle? style,
  }) => TyreSpec(
    name: name ?? this.name,
    centre: centre ?? this.centre,
    radius: radius ?? this.radius,
    width: width ?? this.width,
    groupName: groupName ?? this.groupName,
    treadCount: treadCount ?? this.treadCount,
    treadCover: treadCover ?? this.treadCover,
    treadSpan: treadSpan ?? this.treadSpan,
    treadHeight: treadHeight ?? this.treadHeight,
    shoulder: shoulder ?? this.shoulder,
    sidewallShare: sidewallShare ?? this.sidewallShare,
    hubShare: hubShare ?? this.hubShare,
    spin: spin ?? this.spin,
    style: style ?? this.style,
  );

  @override
  List<Object?> get props => [
    name,
    centre,
    radius,
    width,
    groupName,
    treadCount,
    treadCover,
    treadSpan,
    treadHeight,
    shoulder,
    sidewallShare,
    hubShare,
    spin,
    style,
  ];
}
