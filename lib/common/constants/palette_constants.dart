/// The classic Paint swatches, as 0xAARRGGBB ints.
const List<int> kPalette = [
  0xFF000000, 0xFF7F7F7F, 0xFF880015, 0xFFED1C24, 0xFFFF7F27,
  0xFFFFF200, 0xFF22B14C, 0xFF00A2E8, 0xFF3F48CC, 0xFFA349A4,
  0xFFFFFFFF, 0xFFC3C3C3, 0xFFB97A57, 0xFFFFAEC9, 0xFFFFC90E,
  0xFFEFE4B0, 0xFFB5E61D, 0xFF99D9EA, 0xFF7092BE, 0xFFC8BFE7,
];

/// Workspace backgrounds the toolbar cycles through.
const List<int> kCanvasBackgrounds = [
  0xFF3A3F47,
  0xFFFFFFFF,
  0xFF000000,
  0xFF5E7F52,
];

/// "#RRGGBB", or "#AARRGGBB" when the colour is translucent.
String hexOf(int argb) {
  final s = argb.toRadixString(16).padLeft(8, '0').toUpperCase();
  return s.startsWith('FF') ? '#${s.substring(2)}' : '#$s';
}

/// Accepts "RRGGBB", "#RRGGBB", "AARRGGBB" or "#AARRGGBB". Null if invalid.
int? parseHex(String input) {
  final s = input.trim().replaceFirst('#', '');
  final v = int.tryParse(s, radix: 16);
  if (v == null) return null;
  if (s.length == 6) return 0xFF000000 | v;
  if (s.length == 8) return v;
  return null;
}
