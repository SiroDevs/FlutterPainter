// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../editor/bloc/editor_bloc.dart';
import '../cubit/quick_code_cubit.dart';
import '../quick_code_request.dart';
import 'quick_code_panel.dart';

/// Slides the Quick Code editor over the right side of the workspace.
class QuickCodeHost extends StatefulWidget {
  const QuickCodeHost({
    super.key,
    required this.open,
    required this.request,
    required this.child,
  });

  final ValueNotifier<bool> open;
  final ValueNotifier<QuickCodeRequest?> request;
  final Widget child;

  @override
  State<QuickCodeHost> createState() => _QuickCodeHostState();
}

class _QuickCodeHostState extends State<QuickCodeHost> {
  static const double _widthFactor = 0.4;
  QuickCodeCubit? _cubit;
  QuickCodeRequest? _scheduledRequest;
  bool _wasOpen = false;
  int _panelVersion = 0;

  @override
  void dispose() {
    _cubit?.close();
    super.dispose();
  }

  void _scheduleOpen(QuickCodeRequest request, {required bool reopening}) {
    if (!reopening && identical(request, _scheduledRequest)) return;
    _scheduledRequest = request;
    _panelVersion++;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _cubit?.open(request);
    });
  }

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      widget.child,
      ValueListenableBuilder<bool>(
        valueListenable: widget.open,
        builder: (context, isOpen, _) {
          final reopening = isOpen && !_wasOpen;
          _wasOpen = isOpen;
          return ValueListenableBuilder<QuickCodeRequest?>(
            valueListenable: widget.request,
            builder: (context, request, _) {
              if (isOpen && request != null) {
                _cubit ??= QuickCodeCubit(context.read<EditorBloc>());
                _scheduleOpen(request, reopening: reopening);
              }
              final cubit = _cubit;
              if (cubit == null) return const SizedBox.shrink();
              return Positioned.fill(
                child: LayoutBuilder(
                  builder: (context, constraints) => ClipRect(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IgnorePointer(
                        ignoring: !isOpen,
                        child: ExcludeFocus(
                          excluding: !isOpen,
                          child: AnimatedSlide(
                            offset: isOpen ? Offset.zero : const Offset(1, 0),
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut,
                            child: SizedBox(
                              width: constraints.maxWidth * _widthFactor,
                              child: QuickCodePanel(
                                key: ValueKey(_panelVersion),
                                cubit: cubit,
                                onClose: () {
                                  cubit.clearPreview();
                                  widget.open.value = false;
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    ],
  );
}
