// Dart imports:
import 'dart:typed_data';

// Package imports:
import 'package:equatable/equatable.dart';

/// A picture shown under the shapes so it can be traced. It lives in the
/// drawing, so a project file carries its own reference and stays
/// self-contained.
class ReferenceImage extends Equatable {
  const ReferenceImage({
    required this.bytes,
    required this.id,
    this.x = 0.0,
    this.y = 0.0,
    this.scale = 1.0,
    this.opacity = 0.5,
    this.visible = true,
  });

  factory ReferenceImage.fromBytes(Uint8List bytes) =>
      ReferenceImage(bytes: bytes, id: idOf(bytes));

  final Uint8List bytes;
  final String id;

  /// Where the image's top-left corner sits in design units.
  final double x;
  final double y;

  /// Design units per image pixel.
  final double scale;
  final double opacity;
  final bool visible;

  /// A cheap content fingerprint (FNV-1a plus length), used as the image id.
  static String idOf(Uint8List b) {
    var h = 0x811c9dc5;
    for (final v in b) {
      h ^= v;
      h = (h * 0x01000193) & 0xFFFFFFFF;
    }
    return '${h.toRadixString(16)}-${b.length}';
  }

  ReferenceImage copyWith({
    Uint8List? bytes,
    String? id,
    double? x,
    double? y,
    double? scale,
    double? opacity,
    bool? visible,
  }) =>
      ReferenceImage(
        bytes: bytes ?? this.bytes,
        id: id ?? this.id,
        x: x ?? this.x,
        y: y ?? this.y,
        scale: scale ?? this.scale,
        opacity: opacity ?? this.opacity,
        visible: visible ?? this.visible,
      );

  /// [bytes] is left out on purpose: [id] is a fingerprint of it, and comparing
  /// megabytes of pixels on every state change would be slow.
  @override
  List<Object?> get props => [id, x, y, scale, opacity, visible];
}
