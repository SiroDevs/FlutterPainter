// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../common/constants/app_constants.dart';
import '../../../core/utils/l10n_ext.dart';

/// Shows application identity and credits.
class AboutSettingsPage extends StatelessWidget {
  const AboutSettingsPage({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.brush_outlined, size: 44),
        const SizedBox(height: 18),
        Text(
          AppConstants.appTitle,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(context.l10n.aboutDescription),
        const Spacer(),
        Text(context.l10n.aboutCredits),
        const SizedBox(height: 6),
        Text(
          AppConstants.appCredits,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    ),
  );
}
