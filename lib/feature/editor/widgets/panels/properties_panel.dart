// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../common/widgets/dialogs/app_dialogs.dart';
import '../../../../common/widgets/inputs/labeled_slider.dart';
import '../../../../core/utils/l10n_ext.dart';
import '../../../../domain/models/shapes/shape.dart';
import '../../../../domain/models/shapes/shape_kind.dart';
import '../../../../domain/models/editor/tool.dart';
import '../../bloc/editor_bloc.dart';
import '../../logic/drawing/editor_ops.dart';
import 'property_style_controls.dart';

/// Style controls. They edit the selected shape, or set the style used for the
/// next shapes when nothing is selected.
class PropertiesPanel extends StatelessWidget {
  const PropertiesPanel({super.key});

  Future<void> _rename(BuildContext context, Shape s) async {
    final bloc = context.read<EditorBloc>();
    final name = await promptText(
      context,
      title: 'Rename shape',
      initial: s.name,
    );
    if (name != null) bloc.add(ShapeRenamed(name));
  }

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
              _selectionInfo(context, state, s),
              if (s != null && s.usesVertices && s.points.length >= 3) ...[
                const SizedBox(width: 12),
                _closedShapeControl(s, bloc),
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
                      label: 'Corner radius: ${st.radius.toStringAsFixed(2)}',
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

  Widget _selectionInfo(BuildContext context, EditorState state, Shape? shape) {
    final selectionCount = state.validSelectedIndices.length;
    return SizedBox(
      width: 240,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Properties', style: Theme.of(context).textTheme.titleSmall),
          if (selectionCount > 1)
            Text(
              context.l10n.shapeSelectionCount(selectionCount),
              style: Theme.of(context).textTheme.bodySmall,
            )
          else if (shape == null)
            Text(
              'No shape selected. These settings apply to the next shape you draw.',
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          else ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    shape.name.isEmpty ? shape.kind.name : shape.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  tooltip: 'Rename shape',
                  iconSize: 18,
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints.tightFor(
                    width: 32,
                    height: 32,
                  ),
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => _rename(context, shape),
                ),
              ],
            ),
            Text(
              _bounds(shape),
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (selectionCount > 0)
            Text(
              context.l10n.shapeRotateHint,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }

  Widget _closedShapeControl(Shape shape, EditorBloc bloc) => SizedBox(
    width: 190,
    child: Row(
      children: [
        Checkbox(
          value: shape.kind == ShapeKind.polygon,
          onChanged: (value) => bloc.add(ClosedToggled(value ?? false)),
        ),
        const Expanded(child: Text('Closed shape (can be filled)')),
      ],
    ),
  );

  String _bounds(Shape s) {
    final b = s.bounds;
    String f(double v) => v.toStringAsFixed(1);
    return 'x ${f(b.left)}  y ${f(b.top)}  w ${f(b.width)}  h ${f(b.height)}';
  }
}
