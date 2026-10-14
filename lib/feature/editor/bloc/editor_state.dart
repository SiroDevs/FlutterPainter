part of 'editor_bloc.dart';

/// Everything about one open project: the document, its history, the active
/// tool, the selection, the style, the view and any gesture in progress.
class EditorState extends Equatable {
  const EditorState({
    required this.tabId,
    required this.drawing,
    required this.history,
    this.filePath,
    this.overwriteConfirmed = false,
    this.revision = 0,
    this.tool = Tool.select,
    this.layerIndex = 0,
    this.selected,
    this.draft,
    this.hover,
    this.cursor,
    this.style = const StyleSettings(),
    this.view = const ViewSettings(),
    this.gesture = const GestureState(),
    this.images = const <String, Image>{},
  });

  factory EditorState.fromSeed(EditorSeed seed) => EditorState(
        tabId: seed.tabId,
        drawing: seed.drawing,
        history: EditHistory.initial(seed.drawing, saved: !seed.recovered),
        filePath: seed.filePath,
      );

  final String tabId;

  /// The document as it is right now (may be ahead of [history] mid-drag).
  final Drawing drawing;
  final EditHistory history;

  /// The .flp this project is saved to, or null for a project never saved.
  final String? filePath;

  /// Whether the user already agreed to overwrite [filePath] this session.
  final bool overwriteConfirmed;

  /// Bumped on every recorded change; the workspace watches it to write drafts.
  final int revision;
  final Tool tool;
  final int layerIndex;

  /// The selection in the active layer: a shape index, [kImageSlot] for the
  /// layer's picture, or null for nothing. Every place that clears the
  /// selection therefore clears the picture selection too.
  final int? selected;

  /// The shape being drawn right now, plus the rubber-band point for polygons.
  final Shape? draft;
  final Offset? hover;

  /// Last pointer position in design units, for the status bar.
  final Offset? cursor;
  final StyleSettings style;
  final ViewSettings view;
  final GestureState gesture;

  /// Decoded pictures by [ReferenceImage.id], one entry per distinct picture
  /// used by any layer (or any undo step).
  final Map<String, Image> images;

  /// Nullable fields ([filePath], [selected], [draft], [hover], [cursor]) can
  /// be cleared by passing `null` explicitly.
  EditorState copyWith({
    String? tabId,
    Drawing? drawing,
    EditHistory? history,
    Object? filePath = unset,
    bool? overwriteConfirmed,
    int? revision,
    Tool? tool,
    int? layerIndex,
    Object? selected = unset,
    Object? draft = unset,
    Object? hover = unset,
    Object? cursor = unset,
    StyleSettings? style,
    ViewSettings? view,
    GestureState? gesture,
    Map<String, Image>? images,
  }) =>
      EditorState(
        tabId: tabId ?? this.tabId,
        drawing: drawing ?? this.drawing,
        history: history ?? this.history,
        filePath: keep<String>(filePath, this.filePath),
        overwriteConfirmed: overwriteConfirmed ?? this.overwriteConfirmed,
        revision: revision ?? this.revision,
        tool: tool ?? this.tool,
        layerIndex: layerIndex ?? this.layerIndex,
        selected: keep<int>(selected, this.selected),
        draft: keep<Shape>(draft, this.draft),
        hover: keep<Offset>(hover, this.hover),
        cursor: keep<Offset>(cursor, this.cursor),
        style: style ?? this.style,
        view: view ?? this.view,
        gesture: gesture ?? this.gesture,
        images: images ?? this.images,
      );

  @override
  List<Object?> get props => [
        tabId,
        drawing,
        history,
        filePath,
        overwriteConfirmed,
        revision,
        tool,
        layerIndex,
        selected,
        draft,
        hover,
        cursor,
        style,
        view,
        gesture,
        images,
      ];
}
