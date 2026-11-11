// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../core/utils/l10n_ext.dart';
import '../../../domain/models/export/export_file.dart';
import '../../../domain/services/code_import/quick_code_points.dart';
import '../../export/widgets/code_editor.dart';
import '../../export/widgets/vscode_colors.dart';
import '../cubit/quick_code_cubit.dart';

/// The Quick Code coordinate editor and its canvas actions.
class QuickCodePanel extends StatefulWidget {
  const QuickCodePanel({super.key, required this.cubit, required this.onClose});

  final QuickCodeCubit cubit;
  final VoidCallback onClose;

  @override
  State<QuickCodePanel> createState() => _QuickCodePanelState();
}

class _QuickCodePanelState extends State<QuickCodePanel> {
  final EditorViewStore _views = EditorViewStore();
  final ValueNotifier<CaretInfo> _caret = ValueNotifier(const CaretInfo(1, 1));

  @override
  void dispose() {
    _caret.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = VsCodeColors.of(Theme.of(context).brightness);
    return BlocProvider.value(
      value: widget.cubit,
      child: Material(
        color: colors.editorBg,
        child: Column(
          children: [
            _header(colors),
            Expanded(child: _editor(colors)),
            _footer(colors),
          ],
        ),
      ),
    );
  }

  Widget _header(VsCodeColors colors) =>
      BlocBuilder<QuickCodeCubit, QuickCodeState>(
        buildWhen: (a, b) => a.format != b.format || a.status != b.status,
        builder: (context, state) => Container(
          height: 42,
          padding: const EdgeInsets.only(left: 14),
          color: colors.titleBar,
          child: Row(
            children: [
              Icon(Icons.code, size: 17, color: colors.titleText),
              const SizedBox(width: 8),
              Text(
                context.l10n.quickCode,
                style: TextStyle(color: colors.titleText),
              ),
              const Spacer(),
              Tooltip(
                message: context.l10n.quickCodeFormatTooltip,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: colors.titleText,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    visualDensity: VisualDensity.compact,
                  ),
                  onPressed: state.status == QuickCodeStatus.invalid
                      ? null
                      : widget.cubit.toggleFormat,
                  icon: const Icon(Icons.swap_horiz, size: 17),
                  label: Text(
                    state.format == QuickCodeFormat.dartOffsets
                        ? context.l10n.quickCodeCoordinates
                        : context.l10n.quickCodeDartCode,
                  ),
                ),
              ),
              IconButton(
                tooltip: context.l10n.quickCodeClose,
                onPressed: widget.onClose,
                icon: Icon(Icons.close, size: 18, color: colors.titleText),
              ),
            ],
          ),
        ),
      );

  Widget _editor(VsCodeColors colors) =>
      BlocBuilder<QuickCodeCubit, QuickCodeState>(
        buildWhen: (a, b) => a.content != b.content,
        builder: (context, state) => CodeEditor(
          key: const ValueKey('quick-code-points'),
          file: ExportFile(path: 'quick_code.dart', content: state.content),
          colors: colors,
          views: _views,
          caret: _caret,
          onChanged: widget.cubit.edit,
        ),
      );

  Widget _footer(VsCodeColors colors) =>
      BlocBuilder<QuickCodeCubit, QuickCodeState>(
        buildWhen: (a, b) => a.status != b.status || a.isPolygon != b.isPolygon,
        builder: (context, state) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: colors.statusBar,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _statusLabel(state),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: colors.statusText, fontSize: 12),
                ),
              ),
              if (state.isPolygon)
                TextButton.icon(
                  onPressed: state.status == QuickCodeStatus.ready
                      ? widget.cubit.addPolygon
                      : null,
                  icon: const Icon(Icons.add, size: 17),
                  label: Text(context.l10n.quickCodeAddPolygon),
                ),
            ],
          ),
        ),
      );

  String _statusLabel(QuickCodeState state) => switch (state.status) {
    QuickCodeStatus.empty => context.l10n.quickCodeHint,
    QuickCodeStatus.invalid => context.l10n.quickCodeInvalid,
    QuickCodeStatus.tooFew => context.l10n.quickCodeNeedMorePoints,
    QuickCodeStatus.ready =>
      state.isPolygon
          ? context.l10n.quickCodePolygonReady
          : context.l10n.quickCodeShapeReady,
  };
}
