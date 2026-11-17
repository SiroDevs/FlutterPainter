// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../../core/utils/l10n_ext.dart';
import '../../../../../domain/models/model3d/view_angle.dart';
import 'model3d_edits.dart';
import 'model3d_parts.dart';

/// A checkbox that shows or hides a part in one view.
class Model3dPartVisibility extends StatelessWidget {
  const Model3dPartVisibility({
    super.key,
    required this.part,
    required this.view,
    required this.viewIndex,
  });

  final PartEntry part;
  final ViewAngle view;
  final int viewIndex;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Checkbox(
        value: !view.hidden.contains(part.id),
        onChanged: (visible) => editModel(
          context,
          (current) => updateView(current, viewIndex, (item) {
            final hidden = {...item.hidden};
            visible == true ? hidden.remove(part.id) : hidden.add(part.id);
            return item.copyWith(hidden: hidden);
          }),
        ),
      ),
      Expanded(child: Text(context.l10n.model3dPartVisible)),
    ],
  );
}
