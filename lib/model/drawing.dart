// Dart imports:
import 'dart:convert';

// Dart imports:
import 'dart:typed_data';

// Project imports:
import 'reference_image.dart';
import 'shape.dart';

/// A named group of shapes. Layers draw bottom to top and export as one method
/// (or one class) each, which is how a bike and its rider stay separate.
class Layer {
  Layer({required this.name, this.visible = true, List<Shape>? shapes})
      : shapes = shapes ?? [];

  String name;
  bool visible;
  List<Shape> shapes;

  Map<String, dynamic> toJson() => {
        'name': name,
        'visible': visible,
        'shapes': [for (final s in shapes) s.toJson()],
      };

  factory Layer.fromJson(Map<String, dynamic> j) => Layer(
        name: j['name'] as String,
        visible: (j['visible'] as bool?) ?? true,
        shapes: [
          for (final s in j['shapes'] as List)
            Shape.fromJson(s as Map<String, dynamic>),
        ],
      );
}

/// The whole document: a design box (in logical units) plus its layers.
class Drawing {
  Drawing({
    required this.name,
    this.width = 120,
    this.height = 170,
    List<Layer>? layers,
    this.reference,
  }) : layers = layers ?? [Layer(name: 'Layer 1')];

  String name;
  double width;
  double height;
  List<Layer> layers;

  /// Optional picture drawn under the shapes, for tracing.
  ReferenceImage? reference;

  /// Every colour in use, so it can be picked again with one click.
  List<int> usedColors() {
    final seen = <int>{};
    for (final l in layers) {
      for (final s in l.shapes) {
        if (s.fill != null) seen.add(s.fill!);
        if (s.stroke != null) seen.add(s.stroke!);
      }
    }
    return seen.toList();
  }

  /// [withImage] false keeps only the image id and settings, which is what the
  /// undo history stores so it does not copy megabytes of pixels per step.
  Map<String, dynamic> toJson({bool withImage = true}) => {
        'format': 'flp',
        'version': 1,
        'name': name,
        'width': width,
        'height': height,
        'layers': [for (final l in layers) l.toJson()],
        if (reference != null) 'reference': reference!.toJson(withData: withImage),
      };

  factory Drawing.fromJson(
    Map<String, dynamic> j, {
    Uint8List? Function(String id)? lookup,
  }) =>
      Drawing(
        name: (j['name'] as String?) ?? 'Untitled',
        width: ((j['width'] as num?) ?? 120).toDouble(),
        height: ((j['height'] as num?) ?? 170).toDouble(),
        layers: [
          for (final l in j['layers'] as List)
            Layer.fromJson(l as Map<String, dynamic>),
        ],
        reference: j['reference'] == null
            ? null
            : ReferenceImage.fromJson(j['reference'] as Map<String, dynamic>, lookup),
      );

  String encode({bool withImage = true}) =>
      jsonEncode(toJson(withImage: withImage));

  String encodePretty() => JsonEncoder.withIndent('  ').convert(toJson());

  static Drawing decode(String text, {Uint8List? Function(String id)? lookup}) =>
      Drawing.fromJson(jsonDecode(text) as Map<String, dynamic>, lookup: lookup);
}
