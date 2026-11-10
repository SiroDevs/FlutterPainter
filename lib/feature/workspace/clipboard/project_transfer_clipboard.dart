// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import '../../../domain/models/drawing/paint_layer.dart';
import '../../../domain/models/drawing/project_transfer.dart';
import '../../editor/bloc/editor_bloc.dart';
import '../../editor/logic/drawing/editor_ops.dart';

/// Keeps copied project content available while the user switches tabs.
class ProjectTransferClipboard extends ValueNotifier<ProjectTransfer?> {
  ProjectTransferClipboard._() : super(null);

  static final ProjectTransferClipboard instance = ProjectTransferClipboard._();

  void copySelection(EditorState state) {
    final indices = state.validSelectedIndices.toSet();
    final shapes = state.selectedShapes;
    if (shapes.isEmpty) return;
    final groupId = shapes.first.groupId;
    if (groupId != null && shapes.every((shape) => shape.groupId == groupId)) {
      final visibleGroupIndices = {
        for (var index = 0; index < state.layer.shapes.length; index++)
          if (state.layer.shapes[index].visible &&
              state.layer.shapes[index].groupId == groupId)
            index,
      };
      if (indices.containsAll(visibleGroupIndices) &&
          visibleGroupIndices.containsAll(indices)) {
        copyGroup(state);
        return;
      }
    }
    value = ProjectTransfer(
      kind: ProjectTransferKind.items,
      shapes: [
        for (final shape in shapes)
          shape.copyWith(groupId: null, groupName: null),
      ],
    );
  }

  void copyGroup(EditorState state) {
    final shapes = state.selectedShapes;
    if (shapes.isEmpty || shapes.first.groupId == null) return;
    final groupId = shapes.first.groupId;
    if (shapes.any((shape) => shape.groupId != groupId)) return;
    final members = state.layer.shapes
        .where((shape) => shape.groupId == groupId)
        .toList();
    value = ProjectTransfer(
      kind: ProjectTransferKind.group,
      shapes: members,
      groupName: members.first.groupName,
    );
  }

  void copyLayer(PaintLayer layer) {
    value = ProjectTransfer(kind: ProjectTransferKind.layer, layer: layer);
  }

  void pasteInto(EditorBloc target) {
    final transfer = value;
    if (transfer != null) target.add(ProjectContentPasted(transfer));
  }
}
