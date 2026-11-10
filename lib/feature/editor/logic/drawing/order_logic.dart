// Project imports:
import '../../bloc/editor_bloc.dart';
import 'editor_ops.dart';

/// Changes selected shapes' drawing order without breaking their selection.
abstract class ShapeOrderLogic {
  ShapeOrderLogic._();

  static EditorState reorder(
    EditorState state,
    int direction, {
    bool toExtreme = false,
  }) {
    final selectedIndices = state.validSelectedIndices..sort();
    final shapes = state.layer.shapes;
    if (selectedIndices.isEmpty || direction == 0) return state;
    if (!toExtreme) return _moveOneStep(state, direction);
    final alreadyAtEdge = direction > 0
        ? selectedIndices.length == shapes.length - selectedIndices.first
        : selectedIndices.length == selectedIndices.last + 1;
    if (alreadyAtEdge) return state;

    final selected = selectedIndices.toSet();
    final selectedShapes = [
      for (var index = 0; index < shapes.length; index++)
        if (selected.contains(index)) shapes[index],
    ];
    final otherShapes = [
      for (var index = 0; index < shapes.length; index++)
        if (!selected.contains(index)) shapes[index],
    ];
    final reordered = direction > 0
        ? [...otherShapes, ...selectedShapes]
        : [...selectedShapes, ...otherShapes];
    final selectionStart = direction > 0 ? otherShapes.length : 0;
    return state.withShapes(reordered).selectIndices([
      for (
        var index = selectionStart;
        index < selectionStart + selectedShapes.length;
        index++
      )
        index,
    ]).commit();
  }

  static EditorState _moveOneStep(EditorState state, int direction) {
    final selected = state.validSelectedIndices.toSet();
    final shapes = [...state.layer.shapes];
    var moved = false;
    if (direction > 0) {
      for (var index = shapes.length - 2; index >= 0; index--) {
        if (selected.contains(index) && !selected.contains(index + 1)) {
          final displaced = shapes[index + 1];
          shapes[index + 1] = shapes[index];
          shapes[index] = displaced;
          selected
            ..remove(index)
            ..add(index + 1);
          moved = true;
        }
      }
    } else {
      for (var index = 1; index < shapes.length; index++) {
        if (selected.contains(index) && !selected.contains(index - 1)) {
          final displaced = shapes[index - 1];
          shapes[index - 1] = shapes[index];
          shapes[index] = displaced;
          selected
            ..remove(index)
            ..add(index - 1);
          moved = true;
        }
      }
    }
    return moved
        ? state.withShapes(shapes).selectIndices(selected.toList()).commit()
        : state;
  }
}
