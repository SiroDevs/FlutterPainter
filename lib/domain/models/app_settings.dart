// Package imports:
import 'package:equatable/equatable.dart';

/// How much of the interface is shown.
enum InterfaceMode {
  /// Canvas, tools and colours only; every command stays in the menus.
  minimal('Minimal'),

  /// Ribbon and all side panels.
  advanced('Advanced');

  const InterfaceMode(this.label);

  final String label;
}

/// How exported Dart code is laid out.
enum CodeStyle {
  /// Each layer is its own class in its own file and each shape its own
  /// function, plus a painter that composes the layers.
  refactored('Refactored'),

  /// Everything in a single file: one painter class with a method per layer.
  monolithic('Monolithic');

  const CodeStyle(this.label);

  final String label;
}

/// A colour-vision simulation for the canvas. It only changes what the canvas
/// looks like on screen; the project and the exported code are untouched.
enum ColorPreview {
  none('Off (true colours)'),
  grayscale('Grayscale'),
  protanopia('Protanopia (no red)'),
  deuteranopia('Deuteranopia (no green)'),
  tritanopia('Tritanopia (no blue)');

  const ColorPreview(this.label);

  final String label;
}

/// How a colour is written in exported code.
enum ColorFormat {
  hex('Color(0xFFRRGGBB)'),
  argb('Color.fromARGB(255, r, g, b)'),
  rgbo('Color.fromRGBO(r, g, b, 1.0)');

  const ColorFormat(this.label);

  final String label;
}

/// Preferences other than the theme (which has its own bloc), remembered
/// between launches.
class AppSettings extends Equatable {
  const AppSettings({
    this.interfaceMode = InterfaceMode.advanced,
    this.codeStyle = CodeStyle.refactored,
    this.colorPreview = ColorPreview.none,
    this.colorFormat = ColorFormat.hex,
    this.colorConstants = true,
  });

  final InterfaceMode interfaceMode;
  final CodeStyle codeStyle;
  final ColorPreview colorPreview;
  final ColorFormat colorFormat;

  /// Export each distinct colour once, as a named constant, instead of writing
  /// the literal at every use.
  final bool colorConstants;

  AppSettings copyWith({
    InterfaceMode? interfaceMode,
    CodeStyle? codeStyle,
    ColorPreview? colorPreview,
    ColorFormat? colorFormat,
    bool? colorConstants,
  }) =>
      AppSettings(
        interfaceMode: interfaceMode ?? this.interfaceMode,
        codeStyle: codeStyle ?? this.codeStyle,
        colorPreview: colorPreview ?? this.colorPreview,
        colorFormat: colorFormat ?? this.colorFormat,
        colorConstants: colorConstants ?? this.colorConstants,
      );

  @override
  List<Object?> get props =>
      [interfaceMode, codeStyle, colorPreview, colorFormat, colorConstants];
}
