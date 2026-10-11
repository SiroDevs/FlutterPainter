/// A Dart double literal: at most two decimals, always with a decimal point.
String fmt(double v) {
  var s = v.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '');
  if (s.endsWith('.')) s += '0';
  return s == '-0.0' ? '0.0' : s;
}

/// "rider body" -> "RiderBody". Always a valid class-name fragment.
String pascalCase(String s) {
  final parts = s.split(RegExp(r'[^A-Za-z0-9]+')).where((p) => p.isNotEmpty);
  var out = parts.map((p) => p[0].toUpperCase() + p.substring(1)).join();
  if (out.isEmpty) out = 'Drawing';
  if (RegExp(r'^[0-9]').hasMatch(out)) out = 'L$out';
  return out;
}

String lowerFirst(String s) => s[0].toLowerCase() + s.substring(1);

/// A Dart colour literal body, e.g. 0xFFC9222B.
String colorLiteral(int argb) =>
    '0x${argb.toRadixString(16).padLeft(8, '0').toUpperCase()}';
