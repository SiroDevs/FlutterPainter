// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../core/utils/color_preview.dart';
import '../../../../domain/models/app_settings.dart';
import '../../../../domain/models/tool.dart';
import '../../../settings/cubit/settings_cubit.dart';
import '../../bloc/editor_bloc.dart';
import 'drawing_painter.dart';

class CanvasView extends StatefulWidget {
  const CanvasView({super.key, required this.focus});

  final FocusNode focus;

  @override
  State<CanvasView> createState() => _CanvasViewState();
}

class _CanvasViewState extends State<CanvasView> {
  bool _panning = false;
  Size? _reportedSize;
  double _lastScale = 1;

  EditorBloc get _bloc => context.read<EditorBloc>();

  /// Pointer position in screen space -> design units.
  Offset _design(Offset local) {
    final v = _bloc.state.view;
    return (local - v.pan) / v.zoom;
  }

  MouseCursor _cursor(Tool tool) => switch (tool) {
    Tool.select => SystemMouseCursors.basic,
    Tool.reference => SystemMouseCursors.grab,
    _ => SystemMouseCursors.precise,
  };

  /// Tells the bloc how big the canvas area is (it fits the drawing to it).
  void _reportSize(Size size) {
    if (size == _reportedSize) return;
    _reportedSize = size;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _bloc.add(ViewportChanged(size));
    });
  }

  @override
  Widget build(BuildContext context) {
    // The colour-vision preview only changes how the canvas is shown.
    final filter = colorFilterFor(
      context.select<SettingsCubit, ColorPreview>((c) => c.state.colorPreview),
    );
    return LayoutBuilder(
      builder: (context, box) {
        _reportSize(box.biggest);
        return BlocBuilder<EditorBloc, EditorState>(
          builder: (context, state) => MouseRegion(
            cursor: _cursor(state.tool),
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerDown: _down,
              onPointerMove: _move,
              onPointerUp: _up,
              onPointerCancel: (_) => _panning = false,
              onPointerHover: (e) =>
                  _bloc.add(PointerHovered(_design(e.localPosition))),
              onPointerSignal: _signal,
              onPointerPanZoomStart: (_) => _lastScale = 1,
              onPointerPanZoomUpdate: _panZoom,
              child: ClipRect(
                child: _filtered(
                  filter,
                  CustomPaint(
                    painter: DrawingPainter(state),
                    size: Size.infinite,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _filtered(ColorFilter? filter, Widget child) =>
      filter == null ? child : ColorFiltered(colorFilter: filter, child: child);

  void _down(PointerDownEvent e) {
    widget.focus.requestFocus();
    if ((e.buttons & (kSecondaryButton | kMiddleMouseButton)) != 0) {
      _panning = true;
      return;
    }
    if ((e.buttons & kPrimaryButton) == 0) return;
    _bloc.add(
      PointerPressed(
        _design(e.localPosition),
        shift: HardwareKeyboard.instance.isShiftPressed,
        alt: HardwareKeyboard.instance.isAltPressed,
        timeMs: DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  void _move(PointerMoveEvent e) {
    if (_panning) {
      _bloc.add(ViewPanned(e.delta));
      return;
    }
    _bloc.add(
      PointerMoved(
        _design(e.localPosition),
        shift: HardwareKeyboard.instance.isShiftPressed,
      ),
    );
  }

  void _up(PointerUpEvent e) {
    if (!_panning) _bloc.add(const PointerReleased());
    _panning = false;
  }

  void _panZoom(PointerPanZoomUpdateEvent e) {
    if (e.panDelta != Offset.zero) _bloc.add(ViewPanned(e.panDelta));
    final factor = e.scale / _lastScale;
    _lastScale = e.scale;
    if (factor != 1) _bloc.add(ViewZoomed(factor, e.localPosition));
  }

  void _signal(PointerSignalEvent e) {
    if (e is! PointerScrollEvent) return;

    // if (e is PointerScrollEvent) {
    //   _bloc.add(
    //     ViewZoomed(e.scrollDelta.dy < 0 ? 1.12 : 1 / 1.12, e.localPosition),
    //   );
    // }

    final kb = HardwareKeyboard.instance;
    if (kb.isControlPressed || kb.isMetaPressed) {
      _bloc.add(
        ViewZoomed(e.scrollDelta.dy < 0 ? 1.12 : 1 / 1.12, e.localPosition),
      );
    } else {
      // Shift + wheel scrolls sideways.
      final d = kb.isShiftPressed
          ? Offset(-e.scrollDelta.dy, 0)
          : -e.scrollDelta;
      _bloc.add(ViewPanned(d));
    }
  }
}
