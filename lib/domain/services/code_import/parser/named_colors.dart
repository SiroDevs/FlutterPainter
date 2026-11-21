// Project imports:
import 'code_values.dart';

const Map<String, int> _namedColors = {
  'transparent': 0x00000000,
  'black': 0xFF000000,
  'white': 0xFFFFFFFF,
  'red': 0xFFF44336,
  'pink': 0xFFE91E63,
  'purple': 0xFF9C27B0,
  'deepPurple': 0xFF673AB7,
  'indigo': 0xFF3F51B5,
  'blue': 0xFF2196F3,
  'lightBlue': 0xFF03A9F4,
  'cyan': 0xFF00BCD4,
  'teal': 0xFF009688,
  'green': 0xFF4CAF50,
  'lightGreen': 0xFF8BC34A,
  'lime': 0xFFCDDC39,
  'yellow': 0xFFFFEB3B,
  'amber': 0xFFFFC107,
  'orange': 0xFFFF9800,
  'deepOrange': 0xFFFF5722,
  'brown': 0xFF795548,
  'grey': 0xFF9E9E9E,
  'blueGrey': 0xFF607D8B,
  'black12': 0x1F000000,
  'black26': 0x42000000,
  'black38': 0x61000000,
  'black54': 0x8A000000,
  'black87': 0xDD000000,
  'white12': 0x1FFFFFFF,
  'white24': 0x3DFFFFFF,
  'white30': 0x4DFFFFFF,
  'white54': 0x8AFFFFFF,
  'white70': 0xB3FFFFFF,
};

// The colour for `Colors.<name>`, or null.
CodeColor? namedColor(String name) {
  final argb = _namedColors[name == 'gray' ? 'grey' : name];
  return argb == null ? null : CodeColor(argb);
}
