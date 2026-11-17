// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../../common/widgets/dialogs/app_dialogs.dart';
import '../../../../../common/widgets/inputs/item_chip_row.dart';
import '../../../../../core/utils/l10n_ext.dart';
import '../../../../../domain/models/model3d/model3d.dart';
import '../../../../../domain/models/model3d/point3.dart';
import '../../../../../domain/models/model3d/tyre_spec.dart';
import '../../../logic/drawing/editor_ops.dart';
import 'model3d_edits.dart';
import 'model3d_slider.dart';
import 'model3d_tyre_colors.dart';

/// The tyres of a 3D layer: round parts built from numbers instead of shapes.
class Model3dTyresSection extends StatelessWidget {
  const Model3dTyresSection({
    super.key,
    required this.model,
    required this.selected,
    required this.canvasSize,
    required this.onSelected,
  });

  final Model3d model;
  final int selected;
  final Size canvasSize;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final tyres = model.tyres;
    final tyre = tyres.isEmpty ? null : tyres[selected];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.model3dTyres,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        ItemChipRow(
          labels: [for (final item in tyres) item.name],
          selected: selected,
          onSelected: onSelected,
          onAdd: () => _add(context),
          addTooltip: context.l10n.model3dTyreAdd,
          onRename: tyre == null ? null : () => _rename(context, tyre),
          renameTooltip: context.l10n.model3dTyreRename,
          onDelete: tyre == null ? null : () => _delete(context),
          deleteTooltip: context.l10n.model3dTyreDelete,
        ),
        if (tyre == null)
          Text(
            context.l10n.model3dTyreNone,
            style: Theme.of(context).textTheme.bodySmall,
          )
        else ...[
          ..._position(context, tyre),
          ..._shape(context, tyre),
          Model3dTyreColors(
            style: tyre.style,
            onChanged: (style) => editModel(
              context,
              (current) => updateTyre(
                current,
                selected,
                (item) => item.copyWith(style: style),
              ),
            ),
          ),
        ],
      ],
    );
  }

  List<Widget> _position(BuildContext context, TyreSpec tyre) {
    final centre = tyre.centre;
    return [
      _slider(
        context,
        context.l10n.model3dAcross,
        centre.dx,
        0,
        canvasSize.width,
        (item, next) => item.copyWith(
          centre: Point3(next, centre.dy, centre.dz),
        ),
      ),
      _slider(
        context,
        context.l10n.model3dDown,
        centre.dy,
        0,
        canvasSize.height,
        (item, next) => item.copyWith(
          centre: Point3(centre.dx, next, centre.dz),
        ),
      ),
      _slider(
        context,
        context.l10n.model3dDepth,
        centre.dz,
        -kDepthRange,
        kDepthRange,
        (item, next) => item.copyWith(
          centre: Point3(centre.dx, centre.dy, next),
        ),
      ),
    ];
  }

  List<Widget> _shape(BuildContext context, TyreSpec tyre) => [
    _slider(context, context.l10n.model3dRadius, tyre.radius, 1, 80,
        (item, next) => item.copyWith(radius: next)),
    _slider(context, context.l10n.model3dWidth, tyre.width, 1, 60,
        (item, next) => item.copyWith(width: next)),
    _slider(context, context.l10n.model3dTreads, tyre.treadCount.toDouble(), 4,
        40, (item, next) => item.copyWith(treadCount: next.round()),
        step: 1, decimals: 0),
    _slider(context, context.l10n.model3dSpin, degreesOf(tyre.spin), 0, 360,
        (item, next) => item.copyWith(spin: radiansOf(next)),
        step: 1, decimals: 0),
    _slider(context, context.l10n.model3dShoulder, tyre.shoulder, 0, 1,
        (item, next) => item.copyWith(shoulder: next),
        step: 0.01, decimals: 2),
    _slider(context, context.l10n.model3dSidewall, tyre.sidewallShare, 0.3, 1,
        (item, next) => item.copyWith(sidewallShare: next),
        step: 0.01, decimals: 2),
    _slider(context, context.l10n.model3dHub, tyre.hubShare, 0.05, 0.9,
        (item, next) => item.copyWith(hubShare: next),
        step: 0.01, decimals: 2),
  ];

  Widget _slider(
    BuildContext context,
    String name,
    double value,
    double min,
    double max,
    TyreSpec Function(TyreSpec tyre, double next) apply, {
    double step = 0.5,
    int decimals = 1,
  }) => Model3dSlider(
    name: name,
    valueText: value.toStringAsFixed(decimals),
    value: value,
    min: min,
    max: max,
    onChanged: (next) =>
        _change(context, (item) => apply(item, snapTo(next, step))),
  );

  void _change(BuildContext context, TyreSpec Function(TyreSpec tyre) change) =>
      editModel(
        context,
        (current) => updateTyre(current, selected, change),
        record: false,
      );

  void _add(BuildContext context) {
    final name = context.l10n.model3dDefaultTyreName(
      '${model.tyres.length + 1}',
    );
    editModel(
      context,
      (current) => current.copyWith(
        tyres: [
          ...current.tyres,
          TyreSpec(
            name: name,
            centre: Point3(current.pivot.dx, current.pivot.dy - 30, 0),
            radius: 30,
            width: 16,
          ),
        ],
      ),
    );
    onSelected(model.tyres.length);
  }

  Future<void> _rename(BuildContext context, TyreSpec tyre) async {
    final name = await promptText(
      context,
      title: context.l10n.model3dTyreRename,
      initial: tyre.name,
    );
    if (name == null || name.isEmpty || !context.mounted) return;
    // The tyre's part id follows its name, so its joint and poses move too.
    final newPartId = tyre.copyWith(name: name).partId;
    editModel(
      context,
      (current) => updateTyre(
        current,
        selected,
        (item) => item.copyWith(name: name),
      ).renamePart(tyre.partId, newPartId),
    );
  }

  void _delete(BuildContext context) {
    editModel(
      context,
      (current) => selected < current.tyres.length
          ? current.copyWith(tyres: removedAt(current.tyres, selected))
          : current,
    );
    onSelected(selected > 0 ? selected - 1 : 0);
  }
}
