enum Tool { select, rect, ellipse, line, polygon, freehand, reference }

extension ToolHint on Tool {
  String get hint => switch (this) {
        Tool.select =>
          'Click a shape to select it. Drag to move, drag handles to resize. Double-click an edge to add a point, Alt-click a point to remove it.',
        Tool.rect => 'Drag to draw a rectangle. Hold Shift for a square.',
        Tool.ellipse => 'Drag to draw an ellipse. Hold Shift for a circle.',
        Tool.line => 'Drag to draw a line. Hold Shift for 45° angles.',
        Tool.polygon =>
          'Click to add points. Click the first point or double-click to close the shape; Enter leaves it open as a line path. Esc cancels.',
        Tool.freehand => 'Drag to draw a smoothed freehand stroke.',
        Tool.reference => 'Drag to move the background image. Use the Background panel to scale it.',
      };
}
