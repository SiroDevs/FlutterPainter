// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import '../shapes/shape.dart';
import 'paint_layer.dart';

enum ProjectTransferKind { items, group, layer }

class ProjectTransfer extends Equatable {
  const ProjectTransfer({
    required this.kind,
    this.shapes = const <Shape>[],
    this.groupName,
    this.layer,
  });

  final ProjectTransferKind kind;
  final List<Shape> shapes;
  final String? groupName;
  final PaintLayer? layer;

  @override
  List<Object?> get props => [kind, shapes, groupName, layer];
}
