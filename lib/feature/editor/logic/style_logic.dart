// Project imports:
import '../../../domain/models/shape.dart';
import '../../../domain/models/shape_gradient.dart';
import '../../../domain/models/shape_kind.dart';
import '../bloc/editor_bloc.dart';
import '../models/style_settings.dart';
import 'editor_ops.dart';

/// Colours and stroke. They update the current style and, when a shape is
/// selected, that shape too.
abstract class StyleLogic {
  StyleLogic._();

  /// Loads a selected shape's look into the style controls.
  static StyleSettings adopt(StyleSettings st, Shape s) => st.copyWith(
        fillOn: s.isClosed ? s.fill != null : st.fillOn,
        fillColor: s.isClosed && s.fill != null ? s.fill! : st.fillColor,
        fillGradient: s.isClosed ? s.gradient : st.fillGradient,
        strokeOn: s.stroke != null,
        strokeColor: s.stroke ?? st.strokeColor,
        strokeWidth: s.strokeWidth,
        radius: s.kind == ShapeKind.rect ? s.radius : st.radius,
      );

  static EditorState target(EditorState s, bool editFill) =>
      s.copyWith(style: s.style.copyWith(editFill: editFill));

  /// Palette click: paints whichever swatch is active.
  static EditorState pick(EditorState s, int color) =>
      s.style.editFill ? pickFill(s, color) : pickStroke(s, color);

  static EditorState pickFill(EditorState s, int color) => s
      .copyWith(
        style: s.style.copyWith(
          fillColor: color,
          fillOn: true,
          fillGradient: null,
        ),
      )
      .editSelected(
        (sh) => sh.isClosed ? sh.copyWith(fill: color, gradient: null) : sh,
      )
      .commit();

  /// Paints the fill with [gradient]; null goes back to the flat fill colour.
  static EditorState pickGradient(EditorState s, ShapeGradient? gradient) {
    final color = gradient?.firstColor ?? s.style.fillColor;
    return s
        .copyWith(
          style: s.style.copyWith(
            fillColor: color,
            fillOn: true,
            fillGradient: gradient,
          ),
        )
        .editSelected(
          (sh) => sh.isClosed ? sh.copyWith(fill: color, gradient: gradient) : sh,
        )
        .commit();
  }

  static EditorState pickStroke(EditorState s, int color) => s
      .copyWith(style: s.style.copyWith(strokeColor: color, strokeOn: true))
      .editSelected((sh) => sh.copyWith(stroke: color))
      .commit();

  static EditorState toggleFill(EditorState s, bool on) => s
      .copyWith(style: s.style.copyWith(fillOn: on))
      .editSelected(
        (sh) => sh.isClosed
            ? sh.copyWith(
                fill: on ? s.style.fillColor : null,
                gradient: on ? s.style.fillGradient : null,
              )
            : sh,
      )
      .commit();

  /// Open shapes (lines, freehand) are all stroke, so only closed ones toggle.
  static EditorState toggleStroke(EditorState s, bool on) => s
      .copyWith(style: s.style.copyWith(strokeOn: on))
      .editSelected(
        (sh) => sh.isClosed ? sh.copyWith(stroke: on ? s.style.strokeColor : null) : sh,
      )
      .commit();

  /// Slider drag: applies at once, history is recorded by ChangesCommitted.
  static EditorState strokeWidth(EditorState s, double width) => s
      .copyWith(style: s.style.copyWith(strokeWidth: width))
      .editSelected((sh) => sh.copyWith(strokeWidth: width));

  static EditorState radius(EditorState s, double radius) => s
      .copyWith(style: s.style.copyWith(radius: radius))
      .editSelected((sh) => sh.kind == ShapeKind.rect ? sh.copyWith(radius: radius) : sh);
}
