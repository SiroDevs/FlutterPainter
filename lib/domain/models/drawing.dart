// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import '../../common/constants/app_constants.dart';
import 'paint_layer.dart';
import 'reference_image.dart';

part 'drawing.freezed.dart';

/// The whole document: a design box (in logical units) plus its layers.
@freezed
abstract class Drawing with _$Drawing {
  const Drawing._();

  const factory Drawing({
    required String name,
    @Default(AppConstants.defaultCanvasWidth) double width,
    @Default(AppConstants.defaultCanvasHeight) double height,
    @Default([PaintLayer(name: 'Layer 1')]) List<PaintLayer> layers,

    /// Optional picture drawn under the shapes, for tracing.
    ReferenceImage? reference,
  }) = _Drawing;

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
}
