// Dart imports:
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../core/theme/bloc/theme_bloc.dart';
import '../../editor/bloc/editor_bloc.dart';
import '../../editor/logic/exports.dart';
import '../cubit/workspace_cubit.dart';

export 'groups/exports.dart';

class WorkspaceCommands {
  WorkspaceCommands({
    required this.context,
    required this.ws,
    required this.bloc,
    required this.themeBloc,
    required this.state,
    required this.autoSaveOn,
    required this.dark,
  });

  final BuildContext context;
  final WorkspaceCubit ws;
  final EditorBloc bloc;
  final ThemeBloc themeBloc;
  final EditorState state;
  final bool autoSaveOn;
  final bool dark;

  bool get hasShape => state.selectedShape != null;
  bool get hasImage => state.layer.image != null;

  void send(EditorEvent e) => bloc.add(e);

  Offset get viewCenter {
    final v = bloc.state.view.viewport;
    return Offset(v.width / 2, v.height / 2);
  }

  /// Used by the image slider ranges so the thumb is always inside them.
  static double scaleMin(double scale) => math.min(0.01, scale);
  static double scaleMax(double scale) => math.max(4.0, scale * 1.5);
}
