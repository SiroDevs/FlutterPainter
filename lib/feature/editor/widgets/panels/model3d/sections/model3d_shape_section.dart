// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../../../core/utils/l10n_ext.dart';
import '../../../../../../domain/models/model3d/model3d.dart';
import '../../../../../../domain/models/model3d/points.dart';
import '../../../../../../domain/models/shapes/shape.dart';
import '../../../../bloc/controller/editor_bloc.dart';
import '../support/model3d_edits.dart';
import '../controls/model3d_slider.dart';

const double _thicknessRange = 60;
const double _thicknessInputLimit = 1000;

/// Where the selected shapes are (X, Y, Z) and how thick they are.
class Model3dShapeSection extends StatelessWidget {
  const Model3dShapeSection({
    super.key,
    required this.shape,
    required this.bounds,
    required this.canvasSize,
  });

  final Shape? shape;
  final Rect? bounds;
  final Size canvasSize;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EditorBloc>();
    final current = shape;
    final middle = bounds?.center;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.model3dShape,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        if (current == null || middle == null)
          Text(
            context.l10n.model3dNoShape,
            style: Theme.of(context).textTheme.bodySmall,
          )
        else ...[
          Model3dSlider(
            name: context.l10n.model3dAxisX,
            value: middle.dx,
            min: 0,
            max: canvasSize.width,
            inputMin: -kPositionLimit,
            inputMax: kPositionLimit,
            onChanged: (next) => bloc.add(ShapePlaced(x: next)),
          ),
          Model3dSlider(
            name: context.l10n.model3dAxisY,
            value: middle.dy,
            min: 0,
            max: canvasSize.height,
            inputMin: -kPositionLimit,
            inputMax: kPositionLimit,
            onChanged: (next) => bloc.add(ShapePlaced(y: next)),
          ),
          Model3dSlider(
            name: context.l10n.model3dAxisZ,
            value: current.z,
            min: -kZSliderRange,
            max: kZSliderRange,
            inputMin: -kZRange,
            inputMax: kZRange,
            onChanged: (next) => bloc.add(ShapePlaced(z: next)),
          ),
          Model3dSlider(
            name: context.l10n.model3dThickness,
            value: current.thickness,
            min: 0,
            max: _thicknessRange,
            inputMax: _thicknessInputLimit,
            onChanged: (next) => bloc.add(ShapePlaced(thickness: next)),
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
          context.l10n.model3dAxisX,
          pivot.dx,
          0,
          canvasSize.width,
          (next) => Point3(next, pivot.dy, pivot.dz),
        ),
        _slider(
          context,
          context.l10n.model3dAxisY,
          pivot.dy,
          0,
          canvasSize.height,
          (next) => Point3(pivot.dx, next, pivot.dz),
        ),
        _slider(
          context,
          context.l10n.model3dAxisZ,
          pivot.dz,
          -kZSliderRange,
          kZSliderRange,
          (next) => Point3(pivot.dx, pivot.dy, next),
          inputLimit: kZRange,
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
    Point3 Function(double next) moved, {
    double? inputLimit,
  }) => Model3dSlider(
    name: name,
    value: value,
    min: min,
    max: max,
    inputMin: inputLimit == null ? null : -inputLimit,
    inputMax: inputLimit,
    onChanged: (next) => editModel(
      context,
      (current) => current.copyWith(pivot: moved(next)),
      record: false,
    ),
  );
}
