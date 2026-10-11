// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Project imports:
import '../model/drawing.dart';
import '../ui/file_dialogs.dart';
import 'dart_exporter.dart';

Future<void> showExportDialog(BuildContext context, Drawing drawing) {
  return showDialog<void>(
    context: context,
    builder: (_) => _ExportDialog(drawing: drawing),
  );
}

class _ExportDialog extends StatefulWidget {
  const _ExportDialog({required this.drawing});

  final Drawing drawing;

  @override
  State<_ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<_ExportDialog> {
  bool _perLayer = true;
  String _status = '';

  String get _code =>
      DartExporter(widget.drawing, classPerLayer: _perLayer).generate();

  Future<void> _save() async {
    try {
      final path = await saveDartFile(_code);
      if (path != null) setState(() => _status = 'Saved $path');
    } catch (e) {
      setState(() => _status = 'Could not save: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final code = _code;
    return AlertDialog(
      title: const Text('Export Dart'),
      content: SizedBox(
        width: 780,
        height: 500,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Wrap(spacing: 8, children: [
            ChoiceChip(
              label: const Text('One class per layer'),
              selected: _perLayer,
              onSelected: (_) => setState(() => _perLayer = true),
            ),
            ChoiceChip(
              label: const Text('Single class'),
              selected: !_perLayer,
              onSelected: (_) => setState(() => _perLayer = false),
            ),
          ]),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              width: double.infinity,
              color: const Color(0xFF14161A),
              padding: const EdgeInsets.all(12),
              child: SingleChildScrollView(
                child: SelectableText(
                  code,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(_status, style: Theme.of(context).textTheme.bodySmall),
        ]),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: code));
            setState(() => _status = 'Copied to clipboard');
          },
          child: const Text('Copy'),
        ),
        TextButton(onPressed: _save, child: const Text('Save as .dart')),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
