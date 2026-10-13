// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'shape.dart';

part 'paint_layer.freezed.dart';

/// A named group of shapes. Layers draw bottom to top and export as one method
/// (or one class) each, which is how a bike and its rider stay separate.
@freezed
abstract class PaintLayer with _$PaintLayer {
  const factory PaintLayer({
    required String name,
    @Default(true) bool visible,
    @Default(<Shape>[]) List<Shape> shapes,
  }) = _PaintLayer;
}
