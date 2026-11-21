// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../../../core/utils/l10n_ext.dart';
import '../../../../../../domain/models/model3d/model3d.dart';
import '../../../../../../domain/models/model3d/view_angle.dart';
import '../../../../bloc/controller/editor_bloc.dart';
import '../support/model3d_edits.dart';

const double _startTurn = -0.5;
const double _startTilt = 0.35;

/// Switch for the live 3D camera, and a way to keep its angle as a view.
class Model3dLiveSection extends StatelessWidget {
  const Model3dLiveSection({
    super.key,
    required this.camera,
    required this.model,
  });

  final ViewAngle? camera;
  final Model3d model;

  @override
  Widget build(BuildContext context) {
    final live = camera;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: live != null,
              onChanged: (on) => context.read<EditorBloc>().add(
                LiveCameraChanged(
                  on == true
                      ? ViewAngle(
                          name: context.l10n.model3dLive,
                          yaw: _startTurn,
                          pitch: _startTilt,
                        )
                      : null,
                ),
              ),
            ),
            Expanded(child: Text(context.l10n.model3dLive)),
          ],
        ),
        if (live != null) ...[
          Text(
            context.l10n.model3dLiveNote,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          TextButton(
            onPressed: () => _saveView(context, live),
            child: Text(context.l10n.model3dLiveSave),
          ),
        ],
      ],
    );
  }

  void _saveView(BuildContext context, ViewAngle live) {
    final name = context.l10n.model3dDefaultViewName(
      '${model.views.length + 1}',
    );
    editModel(
      context,
      (current) =>
          current.copyWith(views: [...current.views, live.copyWith(name: name)]),
    );
  }
}
