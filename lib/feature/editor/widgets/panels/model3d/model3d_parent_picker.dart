// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../../core/utils/l10n_ext.dart';
import '../../../../../domain/models/model3d/model3d.dart';
import 'model3d_edits.dart';
import 'model3d_parts.dart';

/// Picks the part another part hangs from, so it follows that part's folds
/// and poses. A part cannot hang from one that hangs from it.
class Model3dParentPicker extends StatelessWidget {
  const Model3dParentPicker({
    super.key,
    required this.model,
    required this.part,
    required this.parts,
  });

  final Model3d model;
  final PartEntry part;
  final List<PartEntry> parts;

  @override
  Widget build(BuildContext context) {
    final options = [
      for (final other in parts)
        if (other.id != part.id && !hangsFrom(model, other.id, part.id)) other,
    ];
    final parentId = rigOf(model, part).parentId;
    return Row(
      children: [
        Text(context.l10n.model3dPartParent),
        const SizedBox(width: 8),
        DropdownButton<String?>(
          isDense: true,
          value: options.any((other) => other.id == parentId) ? parentId : null,
          items: [
            DropdownMenuItem<String?>(
              value: null,
              child: Text(context.l10n.model3dPartParentNone),
            ),
            for (final other in options)
              DropdownMenuItem<String?>(
                value: other.id,
                child: Text(other.name),
              ),
          ],
          onChanged: (id) => editModel(
            context,
            (current) =>
                withRig(current, part, (rig) => rig.copyWith(parentId: id)),
          ),
        ),
      ],
    );
  }
}
