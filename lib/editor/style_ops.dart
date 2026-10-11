// Project imports:
import '../model/shape.dart';
import 'editor_controller.dart';

/// Colour and stroke settings. They update the current style and, when a shape
/// is selected, that shape too.
extension StyleOps on EditorController {
  void setEditFill(bool v) {
    editFill = v;
    touch();
  }

  /// Palette click: paints whichever swatch is active.
  void setColor(int v) => editFill ? setFillColor(v) : setStrokeColor(v);

  void setFillColor(int v) {
    fillColor = v;
    fillOn = true;
    editSelected((s) {
      if (s.isClosed) s.fill = v;
    });
  }

  void setStrokeColor(int v) {
    strokeColor = v;
    strokeOn = true;
    editSelected((s) => s.stroke = v);
  }

  void setFillOn(bool on) {
    fillOn = on;
    editSelected((s) {
      if (s.isClosed) s.fill = on ? fillColor : null;
    });
  }

  void setStrokeOn(bool on) {
    strokeOn = on;
    editSelected((s) {
      if (s.isClosed) s.stroke = on ? strokeColor : null;
    });
  }

  void setStrokeWidth(double w, {bool record = true}) {
    strokeWidth = w;
    editSelected((s) => s.strokeWidth = w, record: record);
  }

  void setRadius(double r, {bool record = true}) {
    radius = r;
    editSelected((s) {
      if (s.kind == ShapeKind.rect) s.radius = r;
    }, record: record);
  }
}
