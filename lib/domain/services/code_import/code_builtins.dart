// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../models/shape_gradient.dart';
import 'code_values.dart';

double asDouble(Object? value) {
  if (value is num) return value.toDouble();
  throw CodeUnsupported('Expected a number, found $value');
}

Offset _offset(Object? value) {
  if (value is Offset) return value;
  throw CodeUnsupported('Expected an Offset, found $value');
}

Rect _rect(Object? value) {
  if (value is Rect) return value;
  throw CodeUnsupported('Expected a Rect, found $value');
}

int _channel(Object? value) => asDouble(value).round().clamp(0, 255).toInt();

List<int> _colorList(Object? value) {
  if (value is! List) throw const CodeUnsupported('Expected a list of colours');
  return [
    for (final item in value)
      item is CodeColor ? item.argb : throw const CodeUnsupported('Bad colour'),
  ];
}

List<double> _stopList(Object? value, int count) {
  if (value is List && value.length == count) {
    return [for (final item in value) asDouble(item)];
  }
  return [for (var i = 0; i < count; i++) count == 1 ? 0 : i / (count - 1)];
}

CodeColor _withAlpha(CodeColor color, int alpha) =>
    CodeColor((alpha << 24) | (color.argb & 0x00FFFFFF));

// Applies `+`, `-`, `*` or `/` to numbers and offsets.
Object? combineValues(Object? left, Object? right, String operator) {
  if (left is num && right is num) {
    return switch (operator) {
      '+' => left + right,
      '-' => left - right,
      '*' => left * right,
      _ => left / right,
    };
  }
  if (left is Offset && right is Offset) {
    return operator == '+' ? left + right : left - right;
  }
  if (left is Offset && right is num) {
    return operator == '*' ? left * right.toDouble() : left / right.toDouble();
  }
  if (left is num && right is Offset && operator == '*') {
    return right * left.toDouble();
  }
  if (left == 0 && right is Offset && operator == '-') return -right;
  throw const CodeUnsupported('Unsupported arithmetic');
}

// Calls a constructor or function that is part of Dart or Flutter, such as
// `Offset(1, 2)` or `Rect.fromLTWH(...)`.
Object? callStatic(String name, List<Object?> args, Map<String, Object?> named) {
  switch (name.replaceFirst('ui.', '').replaceFirst('math.', '')) {
    case 'Offset':
      return Offset(asDouble(args[0]), asDouble(args[1]));
    case 'Size':
      return Size(asDouble(args[0]), asDouble(args[1]));
    case 'Radius.circular':
      return asDouble(args[0]);
    case 'Rect.fromLTWH':
      final [left, top, width, height] = [for (final a in args) asDouble(a)];
      return Rect.fromLTWH(left, top, width, height);
    case 'Rect.fromLTRB':
      final [left, top, right, bottom] = [for (final a in args) asDouble(a)];
      return Rect.fromLTRB(left, top, right, bottom);
    case 'Rect.fromCenter':
      return Rect.fromCenter(
        center: _offset(named['center']),
        width: asDouble(named['width']),
        height: asDouble(named['height']),
      );
    case 'Rect.fromCircle':
      return Rect.fromCircle(
        center: _offset(named['center']),
        radius: asDouble(named['radius']),
      );
    case 'Rect.fromPoints':
      return Rect.fromPoints(_offset(args[0]), _offset(args[1]));
    case 'RRect.fromRectXY':
      return CodeRRect(_rect(args[0]), asDouble(args[1]));
    case 'RRect.fromRectAndRadius':
      return CodeRRect(_rect(args[0]), asDouble(args[1]));
    case 'Color':
      return CodeColor((args[0] as num).toInt() & 0xFFFFFFFF);
    case 'Color.fromARGB':
      return CodeColor((_channel(args[0]) << 24) |
          (_channel(args[1]) << 16) |
          (_channel(args[2]) << 8) |
          _channel(args[3]));
    case 'Color.fromRGBO':
      return CodeColor(((asDouble(args[3]) * 255).round() << 24) |
          (_channel(args[0]) << 16) |
          (_channel(args[1]) << 8) |
          _channel(args[2]));
    case 'Gradient.linear':
      return _gradient(GradientKind.linear, args[0], args[1], 0, args[2], args);
    case 'Gradient.radial':
      return _gradient(GradientKind.radial, args[0], null, asDouble(args[1]), args[2], args);
    case 'Gradient.sweep':
      return _gradient(GradientKind.sweep, args[0], null, 0, args[1], args);
    case 'sqrt':
      return math.sqrt(asDouble(args[0]));
    case 'sin':
      return math.sin(asDouble(args[0]));
    case 'cos':
      return math.cos(asDouble(args[0]));
    case 'min':
      return math.min(asDouble(args[0]), asDouble(args[1]));
    case 'max':
      return math.max(asDouble(args[0]), asDouble(args[1]));
    case 'pow':
      return math.pow(asDouble(args[0]), asDouble(args[1]));
  }
  throw CodeUnknownCall('Unknown call $name');
}

CodeGradient _gradient(
  GradientKind kind,
  Object? anchor,
  Object? target,
  double radius,
  Object? colorsValue,
  List<Object?> args,
) {
  final colors = _colorList(colorsValue);
  final stopsIndex = kind == GradientKind.linear ? 3 : (kind == GradientKind.radial ? 3 : 2);
  final stopsValue = args.length > stopsIndex ? args[stopsIndex] : null;
  return CodeGradient(
    kind: kind,
    anchor: _offset(anchor),
    target: target == null ? null : _offset(target),
    radius: radius,
    colors: colors,
    stops: _stopList(stopsValue, colors.length),
  );
}

// Calls a method on a value, such as `color.withOpacity(0.5)`.
Object? callMethod(Object? target, String name, List<Object?> args, Map<String, Object?> named) {
  if (target is CodeColor) {
    switch (name) {
      case 'withOpacity':
        return _withAlpha(target, (asDouble(args[0]) * 255).round().clamp(0, 255).toInt());
      case 'withAlpha':
        return _withAlpha(target, _channel(args[0]));
      case 'withValues':
        return _withAlpha(target, (asDouble(named['alpha']) * 255).round().clamp(0, 255).toInt());
    }
  }
  if (target is num) {
    switch (name) {
      case 'toDouble':
        return target.toDouble();
      case 'toInt':
        return target.toInt();
      case 'abs':
        return target.abs();
    }
  }
  throw CodeUnsupported('Unknown method $name');
}

// Reads a property such as `size.width` or `offset.dx`.
Object? readProperty(Object? target, String name) {
  if (target is Size) {
    if (name == 'width') return target.width;
    if (name == 'height') return target.height;
  }
  if (target is Offset) {
    if (name == 'dx') return target.dx;
    if (name == 'dy') return target.dy;
  }
  if (target is Rect) {
    switch (name) {
      case 'left':
        return target.left;
      case 'top':
        return target.top;
      case 'right':
        return target.right;
      case 'bottom':
        return target.bottom;
      case 'width':
        return target.width;
      case 'height':
        return target.height;
      case 'center':
        return target.center;
    }
  }
  throw CodeUnsupported('Unknown property $name');
}
