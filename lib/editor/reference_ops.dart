// Dart imports:
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

// Project imports:
import '../model/reference_image.dart';
import 'editor_controller.dart';
import 'tool.dart';

/// Decodes PNG/JPG/WebP/etc. bytes into a [Image] using only dart:ui.
Future<Image> decodeImageBytes(Uint8List bytes) async {
  final codec = await instantiateImageCodec(bytes);
  try {
    final frame = await codec.getNextFrame();
    return frame.image;
  } finally {
    codec.dispose();
  }
}

/// The background image used for tracing.
extension ReferenceOps on EditorController {
  Future<void> syncReference() async {
    final r = drawing.reference;
    if (r == null) {
      refImage = null;
      refImageId = null;
      return;
    }
    images[r.id] = r.bytes;
    if (refImageId == r.id && refImage != null) return;
    final img = await decodeImageBytes(r.bytes);
    if (disposed || drawing.reference?.id != r.id) return;
    refImage = img;
    refImageId = r.id;
    touch();
  }

  /// Loads [bytes] as the reference, scaled to fit inside the canvas.
  Future<void> setReferenceBytes(Uint8List bytes) async {
    final ref = ReferenceImage.fromBytes(bytes);
    final img = await decodeImageBytes(bytes);
    if (disposed) return;
    images[ref.id] = bytes;
    drawing.reference = ref;
    refImage = img;
    refImageId = ref.id;
    fitReference();
  }

  void removeReference() {
    drawing.reference = null;
    refImage = null;
    refImageId = null;
    if (tool == Tool.reference) tool = Tool.select;
    changed();
  }

  /// Scales and centres the image so it fills the canvas box.
  void fitReference() {
    final r = drawing.reference;
    final img = refImage;
    if (r == null || img == null) return;
    r.scale = math.min(drawing.width / img.width, drawing.height / img.height);
    r.x = (drawing.width - img.width * r.scale) / 2;
    r.y = (drawing.height - img.height * r.scale) / 2;
    changed();
  }

  void editReference(void Function(ReferenceImage r) apply, {bool record = true}) {
    final r = drawing.reference;
    if (r != null) apply(r);
    changed(record: record && r != null);
  }

  /// Scales about the image centre so it does not jump while the slider moves.
  void setReferenceScale(double scale, {bool record = true}) {
    final img = refImage;
    editReference((r) {
      if (img != null) {
        final cx = r.x + img.width * r.scale / 2;
        final cy = r.y + img.height * r.scale / 2;
        r.x = cx - img.width * scale / 2;
        r.y = cy - img.height * scale / 2;
      }
      r.scale = scale;
    }, record: record);
  }

  /// Mid-drag move; call [changed] when the drag ends.
  void moveReferenceBy(Offset delta) {
    final r = drawing.reference;
    if (r == null) return;
    r.x += delta.dx;
    r.y += delta.dy;
    touch();
  }
}