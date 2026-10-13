part of 'editor_bloc.dart';

/// Everything about one open project: the document, its history, the active
/// tool, the selection, the style, the view and any gesture in progress.
@freezed
abstract class EditorState with _$EditorState {
  const EditorState._();

  const factory EditorState({
    required String tabId,

    /// The document as it is right now (may be ahead of [history] mid-drag).
    required Drawing drawing,
    required EditHistory history,

    /// The .flp this project is saved to, or null for a project never saved.
    String? filePath,

    /// Whether the user already agreed to overwrite [filePath] this session.
    @Default(false) bool overwriteConfirmed,

    /// Bumped on every recorded change; the workspace watches it to write drafts.
    @Default(0) int revision,
    @Default(Tool.select) Tool tool,
    @Default(0) int layerIndex,
    int? selected,

    /// The shape being drawn right now, plus the rubber-band point for polygons.
    Shape? draft,
    Offset? hover,

    /// Last pointer position in design units, for the status bar.
    Offset? cursor,
    @Default(StyleSettings()) StyleSettings style,
    @Default(ViewSettings()) ViewSettings view,
    @Default(GestureState()) GestureState gesture,

    /// The decoded background image and the id of the pixels it came from.
    Image? refImage,
    String? refImageId,
  }) = _EditorState;

  factory EditorState.fromSeed(EditorSeed seed) => EditorState(
        tabId: seed.tabId,
        drawing: seed.drawing,
        history: EditHistory.initial(seed.drawing, saved: !seed.recovered),
        filePath: seed.filePath,
      );
}
