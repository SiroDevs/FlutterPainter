// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'shape.dart';

/// A named group of shapes. Layers draw bottom to top and export as one method
/// (or one class) each, which is how a bike and its rider stay separate.
class PaintLayer extends Equatable {
  const PaintLayer({
    required this.name,
    this.visible = true,
    this.shapes = const <Shape>[],
  });

  final String name;
  final bool visible;
  final List<Shape> shapes;

  PaintLayer copyWith({
    String? name,
    bool? visible,
    List<Shape>? shapes,
  }) =>
      PaintLayer(
        name: name ?? this.name,
        visible: visible ?? this.visible,
        shapes: shapes ?? this.shapes,
      );

  @override
  List<Object?> get props => [name, visible, shapes];
}
