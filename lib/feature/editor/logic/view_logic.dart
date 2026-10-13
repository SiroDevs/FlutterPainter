// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../../domain/models/drawing.dart';
import '../bloc/editor_bloc.dart';
import '../models/view_settings.dart';

/// Zoom, pan, fit-to-window and the view toggles.
abstract class ViewLogic {
  ViewLogic._();

  static EditorState pan(EditorState s, Offset delta) =>
      s.copyWith(view: s.view.copyWith(pan: s.view.pan + delta));

  /// Zooms about [focal] (a point in screen space) so it stays under the cursor.
  static EditorState zoomAt(EditorState s, double factor, Offset focal) {
    final v = s.view;
    final next = (v.zoom * factor).clamp(0.5, 60.0).toDouble();
    return s.copyWith(
      view: v.copyWith(pan: focal - (focal - v.pan) * (next / v.zoom), zoom: next),
    );
  }

  /// Called whenever the canvas area changes size.
  static EditorState viewport(EditorState s, Size size) {
    var v = s.view.copyWith(viewport: size);
    if (v.needsFit) v = fitted(v, s.drawing);
    return s.copyWith(view: v);
  }

  static EditorState requestFit(EditorState s) =>
      s.copyWith(view: fitted(s.view, s.drawing, force: true));

  /// Centres the design box in the viewport. If the viewport is not known yet
  /// the fit is deferred until it is.
  static ViewSettings fitted(ViewSettings v, Drawing d, {bool force = false}) {
    if (v.viewport.isEmpty) return force ? v.copyWith(needsFit: true) : v;
    final zoom = math
        .min((v.viewport.width - 60) / d.width, (v.viewport.height - 60) / d.height)
        .clamp(0.5, 60.0)
        .toDouble();
    return v.copyWith(
      zoom: zoom,
      pan: Offset(
        (v.viewport.width - d.width * zoom) / 2,
        (v.viewport.height - d.height * zoom) / 2,
      ),
      needsFit: false,
    );
  }

  static EditorState toggleGrid(EditorState s) =>
      s.copyWith(view: s.view.copyWith(grid: !s.view.grid));

  static EditorState toggleSnap(EditorState s) =>
      s.copyWith(view: s.view.copyWith(snap: !s.view.snap));

  static EditorState cycleBackground(EditorState s) =>
      s.copyWith(view: s.view.copyWith(background: s.view.background + 1));
}
