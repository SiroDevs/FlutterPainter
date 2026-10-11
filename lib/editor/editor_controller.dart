// Dart imports:
import 'dart:typed_data';
import 'dart:ui';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import '../model/drawing.dart';
import '../model/shape.dart';
import 'history.dart';
import 'reference_ops.dart';
import 'tool.dart';

/// All state for ONE open project (one tab): the document, the active tool,
/// the selection, current colours, the view transform and undo history.
/// Widgets only read this and call its methods, so every edit goes through one
/// place.
class EditorController extends ChangeNotifier {
  EditorController({Drawing? drawing, String? tabId, this.filePath})
      : drawing = drawing ?? Drawing(name: 'Untitled'),
        tabId = tabId ?? _newTabId() {
    _history.reset(_snapshot());
    syncReference();
  }

  static int _counter = 0;
  static String _newTabId() =>
      '${DateTime.now().millisecondsSinceEpoch.toRadixString(36)}-${_counter++}';

  Drawing drawing;

  /// Stable id for this tab; names its side copy (draft) on disk.
  final String tabId;

  /// The .flp this project is saved to, or null for a project never saved.
  String? filePath;

  /// Whether the user already agreed to overwrite [filePath] this session.
  bool overwriteConfirmed = false;

  /// Bumped on every recorded change; the workspace watches it to write drafts.
  int revision = 0;
  bool disposed = false;

  Tool tool = Tool.select;
  int layerIndex = 0;
  int? selected;

  /// The shape being drawn right now, plus the rubber-band point for polygons.
  Shape? draft;
  Offset? hover;
  final ValueNotifier<Offset?> cursor = ValueNotifier(null);

  // Reference image: decoded pixels plus every image seen, for undo.
  Image? refImage;
  String? refImageId;
  final Map<String, Uint8List> images = {};

  // Current style. Also mirrors the selected shape, so edits apply to it.
  int fillColor = 0xFFED1C24;
  bool fillOn = true;
  int strokeColor = 0xFF000000;
  bool strokeOn = true;
  double strokeWidth = 1;
  double radius = 0;
  bool editFill = true;

  // View.
  bool snap = true;
  bool grid = true;
  int bg = 0;
  double zoom = 6;
  Offset pan = const Offset(40, 40);
  Size viewport = Size.zero;
  bool needsFit = true;

  final History _history = History();

  Layer get layer => drawing.layers[layerIndex];

  Shape? get selectedShape {
    final i = selected;
    return (i != null && i < layer.shapes.length) ? layer.shapes[i] : null;
  }

  bool get canUndo => _history.canUndo;
  bool get canRedo => _history.canRedo;

  /// True when the drawing differs from what was last saved to [filePath].
  bool get dirty => !_history.isAtSaved;

  /// A project with no file, no edits and no shapes: nothing to lose.
  bool get isPristine =>
      filePath == null && !dirty && drawing.layers.every((l) => l.shapes.isEmpty);

  String _snapshot() => drawing.encode(withImage: false);

  /// Call after any edit. [record] pushes an undo snapshot.
  void changed({bool record = true}) {
    if (record && _history.push(_snapshot())) revision++;
    notifyListeners();
  }

  /// Repaint only (mid-drag updates).
  void touch() => notifyListeners();

  /// Applies [apply] to the selected shape (if any) and records the change.
  void editSelected(void Function(Shape s) apply, {bool record = true}) {
    final s = selectedShape;
    if (s != null) apply(s);
    changed(record: record && s != null);
  }

  void undo() => _restore(_history.undo());
  void redo() => _restore(_history.redo());

  void _restore(String? snapshot) {
    if (snapshot == null) return;
    drawing = Drawing.decode(snapshot, lookup: (id) => images[id]);
    layerIndex = layerIndex.clamp(0, drawing.layers.length - 1).toInt();
    selected = null;
    draft = null;
    revision++;
    syncReference();
    notifyListeners();
  }

  /// Called after a successful save: the current state is now what is on disk.
  void markSaved() {
    _history.markSaved();
    notifyListeners();
  }

  /// For a recovered draft: the file on disk does not match this state.
  void markUnsaved() => _history.markUnsaved();

  void setTool(Tool t) {
    tool = t;
    selected = null;
    draft = null;
    hover = null;
    notifyListeners();
  }

  /// Selects the topmost visible shape under [p]. Returns whether one was hit.
  bool selectAt(Offset p, double tol) {
    for (var li = drawing.layers.length - 1; li >= 0; li--) {
      final l = drawing.layers[li];
      if (!l.visible) continue;
      for (var si = l.shapes.length - 1; si >= 0; si--) {
        if (l.shapes[si].hitTest(p, tol)) {
          layerIndex = li;
          selected = si;
          _adopt(l.shapes[si]);
          notifyListeners();
          return true;
        }
      }
    }
    selected = null;
    notifyListeners();
    return false;
  }

  void _adopt(Shape s) {
    if (s.isClosed) {
      fillOn = s.fill != null;
      if (s.fill != null) fillColor = s.fill!;
    }
    strokeOn = s.stroke != null;
    if (s.stroke != null) strokeColor = s.stroke!;
    strokeWidth = s.strokeWidth;
    if (s.kind == ShapeKind.rect) radius = s.radius;
  }

  @override
  void notifyListeners() {
    if (!disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    disposed = true;
    cursor.dispose();
    refImage?.dispose();
    super.dispose();
  }
}
