// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Project imports:
import '../../../../domain/models/tool.dart';

/// Name, icon and single-key shortcut of each tool, shared by the toolbox, the
/// ribbon, the menus and the keyboard shortcuts so they never disagree.
extension ToolInfo on Tool {
  String get label => switch (this) {
        Tool.select => 'Select / move',
        Tool.reference => 'Move / resize layer image',
        Tool.rect => 'Rectangle',
        Tool.ellipse => 'Ellipse',
        Tool.line => 'Line',
        Tool.polygon => 'Polygon / line path',
        Tool.freehand => 'Freehand',
      };

  IconData get icon => switch (this) {
        Tool.select => Icons.near_me,
        Tool.reference => Icons.image_outlined,
        Tool.rect => Icons.crop_square,
        Tool.ellipse => Icons.circle_outlined,
        Tool.line => Icons.horizontal_rule,
        Tool.polygon => Icons.change_history,
        Tool.freehand => Icons.brush,
      };

  LogicalKeyboardKey get shortcutKey => switch (this) {
        Tool.select => LogicalKeyboardKey.keyV,
        Tool.reference => LogicalKeyboardKey.keyI,
        Tool.rect => LogicalKeyboardKey.keyR,
        Tool.ellipse => LogicalKeyboardKey.keyE,
        Tool.line => LogicalKeyboardKey.keyL,
        Tool.polygon => LogicalKeyboardKey.keyP,
        Tool.freehand => LogicalKeyboardKey.keyB,
      };

  /// The letter shown next to the tool's name.
  String get keyLabel => shortcutKey.keyLabel;
}

/// Tools that share one slot in the toolbox, the way Photoshop stacks related
/// tools: the slot shows the last one used and a flyout offers the others.
const List<List<Tool>> kToolGroups = [
  [Tool.select, Tool.reference],
  [Tool.rect, Tool.ellipse, Tool.line],
  [Tool.polygon, Tool.freehand],
];
