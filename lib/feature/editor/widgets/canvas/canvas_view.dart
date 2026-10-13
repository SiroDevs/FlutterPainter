// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../domain/models/tool.dart';
import '../../bloc/editor_bloc.dart';
import 'drawing_painter.dart';

/// The drawing surface. A thin forwarder: it turns raw pointer events into
/// [EditorEvent]s (positions in design units plus modifier keys) and paints the
/// bloc state. Raw pointer events (no gesture arena) mean drawing starts
/// instantly: the left button uses the tool, right or middle button pans, and
/// the wheel zooms around the cursor.
class CanvasView extends StatefulWidget {
  const CanvasView({super.key, required this.focus});

  final FocusNode focus;

  @override
  State<CanvasView> createState() => _CanvasViewState();
}

class _CanvasViewState extends State<CanvasView> {
  bool _panning = false;
  Size? _reportedSize;

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
      if (mounted) _bloc.add(EditorEvent.viewportChanged(size));
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, box) {
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
                _bloc.add(EditorEvent.pointerHovered(_design(e.localPosition))),
            onPointerSignal: _signal,
            child: ClipRect(
              child: CustomPaint(
                painter: DrawingPainter(state),
                size: Size.infinite,
              ),
            ),
          ),
        ),
      );
    });
  }

  void _down(PointerDownEvent e) {
    widget.focus.requestFocus();
    if ((e.buttons & (kSecondaryButton | kMiddleMouseButton)) != 0) {
      _panning = true;
      return;
    }
    if ((e.buttons & kPrimaryButton) == 0) return;
    _bloc.add(EditorEvent.pointerPressed(
      _design(e.localPosition),
      shift: HardwareKeyboard.instance.isShiftPressed,
      alt: HardwareKeyboard.instance.isAltPressed,
      timeMs: DateTime.now().millisecondsSinceEpoch,
    ));
  }

  void _move(PointerMoveEvent e) {
    if (_panning) {
      _bloc.add(EditorEvent.viewPanned(e.delta));
      return;
    }
    _bloc.add(EditorEvent.pointerMoved(
      _design(e.localPosition),
      shift: HardwareKeyboard.instance.isShiftPressed,
    ));
  }

  void _up(PointerUpEvent e) {
    if (!_panning) _bloc.add(const EditorEvent.pointerReleased());
    _panning = false;
  }

  void _signal(PointerSignalEvent e) {
    if (e is PointerScrollEvent) {
      _bloc.add(EditorEvent.viewZoomed(
        e.scrollDelta.dy < 0 ? 1.12 : 1 / 1.12,
        e.localPosition,
      ));
    }
  }
}
