// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../core/di/injectable.dart';
import '../../../domain/models/drawing.dart';
import '../cubit/export_cubit.dart';

/// Shows the generated Dart for [drawing] with copy and save buttons.
Future<void> showExportDialog(BuildContext context, Drawing drawing) {
  return showDialog<void>(
    context: context,
    builder: (_) => BlocProvider(
      create: (_) => getIt<ExportCubit>()..start(drawing),
      child: const _ExportDialog(),
    ),
  );
}

class _ExportDialog extends StatelessWidget {
  const _ExportDialog();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ExportCubit>();
    return BlocBuilder<ExportCubit, ExportState>(
      builder: (context, state) => AlertDialog(
        title: const Text('Export Dart'),
        content: SizedBox(
          width: 780,
          height: 500,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Wrap(spacing: 8, children: [
              ChoiceChip(
                label: const Text('One class per layer'),
                selected: state.perLayer,
                onSelected: (_) => cubit.setPerLayer(true),
              ),
              ChoiceChip(
                label: const Text('Single class'),
                selected: !state.perLayer,
                onSelected: (_) => cubit.setPerLayer(false),
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
                    state.code,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(state.status, style: Theme.of(context).textTheme.bodySmall),
          ]),
        ),
        actions: [
          TextButton(onPressed: cubit.copy, child: const Text('Copy')),
          TextButton(onPressed: cubit.save, child: const Text('Save as .dart')),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
