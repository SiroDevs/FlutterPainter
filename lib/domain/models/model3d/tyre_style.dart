// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import '../../../core/utils/copy_with_util.dart';
import '../shapes/shape_gradient.dart';

/// Colours and line widths of a tyre. Colours are 0xAARRGGBB ints.
class TyreStyle extends Equatable {
  const TyreStyle({
    this.bodyFill = 0xFF000000,
    this.bodyStroke = 0xFF7F7F7F,
    this.bodyStrokeWidth = 0.25,
    this.treadFill,
    this.treadStroke = 0xFF7F7F7F,
    this.treadStrokeWidth = 1.0,
    this.sidewallFill = 0xFF404040,
    this.sidewallGradient,
    this.hubFill = 0xFF000000,
    this.hubGradient,
  });

  final int bodyFill;
  final int? bodyStroke;
  final double bodyStrokeWidth;
  final int? treadFill;
  final int? treadStroke;
  final double treadStrokeWidth;
  final int sidewallFill;
  final ShapeGradient? sidewallGradient;
  final int hubFill;
  final ShapeGradient? hubGradient;

  TyreStyle copyWith({
    int? bodyFill,
    Object? bodyStroke = unset,
    double? bodyStrokeWidth,
    Object? treadFill = unset,
    Object? treadStroke = unset,
    double? treadStrokeWidth,
    int? sidewallFill,
    Object? sidewallGradient = unset,
    int? hubFill,
    Object? hubGradient = unset,
  }) => TyreStyle(
    bodyFill: bodyFill ?? this.bodyFill,
    bodyStroke: keep<int>(bodyStroke, this.bodyStroke),
    bodyStrokeWidth: bodyStrokeWidth ?? this.bodyStrokeWidth,
    treadFill: keep<int>(treadFill, this.treadFill),
    treadStroke: keep<int>(treadStroke, this.treadStroke),
    treadStrokeWidth: treadStrokeWidth ?? this.treadStrokeWidth,
    sidewallFill: sidewallFill ?? this.sidewallFill,
    sidewallGradient: keep<ShapeGradient>(
      sidewallGradient,
      this.sidewallGradient,
    ),
    hubFill: hubFill ?? this.hubFill,
    hubGradient: keep<ShapeGradient>(hubGradient, this.hubGradient),
  );

  @override
  List<Object?> get props => [
    bodyFill,
    bodyStroke,
    bodyStrokeWidth,
    treadFill,
    treadStroke,
    treadStrokeWidth,
    sidewallFill,
    sidewallGradient,
    hubFill,
    hubGradient,
  ];
}
