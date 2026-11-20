// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../../common/widgets/dialogs/app_dialogs.dart';
import '../../../../../common/widgets/inputs/item_chip_row.dart';
import '../../../../../core/utils/l10n_ext.dart';
import '../../../../../domain/models/model3d/model3d.dart';
import '../../../../../domain/models/model3d/view_angle.dart';
import '../../../logic/drawing/editor_ops.dart';
import 'model3d_edits.dart';
import 'model3d_slider.dart';

/// The named camera angles of a 3D layer; each one exports as a flat layer.
class Model3dViewsSection extends StatelessWidget {
  const Model3dViewsSection({
    super.key,
    required this.model,
    required this.selected,
    required this.onSelected,
  });

  final Model3d model;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final views = model.views;
    final view = views.isEmpty ? null : views[selected];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.model3dViews,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        ItemChipRow(
          labels: [for (final item in views) item.name],
          selected: selected,
          onSelected: onSelected,
          onAdd: () => _add(context),
          addTooltip: context.l10n.model3dViewAdd,
          onRename: view == null ? null : () => _rename(context, view),
          renameTooltip: context.l10n.model3dViewRename,
          onDelete: view == null ? null : () => _delete(context),
          deleteTooltip: context.l10n.model3dViewDelete,
        ),
        if (view != null) ..._sliders(context, view),
      ],
    );
  }

  List<Widget> _sliders(BuildContext context, ViewAngle view) => [
    Model3dSlider(
      name: context.l10n.model3dTurn,
      unit: '°',
      value: degreesOf(view.yaw),
      min: -85,
      max: 85,
      onChanged: (next) => _change(
        context,
        (item) => item.copyWith(yaw: radiansOf(next)),
      ),
    ),
    Model3dSlider(
      name: context.l10n.model3dTilt,
      unit: '°',
      value: degreesOf(view.pitch),
      min: -85,
      max: 85,
      onChanged: (next) => _change(
        context,
        (item) => item.copyWith(pitch: radiansOf(next)),
      ),
    ),
    Model3dSlider(
      name: context.l10n.model3dZoom,
      step: 0.01,
      decimals: 2,
      value: view.scale,
      min: 0.5,
      max: 2,
      onChanged: (next) =>
          _change(context, (item) => item.copyWith(scale: next)),
    ),
  ];

  void _change(
    BuildContext context,
    ViewAngle Function(ViewAngle view) change,
  ) => editModel(
    context,
    (current) => updateView(current, selected, change),
    record: false,
  );

  void _add(BuildContext context) {
    final name = context.l10n.model3dDefaultViewName(
      '${model.views.length + 1}',
    );
    editModel(
      context,
      (current) =>
          current.copyWith(views: [...current.views, ViewAngle(name: name)]),
    );
    onSelected(model.views.length);
  }

  Future<void> _rename(BuildContext context, ViewAngle view) async {
    final name = await promptText(
      context,
      title: context.l10n.model3dViewRename,
      initial: view.name,
    );
    if (name == null || name.isEmpty || !context.mounted) return;
    editModel(
      context,
      (current) =>
          updateView(current, selected, (item) => item.copyWith(name: name)),
    );
  }

  void _delete(BuildContext context) {
    editModel(
      context,
      (current) => selected < current.views.length
          ? current.copyWith(views: removedAt(current.views, selected))
          : current,
    );
    onSelected(selected > 0 ? selected - 1 : 0);
  }
}
