enum QuickCodeTargetKind { polygon, shape }

class QuickCodeRequest {
  const QuickCodeRequest.polygon()
    : kind = QuickCodeTargetKind.polygon,
      layerIndex = null,
      shapeIndex = null;

  const QuickCodeRequest.shape({
    required this.layerIndex,
    required this.shapeIndex,
  }) : kind = QuickCodeTargetKind.shape;

  final QuickCodeTargetKind kind;
  final int? layerIndex;
  final int? shapeIndex;

  bool get isPolygon => kind == QuickCodeTargetKind.polygon;
}
