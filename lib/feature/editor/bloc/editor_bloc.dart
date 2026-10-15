// Dart imports:
import 'dart:typed_data';
import 'dart:ui';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import '../../../core/utils/copy_with_util.dart';
import '../../../core/utils/image_util.dart';
import '../../../domain/models/drawing.dart';
import '../../../domain/models/edit_history.dart';
import '../../../domain/models/reference_image.dart';
import '../../../domain/models/shape.dart';
import '../../../domain/models/tool.dart';
import '../logic/exports.dart';
import '../models/editor_seed.dart';
import '../models/gesture_state.dart';
import '../models/style_settings.dart';
import '../models/view_settings.dart';

part 'editor_event.dart';
part 'editor_state.dart';


/// One bloc per open project (tab). It holds no business logic itself: every
/// event is routed to a pure function in `logic/` that maps the old state to
/// the new one, which keeps the behaviour easy to test without any widgets.
@injectable
class EditorBloc extends Bloc<EditorEvent, EditorState> {
  EditorBloc(@factoryParam EditorSeed seed) : super(EditorState.fromSeed(seed)) {
    _registerPointer();
    _registerView();
    _registerTools();
    _registerStyle();
    _registerShapes();
    _registerLayers();
    _registerDocument();
    _registerImages();
    if (seed.drawing.layers.any((l) => l.image != null)) {
      add(const ImageSyncRequested());
    }
  }

  /// Registers a handler that maps (state, event) to the next state.
  void _reduce<E extends EditorEvent>(
    EditorState Function(EditorState state, E event) reducer,
  ) {
    on<E>((event, emit) => emit(reducer(state, event)));
  }

  void _registerPointer() {
    _reduce<PointerPressed>(PointerLogic.pressed);
    _reduce<PointerMoved>(PointerLogic.moved);
    _reduce<PointerReleased>((s, e) => PointerLogic.released(s));
    _reduce<PointerHovered>((s, e) => PointerLogic.hovered(s, e.point));
  }

  void _registerView() {
    _reduce<ViewPanned>((s, e) => ViewLogic.pan(s, e.delta));
    _reduce<ViewZoomed>((s, e) => ViewLogic.zoomAt(s, e.factor, e.focal));
    _reduce<ViewportChanged>((s, e) => ViewLogic.viewport(s, e.size));
    _reduce<FitRequested>((s, e) => ViewLogic.requestFit(s));
    _reduce<GridToggled>((s, e) => ViewLogic.toggleGrid(s));
    _reduce<SnapToggled>((s, e) => ViewLogic.toggleSnap(s));
    _reduce<BackgroundCycled>((s, e) => ViewLogic.cycleBackground(s));
  }

  void _registerTools() {
    _reduce<ToolSelected>((s, e) => ToolLogic.select(s, e.tool));
    _reduce<PolygonFinished>((s, e) => DrawLogic.finishPolygon(s, closed: e.closed));
    _reduce<DraftCancelled>((s, e) => DrawLogic.cancelDraft(s));
    _reduce<ChangesCommitted>((s, e) => s.commit());
    on<UndoRequested>((event, emit) async {
      emit(HistoryLogic.undo(state));
      await _syncImages(emit);
    });
    on<RedoRequested>((event, emit) async {
      emit(HistoryLogic.redo(state));
      await _syncImages(emit);
    });
  }

  void _registerStyle() {
    _reduce<StyleTargetChanged>((s, e) => StyleLogic.target(s, e.editFill));
    _reduce<ColorPicked>((s, e) => StyleLogic.pick(s, e.color));
    _reduce<StrokeColorPicked>((s, e) => StyleLogic.pickStroke(s, e.color));
    _reduce<FillToggled>((s, e) => StyleLogic.toggleFill(s, e.on));
    _reduce<StrokeToggled>((s, e) => StyleLogic.toggleStroke(s, e.on));
    _reduce<StrokeWidthChanged>((s, e) => StyleLogic.strokeWidth(s, e.width));
    _reduce<RadiusChanged>((s, e) => StyleLogic.radius(s, e.radius));
  }

  void _registerShapes() {
    _reduce<ShapeDeleted>((s, e) => ShapeLogic.delete(s));
    _reduce<ShapeDuplicated>((s, e) => ShapeLogic.duplicate(s));
    _reduce<ShapeReordered>((s, e) => ShapeLogic.reorder(s, e.direction));
    _reduce<ShapeMovedToLayer>((s, e) => ShapeLogic.moveToLayer(s, e.layer));
    _reduce<ShapeRenamed>((s, e) => ShapeLogic.rename(s, e.name));
    _reduce<ClosedToggled>((s, e) => VertexLogic.setClosed(s, e.closed));
  }

  void _registerLayers() {
    _reduce<LayerAdded>((s, e) => LayerLogic.add(s));
    _reduce<LayerDeleted>((s, e) => LayerLogic.delete(s, e.index));
    _reduce<LayerRenamed>((s, e) => LayerLogic.rename(s, e.index, e.name));
    _reduce<LayerVisibilityToggled>((s, e) => LayerLogic.toggleVisible(s, e.index));
    _reduce<LayerMoved>((s, e) => LayerLogic.move(s, e.index, e.direction));
    _reduce<LayerActivated>((s, e) => LayerLogic.activate(s, e.index));
  }

  void _registerDocument() {
    _reduce<DrawingRenamed>((s, e) => DocumentLogic.rename(s, e.name));
    _reduce<CanvasResized>((s, e) => DocumentLogic.resizeCanvas(s, e.width, e.height));
    _reduce<DocumentSaved>((s, e) => DocumentLogic.saved(s, e.path));
  }

  void _registerImages() {
    on<ImageLoaded>(_onImageLoaded);
    on<ImageSyncRequested>((event, emit) => _syncImages(emit));
    _reduce<ImageRemoved>((s, e) => ImageLogic.remove(s));
    _reduce<ImageFitted>((s, e) => ImageLogic.fit(s));
    _reduce<ImageSelected>((s, e) => ImageLogic.select(s));
    _reduce<ImageVisibilityChanged>(
      (s, e) => ImageLogic.visibility(s, e.visible),
    );
    _reduce<ImageOpacityChanged>((s, e) => ImageLogic.opacity(s, e.opacity));
    _reduce<ImageScaleChanged>((s, e) => ImageLogic.scale(s, e.scale));
  }

  Future<void> _onImageLoaded(
    ImageLoaded event,
    Emitter<EditorState> emit,
  ) async {
    final ref = ReferenceImage.fromBytes(event.bytes);
    // The same picture may already be decoded (another layer, or an undo step).
    final cached = state.images[ref.id];
    final pixels = cached ?? await decodeImageBytes(event.bytes);
    if (isClosed) {
      if (cached == null) pixels.dispose();
      return;
    }
    emit(ImageLogic.loaded(state, ref, pixels, onNewLayer: event.onNewLayer));
  }

  /// Decodes the picture of every layer that has one not decoded yet, e.g.
  /// after a file load or an undo that brought a picture back.
  Future<void> _syncImages(Emitter<EditorState> emit) async {
    final wanted = <ReferenceImage>[];
    final seen = <String>{};
    for (final layer in state.drawing.layers) {
      final ref = layer.image;
      if (ref != null && !state.images.containsKey(ref.id) && seen.add(ref.id)) {
        wanted.add(ref);
      }
    }
    for (final ref in wanted) {
      final pixels = await decodeImageBytes(ref.bytes);
      if (isClosed || state.images.containsKey(ref.id)) {
        pixels.dispose();
        if (isClosed) return;
        continue;
      }
      emit(state.copyWith(images: {...state.images, ref.id: pixels}));
    }
  }

  @override
  Future<void> close() {
    for (final pixels in state.images.values) {
      pixels.dispose();
    }
    return super.close();
  }
}
