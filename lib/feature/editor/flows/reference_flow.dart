// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../common/widgets/progress/custom_snackbar.dart';
import '../../../core/di/injectable.dart';
import '../../../core/platform/file_dialogs.dart';
import '../bloc/editor_bloc.dart';

/// Lets the user pick a picture and loads it as the tab's background image.
Future<void> chooseReferenceImage(BuildContext context, EditorBloc bloc) async {
  try {
    final bytes = await getIt<FileDialogs>().pickImageBytes();
    if (bytes != null) bloc.add(EditorEvent.referenceLoaded(bytes));
  } catch (e) {
    if (context.mounted) {
      CustomSnackbar.show(context, 'Could not load that image: $e');
    }
  }
}
