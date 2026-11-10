// Dart imports:
import 'dart:async';
import 'dart:ui';

// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../core/utils/copy_with_util.dart';
import '../../../domain/models/editor/tool.dart';
import '../../../domain/models/shapes/shape_kind.dart';
import '../../../domain/services/code_import/quick_code_points.dart';
import '../../editor/bloc/editor_bloc.dart';
import '../../editor/logic/drawing/editor_ops.dart';
import '../quick_code_request.dart';

part 'quick_code_state.dart';

/// Edits polygon coordinates or the points of one selected shape.
class QuickCodeCubit extends Cubit<QuickCodeState> {
  QuickCodeCubit(this._editor)
    : super(
        QuickCodeState(
          content: QuickCodePoints.format(const []),
          request: const QuickCodeRequest.polygon(),
          status: QuickCodeStatus.empty,
        ),
      );

  final EditorBloc _editor;
  Timer? _previewTimer;
  Timer? _commitTimer;
  List<Offset>? _pendingPoints;
  List<Offset>? _previewedPoints;

  void open(QuickCodeRequest request) {
    _previewTimer?.cancel();
    _commitTimer?.cancel();
    _pendingPoints = null;
    _previewedPoints = null;
    if (request.isPolygon) {
      _editor
        ..add(const DraftCancelled())
        ..add(const ToolSelected(Tool.polygon));
      emit(
        QuickCodeState(
          content: QuickCodePoints.format(const []),
          request: request,
          status: QuickCodeStatus.empty,
        ),
      );
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
    final content = QuickCodePoints.format(shape.points);
    emit(
      QuickCodeState(
        content: content,
        request: request,
        shapeKind: shape.kind,
        status: _status(content, shape.kind),
      ),
    );
  }

  void edit(String content) {
    final status = _status(content, state.shapeKind);
    emit(state.copyWith(content: content, status: status));
    _pendingPoints = null;
    _previewTimer?.cancel();
    _commitTimer?.cancel();
    if (state.isPolygon) {
      if (status == QuickCodeStatus.empty) {
        _editor.add(const QuickCodePolygonPreviewChanged([]));
        return;
      }
      try {
        final points = QuickCodePoints.parse(content);
        if (points.isNotEmpty) {
          _pendingPoints = points;
          _previewTimer = Timer(const Duration(milliseconds: 100), () {
            _apply(points, commit: false);
          });
        }
      } catch (_) {
        return;
      }
      return;
    }
    if (status != QuickCodeStatus.ready) {
      final previewed = _previewedPoints;
      if (previewed != null) _apply(previewed, commit: true);
      return;
    }
    final points = QuickCodePoints.parse(content);
    _pendingPoints = points;
    _previewTimer = Timer(const Duration(milliseconds: 100), () {
      _apply(points, commit: false);
    });
    if (!state.isPolygon) {
      _commitTimer = Timer(const Duration(milliseconds: 500), () {
        _apply(points, commit: true);
      });
    }
  }

  void addPolygon() {
    if (!state.isPolygon || state.status != QuickCodeStatus.ready) return;
    _previewTimer?.cancel();
    _pendingPoints = null;
    final points = QuickCodePoints.parse(state.content);
    final layer = _editor.state.layerIndex;
    final index = _editor.state.layer.shapes.length;
    _editor.add(QuickCodePolygonApplied(points));
    final request = QuickCodeRequest.shape(
      layerIndex: layer,
      shapeIndex: index,
    );
    emit(
      state.copyWith(
        request: request,
        shapeKind: ShapeKind.polygon,
        status: QuickCodeStatus.ready,
      ),
    );
  }

  QuickCodeStatus _status(String content, ShapeKind? kind) {
    if (content.trim().isEmpty) return QuickCodeStatus.empty;
    try {
      final points = QuickCodePoints.parse(content);
      if (points.isEmpty) return QuickCodeStatus.empty;
      final validCount = switch (kind) {
        ShapeKind.rect || ShapeKind.ellipse => points.length == 2,
        ShapeKind.line => points.length >= 2,
        ShapeKind.polygon => points.length >= 3,
        ShapeKind.freehand => points.length >= 2,
        null => points.length >= 3,
      };
      if (validCount) return QuickCodeStatus.ready;
      return points.length < 2
          ? QuickCodeStatus.tooFew
          : QuickCodeStatus.invalid;
    } catch (_) {
      return QuickCodeStatus.invalid;
    }
  }

  void _apply(List<Offset> points, {required bool commit}) {
    if (_editor.isClosed) return;
    if (commit) _pendingPoints = null;
    if (state.isPolygon) {
      _editor.add(QuickCodePolygonPreviewChanged(points));
      return;
    }
    _previewedPoints = commit ? null : points;
    final layer = state.request.layerIndex;
    final shape = state.request.shapeIndex;
    if (layer == null || shape == null) return;
    _editor.add(
      QuickCodeShapePointsChanged(
        layerIndex: layer,
        shapeIndex: shape,
        points: points,
        commit: commit,
      ),
    );
  }

  @override
  Future<void> close() {
    _previewTimer?.cancel();
    _commitTimer?.cancel();
    final points = _pendingPoints;
    if (points != null && !state.isPolygon) _apply(points, commit: true);
    return super.close();
  }
}
