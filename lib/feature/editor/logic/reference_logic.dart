// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../../domain/models/drawing.dart';
import '../../../domain/models/reference_image.dart';
import '../../../domain/models/tool.dart';
import '../bloc/editor_bloc.dart';
import '../models/gesture_state.dart';
import 'editor_ops.dart';

/// The background image used for tracing.
abstract class ReferenceLogic {
  ReferenceLogic._();

  // ---- dragging with the "move background image" tool -------------------

  static EditorState pressed(EditorState s, Offset p) => s.drawing.reference == null
      ? s
      : s.copyWith(
          gesture: s.gesture.copyWith(mode: GestureMode.referenceDrag, last: p),
        );

  static EditorState dragged(EditorState s, Offset p) {
    final r = s.drawing.reference;
    if (r == null) return s;
    final d = p - s.gesture.last;
    return s
        .withDrawing(
          s.drawing.copyWith(reference: r.copyWith(x: r.x + d.dx, y: r.y + d.dy)),
        )
        .copyWith(gesture: s.gesture.copyWith(last: p));
  }

  static EditorState released(EditorState s) => s.endGesture().commit();

  // ---- loading and editing ----------------------------------------------

  /// Installs [ref] (already decoded as [image]) scaled to fit the canvas.
  static EditorState loaded(EditorState s, ReferenceImage ref, Image image) {
    final fitted = _fitted(s.drawing, ref, image);
    return s
        .withDrawing(s.drawing.copyWith(reference: fitted))
        .copyWith(refImage: image, refImageId: ref.id)
        .commit();
  }

  static ReferenceImage _fitted(Drawing d, ReferenceImage r, Image image) {
    final scale = math.min(d.width / image.width, d.height / image.height);
    return r.copyWith(
      scale: scale,
      x: (d.width - image.width * scale) / 2,
      y: (d.height - image.height * scale) / 2,
    );
  }

  static EditorState fit(EditorState s) {
    final r = s.drawing.reference;
    final image = s.refImage;
    if (r == null || image == null) return s;
    return s
        .withDrawing(s.drawing.copyWith(reference: _fitted(s.drawing, r, image)))
        .commit();
  }

  static EditorState remove(EditorState s) => s
      .withDrawing(s.drawing.copyWith(reference: null))
      .copyWith(
        refImage: null,
        refImageId: null,
        tool: s.tool == Tool.reference ? Tool.select : s.tool,
      )
      .commit();

  static EditorState visibility(EditorState s, bool visible) =>
      _edit(s, (r) => r.copyWith(visible: visible)).commit();

  /// Slider drags apply at once; ChangesCommitted records the history entry.
  static EditorState opacity(EditorState s, double opacity) =>
      _edit(s, (r) => r.copyWith(opacity: opacity));

  /// Scales about the image centre so it does not jump while the slider moves.
  static EditorState scale(EditorState s, double scale) {
    final image = s.refImage;
    return _edit(s, (r) {
      if (image == null) return r.copyWith(scale: scale);
      final cx = r.x + image.width * r.scale / 2;
      final cy = r.y + image.height * r.scale / 2;
      return r.copyWith(
        scale: scale,
        x: cx - image.width * scale / 2,
        y: cy - image.height * scale / 2,
      );
    });
  }

  static EditorState _edit(
    EditorState s,
    ReferenceImage Function(ReferenceImage r) change,
  ) {
    final r = s.drawing.reference;
    if (r == null) return s;
    return s.withDrawing(s.drawing.copyWith(reference: change(r)));
  }
}
