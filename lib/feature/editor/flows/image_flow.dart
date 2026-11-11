// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../common/widgets/progress/custom_snackbar.dart';
import '../../../core/di/injectable.dart';
import '../../../core/platform/file_dialogs.dart';
import '../../../core/utils/l10n_ext.dart';
import '../bloc/editor_bloc.dart';

/// Lets the user pick a picture and puts it on the active layer, or on a new
/// layer above it when [onNewLayer] is set.
Future<void> chooseLayerImage(
  BuildContext context,
  EditorBloc bloc, {
  bool onNewLayer = false,
}) async {
  try {
    final bytes = await getIt<FileDialogs>().pickImageBytes(context.l10n);
    if (bytes != null) bloc.add(ImageLoaded(bytes, onNewLayer: onNewLayer));
  } catch (e) {
    if (context.mounted) {
      CustomSnackbar.show(context, context.l10n.imageLoadFailed('$e'));
    }
  }
}
