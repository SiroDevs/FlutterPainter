// Dart imports:
import 'dart:ui';

// Project imports:
import '../model/drawing.dart';
import '../model/shape.dart';
import 'editor_controller.dart';

/// Layer and shape-ordering operations, kept apart so the controller stays
/// focused on state.
extension LayerOps on EditorController {
  void setActiveLayer(int i) {
    layerIndex = i;
    selected = null;
    changed(record: false);
  }

  void addLayer() {
    drawing.layers.add(Layer(name: 'Layer ${drawing.layers.length + 1}'));
    layerIndex = drawing.layers.length - 1;
    selected = null;
    changed();
  }

  void deleteLayer(int i) {
    if (drawing.layers.length <= 1) return;
    drawing.layers.removeAt(i);
    layerIndex = layerIndex.clamp(0, drawing.layers.length - 1).toInt();
    selected = null;
    changed();
  }

  void renameLayer(int i, String name) {
    drawing.layers[i].name = name;
    changed();
  }

  void toggleVisible(int i) {
    drawing.layers[i].visible = !drawing.layers[i].visible;
    if (i == layerIndex) selected = null;
    changed();
  }

  /// [dir] +1 moves the layer up (drawn later), -1 moves it down.
  void moveLayer(int i, int dir) {
    final j = i + dir;
    if (j < 0 || j >= drawing.layers.length) return;
    drawing.layers.insert(j, drawing.layers.removeAt(i));
    layerIndex = layerIndex == i ? j : (layerIndex == j ? i : layerIndex);
    selected = null;
    changed();
  }

  void deleteSelected() {
    final i = selected;
    if (i == null || selectedShape == null) return;
    layer.shapes.removeAt(i);
    selected = null;
    changed();
  }

  void duplicateSelected() {
    final s = selectedShape;
    if (s == null) return;
    final copy = s.copy()
      ..points = [for (final p in s.points) p + const Offset(3, 3)]
      ..name = '${s.name} copy';
    layer.shapes.add(copy);
    selected = layer.shapes.length - 1;
    changed();
  }

  /// [dir] +1 draws the shape later (in front), -1 earlier (behind).
  void reorderSelected(int dir) {
    final i = selected;
    if (i == null || selectedShape == null) return;
    final j = i + dir;
    if (j < 0 || j >= layer.shapes.length) return;
    layer.shapes.insert(j, layer.shapes.removeAt(i));
    selected = j;
    changed();
  }

  void moveSelectedToLayer(int target) {
    final i = selected;
    final s = selectedShape;
    if (i == null || s == null || target == layerIndex) return;
    layer.shapes.removeAt(i);
    drawing.layers[target].shapes.add(s);
    drawing.layers[target].visible = true;
    layerIndex = target;
    selected = drawing.layers[target].shapes.length - 1;
    changed();
  }

  void renameSelected(String name) {
    final Shape? s = selectedShape;
    if (s == null) return;
    s.name = name;
    changed();
  }

  void setCanvasSize(double w, double h) {
    drawing.width = w;
    drawing.height = h;
    needsFit = true;
    changed();
  }

  void renameDrawing(String name) {
    drawing.name = name;
    changed();
  }
}
