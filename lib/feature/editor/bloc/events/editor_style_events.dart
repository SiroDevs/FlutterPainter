part of 'editor_bloc.dart';

class ChangesCommitted extends EditorEvent {
  const ChangesCommitted();
}

class StyleTargetChanged extends EditorEvent {
  const StyleTargetChanged(this.editFill);

  final bool editFill;
}

class ColorPicked extends EditorEvent {
  const ColorPicked(this.color);

  final int color;
}

class GradientPicked extends EditorEvent {
  const GradientPicked(this.gradient);

  final ShapeGradient? gradient;
}

class StrokeColorPicked extends EditorEvent {
  const StrokeColorPicked(this.color);

  final int color;
}

class FillToggled extends EditorEvent {
  const FillToggled(this.on);

  final bool on;
}

class StrokeToggled extends EditorEvent {
  const StrokeToggled(this.on);

  final bool on;
}

class StrokeWidthChanged extends EditorEvent {
  const StrokeWidthChanged(this.width);

  final double width;
}

class RadiusChanged extends EditorEvent {
  const RadiusChanged(this.radius);

  final double radius;
}

class CodeApplied extends EditorEvent {
  const CodeApplied(this.layers);

  final List<PaintLayer> layers;
}
