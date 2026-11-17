// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import '../../../core/utils/copy_with_util.dart';
import '../model3d/model3d.dart';
import '../shapes/shape.dart';
import 'reference_image.dart';

/// A named group of shapes, optionally with one picture underneath them.
/// Layers draw bottom to top (the picture first, then the shapes) and export as
/// one method (or one class) each, which is how a bike and its rider stay
/// separate. The picture is not exported; it is only there to trace over.
class PaintLayer extends Equatable {
  const PaintLayer({
    required this.name,
    this.visible = true,
    this.shapes = const <Shape>[],
    this.image,
    this.model,
  });

  final String name;
  final bool visible;
  final List<Shape> shapes;

  /// The picture on this layer, or null.
  final ReferenceImage? image;

  /// The 3D setup when this is a 3D layer, or null for a flat layer.
  final Model3d? model;

  PaintLayer copyWith({
    String? name,
    bool? visible,
    List<Shape>? shapes,
    Object? image = unset,
    Object? model = unset,
  }) =>
      PaintLayer(
        name: name ?? this.name,
        visible: visible ?? this.visible,
        shapes: shapes ?? this.shapes,
        image: keep<ReferenceImage>(image, this.image),
        model: keep<Model3d>(model, this.model),
      );

  @override
  List<Object?> get props => [name, visible, shapes, image, model];
}
