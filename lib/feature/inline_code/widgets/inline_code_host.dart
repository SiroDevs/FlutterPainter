// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import '../../../common/app_router/route_names.dart';
import '../../editor/bloc/editor_bloc.dart';
import '../../export/export_args.dart';
import '../../settings/cubit/settings_cubit.dart';
import '../cubit/inline_code_cubit.dart';
import 'inline_code_panel.dart';

// Lays the inline code view over the right side of [child], covering 0.4 of the
// width, and slides it in and out as [open] changes. The code is only
// generated the first time the view is opened.
class InlineCodeHost extends StatefulWidget {
  const InlineCodeHost({super.key, required this.open, required this.child});

  final ValueNotifier<bool> open;
  final Widget child;

  @override
  State<InlineCodeHost> createState() => _InlineCodeHostState();
}

class _InlineCodeHostState extends State<InlineCodeHost> {
  static const double _widthFactor = 0.4;

  InlineCodeCubit? _cubit;

  @override
  void dispose() {
    _cubit?.close();
    super.dispose();
  }

  void _openFullEditor(BuildContext context) {
    final drawing = context.read<EditorBloc>().state.drawing;
    context.push(RoutePaths.export, extra: ExportArgs(drawing));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      widget.child,
      ValueListenableBuilder<bool>(
        valueListenable: widget.open,
        builder: (context, isOpen, _) {
          if (isOpen) {
            _cubit ??= InlineCodeCubit.create(
              context.read<EditorBloc>(),
              context.read<SettingsCubit>().state,
            );
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
                          child: InlineCodePanel(
                            cubit: cubit,
                            onOpenFullEditor: () => _openFullEditor(context),
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
      ),
    ]);
  }
}
