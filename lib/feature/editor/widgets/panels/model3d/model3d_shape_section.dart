// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../../core/utils/l10n_ext.dart';
import '../../../../../domain/models/model3d/model3d.dart';
import '../../../../../domain/models/model3d/point3.dart';
import '../../../../../domain/models/shapes/shape.dart';
import '../../../bloc/editor_bloc.dart';
import 'model3d_edits.dart';
import 'model3d_slider.dart';

const double _thicknessRange = 60;
const double _thicknessInputLimit = 1000;

/// Depth and thickness of the selected shapes.
class Model3dShapeSection extends StatelessWidget {
  const Model3dShapeSection({super.key, required this.shape});

  final Shape? shape;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EditorBloc>();
    final current = shape;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.model3dShape,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        if (current == null)
          Text(
            context.l10n.model3dNoShape,
            style: Theme.of(context).textTheme.bodySmall,
          )
        else ...[
          Model3dSlider(
            name: context.l10n.model3dDepth,
            value: current.depth,
            min: -kDepthRange,
            max: kDepthRange,
            onChanged: (next) =>
                bloc.add(ShapeDepthChanged(depth: next)),
          ),
          Model3dSlider(
            name: context.l10n.model3dThickness,
            value: current.thickness,
            min: 0,
            max: _thicknessRange,
            inputMax: _thicknessInputLimit,
            onChanged: (next) =>
                bloc.add(ShapeDepthChanged(thickness: next)),
          ),
        ],
      ],
    );
  }
}

/// The point the object turns around.
class Model3dPivotSection extends StatelessWidget {
  const Model3dPivotSection({
    super.key,
    required this.model,
    required this.canvasSize,
  });

  final Model3d model;
  final Size canvasSize;

  @override
  Widget build(BuildContext context) {
    final pivot = model.pivot;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.model3dPivot,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        _slider(
          context,
          context.l10n.model3dAcross,
          pivot.dx,
          0,
          canvasSize.width,
          (next) => Point3(next, pivot.dy, pivot.dz),
        ),
        _slider(
          context,
          context.l10n.model3dDown,
          pivot.dy,
          0,
          canvasSize.height,
          (next) => Point3(pivot.dx, next, pivot.dz),
        ),
        _slider(
          context,
          context.l10n.model3dDepth,
          pivot.dz,
          -kDepthRange,
          kDepthRange,
          (next) => Point3(pivot.dx, pivot.dy, next),
        ),
      ],
    );
  }

  Widget _slider(
    BuildContext context,
    String name,
    double value,
    double min,
    double max,
    Point3 Function(double next) moved,
  ) => Model3dSlider(
    name: name,
    value: value,
    min: min,
    max: max,
    onChanged: (next) => editModel(
      context,
      (current) => current.copyWith(pivot: moved(next)),
      record: false,
    ),
  );
}
