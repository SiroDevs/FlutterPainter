// Package imports:
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import '../../../core/platform/file_dialogs.dart';
import '../../../domain/models/drawing.dart';
import '../../../domain/services/dart_exporter.dart';

part 'export_state.dart';

/// Generates the Dart code for a drawing and lets the user copy or save it.
@injectable
class ExportCubit extends Cubit<ExportState> {
  ExportCubit(this._dialogs) : super(const ExportState());

  final FileDialogs _dialogs;
  Drawing? _drawing;

  void start(Drawing drawing) {
    _drawing = drawing;
    _generate(state.perLayer);
  }

  void setPerLayer(bool perLayer) => _generate(perLayer);

  void _generate(bool perLayer) {
    final d = _drawing;
    if (d == null) return;
    emit(state.copyWith(
      perLayer: perLayer,
      code: DartExporter(d, classPerLayer: perLayer).generate(),
      status: '',
    ));
  }

  Future<void> copy() async {
    await Clipboard.setData(ClipboardData(text: state.code));
    emit(state.copyWith(status: 'Copied to clipboard'));
  }

  Future<void> save() async {
    try {
      final path = await _dialogs.saveDartFile(state.code);
      if (path != null) emit(state.copyWith(status: 'Saved $path'));
    } catch (e) {
      emit(state.copyWith(status: 'Could not save: $e'));
    }
  }
}
