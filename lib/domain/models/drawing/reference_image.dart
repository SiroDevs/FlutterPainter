// Dart imports:
import 'dart:typed_data';

// Package imports:
import 'package:equatable/equatable.dart';

/// A picture that belongs to one layer and is drawn under that layer's shapes.
/// It lives in the drawing, so a project file carries its own images and stays
/// self-contained.
///
/// The picture is placed by its top-left corner ([x], [y]) in design units and
/// sized by a separate horizontal and vertical scale (design units per image
/// pixel), so it can be moved, resized and stretched independently on each axis.
/// The decoded pixels are kept by the editor state, keyed by [id].
class ReferenceImage extends Equatable {
  const ReferenceImage({
    required this.bytes,
    required this.id,
    this.x = 0.0,
    this.y = 0.0,
    this.scaleX = 1.0,
    this.scaleY = 1.0,
    this.opacity = 0.5,
    this.visible = true,
  });

  factory ReferenceImage.fromBytes(Uint8List bytes) =>
      ReferenceImage(bytes: bytes, id: idOf(bytes));

  /// The encoded file (png, jpg, ...), kept so the project can be saved.
  final Uint8List bytes;

  /// Content hash: the same picture on two layers shares one decoded image.
  final String id;

  /// Top-left corner, in design units.
  final double x;
  final double y;

  /// Design units per image pixel, horizontally and vertically.
  final double scaleX;
  final double scaleY;

  final double opacity;
  final bool visible;

  /// A cheap content fingerprint (FNV-1a) plus the length.
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
    double? scaleX,
    double? scaleY,
    double? opacity,
    bool? visible,
  }) =>
      ReferenceImage(
        bytes: bytes ?? this.bytes,
        id: id ?? this.id,
        x: x ?? this.x,
        y: y ?? this.y,
        scaleX: scaleX ?? this.scaleX,
        scaleY: scaleY ?? this.scaleY,
        opacity: opacity ?? this.opacity,
        visible: visible ?? this.visible,
      );

  // Bytes are left out on purpose: [id] already identifies them, and comparing
  // megabytes on every history push would be slow.
  @override
  List<Object?> get props => [id, x, y, scaleX, scaleY, opacity, visible];
}
