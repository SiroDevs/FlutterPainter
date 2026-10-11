// Flutter imports:
import 'package:flutter/material.dart';

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
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, ctl.text.trim()),
          child: const Text('OK'),
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
      title: const Text('Canvas size (design units)'),
      content: Row(children: [
        Expanded(child: TextField(controller: wc, decoration: const InputDecoration(labelText: 'Width'))),
        const SizedBox(width: 12),
        Expanded(child: TextField(controller: hc, decoration: const InputDecoration(labelText: 'Height'))),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            final nw = double.tryParse(wc.text);
            final nh = double.tryParse(hc.text);
            if (nw != null && nh != null && nw >= 8 && nh >= 8) {
              Navigator.pop(ctx, (nw, nh));
            }
          },
          child: const Text('Resize'),
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
      title: Text('Save changes to "$name"?'),
      content: const Text('Your changes will be lost if you do not save them.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, SaveChoice.cancel),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, SaveChoice.discard),
          child: const Text("Don't save"),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, SaveChoice.save),
          child: const Text('Save'),
        ),
      ],
    ),
  );
  return choice ?? SaveChoice.cancel;
}

enum OverwriteChoice { overwrite, saveNew, cancel }

/// Shown the first time an opened project is saved.
Future<OverwriteChoice> askOverwrite(BuildContext context, String path) async {
  final choice = await showDialog<OverwriteChoice>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Overwrite the original file?'),
      content: Text('$path\n\nOverwrite it with your changes, or save them as a new file '
          'and leave the original untouched?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, OverwriteChoice.cancel),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, OverwriteChoice.saveNew),
          child: const Text('Save as new file'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, OverwriteChoice.overwrite),
          child: const Text('Overwrite'),
        ),
      ],
    ),
  );
  return choice ?? OverwriteChoice.cancel;
}

/// Offered at startup when unsaved work was left behind. True = restore it.
Future<bool> askRecover(BuildContext context, List<String> titles) async {
  final restore = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      title: const Text('Recover unsaved work?'),
      content: Text('These projects had unsaved changes when Flutter Painter last closed:\n\n'
          '${titles.map((t) => '  - $t').join('\n')}'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Discard'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Restore'),
        ),
      ],
    ),
  );
  return restore ?? false;
}
