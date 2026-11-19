// Dart imports:
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../../domain/models/model3d/model3d.dart';
import '../../../../../domain/models/model3d/view_angle.dart';
import '../../../bloc/editor_bloc.dart';
import '../../../logic/drawing/editor_ops.dart';

export '../../../../../domain/models/model3d/depth_range.dart';

/// Sends a change to the active layer's 3D setup. [record] also makes it one
/// undo step; sliders pass false while dragging and commit when they let go.
void editModel(
  BuildContext context,
  Model3d Function(Model3d model) change, {
  bool record = true,
}) {
  final bloc = context.read<EditorBloc>();
  bloc.add(Model3dEdited(change));
  if (record) bloc.add(const ChangesCommitted());
}

/// Applies [change] to the view at [index], if it still exists.
Model3d updateView(
  Model3d model,
  int index,
  ViewAngle Function(ViewAngle view) change,
) => index >= 0 && index < model.views.length
    ? model.copyWith(
        views: replacedAt(model.views, index, change(model.views[index])),
      )
    : model;

double degreesOf(double radians) => radians * 180 / math.pi;

double radiansOf(double degrees) => degrees * math.pi / 180;

/// Rounds [value] to the nearest multiple of [step].
double snapTo(double value, double step) => (value / step).round() * step;

/// Keeps a remembered list position valid after the list changed.
int clampedIndex(int index, int length) =>
    length == 0 ? 0 : index.clamp(0, length - 1).toInt();
