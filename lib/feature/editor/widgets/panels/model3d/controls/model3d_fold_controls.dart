// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../../../core/utils/l10n_ext.dart';
import '../../../../../../domain/models/model3d/model3d.dart';
import '../../../../../../domain/models/shapes/shape.dart';
import '../../../../../../domain/models/shapes/shape_kind.dart';
import '../../../../../../domain/services/geometry/hinge_edges.dart';
import '../../../../bloc/controller/editor_bloc.dart';
import '../support/model3d_edits.dart';
import '../support/model3d_parts.dart';
import 'model3d_slider.dart';

/// Folds and bends the selected part, adds faces next to its edges, and
/// switches to working on it face-on.
class Model3dFoldControls extends StatefulWidget {
  const Model3dFoldControls({
    super.key,
    required this.model,
    required this.part,
    required this.shapes,
    required this.workingPart,
    required this.faceNumber,
  });

  final Model3d model;
  final PartEntry part;
  final List<Shape> shapes;
  final String? workingPart;
  final int faceNumber;

  @override
  State<Model3dFoldControls> createState() => _Model3dFoldControlsState();
}

class _Model3dFoldControlsState extends State<Model3dFoldControls> {
  int _edge = 0;

  @override
  Widget build(BuildContext context) {
    final rig = rigOf(widget.model, widget.part);
    final working = widget.workingPart == widget.part.id;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.model3dFoldHint,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        _slider(
          context,
          context.l10n.model3dFold,
          rig.fold,
          180,
          (rig, radians) => rig.copyWith(fold: radians),
        ),
        _slider(
          context,
          context.l10n.model3dBend,
          rig.bend,
          270,
          (rig, radians) => rig.copyWith(bend: radians),
        ),
        _slider(
          context,
          context.l10n.model3dAxis,
          rig.axisAngle,
          180,
          (rig, radians) => rig.copyWith(axisAngle: radians),
        ),
        OutlinedButton.icon(
          icon: Icon(working ? Icons.stop_outlined : Icons.draw_outlined),
          label: Text(
            working
                ? context.l10n.model3dWorkStop
                : context.l10n.model3dWorkStart,
          ),
          onPressed: () => context.read<EditorBloc>().add(
            WorkPartChanged(working ? null : widget.part.id),
          ),
        ),
        if (working)
          Text(
            context.l10n.model3dWorkNote(widget.part.name),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ..._addFace(context),
      ],
    );
  }

  Widget _slider(
    BuildContext context,
    String name,
    double radians,
    double range,
    PartRigChange change,
  ) => Model3dSlider(
    name: name,
    unit: '°',
    value: degreesOf(radians),
    min: -range,
    max: range,
    onChanged: (next) => editModel(
      context,
      (current) => withRig(
        current,
        widget.part,
        (rig) => change(rig, radiansOf(next)),
      ),
      record: false,
    ),
  );

  List<Widget> _addFace(BuildContext context) {
    final shape = _hingeShape();
    if (shape == null) return const [];
    final count = hingeEdgesOf(shape).length;
    final edge = _edge.clamp(0, count - 1).toInt();
    return [
      Row(
        children: [
          Text(context.l10n.model3dAddFaceOn),
          const SizedBox(width: 8),
          DropdownButton<int>(
            isDense: true,
            value: edge,
            items: [
              for (var index = 0; index < count; index++)
                DropdownMenuItem(
                  value: index,
                  child: Text(_label(context, shape, index)),
                ),
            ],
            onChanged: (next) => setState(() => _edge = next ?? 0),
          ),
          IconButton(
            tooltip: context.l10n.model3dAddFace,
            icon: const Icon(Icons.add_box_outlined),
            onPressed: () => context.read<EditorBloc>().add(
              FaceAdded(
                partId: widget.part.id,
                edgeIndex: edge,
                name: context.l10n.model3dFaceName('${widget.faceNumber}'),
              ),
            ),
          ),
        ],
      ),
    ];
  }

  Shape? _hingeShape() {
    for (final shape in widget.shapes) {
      if (shape.groupId == widget.part.id && hingeEdgesOf(shape).isNotEmpty) {
        return shape;
      }
    }
    return null;
  }

  String _label(BuildContext context, Shape shape, int index) {
    if (shape.kind != ShapeKind.rect) {
      return context.l10n.model3dEdgeNumber('${index + 1}');
    }
    return [
      context.l10n.model3dEdgeTop,
      context.l10n.model3dEdgeRight,
      context.l10n.model3dEdgeBottom,
      context.l10n.model3dEdgeLeft,
    ][index];
  }
}
