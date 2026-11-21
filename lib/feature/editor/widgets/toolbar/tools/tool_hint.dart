// Flutter imports:
import 'package:flutter/widgets.dart';

// Project imports:
import '../../../../../core/utils/l10n_ext.dart';
import '../../../../../domain/models/editor/tool.dart';

/// One-line help shown in the status bar for each tool.
extension ToolHint on Tool {
  String localizedHint(BuildContext context) => switch (this) {
    Tool.select => context.l10n.toolHintSelect,
    Tool.rect => context.l10n.toolHintRectangle,
    Tool.ellipse => context.l10n.toolHintEllipse,
    Tool.line => context.l10n.toolHintLine,
    Tool.polygon => context.l10n.toolHintPolygon,
    Tool.freehand => context.l10n.toolHintFreehand,
    Tool.reference => context.l10n.toolHintImage,
    Tool.paint => context.l10n.paintBucketHint,
  };
}
