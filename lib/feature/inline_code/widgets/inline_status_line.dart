// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Package imports:
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../core/utils/l10n_ext.dart';
import '../../export/widgets/vscode_colors.dart';
import '../cubit/inline_code_cubit.dart';

// A thin line under the code that says what the last edit did to the canvas.
class InlineStatusLine extends StatelessWidget {
  const InlineStatusLine({super.key, required this.colors});

  final VsCodeColors colors;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InlineCodeCubit, InlineCodeState>(
      buildWhen: (a, b) => a.status != b.status || a.skippedCount != b.skippedCount,
      builder: (context, state) {
        final l10n = context.l10n;
        final text = switch (state.status) {
          InlineCodeStatus.idle => l10n.statusIdle,
          InlineCodeStatus.unreadable => l10n.statusUnreadable,
          InlineCodeStatus.rendered when state.skippedCount > 0 =>
            l10n.statusSkipped(state.skippedCount),
          InlineCodeStatus.rendered => l10n.statusRendered,
        };
        return Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 12, color: colors.statusText),
        )
            .padding(horizontal: 12)
            .alignment(Alignment.centerLeft)
            .height(24)
            .decorated(
              color: colors.statusBar,
              border: Border(top: BorderSide(color: colors.border)),
            );
      },
    );
  }
}
