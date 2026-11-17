// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../common/widgets/inputs/labeled_slider.dart';
import '../../../../core/utils/l10n_ext.dart';
import '../../../../domain/models/editor/tool.dart';
import '../../../../domain/models/shapes/shape.dart';
import '../../../../domain/models/shapes/shape_kind.dart';
import '../../bloc/editor_bloc.dart';
import '../../logic/drawing/editor_ops.dart';
import 'property_selection_info.dart';
import 'property_style_controls.dart';

/// Style controls. They edit the selected shape, or set the style used for the
/// next shapes when nothing is selected.
class PropertiesPanel extends StatelessWidget {
  const PropertiesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EditorBloc>();
    return BlocBuilder<EditorBloc, EditorState>(
      builder: (context, state) {
        final s = state.selectedShape;
        final selectionCount = state.validSelectedIndices.length;
        final st = state.style;
        final showRadius = state.tool == Tool.rect || s?.kind == ShapeKind.rect;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PropertySelectionInfo(state: state, shape: s, bloc: bloc),
              if (s != null && s.usesVertices && s.points.length >= 3) ...[
                const SizedBox(width: 12),
                _closedShapeControl(context, s, bloc),
              ],
              if (selectionCount <= 1) ...[
                const SizedBox(width: 12),
                PropertyStyleControls(style: st),
                if (showRadius) ...[
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 190,
                    child: LabeledSlider(
                      compact: true,
                      label: context.l10n.propertyCornerRadius(
                        st.radius.toStringAsFixed(2),
                      ),
                      value: st.radius,
                      min: 0,
                      max: 40,
                      onChanged: (v) =>
                          bloc.add(RadiusChanged((v * 4).round() / 4)),
                      onChangeEnd: () => bloc.add(const ChangesCommitted()),
                    ),
                  ),
                ],
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _closedShapeControl(
    BuildContext context,
    Shape shape,
    EditorBloc bloc,
  ) => SizedBox(
    width: 190,
    child: Row(
      children: [
        Checkbox(
          value: shape.kind == ShapeKind.polygon,
          onChanged: (value) => bloc.add(ClosedToggled(value ?? false)),
        ),
        Expanded(child: Text(context.l10n.propertyClosedShape)),
      ],
    ),
  );
}
