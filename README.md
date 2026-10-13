# Flutter Painter

A desktop vector painting tool, in the spirit of MS Paint, built with Flutter.
You draw shapes on layers, trace over a background picture if you like, and
**export the result as plain Dart** that paints the same picture on a
`dart:ui` `Canvas`. It was made to build game sprites (the RoadBash bike rider)
visually instead of guessing coordinates in code.

Everything is vector: shapes are stored as points, colours and stroke widths,
never as pixels, so a drawing stays sharp at any zoom and exports to compact
code.

The code follows the same architecture as RoadBash: **bloc + Freezed**,
**injectable / get_it** dependency injection, a **data / domain / feature**
split, and `go_router`. See [Architecture](#architecture).

- [Getting started](#getting-started)
- [A tour of the window](#a-tour-of-the-window)
- [Drawing](#drawing)
- [Tracing over a background image](#tracing-over-a-background-image)
- [Layers](#layers)
- [Projects, tabs and the .flp format](#projects-tabs-and-the-flp-format)
- [Saving, auto-save and recovery](#saving-auto-save-and-recovery)
- [Exporting to Dart](#exporting-to-dart)
- [Keyboard shortcuts](#keyboard-shortcuts)
- [Opening .flp files from the desktop](#opening-flp-files-from-the-desktop)
- [Architecture](#architecture)
- [Tests](#tests)
- [Known limits](#known-limits)

## Getting started

Requires Flutter with desktop support enabled (Dart `^3.13.5`, as in RoadBash).

```
flutter create --platforms=windows,macos,linux .
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d windows          # or macos / linux
flutter build windows           # release build
```

`flutter create .` only adds the platform folders; it does not overwrite the
files in this project.

**`build_runner` is required.** This project uses Freezed and injectable, whose
generated files (`*.freezed.dart` and `lib/core/di/injectable.config.dart`) are
not checked in here. Run the command above once after `flutter pub get`, and
again after you change a Freezed class, an event or state, or an `@injectable`
class. While developing, `dart run build_runner watch -d` keeps them current.

Packages: `flutter_bloc`, `freezed`, `injectable` + `get_it`, `go_router`,
`shared_preferences` (settings), `file_selector` (open/save dialogs),
`desktop_drop` (drag a file onto the window), `path_provider` (the folder for
side copies).

## A tour of the window

```
+--------------------------------------------------------------------------+
| New  Open  Save  Save as  Auto-save  [Export Dart]  Undo Redo  Zoom ...  |  top bar
| [ Rider x ] [ Untitled 2 * x ] [ + ]                                     |  project tabs
+------+---------------------------------------------+---------------------+
| tool |                                             | Layers              |
| pal- |                canvas                       | Background image    |
| ette |                                             | Properties          |
+------+---------------------------------------------+---------------------+
| fill/stroke swatches | hex | palette | colours already used              |
| x 52.0  y 98.5   hint for the current tool                               |
+--------------------------------------------------------------------------+
```

- **Top bar:** file actions, the Auto-save switch, Export Dart, undo/redo, zoom,
  grid and snap toggles, background colour, canvas size, light/dark theme and the
  project name.
- **Project tabs:** one tab per open project, each with its name, a dot when it
  has unsaved changes, and a close button. The `+` opens a new blank project.
- **Tool palette (left):** Select, Rectangle, Ellipse, Line, Polygon / line
  path, Freehand, and Move background image.
- **Canvas (centre):** the design box with an optional grid. Right- or
  middle-drag pans, the wheel zooms around the cursor. The status bar shows the
  cursor position in design units and a hint for the active tool.
- **Side panel (right):** Layers, Background image, and Properties.
- **Colour bar (bottom):** like Paint's: two overlapping swatches (fill in
  front, stroke behind), a hex field, the classic palette and a strip of colours
  already used in the drawing.

The canvas is a "design box" measured in abstract units (default 120 x 170).
Those units become the coordinates in the exported code, so you can pick any
scale that suits your game and change it with **Canvas size**.

## Drawing

| Tool | How it works |
|------|--------------|
| **Select** | Click a shape to select it. Drag to move it. Drag a corner handle to resize it. On lines and polygons the handles are the points themselves: drag one to reshape. **Double-click an edge** to add a point there, **Alt-click a point** to delete it. |
| **Rectangle** | Drag. Hold Shift for a square. Set a corner radius in Properties. |
| **Ellipse** | Drag. Hold Shift for a circle. |
| **Line** | Drag. Hold Shift to snap to 45 degree steps. |
| **Polygon / line path** | Click to place points one after another. See below. |
| **Freehand** | Drag. The stroke is smoothed with quadratic curves; the exported code uses the same curves. |

### Making a shape out of lines

Use the **Polygon / line path** tool. Each click adds a point and a line to the
previous one, so you build a shape one edge at a time.

- **Close it into a filled shape:** click back on the first point, or
  double-click, or press **Shift+Enter**. You get a polygon that takes a fill
  colour.
- **Leave it open:** press **Enter**. You get a line path (a stroke only).
- **Change your mind later:** select the shape and tick or untick **Closed
  shape** in Properties. Closing an open path makes it fillable; opening a
  polygon turns it back into a line path.
- **Refine it:** with the Select tool, drag points, double-click an edge to add
  a point, Alt-click a point to remove one. Esc cancels a shape you are still
  placing.

### Colour and stroke

Left-click a palette colour to paint the **active** swatch (click the Fill or
Stroke swatch to choose which). Right-click a palette colour to set the stroke.
The hex field accepts `#RRGGBB` or `#AARRGGBB` (the first pair is the alpha, so
`#80FF0000` is half-transparent red). **None / Use** turns fill or stroke off or
on. Stroke width and corner radius are sliders in Properties.

These settings do two jobs. With a shape selected they edit that shape; with
nothing selected they are what the next shape you draw will use. Selecting a
shape loads its settings into the controls.

**Snap** rounds points to whole units (half units once you zoom in far), which
keeps coordinates tidy in the exported code. Turn it off for freehand work.

## Tracing over a background image

Load a picture and draw over it to copy its outline.

1. In the **Background image** panel press **Load**, or drag an image file
   (PNG, JPG, WebP, BMP, GIF) onto the window. It is fitted to the canvas box.
2. Lower **Opacity** so your lines stand out against it.
3. Choose **Move image** (or the *Move background image* tool) and drag it into
   place. Adjust **Scale** with the slider (it scales about the image centre).
   **Fit to canvas** resets both.
4. Switch back to a drawing tool and trace. The image sits under the grid and
   your shapes, and may extend past the canvas box so a large photo can be
   traced piece by piece.
5. Untick **Show** to hide it and check your work, or **Remove** it when done.

The image is saved inside the `.flp` file, so a project always opens with its
reference. It is not part of the Dart export.

## Layers

Layers draw from bottom to top, and **each visible layer is exported as its own
method or class**. That is how the bike and the rider stay separate: put the bike
on a `Bike` layer and the rider on a `Body` layer and you get `RiderBike` and
`RiderBody`.

The Layers panel lists the top layer first. Click a layer to make it active (it
receives new shapes). Use the buttons to add, rename, reorder and delete layers;
the eye hides a layer (hidden layers are not exported). In Properties you can
change a shape's order within its layer (Forward / Back), duplicate or delete it,
or move it to another layer.

**New > RoadBash rider (template)** opens the current game rider in its neutral
pose as 47 editable shapes, already split into Shadow, Bike, Body, Handlebars
and Helmet layers.

## Projects, tabs and the .flp format

Each project opens in **its own tab**. A tab shows the project name, a dot when
it has unsaved changes, and a close button. Hover a tab to see its file path.

- **New:** `+` on the tab strip, Ctrl+N, or the New menu (blank or template).
- **Open:** Ctrl+O, or **drag one or more `.flp` files onto the window**. A file
  that is already open just switches to its tab.
- **Several projects at once:** each tab has its own `EditorBloc`, so its drawing,
  selection, view and undo history are independent.
- **Closing the last tab** leaves a fresh blank one so the window is never empty.

Projects are saved as **`.flp`** ("Flutter Painter project") files. The format is
readable JSON, so it diffs well in git:

```json
{
  "format": "flp",
  "version": 1,
  "name": "Rider",
  "width": 120.0,
  "height": 170.0,
  "layers": [
    {
      "name": "Bike",
      "visible": true,
      "shapes": [
        {
          "kind": "rect",
          "name": "Rear tyre",
          "points": [[48.0, 96.0], [72.0, 164.0]],
          "fill": 4279638296,
          "stroke": null,
          "strokeWidth": 1.0,
          "radius": 10.0
        }
      ]
    }
  ],
  "reference": {
    "id": "3fa2c1-48211",
    "x": 0.0, "y": 0.0, "scale": 0.25,
    "opacity": 0.5, "visible": true,
    "data": "<base64 image bytes>"
  }
}
```

- `kind` is one of `rect`, `ellipse`, `line`, `polygon`, `freehand`.
- For `rect` and `ellipse`, `points` holds two opposite corners. For `line`,
  `polygon` and `freehand` it is the list of vertices.
- `fill` and `stroke` are `0xAARRGGBB` colours as integers, or `null` for none.
- `reference` is present only when a background image is loaded.

Plain `.json` files in this format also open. The mapping between this JSON and
the domain models lives in `lib/data/mappers/drawing_mapper.dart`.

## Saving, auto-save and recovery

The goal: you never lose work, and you never overwrite a file by accident.

**Side copies.** As soon as a project has unsaved changes, Flutter Painter keeps
a safe side copy of it (a *draft*) in the app's support folder, rewritten about a
second after each edit. Your real `.flp` file is not touched until you save.

**Save (Ctrl+S).** Writes your latest state into the real file and deletes the
side copy. The write goes to a temporary file that is then renamed over the
target, so a crash in the middle of a save cannot leave a half-written project.

- A project that was **never saved** asks where to save (Save as).
- The **first time you save a project you opened from disk**, you are asked
  whether to **overwrite** the original or **save as a new file**. After you
  choose to overwrite, later saves just save.

**Auto-save.** The **Auto-save** switch changes where edits go. Off (the
default): to the side copy until you press Save. On: straight into the project's
own `.flp` file, a moment after each edit. Auto-save only writes to a file you
have already confirmed (by saving it, or by choosing Overwrite once), so it can
never silently overwrite a file you merely opened. Projects that have never been
saved still use side copies until you save them. The switch is remembered
between launches.

**Closing.** Closing a tab with unsaved changes asks **Save / Don't save /
Cancel**; for a project that was never saved, *Save* opens the Save As dialog
and cancelling it keeps the tab open. Closing the window does the same for every
project with unsaved changes.

**Recovery.** If the app crashes or is killed, the side copies are still on disk.
Next launch offers to **restore** them (each comes back in a tab, still marked
unsaved, remembering its original file) or discard them.

A tab is "unsaved" exactly when it differs from what is on disk: undo back to the
saved state and the dot goes away.

## Exporting to Dart

**Export Dart** (Ctrl+E) shows generated code you can copy or save as a `.dart`
file. It depends only on `dart:ui`.

- **One class per layer** (default): a class per layer (`RiderBike`,
  `RiderBody`, ...) each with `paint(Canvas)`, plus a `RiderPainter` that holds
  them and paints them in layer order.
- **Single class**: one `RiderPainter` with a `paintBike(canvas)`,
  `paintBody(canvas)`, ... method per layer.

Every shape is emitted as the matching canvas call (`drawRRect`, `drawOval`,
`drawLine`, `drawPath`) with exact colours and widths. Class names come from the
project name and layer names, so name them as you want them to appear.

Using it in a game:

```dart
final rider = RiderPainter();

void render(Canvas canvas, double lean) {
  canvas.save();
  canvas.translate(RiderPainter.width / 2, RiderPainter.height);
  canvas.rotate(lean);
  canvas.translate(-RiderPainter.width / 2, -RiderPainter.height);
  rider.paint(canvas);
  canvas.restore();
}
```

The export is **static artwork**. Lean, steering, bobbing, the brake light and
the tread scroll are not stored in the drawing; apply them in the game around
each layer's `paint(canvas)` call (that is the reason to keep parts on separate
layers, so you can rotate or tint one without touching the others).

## Keyboard shortcuts

Use Cmd instead of Ctrl on macOS.

| Keys | Action |
|------|--------|
| Ctrl+N / Ctrl+O | New project / open |
| Ctrl+S / Ctrl+Shift+S | Save / save as |
| Ctrl+W | Close the current tab |
| Ctrl+E | Export Dart |
| Ctrl+Z, Ctrl+Y or Ctrl+Shift+Z | Undo, redo |
| Ctrl+D | Duplicate the selected shape |
| Delete / Backspace | Delete the selected shape |
| Enter | Finish a polygon as an open line path |
| Shift+Enter | Finish a polygon as a closed shape |
| Esc | Cancel the shape being drawn and return to Select |
| Shift (while dragging) | Square / circle / 45 degree line |
| Alt+click a point | Delete that point of a line or polygon |

Shortcuts that edit shapes are ignored while a text field (such as the hex box)
has the keyboard.

## Opening .flp files from the desktop

Dragging a file onto the window works everywhere. Double-clicking a `.flp` in the
file manager needs a one-time OS file association; the app opens any file path
passed on its command line (`main(List<String> args)`).

- **Windows:** register the extension (adjust the path), for example:

  ```
  reg add HKCU\Software\Classes\.flp /ve /d FlutterPainter.Project /f
  reg add HKCU\Software\Classes\FlutterPainter.Project\shell\open\command /ve ^
      /d "\"C:\Apps\flutter_painter\flutter_painter.exe\" \"%1\"" /f
  ```
- **Linux:** add a `.desktop` file with `Exec=/path/to/flutter_painter %f` and
  `MimeType=application/x-flp;` plus a matching mime type for `*.flp`.
- **macOS:** Finder passes documents to the app through an Apple event rather
  than the command line, which this project does not handle. Drag files onto the
  window or use Open instead.

## Architecture

Flutter Painter follows RoadBash's structure. The rule is simple: **widgets send
events, blocs turn events into states, repositories talk to the outside world.**

```
lib/
  main.dart, app.dart          entry point, MultiBlocProvider, MaterialApp.router
  common/
    app_router/                go_router: RouteNames, RoutePaths, AppRouter
    constants/                 AppConstants, PrefConstants, palette
    widgets/                   dialogs, labelled slider, snackbar
  core/
    di/                        injectable.dart (+ generated injectable.config.dart)
    platform/                  FileDialogs: native open/save dialogs
    theme/                     ThemeBloc (+ Freezed event), colours, ThemeData
    utils/                     logger, path helpers, image decoding
  data/                        talks to the disk
    sources/                   ProjectFileSource, DraftFileSource, support folder
    mappers/                   Drawing <-> .flp JSON, Draft <-> JSON
  domain/                      no Flutter widgets, no IO
    models/                    Freezed: Shape, PaintLayer, Drawing, ReferenceImage,
                               EditHistory, Draft; enums ShapeKind, Tool
    repos/                     ProjectRepo, DraftRepo, PrefsRepo
    services/                  DartExporter, shape geometry, geometry utils
  feature/
    editor/                    one project (one tab)
      bloc/                    EditorBloc + editor_event / editor_state parts
      logic/                   pure functions: (state, event) -> state
      models/                  StyleSettings, ViewSettings, GestureState, EditorSeed
      widgets/                 canvas, toolbar, panels
      flows/                   picking a background image
      editor_screen.dart
    workspace/                 the window: tabs, saving, recovery
      cubit/                   WorkspaceCubit (+ Freezed state), ProjectSaver
      flows/                   save / overwrite / close / recover dialogs
      widgets/                 TopBar, ProjectTabs
      workspace_screen.dart
    export/                    ExportCubit + the export dialog
```

**State management.** Events and states are Freezed, in `part` files next to the
bloc, exactly like RoadBash's `ThemeBloc`:

- `EditorBloc` (one per tab) holds the whole project: the immutable `Drawing`,
  its `EditHistory`, the tool, selection, style, view and any pointer gesture in
  progress. Pointer events arrive in design units with the modifier keys, so the
  canvas widget is a thin forwarder and every behaviour is testable without a
  widget.
- The bloc contains almost no logic. Each event is routed to a **pure function**
  in `feature/editor/logic/` (`DrawLogic`, `SelectLogic`, `StyleLogic`,
  `LayerLogic`, `VertexLogic`, `ViewLogic`, `ReferenceLogic`, ...) that maps the
  old state to the new one. Files stay small and each rule has one home.
- Because `Drawing` is immutable, undo history is just a list of snapshots that
  share structure; "unsaved changes" is `history.index != history.savedIndex`.
- `WorkspaceCubit` owns the tabs. It creates an `EditorBloc` per project (through
  `EditorBlocFactory`, which asks get_it with an `@factoryParam` seed), watches
  each one, and decides when to write a side copy or auto-save.
- `ThemeBloc` and `WorkspaceCubit` are provided at the top of the app; the
  `EditorBloc` for the active tab is provided by `WorkspaceScreen`, so every
  editor widget just does `context.read<EditorBloc>()`.

**Dependency injection.** `injectable` generates `initGetIt`. Repos, data
sources, `FileDialogs`, `ProjectSaver`, `WorkspaceCubit` and `ThemeBloc` are
singletons; `EditorBloc` and `ExportCubit` are factories. `PrefsRepo` uses
RoadBash's abstract-class-plus-implementation pattern.

**Data.** RoadBash stores its data in a Froom/SQLite database; Flutter Painter's
data is files (the `.flp` projects and the side copies), so the `data` layer is
file sources and JSON mappers instead of DAOs and entities. The shape is the
same: the domain asks a repo, the repo uses a source, the source does the IO.

### Adding a feature

1. Model any new data as a Freezed class in `domain/models/`.
2. Add an event to `editor_event.dart` (or a new bloc for a new feature), run
   `build_runner`, and register it in `EditorBloc` with `_reduce<MyEvent>(...)`.
3. Put the rule in a pure function under `feature/editor/logic/` and cover it with
   a test in `test/feature/editor_bloc_test.dart`.
4. Build the widget with `BlocBuilder<EditorBloc, EditorState>` (use `buildWhen`
   so it only rebuilds on what it shows).

### What moved where (from the first version)

| Before | Now |
|--------|-----|
| `EditorController` (ChangeNotifier) | `EditorBloc` + `feature/editor/logic/*` |
| `*_ops.dart` extensions | `*_logic.dart` pure classes |
| `model/*` (mutable) | `domain/models/*` (Freezed, immutable) |
| `Workspace`, `tab_actions` | `WorkspaceCubit`, `ProjectSaver`, `workspace/flows` |
| `storage/*` | `data/sources`, `data/mappers`, `domain/repos` |
| `AppSettings` (settings.json) | `PrefsRepo` (shared_preferences) |
| `DartExporter` | `domain/services/dart_exporter.dart` |
| Flutter `ChangeNotifier` listeners | `BlocBuilder` / `BlocProvider` |

## Tests

```
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
```

The tests cover:

- `domain/` - the undo history and unsaved-changes marker, the Dart exporter.
- `data/` - the `.flp` round trip including the background image, drafts, and
  the rider template.
- `feature/editor_bloc_test.dart` - drawing every tool, shapes from lines (open,
  closed, double-click, first-point), selecting, moving, resizing, vertex insert
  and delete, style edits, layers, undo/redo, dirty tracking, zoom and fit.
- `feature/workspace_cubit_test.dart` - save, side copies, auto-save rules,
  overwrite confirmation, tab lifecycle and recovery, with in-memory fakes.
- `feature/workspace_screen_test.dart` - the window renders and tabs open.

## Known limits

- **Localization:** UI strings are plain text; RoadBash's `l10n` setup is not
  applied here.
- **Static export:** poses and animation are applied in your game code, not stored.
- **No curve handles:** shapes are made of straight edges plus smoothed freehand
  strokes; there are no Bezier control handles.
- **One selection:** you can select and edit one shape at a time.
- **Window-close prompt** relies on Flutter's app-exit request, which the standard
  Windows and Linux runners support; on macOS the runner must use the current
  template. Side copies still protect your work either way.
- **Large background images** make `.flp` files and side copies larger because the
  image is embedded; scale big photos down first if that matters.
