// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../../domain/models/drawing.dart';
import '../../../domain/models/paint_layer.dart';
import '../../../domain/models/reference_image.dart';
import '../../../domain/models/tool.dart';
import '../../../domain/services/image_geometry.dart';
import '../bloc/editor_bloc.dart';
import '../models/gesture_state.dart';
import 'editor_ops.dart';

/// The picture that sits under a layer's shapes (for tracing or as a
/// background): load it, move it, resize or stretch it, fade it.
abstract class ImageLogic {
  ImageLogic._();

  // ---- gestures ------------------------------------------------------------

  /// Starts dragging the active layer's picture: by a handle (resize or
  /// stretch) or, anywhere else, by the body (move). Used by the "Move / resize
  /// layer image" tool, which works even when shapes cover the picture.
  static EditorState pressed(EditorState s, Offset p) {
    final box = s.imageBounds;
    if (box == null) return s;
    return grab(s.copyWith(selected: kImageSlot), p, box);
  }

  /// Begins a move or resize gesture on the picture whose box is [box].
  static EditorState grab(EditorState s, Offset p, Rect box) {
    final handle = hitImageHandle(box, p, 8 / s.view.zoom);
    return s.copyWith(
      gesture: s.gesture.copyWith(
        mode: handle == null ? GestureMode.imageMove : GestureMode.imageScale,
        handle: handle ?? -1,
        origin: p,
        startBounds: box,
      ),
    );
  }

  /// The handle of the selected picture under [p], or null.
  static int? handleAt(EditorState s, Offset p) {
    final box = s.imageBounds;
    if (box == null || !s.showImageHandles) return null;
    return hitImageHandle(box, p, 8 / s.view.zoom);
  }

  /// Applies the drag to the picture. Corners keep the proportions unless
  /// [freeStretch] (Shift) is held; edge handles always stretch one axis.
  static EditorState dragged(EditorState s, Offset p, bool freeStretch) {
    final r = s.layer.image;
    final pixels = r == null ? null : s.images[r.id];
    if (r == null || pixels == null) return s;
    final g = s.gesture;

    if (g.mode == GestureMode.imageMove) {
      final to = g.startBounds.shift(p - g.origin);
      return s.withImage(r.copyWith(x: to.left, y: to.top));
    }

    final to = resizeImageRect(
      g.startBounds,
      g.handle,
      p,
      keepAspect: g.handle < imageCornerCount && !freeStretch,
    );
    if (to.width < 1 || to.height < 1) return s;
    return s.withImage(
      r.copyWith(
        x: to.left,
        y: to.top,
        scaleX: to.width / pixels.width,
        scaleY: to.height / pixels.height,
      ),
    );
  }

  static EditorState released(EditorState s) => s.endGesture().commit();

  // ---- loading and editing -------------------------------------------------

  /// Puts [ref] (already decoded as [pixels]) on the active layer, scaled to fit
  /// the canvas, or on a brand-new layer on top when [onNewLayer] is set.
  static EditorState loaded(
    EditorState s,
    ReferenceImage ref,
    Image pixels, {
    bool onNewLayer = false,
  }) {
    final fitted = _fitted(s.drawing, ref, pixels);
    final cache = {...s.images, ref.id: pixels};
    if (!onNewLayer) {
      return s
          .copyWith(images: cache, selected: kImageSlot)
          .withImage(fitted)
          .commit();
    }
    final layers = [
      ...s.drawing.layers,
      PaintLayer(name: 'Layer ${s.drawing.layers.length + 1}', image: fitted),
    ];
    return s
        .copyWith(
          images: cache,
          layerIndex: layers.length - 1,
          selected: kImageSlot,
        )
        .withLayers(layers)
        .commit();
  }

  static ReferenceImage _fitted(Drawing d, ReferenceImage r, Image pixels) {
    final scale = math.min(d.width / pixels.width, d.height / pixels.height);
    return r.copyWith(
      scaleX: scale,
      scaleY: scale,
      x: (d.width - pixels.width * scale) / 2,
      y: (d.height - pixels.height * scale) / 2,
    );
  }

  /// Fits the picture inside the canvas again (this also undoes any stretch).
  static EditorState fit(EditorState s) {
    final r = s.layer.image;
    final pixels = r == null ? null : s.images[r.id];
    if (r == null || pixels == null) return s;
    return s.withImage(_fitted(s.drawing, r, pixels)).commit();
  }

  static EditorState remove(EditorState s) {
    if (s.layer.image == null) return s;
    return s
        .withImage(null)
        .copyWith(
          selected: null,
          tool: s.tool == Tool.reference ? Tool.select : s.tool,
        )
        .commit();
  }

  static EditorState visibility(EditorState s, bool visible) =>
      _edit(s, (r) => r.copyWith(visible: visible)).commit();

  /// Slider drags apply at once; ChangesCommitted records the history entry.
  static EditorState opacity(EditorState s, double opacity) =>
      _edit(s, (r) => r.copyWith(opacity: opacity));

  /// Sets the horizontal scale and keeps the current stretch (the vertical
  /// scale follows in proportion), growing or shrinking about the picture's
  /// centre so it does not jump while the slider moves.
  static EditorState scale(EditorState s, double scale) {
    final pixels = s.layer.image == null ? null : s.images[s.layer.image!.id];
    return _edit(s, (r) {
      final ratio = r.scaleX == 0 ? 1.0 : r.scaleY / r.scaleX;
      final scaleY = scale * ratio;
      if (pixels == null) return r.copyWith(scaleX: scale, scaleY: scaleY);
      final cx = r.x + pixels.width * r.scaleX / 2;
      final cy = r.y + pixels.height * r.scaleY / 2;
      return r.copyWith(
        scaleX: scale,
        scaleY: scaleY,
        x: cx - pixels.width * scale / 2,
        y: cy - pixels.height * scaleY / 2,
      );
    });
  }

  /// Selects the active layer's picture (shows its handles).
  static EditorState select(EditorState s) =>
      s.layer.image == null ? s : s.copyWith(selected: kImageSlot);

  static EditorState _edit(
    EditorState s,
    ReferenceImage Function(ReferenceImage r) change,
  ) {
    final r = s.layer.image;
    return r == null ? s : s.withImage(change(r));
  }
}
