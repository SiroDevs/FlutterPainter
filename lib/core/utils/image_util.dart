// Dart imports:
import 'dart:typed_data';
import 'dart:ui';

/// Decodes PNG/JPG/WebP/etc. bytes into an [Image] using only dart:ui.
/// (dart:ui's own decodeImageFromList is callback-based and returns void.)
Future<Image> decodeImageBytes(Uint8List bytes) async {
  final codec = await instantiateImageCodec(bytes);
  try {
    final frame = await codec.getNextFrame();
    return frame.image;
  } finally {
    codec.dispose();
  }
}
