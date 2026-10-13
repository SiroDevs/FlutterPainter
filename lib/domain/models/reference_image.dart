// Dart imports:
import 'dart:typed_data';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reference_image.freezed.dart';

/// A picture shown under the shapes so it can be traced. It lives in the
/// drawing, so a project file carries its own reference and stays
/// self-contained.
@freezed
abstract class ReferenceImage with _$ReferenceImage {
  const ReferenceImage._();

  const factory ReferenceImage({
    required Uint8List bytes,
    required String id,

    /// Where the image's top-left corner sits in design units.
    @Default(0.0) double x,
    @Default(0.0) double y,

    /// Design units per image pixel.
    @Default(1.0) double scale,
    @Default(0.5) double opacity,
    @Default(true) bool visible,
  }) = _ReferenceImage;

  factory ReferenceImage.fromBytes(Uint8List bytes) =>
      ReferenceImage(bytes: bytes, id: idOf(bytes));

  /// A cheap content fingerprint (FNV-1a plus length), used as the image id.
  static String idOf(Uint8List b) {
    var h = 0x811c9dc5;
    for (final v in b) {
      h ^= v;
      h = (h * 0x01000193) & 0xFFFFFFFF;
    }
    return '${h.toRadixString(16)}-${b.length}';
  }
}
