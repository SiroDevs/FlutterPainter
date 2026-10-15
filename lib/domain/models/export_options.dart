// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'app_settings.dart';

/// What the exporter needs to know about how to lay the code out.
class ExportOptions extends Equatable {
  const ExportOptions({
    this.style = CodeStyle.refactored,
    this.colorFormat = ColorFormat.hex,
    this.colorConstants = true,
  });

  factory ExportOptions.fromSettings(AppSettings s) => ExportOptions(
        style: s.codeStyle,
        colorFormat: s.colorFormat,
        colorConstants: s.colorConstants,
      );

  final CodeStyle style;
  final ColorFormat colorFormat;
  final bool colorConstants;

  @override
  List<Object?> get props => [style, colorFormat, colorConstants];
}
