// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import '../../common/constants/app_constants.dart';
import 'paint_layer.dart';

/// The whole document: a design box (in logical units) plus its layers.
class Drawing extends Equatable {
  const Drawing({
    required this.name,
    this.width = AppConstants.defaultCanvasWidth,
    this.height = AppConstants.defaultCanvasHeight,
    this.layers = const [PaintLayer(name: 'Layer 1')],
  });

  final String name;
  final double width;
  final double height;
  final List<PaintLayer> layers;

  /// Every colour in use, so it can be picked again with one click.
  List<int> get usedColors {
    final seen = <int>{};
    for (final l in layers) {
      for (final s in l.shapes) {
        if (s.fill != null) seen.add(s.fill!);
        if (s.stroke != null) seen.add(s.stroke!);
      }
    }
    return seen.toList();
  }

  bool get hasShapes => layers.any((l) => l.shapes.isNotEmpty);

  /// Shapes or pictures: anything the user would lose by closing the tab.
  bool get hasContent =>
      layers.any((l) => l.shapes.isNotEmpty || l.image != null);

  Drawing copyWith({
    String? name,
    double? width,
    double? height,
    List<PaintLayer>? layers,
  }) =>
      Drawing(
        name: name ?? this.name,
        width: width ?? this.width,
        height: height ?? this.height,
        layers: layers ?? this.layers,
      );

  @override
  List<Object?> get props => [name, width, height, layers];
}
