// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Package imports:
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../core/utils/l10n_ext.dart';
import '../../export/widgets/vscode_colors.dart';
import '../cubit/inline_code_cubit.dart';

// The files of the inline code view, piled in a scrollable row. A file that
// stands for a layer has an X that removes the layer along with the file.
class InlineFileStrip extends StatelessWidget {
  const InlineFileStrip({super.key, required this.colors});

  final VsCodeColors colors;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<InlineCodeCubit>();
    return BlocBuilder<InlineCodeCubit, InlineCodeState>(
      buildWhen: (a, b) =>
          a.files != b.files ||
          a.activePath != b.activePath ||
          a.removablePaths != b.removablePaths,
      builder: (context, state) => Row(children: [
        IconButton(
          tooltip: context.l10n.undo,
          iconSize: 18,
          color: colors.activityIcon,
          icon: const Icon(Icons.undo),
          onPressed: cubit.undo,
        ),
        ListView(
          scrollDirection: Axis.horizontal,
          children: [
            for (final file in state.files)
              _FileChip(
                name: file.name,
                colors: colors,
                active: file.path == state.activePath,
                removable: state.removablePaths.contains(file.path),
                onTap: () => cubit.select(file.path),
                onRemove: () => cubit.removeFile(file.path),
              ),
          ],
        ).expanded(),
      ])
          .height(36)
          .decorated(
            color: colors.tabBar,
            border: Border(bottom: BorderSide(color: colors.border)),
          ),
    );
  }
}

class _FileChip extends StatelessWidget {
  const _FileChip({
    required this.name,
    required this.colors,
    required this.active,
    required this.removable,
    required this.onTap,
    required this.onRemove,
  });

  final String name;
  final VsCodeColors colors;
  final bool active;
  final bool removable;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 13,
            color: active ? colors.tabActiveText : colors.tabInactiveText,
          ),
        ),
        if (removable)
          IconButton(
            tooltip: context.l10n.removeFileTooltip,
            iconSize: 14,
            visualDensity: VisualDensity.compact,
            color: colors.tabInactiveText,
            icon: const Icon(Icons.close),
            onPressed: onRemove,
          ),
      ])
          .padding(left: 12, right: removable ? 2 : 12)
          .decorated(
            color: active ? colors.editorBg : colors.tabInactive,
            border: Border(
              top: BorderSide(
                color: active ? colors.accent : Colors.transparent,
                width: 2,
              ),
              right: BorderSide(color: colors.border),
            ),
          ),
    );
  }
}
