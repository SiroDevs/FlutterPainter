// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../core/utils/l10n_ext.dart';
import '../../export/widgets/code_editor.dart';
import '../../export/widgets/vscode_colors.dart';
import '../cubit/inline_code_cubit.dart';
import 'inline_file_strip.dart';
import 'inline_status_line.dart';

// The inline code view: file strip on top, the code editor, a status line, and
// a floating button that opens the full code editor.
class InlineCodePanel extends StatefulWidget {
  const InlineCodePanel({
    super.key,
    required this.cubit,
    required this.onOpenFullEditor,
  });

  final InlineCodeCubit cubit;
  final VoidCallback onOpenFullEditor;

  @override
  State<InlineCodePanel> createState() => _InlineCodePanelState();
}

class _InlineCodePanelState extends State<InlineCodePanel> {
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
        child: Column(children: [
          InlineFileStrip(colors: colors),
          Expanded(
            child: Stack(children: [
              _editor(colors),
              _fullEditorButton(colors),
            ]),
          ),
          InlineStatusLine(colors: colors),
        ]),
      ),
    );
  }

  Widget _editor(VsCodeColors colors) {
    return BlocBuilder<InlineCodeCubit, InlineCodeState>(
      buildWhen: (a, b) =>
          a.activePath != b.activePath ||
          a.activeFile?.content != b.activeFile?.content,
      builder: (context, state) {
        final file = state.activeFile;
        if (file == null) return const SizedBox.shrink();
        return CodeEditor(
          key: ValueKey(file.path),
          file: file,
          colors: colors,
          views: _views,
          caret: _caret,
          onChanged: (text) => widget.cubit.edit(file.path, text),
        );
      },
    );
  }

  Widget _fullEditorButton(VsCodeColors colors) {
    return Positioned(
      right: 16,
      bottom: 16,
      child: FloatingActionButton.small(
        tooltip: context.l10n.openFullEditor,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        backgroundColor: colors.sideBar,
        foregroundColor: colors.activityIconActive,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: colors.border),
        ),
        onPressed: widget.onOpenFullEditor,
        child: const Icon(Icons.north_west),
      ),
    );
  }
}
