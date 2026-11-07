part of 'editor_bloc.dart';

class LayerAdded extends EditorEvent {
  const LayerAdded();
}

class LayerDeleted extends EditorEvent {
  const LayerDeleted(this.index);

  final int index;
}

class LayerRenamed extends EditorEvent {
  const LayerRenamed(this.index, this.name);

  final int index;
  final String name;
}

class LayerVisibilityToggled extends EditorEvent {
  const LayerVisibilityToggled(this.index);

  final int index;
}

class LayerMoved extends EditorEvent {
  const LayerMoved(this.index, this.direction);

  final int index;
  final int direction;
}

class LayerActivated extends EditorEvent {
  const LayerActivated(this.index);

  final int index;
}

class DrawingRenamed extends EditorEvent {
  const DrawingRenamed(this.name);

  final String name;
}

class CanvasResized extends EditorEvent {
  const CanvasResized(this.width, this.height);

  final double width;
  final double height;
}

class DocumentSaved extends EditorEvent {
  const DocumentSaved(this.path);

  final String path;
}

class ImageLoaded extends EditorEvent {
  const ImageLoaded(this.bytes, {this.onNewLayer = false});

  final Uint8List bytes;
  final bool onNewLayer;
}

class ImageRemoved extends EditorEvent {
  const ImageRemoved();
}

class ImageFitted extends EditorEvent {
  const ImageFitted();
}

class ImageSelected extends EditorEvent {
  const ImageSelected();
}

class ImageVisibilityChanged extends EditorEvent {
  const ImageVisibilityChanged(this.visible);

  final bool visible;
}

class ImageOpacityChanged extends EditorEvent {
  const ImageOpacityChanged(this.opacity);

  final double opacity;
}

class ImageScaleChanged extends EditorEvent {
  const ImageScaleChanged(this.scale);

  final double scale;
}

class ImageSyncRequested extends EditorEvent {
  const ImageSyncRequested();
}
