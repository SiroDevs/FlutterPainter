// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'point3.dart';
import 'tyre_spec.dart';
import 'view_angle.dart';

/// The 3D setup of a layer. The layer's shapes are the object drawn from the
/// front or rear; this adds where it turns, its tyres and its named views.
class Model3d extends Equatable {
  const Model3d({
    this.pivot = const Point3(60, 166, 0),
    this.views = const [],
    this.tyres = const [],
  });

  final Point3 pivot;
  final List<ViewAngle> views;
  final List<TyreSpec> tyres;

  Model3d copyWith({
    Point3? pivot,
    List<ViewAngle>? views,
    List<TyreSpec>? tyres,
  }) => Model3d(
    pivot: pivot ?? this.pivot,
    views: views ?? this.views,
    tyres: tyres ?? this.tyres,
  );

  @override
  List<Object?> get props => [pivot, views, tyres];
}
