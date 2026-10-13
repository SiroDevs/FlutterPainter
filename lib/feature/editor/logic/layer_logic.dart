// Project imports:
import '../../../domain/models/paint_layer.dart';
import '../bloc/editor_bloc.dart';
import 'editor_ops.dart';

abstract class LayerLogic {
  LayerLogic._();

  static bool _valid(EditorState s, int i) => i >= 0 && i < s.drawing.layers.length;

  static EditorState add(EditorState s) {
    final layers = [
      ...s.drawing.layers,
      PaintLayer(name: 'Layer ${s.drawing.layers.length + 1}'),
    ];
    return s
        .withLayers(layers)
        .copyWith(layerIndex: layers.length - 1, selected: null)
        .commit();
  }

  static EditorState delete(EditorState s, int i) {
    if (s.drawing.layers.length <= 1 || !_valid(s, i)) return s;
    final layers = removedAt(s.drawing.layers, i);
    return s
        .withLayers(layers)
        .copyWith(layerIndex: s.layerIndex.clamp(0, layers.length - 1).toInt(), selected: null)
        .commit();
  }

  static EditorState rename(EditorState s, int i, String name) {
    if (!_valid(s, i)) return s;
    final layer = s.drawing.layers[i].copyWith(name: name);
    return s.withLayers(replacedAt(s.drawing.layers, i, layer)).commit();
  }

  static EditorState toggleVisible(EditorState s, int i) {
    if (!_valid(s, i)) return s;
    final layer = s.drawing.layers[i];
    final next = s.withLayers(
      replacedAt(s.drawing.layers, i, layer.copyWith(visible: !layer.visible)),
    );
    return (i == s.layerIndex ? next.copyWith(selected: null) : next).commit();
  }

  /// [direction] +1 moves the layer up (drawn later), -1 moves it down.
  static EditorState move(EditorState s, int i, int direction) {
    final j = i + direction;
    if (!_valid(s, i) || !_valid(s, j)) return s;
    final layers = [...s.drawing.layers];
    layers.insert(j, layers.removeAt(i));
    final active = s.layerIndex == i ? j : (s.layerIndex == j ? i : s.layerIndex);
    return s.withLayers(layers).copyWith(layerIndex: active, selected: null).commit();
  }

  /// Which layer receives new shapes. Not an edit, so no history entry.
  static EditorState activate(EditorState s, int i) =>
      _valid(s, i) ? s.copyWith(layerIndex: i, selected: null) : s;
}
