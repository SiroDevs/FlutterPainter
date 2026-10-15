// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// True on macOS, where the main shortcut modifier is Command rather than
/// Control.
bool get isMacOS => defaultTargetPlatform == TargetPlatform.macOS;

/// A shortcut with the platform's main modifier (Ctrl, or Command on macOS).
SingleActivator primaryShortcut(
  LogicalKeyboardKey key, {
  bool shift = false,
}) =>
    SingleActivator(key, control: !isMacOS, meta: isMacOS, shift: shift);

/// A shortcut written the way the platform writes it: "Ctrl+Shift+S" or "⇧⌘S".
String shortcutText(SingleActivator a) {
  final key = a.trigger.keyLabel.isEmpty
      ? (a.trigger.debugName ?? '')
      : a.trigger.keyLabel;
  if (isMacOS) {
    return '${a.control ? '⌃' : ''}${a.alt ? '⌥' : ''}'
        '${a.shift ? '⇧' : ''}${a.meta ? '⌘' : ''}$key';
  }
  return [
    if (a.control) 'Ctrl',
    if (a.alt) 'Alt',
    if (a.shift) 'Shift',
    if (a.meta) 'Meta',
    key,
  ].join('+');
}

/// One user action: what the ribbon, the menus and the shortcuts all show and
/// run. [onPressed] is null while the action is unavailable. A non-null
/// [checked] makes it a toggle.
class AppCommand {
  const AppCommand({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.shortcut,
    this.keys,
    this.checked,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;

  /// A real, registerable shortcut (shown in menus and tooltips).
  final SingleActivator? shortcut;

  /// Display-only key hint for single-key shortcuts such as "Del" or "R".
  final String? keys;
  final bool? checked;

  bool get enabled => onPressed != null;

  String? get keyText =>
      shortcut != null ? shortcutText(shortcut!) : keys;

  /// Tooltip text: the description plus the shortcut, if any.
  String get tip {
    final base = tooltip ?? label;
    final k = keyText;
    return k == null ? base : '$base ($k)';
  }
}
