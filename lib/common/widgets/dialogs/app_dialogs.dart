// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../core/utils/l10n_ext.dart';

/// Asks for a line of text. Null if cancelled.
Future<String?> promptText(
  BuildContext context, {
  required String title,
  String initial = '',
}) {
  final ctl = TextEditingController(text: initial);
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: ctl,
        autofocus: true,
        onSubmitted: (v) => Navigator.pop(ctx, v.trim()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(ctx.l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, ctl.text.trim()),
          child: Text(ctx.l10n.buttonOk),
        ),
      ],
    ),
  );
}

/// Asks for a new design-box size. Returns null if cancelled or invalid.
Future<(double, double)?> promptSize(BuildContext context, double w, double h) {
  final wc = TextEditingController(text: w.toStringAsFixed(0));
  final hc = TextEditingController(text: h.toStringAsFixed(0));
  return showDialog<(double, double)>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(ctx.l10n.canvasSizeTitle),
      content: Row(
        children: [
          Expanded(
            child: TextField(
              controller: wc,
              decoration: InputDecoration(labelText: ctx.l10n.fieldWidth),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: hc,
              decoration: InputDecoration(labelText: ctx.l10n.fieldHeight),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(ctx.l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            final nw = double.tryParse(wc.text);
            final nh = double.tryParse(hc.text);
            if (nw != null && nh != null && nw >= 8 && nh >= 8) {
              Navigator.pop(ctx, (nw, nh));
            }
          },
          child: Text(ctx.l10n.buttonResize),
        ),
      ],
    ),
  );
}

enum SaveChoice { save, discard, cancel }

/// Shown when closing a project that has unsaved changes.
Future<SaveChoice> askSaveChanges(BuildContext context, String name) async {
  final choice = await showDialog<SaveChoice>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(ctx.l10n.saveChangesTitle(name)),
      content: Text(ctx.l10n.unsavedChangesMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, SaveChoice.cancel),
          child: Text(ctx.l10n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, SaveChoice.discard),
          child: Text(ctx.l10n.buttonDontSave),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, SaveChoice.save),
          child: Text(ctx.l10n.fileSave),
        ),
      ],
    ),
  );
  return choice ?? SaveChoice.cancel;
}

/// Offered at startup when unsaved work was left behind. True = restore it.
Future<bool> askRecover(BuildContext context, List<String> titles) async {
  final restore = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      title: Text(ctx.l10n.recoverUnsavedTitle),
      content: Text(
        '${ctx.l10n.recoverUnsavedIntro}\n\n'
        '${titles.map((t) => '  - $t').join('\n')}',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(ctx.l10n.buttonDiscard),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(ctx.l10n.buttonRestore),
        ),
      ],
    ),
  );
  return restore ?? false;
}
