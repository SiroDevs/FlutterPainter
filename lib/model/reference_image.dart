// Dart imports:
import 'dart:convert';
import 'dart:typed_data';

/// A picture shown under the shapes so it can be traced. It lives in the
/// drawing, so a .flp file carries its own reference and stays self-contained.
class ReferenceImage {
  ReferenceImage({
    required this.bytes,
    required this.id,
    this.x = 0,
    this.y = 0,
    this.scale = 1,
    this.opacity = 0.5,
    this.visible = true,
  });

  factory ReferenceImage.fromBytes(Uint8List bytes) =>
      ReferenceImage(bytes: bytes, id: idOf(bytes));

  final Uint8List bytes;
  final String id;

  /// Where the image's top-left corner sits in design units.
  double x;
  double y;

  /// Design units per image pixel.
  double scale;
  double opacity;
  bool visible;

  /// A cheap content fingerprint (FNV-1a plus length), used as the image id.
  static String idOf(Uint8List b) {
    var h = 0x811c9dc5;
    for (final v in b) {
      h ^= v;
      h = (h * 0x01000193) & 0xFFFFFFFF;
    }
    return '${h.toRadixString(16)}-${b.length}';
  }

  Map<String, dynamic> toJson({required bool withData}) => {
        'id': id,
        'x': x,
        'y': y,
        'scale': scale,
        'opacity': opacity,
        'visible': visible,
        if (withData) 'data': base64Encode(bytes),
      };

  /// Null when the pixels are neither in [j] nor findable through [lookup].
  static ReferenceImage? fromJson(
    Map<String, dynamic> j,
    Uint8List? Function(String id)? lookup,
  ) {
    final id = j['id'] as String;
    final data = j['data'] as String?;
    final bytes = data != null ? base64Decode(data) : lookup?.call(id);
    if (bytes == null) return null;
    return ReferenceImage(
      bytes: bytes,
      id: id,
      x: ((j['x'] as num?) ?? 0).toDouble(),
      y: ((j['y'] as num?) ?? 0).toDouble(),
      scale: ((j['scale'] as num?) ?? 1).toDouble(),
      opacity: ((j['opacity'] as num?) ?? 0.5).toDouble(),
      visible: (j['visible'] as bool?) ?? true,
    );
  }
}
