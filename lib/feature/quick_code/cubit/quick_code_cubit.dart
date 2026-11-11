// Dart imports:
import 'dart:async';

// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../core/utils/copy_with_util.dart';
import '../../../domain/models/editor/tool.dart';
import '../../../domain/models/shapes/shape_kind.dart';
import '../../../domain/services/code_import/quick_code_format.dart';
import '../../../domain/services/code_import/quick_code_points.dart';
import '../../../domain/services/code_import/quick_code_validation.dart';
import '../../editor/bloc/editor_bloc.dart';
import '../../editor/logic/drawing/editor_ops.dart';
import '../quick_code_request.dart';

part 'quick_code_state.dart';

/// Edits named polygon data or the points of one selected shape.
class QuickCodeCubit extends Cubit<QuickCodeState> {
  QuickCodeCubit(this._editor)
    : super(
        QuickCodeState(
          content: QuickCodeFormatters.format(const []),
          request: const QuickCodeRequest.polygon(),
          status: QuickCodeStatus.empty,
        ),
      );

  final EditorBloc _editor;
  Timer? _previewTimer;
  Timer? _commitTimer;
  List<QuickCodeShapeData>? _pendingShapes;
  List<QuickCodeShapeData>? _previewedShapes;

  void open(QuickCodeRequest request) {
    _cancelTimers();
    _pendingShapes = null;
    _previewedShapes = null;
    _editor.add(const QuickCodePreviewsChanged([]));
    if (request.isPolygon) {
      _editor
        ..add(const DraftCancelled())
        ..add(const ToolSelected(Tool.polygon));
      emit(_emptyState(request));
      return;
    }
    final layer = request.layerIndex;
    final index = request.shapeIndex;
    final drawing = _editor.state.drawing;
    if (layer == null ||
        index == null ||
        layer < 0 ||
        layer >= drawing.layers.length) {
      open(const QuickCodeRequest.polygon());
      return;
    }
    final shapes = drawing.layers[layer].shapes;
    if (index < 0 || index >= shapes.length) {
      open(const QuickCodeRequest.polygon());
      return;
    }
    final shape = shapes[index];
    final data = QuickCodeShapeData(
      points: shape.points,
      name: shape.name.isEmpty ? null : shape.name,
      groupName: shape.groupName,
    );
    final content = QuickCodeFormatters.formatDartShape(data);
    emit(
      QuickCodeState(
        content: content,
        request: request,
        shapeKind: shape.kind,
        status: QuickCodeStatus.ready,
        shapeCount: 1,
      ),
    );
  }

  void edit(String content) {
    final parsed = _parse(content);
    final status = QuickCodeValidation.status(parsed, state.shapeKind);
    emit(
      state.copyWith(
        content: content,
        status: status,
        format: QuickCodeFormatters.detectFormat(content),
        shapeCount: parsed?.length ?? 0,
      ),
    );
    _pendingShapes = null;
    _cancelTimers();
    if (state.isPolygon) {
      if (status == QuickCodeStatus.empty) {
        _editor.add(const QuickCodePreviewsChanged([]));
      } else if (parsed != null) {
        _previewWithDelay(parsed);
      }
      return;
    }
    if (status != QuickCodeStatus.ready) {
      final previous = _previewedShapes;
      if (previous != null) _applyShape(previous.single, commit: true);
      return;
    }
    if (parsed == null) return;
    final shape = parsed.single;
    _pendingShapes = parsed;
    _previewTimer = Timer(const Duration(milliseconds: 100), () {
      _applyShape(shape, commit: false);
    });
    _commitTimer = Timer(const Duration(milliseconds: 500), () {
      _applyShape(shape, commit: true);
    });
  }

  void toggleFormat() {
    final parsed = _parse(state.content);
    if (!state.canToggleFormat || parsed == null) return;
    final next = state.format == QuickCodeFormat.dartOffsets
        ? QuickCodeFormat.compactCoordinates
        : QuickCodeFormat.dartOffsets;
    final content = next == QuickCodeFormat.dartOffsets
        ? QuickCodeFormatters.formatDartShapes(parsed)
        : QuickCodeFormatters.formatCompactShapes(parsed);
    emit(
      state.copyWith(
        content: content,
        format: next,
        status: QuickCodeValidation.status(parsed, state.shapeKind),
      ),
    );
  }

  void addPolygon() {
    final parsed = _parse(state.content);
    if (!state.isPolygon ||
        state.status != QuickCodeStatus.ready ||
        parsed == null ||
        parsed.isEmpty) {
      return;
    }
    _cancelTimers();
    _pendingShapes = null;
    final layer = _editor.state.layerIndex;
    final index = _editor.state.layer.shapes.length;
    _editor.add(QuickCodePolygonsApplied(parsed));
    if (parsed.length == 1) {
      emit(
        state.copyWith(
          request: QuickCodeRequest.shape(layerIndex: layer, shapeIndex: index),
          shapeKind: ShapeKind.polygon,
          shapeCount: 1,
        ),
      );
      return;
    }
    emit(_emptyState(state.request));
  }

  void clearPreview() => _editor.add(const QuickCodePreviewsChanged([]));
  QuickCodeState _emptyState(QuickCodeRequest request) => QuickCodeState(
    content: QuickCodeFormatters.format(const []),
    request: request,
    status: QuickCodeStatus.empty,
  );

  List<QuickCodeShapeData>? _parse(String content) {
    try {
      return QuickCodePoints.parseShapes(content);
    } catch (_) {
      return null;
    }
  }

  void _previewWithDelay(List<QuickCodeShapeData> shapes) {
    if (shapes.any((shape) => shape.points.isEmpty)) return;
    _pendingShapes = shapes;
    _previewTimer = Timer(const Duration(milliseconds: 100), () {
      _editor.add(QuickCodePreviewsChanged(shapes));
    });
  }

  void _applyShape(QuickCodeShapeData shape, {required bool commit}) {
    if (_editor.isClosed) return;
    if (commit) _pendingShapes = null;
    _previewedShapes = commit ? null : [shape];
    final layer = state.request.layerIndex;
    final index = state.request.shapeIndex;
    if (layer == null || index == null) return;
    _editor.add(
      QuickCodeShapePointsChanged(
        layerIndex: layer,
        shapeIndex: index,
        points: shape.points,
        name: shape.name,
        commit: commit,
      ),
    );
  }

  void _cancelTimers() {
    _previewTimer?.cancel();
    _commitTimer?.cancel();
  }

  @override
  Future<void> close() {
    _cancelTimers();
    final pending = _pendingShapes;
    if (pending != null && !state.isPolygon && pending.length == 1) {
      _applyShape(pending.single, commit: true);
    }
    if (!_editor.isClosed && state.isPolygon) clearPreview();
    return super.close();
  }
}
