// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Guarani (`gn`).
class AppLocalizationsGn extends AppLocalizations {
  AppLocalizationsGn([String locale = 'gn']) : super(locale);

  @override
  String get newProject => 'New Project';

  @override
  String get newProjectTooltip => 'Start a new project (Ctrl+N)';

  @override
  String get inlineCode => 'Inline Code';

  @override
  String get inlineCodeTooltip => 'Show or hide the inline code view';

  @override
  String get quickCode => 'Quick Code';

  @override
  String get quickCodeTooltip => 'Edit or paste shape coordinates';

  @override
  String get quickCodePolygonMenu => 'Code';

  @override
  String get quickCodeToolMenuHint => 'Right-click or hold for more options';

  @override
  String get quickCodeCoordinates => 'Coordinates';

  @override
  String get quickCodeDartCode => 'Dart code';

  @override
  String get quickCodeFormatTooltip =>
      'Switch between Dart code and compact coordinates';

  @override
  String get quickCodeHint =>
      'Paste Offset(x, y) points or x,y pairs separated by spaces.';

  @override
  String get quickCodeInvalid => 'Code must be a list of Offset(x, y) points.';

  @override
  String get quickCodeNeedMorePoints => 'Add enough points for this shape.';

  @override
  String get quickCodePolygonReady => 'Polygon preview ready.';

  @override
  String get quickCodeShapeReady => 'Canvas updated from these points.';

  @override
  String get quickCodeAddPolygon => 'Add polygon';

  @override
  String get quickCodeAddShapes => 'Add shapes';

  @override
  String get quickCodeClose => 'Close Quick Code';

  @override
  String get openFullEditor => 'Open the full code editor';

  @override
  String get undo => 'Undo';

  @override
  String get removeFileTooltip => 'Remove this file and its shapes';

  @override
  String get statusIdle => 'Edit the code and the canvas follows';

  @override
  String get statusRendered => 'Canvas updated from the code';

  @override
  String get statusUnreadable =>
      'Cannot read this code yet; the canvas is unchanged';

  @override
  String statusSkipped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count statements were skipped',
      one: '1 statement was skipped',
    );
    return '$_temp0';
  }

  @override
  String get colorMoreTooltip => 'Open the color picker';

  @override
  String get paintBucketTool => 'Paint bucket';

  @override
  String get paintBucketHint =>
      'Click inside a closed shape to fill it with the active fill color.';

  @override
  String get colorPickerTitle => 'Color picker';

  @override
  String get colorSolid => 'Solid';

  @override
  String get colorGradient => 'Gradient';

  @override
  String get colorWheel => 'Wheel';

  @override
  String get colorSquare => 'Square';

  @override
  String get colorHexCode => 'Hex code';

  @override
  String get colorBrightness => 'Brightness';

  @override
  String get colorOpacity => 'Opacity';

  @override
  String get gradientLinear => 'Linear';

  @override
  String get gradientRadial => 'Radial';

  @override
  String get gradientSweep => 'Sweep';

  @override
  String get gradientAngle => 'Angle';

  @override
  String get gradientRadius => 'Radius';

  @override
  String get gradientAddStop => 'Add stop';

  @override
  String get gradientRemoveStop => 'Remove stop';

  @override
  String get gradientStopPosition => 'Position';

  @override
  String get apply => 'Apply';

  @override
  String get cancel => 'Cancel';

  @override
  String get shapeGroup => 'Group';

  @override
  String get shapeUngroup => 'Ungroup';

  @override
  String get shapeGroupTooltip => 'Group selected shapes so they move together';

  @override
  String get shapeUngroupTooltip => 'Ungroup selected shapes';

  @override
  String get shapeActionsPanelTitle => 'Shape actions';

  @override
  String get shapeActionsPanelEmpty => 'Select a shape to see its actions.';

  @override
  String shapeSelectionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count shapes selected',
      one: '1 shape selected',
    );
    return '$_temp0';
  }

  @override
  String get shapeRotateHint =>
      'Drag the round handle to rotate. Hold Shift to snap every 15°.';

  @override
  String get vertexDelete => 'Delete this point';

  @override
  String get vertexSplit => 'Split this point';

  @override
  String get shapeDuplicate => 'Duplicate';

  @override
  String get shapeCopyGroup => 'Copy group';

  @override
  String get shapePasteGroup => 'Paste group';

  @override
  String get shapeDelete => 'Delete';

  @override
  String get shapeForward => 'Forward';

  @override
  String get shapeBack => 'Back';

  @override
  String get shapeBringToFront => 'Bring to front';

  @override
  String get shapeSendToBack => 'Send to back';

  @override
  String get shapeBringForward => 'Bring forward';

  @override
  String get shapeSendBackward => 'Send backward';

  @override
  String get shapeOrderGroup => 'Order';

  @override
  String get shapeMoveToLayer => 'Move to layer';

  @override
  String get shapeToLayer => 'To layer';

  @override
  String get layersTitle => 'Layers';

  @override
  String get layerAdd => 'Add layer';

  @override
  String get layerRename => 'Rename layer';

  @override
  String get layerMoveUp => 'Move layer up';

  @override
  String get layerMoveDown => 'Move layer down';

  @override
  String get layerDelete => 'Delete layer';

  @override
  String get layerHide => 'Hide';

  @override
  String get layerShow => 'Show';

  @override
  String get layerGroup => 'Group';

  @override
  String get layerPicture => 'Picture';

  @override
  String get layerItemRectangle => 'Rectangle';

  @override
  String get layerItemEllipse => 'Ellipse';

  @override
  String get layerItemLine => 'Line';

  @override
  String get layerItemPolygon => 'Polygon';

  @override
  String get layerItemFreehand => 'Freehand';

  @override
  String get layerEditItem => 'Edit item name';

  @override
  String get canvasSelectGroupMemberHint =>
      'Ctrl-click to select only this item from its group';

  @override
  String get layerEditGroup => 'Edit group name';

  @override
  String get shapeScaleDown => 'Scale down 10%';

  @override
  String get ribbonArrangeTab => 'Arrange';

  @override
  String get projectTransferGroup => 'Project transfer';

  @override
  String get projectCopySelection => 'Copy selection';

  @override
  String get projectCopyLayer => 'Copy layer';

  @override
  String get projectPaste => 'Paste';

  @override
  String get projectImportGroup => 'Import';

  @override
  String get projectImport => 'Import project…';

  @override
  String projectImportComplete(int count) {
    return 'Imported $count layers.';
  }

  @override
  String projectImportFailed(String path) {
    return 'Could not import $path.';
  }

  @override
  String get shapeTransformGroup => 'Transform';

  @override
  String get shapeSelectionGroup => 'Selection';

  @override
  String get shapeFlipHorizontal => 'Flip horizontal';

  @override
  String get shapeFlipVertical => 'Flip vertical';

  @override
  String get shapeClosedPath => 'Closed path';

  @override
  String get groupMethodsPublic => 'Expose group shape methods';

  @override
  String get groupMethodsPublicHelp =>
      'On: the layer calls each public shape method. Off: the group exposes one paint() method and keeps shape methods private.';

  @override
  String get exportGenerating => 'Generating Dart code…';

  @override
  String get exportSaving => 'Preparing export…';

  @override
  String get exportGenerationFailed => 'Could not generate the Dart code.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsProject => 'Project';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageHelp => 'Choose the language used by the app.';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageSwahili => 'Kiswahili';

  @override
  String get previewNone => 'Off (true colours)';

  @override
  String get previewGrayscale => 'Grayscale';

  @override
  String get previewProtanopia => 'Protanopia (no red)';

  @override
  String get previewDeuteranopia => 'Deuteranopia (no green)';

  @override
  String get previewTritanopia => 'Tritanopia (no blue)';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get settingsInterface => 'Interface';

  @override
  String get interfaceMinimal => 'Minimal';

  @override
  String get interfaceAdvanced => 'Advanced';

  @override
  String get interfaceHelp =>
      'Advanced shows the ribbon and side panels. Minimal keeps the canvas, tools and colours visible; commands remain in the menus.';

  @override
  String get settingsCodeExport => 'Code export';

  @override
  String get settingsCodeStructure => 'Code structure';

  @override
  String get codeRefactored => 'Refactored';

  @override
  String get codeMonolithic => 'Monolithic';

  @override
  String get codeRefactoredHelp =>
      'A painter, one class per layer in its own file, one function per shape, and a colour palette.';

  @override
  String get codeMonolithicHelp =>
      'One code file with a painter class and one method per layer.';

  @override
  String get settingsColourManagement => 'Colour management';

  @override
  String get settingsColourVision => 'Colour vision preview';

  @override
  String get settingsColourVisionHelp =>
      'Approximates how the canvas may appear to someone with a colour vision difference. It does not change the project or exported code.';

  @override
  String get settingsColourFormat => 'Colour format in exported code';

  @override
  String get settingsColourFormatHelp =>
      'Choose how colours are written in generated Dart.';

  @override
  String get settingsColourConstants => 'Collect colours into named constants';

  @override
  String get settingsColourConstantsHelp =>
      'Write each distinct colour once as a constant and refer to it from shapes.';

  @override
  String get settingsReset => 'Reset to defaults';

  @override
  String get settingsDone => 'Done';

  @override
  String get projectSettingsDescription =>
      'Manage the name and design canvas for this project.';

  @override
  String get projectCurrentName => 'Project name';

  @override
  String get projectCanvasSize => 'Canvas size';

  @override
  String get projectRename => 'Rename project';

  @override
  String get projectResizeCanvas => 'Change canvas size';

  @override
  String projectDimensions(String width, String height) {
    return '$width × $height design units';
  }

  @override
  String get aboutDescription =>
      'A paint studio for creating Flutter custom painters.';

  @override
  String get aboutCredits => 'Made by Siro Devs';

  @override
  String get buttonOk => 'OK';

  @override
  String get canvasSizeTitle => 'Canvas size (design units)';

  @override
  String get fieldWidth => 'Width';

  @override
  String get fieldHeight => 'Height';

  @override
  String get buttonResize => 'Resize';

  @override
  String saveChangesTitle(String name) {
    return 'Save changes to \"$name\"?';
  }

  @override
  String get unsavedChangesMessage =>
      'Your changes will be lost if you do not save them.';

  @override
  String get buttonDontSave => 'Don\'t save';

  @override
  String get recoverUnsavedTitle => 'Recover unsaved work?';

  @override
  String get recoverUnsavedIntro =>
      'These projects had unsaved changes when Flutter Painter last closed:';

  @override
  String get buttonDiscard => 'Discard';

  @override
  String get buttonRestore => 'Restore';

  @override
  String get fileNewBlank => 'New blank canvas';

  @override
  String get fileOpen => 'Open…';

  @override
  String get fileSave => 'Save';

  @override
  String get fileSaveAs => 'Save as…';

  @override
  String get fileAutoSave => 'Auto-save';

  @override
  String get fileAutoSaveHelp =>
      'On: write changes straight into the open .flp file. Off: keep a recovery copy until you save.';

  @override
  String get fileExportDart => 'Export Dart…';

  @override
  String get fileCodeEditorTooltip => 'Open the code editor';

  @override
  String get fileSettings => 'Settings…';

  @override
  String get fileRenameProject => 'Rename project…';

  @override
  String get projectNameTooltip => 'Project name (also used for class names)';

  @override
  String get fileCanvasSize => 'Canvas size…';

  @override
  String get fileCloseProject => 'Close project';

  @override
  String get fileExit => 'Exit';

  @override
  String aboutMenu(String appName) {
    return 'About $appName';
  }

  @override
  String get editRedo => 'Redo';

  @override
  String get editDeleteTooltip => 'Delete the selected shape or image';

  @override
  String get editPathClosedTooltip =>
      'Close or open the selected polygon or line path';

  @override
  String get editFill => 'Fill';

  @override
  String get editOutline => 'Outline';

  @override
  String get editStrokeTooltip => 'Stroke (outline)';

  @override
  String get imageReplace => 'Replace image…';

  @override
  String get imageLoad => 'Load image…';

  @override
  String get imageLoadNewLayer => 'Image on new layer…';

  @override
  String get imagePutLayerTooltip => 'Put a picture on this layer';

  @override
  String get imageLoadNewLayerTooltip => 'Load a picture onto a new layer';

  @override
  String get imageSelect => 'Select image';

  @override
  String get imageSelectTooltip =>
      'Select this layer’s image (shows resize handles)';

  @override
  String get imageMoveResize => 'Move / resize image';

  @override
  String get imageMoveResizeTooltip => 'Move / resize image tool';

  @override
  String get imageFit => 'Fit image to canvas';

  @override
  String get imageFitTooltip => 'Fit to canvas (resets stretch)';

  @override
  String get imageShow => 'Show image';

  @override
  String get imageRemove => 'Remove image';

  @override
  String get imageLoadTooltip => 'Load an image onto a new layer';

  @override
  String get imagePanelShow => 'Show';

  @override
  String imageOpacity(String value) {
    return 'Opacity $value%';
  }

  @override
  String imageScale(String value) {
    return 'Scale $value';
  }

  @override
  String imagePanelTitle(String name) {
    return 'Image on “$name”';
  }

  @override
  String get imagePanelPrompt =>
      'Load a picture onto this layer to trace over or use as a background.';

  @override
  String get viewZoomIn => 'Zoom in';

  @override
  String get viewZoomOut => 'Zoom out';

  @override
  String get viewFitWindow => 'Fit to window';

  @override
  String get viewGrid => 'Grid';

  @override
  String get viewSnap => 'Snap to grid';

  @override
  String get viewCanvasBackground => 'Canvas background';

  @override
  String get viewCanvasBackgroundTooltip =>
      'Cycle the canvas background colour';

  @override
  String get viewLightTheme => 'Light theme';

  @override
  String get viewDarkTheme => 'Dark theme';

  @override
  String get viewThemeTooltip => 'Switch between the light and dark theme';

  @override
  String get menuFile => 'File';

  @override
  String get menuEdit => 'Edit';

  @override
  String get menuLayer => 'Layer';

  @override
  String get menuView => 'View';

  @override
  String get menuTools => 'Tools';

  @override
  String get menuHelp => 'Help';

  @override
  String get menuWindow => 'Window';

  @override
  String get ribbonExport => 'Export';

  @override
  String get ribbonExpand => 'Expand the ribbon';

  @override
  String get ribbonCollapse => 'Collapse the ribbon';

  @override
  String get ribbonLayers => 'Layers';

  @override
  String get ribbonOrder => 'Order';

  @override
  String get ribbonHistory => 'History';

  @override
  String get ribbonStyle => 'Style';

  @override
  String get ribbonNew => 'New';

  @override
  String get ribbonOpen => 'Open';

  @override
  String get ribbonBlankCanvas => 'Blank canvas';

  @override
  String get ribbonProject => 'Project';

  @override
  String get ribbonApp => 'App';

  @override
  String get ribbonShapes => 'Shapes';

  @override
  String get ribbonPaths => 'Paths';

  @override
  String get ribbonPolygon => 'Polygon';

  @override
  String get ribbonPictures => 'Pictures';

  @override
  String get ribbonPicture => 'Picture';

  @override
  String get ribbonOnNewLayer => 'On new layer';

  @override
  String get ribbonLayersGroup => 'Layers';

  @override
  String get ribbonZoom => 'Zoom';

  @override
  String get ribbonFit => 'Fit';

  @override
  String get ribbonShow => 'Show';

  @override
  String get ribbonCanvas => 'Canvas';

  @override
  String get ribbonAppearance => 'Appearance';

  @override
  String get ribbonLightDark => 'Light / dark';

  @override
  String get ribbonArrange => 'Arrange';

  @override
  String get ribbonAdjust => 'Adjust';

  @override
  String get toolSelectMove => 'Select / move';

  @override
  String get toolMoveImage => 'Move / resize layer image';

  @override
  String get toolRectangle => 'Rectangle';

  @override
  String get toolEllipse => 'Ellipse';

  @override
  String get toolLine => 'Line';

  @override
  String get toolPolygonPath => 'Polygon / line path';

  @override
  String get toolFreehand => 'Freehand';

  @override
  String get propertyTitle => 'Properties';

  @override
  String get propertyNoSelection =>
      'No shape selected. These settings apply to the next shape you draw.';

  @override
  String get propertyFill => 'Fill';

  @override
  String get propertyStroke => 'Stroke';

  @override
  String get propertyClosedShape => 'Closed shape (can be filled)';

  @override
  String get propertyRenameShape => 'Rename shape';

  @override
  String propertyCornerRadius(String value) {
    return 'Corner radius: $value';
  }

  @override
  String propertyStrokeWidth(String value) {
    return 'Stroke width: $value';
  }

  @override
  String imageOnLayer(Object name) {
    return 'Image on “$name”';
  }

  @override
  String get imagePanelHint =>
      'Load a picture onto this layer to trace over or use as a background.';

  @override
  String statusPreview(String value) {
    return 'Preview: $value';
  }

  @override
  String get statusCtrlWheel => 'Ctrl+wheel zooms.';

  @override
  String get buttonClose => 'Close';

  @override
  String get buttonReplace => 'Replace';

  @override
  String get buttonLoad => 'Load';

  @override
  String get buttonUse => 'Use';

  @override
  String get buttonNone => 'None';

  @override
  String get colorFillTooltip => 'Fill colour';

  @override
  String get colorStrokeTooltip => 'Stroke colour';

  @override
  String get buttonExport => 'Export';

  @override
  String get interfaceSwitchAdvanced => 'Switch to the advanced interface';

  @override
  String get toolHintSelect =>
      'Click a shape or image to select it. Drag to move it; drag its handles to resize. Double-click an edge to add a point, Alt-click a point to remove it.';

  @override
  String get toolHintRectangle =>
      'Drag to draw a rectangle. Hold Shift for a square.';

  @override
  String get toolHintEllipse =>
      'Drag to draw an ellipse. Hold Shift for a circle.';

  @override
  String get toolHintLine => 'Drag to draw a line. Hold Shift for 45° angles.';

  @override
  String get toolHintPolygon =>
      'Click to add points. Click the first point or double-click to close the shape. Press Enter to leave an open line path; Esc cancels.';

  @override
  String get toolHintFreehand => 'Drag to draw a smoothed freehand stroke.';

  @override
  String get toolHintImage =>
      'Drag to move this layer’s image; drag a handle to resize it. Corners keep proportions; Shift or an edge handle stretches it.';

  @override
  String get ribbonFile => 'File';

  @override
  String get ribbonHome => 'Home';

  @override
  String get ribbonInsert => 'Insert';

  @override
  String get ribbonLayer => 'Layer';

  @override
  String get ribbonImage => 'Image';

  @override
  String get ribbonView => 'View';

  @override
  String viewZoomLabel(String value) {
    return 'Zoom $value';
  }

  @override
  String get statusMousePan => 'Scroll or right-drag pans.';

  @override
  String get fileTypeProject => 'Flutter Painter Project';

  @override
  String get fileTypeImages => 'Images';

  @override
  String get fileTypeDart => 'Dart';

  @override
  String get fileTypeZip => 'Zip archive';

  @override
  String get fileSaveHere => 'Save here';

  @override
  String workspaceInvalidProject(String path) {
    return 'Not a Flutter Painter project: $path';
  }

  @override
  String workspaceOpenFailed(String path, String error) {
    return 'Could not open $path: $error';
  }

  @override
  String workspaceSaved(String path) {
    return 'Saved $path';
  }

  @override
  String workspaceSaveFailed(String error) {
    return 'Could not save: $error';
  }

  @override
  String imageLoadFailed(String error) {
    return 'Could not load that image: $error';
  }

  @override
  String get dropProjectHint =>
      'Drop a .flp project to open it in a new tab, or an image to put it on the active layer.';

  @override
  String get exportReplaceTitle => 'Replace existing files?';

  @override
  String exportReplaceMessage(int existing, int total) {
    return '$existing of $total files already exist in that folder and will be overwritten.';
  }

  @override
  String get exportReplace => 'Replace';

  @override
  String exportSavedFolder(int count, String path) {
    return 'Saved $count file(s) to $path';
  }

  @override
  String exportSavedArchive(int count, String path) {
    return 'Saved $count file(s) to $path';
  }

  @override
  String exportSaveFailed(String error) {
    return 'Could not save: $error';
  }

  @override
  String get exportCloseTitle => 'Close the code editor?';

  @override
  String get exportCloseMessage =>
      'Your edits to the generated files have not been saved and will be lost.';

  @override
  String get exportClose => 'Close';

  @override
  String get exportRegenerateTitle => 'Regenerate the files?';

  @override
  String get exportRegenerateMessage =>
      'This rebuilds every file from the drawing and drops your edits.';

  @override
  String get exportRegenerate => 'Regenerate';

  @override
  String get exportSettingsChanged =>
      'Export settings changed. Regenerate to apply them (this drops your edits).';

  @override
  String exportTitle(String name) {
    return 'Code editor — $name';
  }

  @override
  String get exportSaveFolder => 'Save locally';

  @override
  String exportSaveFolderTooltip(String modifier) {
    return 'Save all files into a folder ($modifier+S)';
  }

  @override
  String get exportSaveArchive => 'Save as an archive';

  @override
  String exportSaveArchiveTooltip(String modifier) {
    return 'Save all files as one .zip ($modifier+Shift+S)';
  }

  @override
  String get exportCopy => 'Copy';

  @override
  String get exportCopyTooltip => 'Copy the open file to the clipboard';

  @override
  String get exportFormatDocument => 'Format document';

  @override
  String get exportFormatTooltip => 'Format the open file (Shift+Alt+F)';

  @override
  String get exportBuildAgain => 'Build again';

  @override
  String get exportBuildAgainTooltip =>
      'Build the files again from the drawing (drops your edits)';

  @override
  String get exportBackToDrawing => 'Back to the drawing';

  @override
  String get exportSelectFileHint => 'Select a file in the explorer to open it';

  @override
  String get exportExplorer => 'Explorer';

  @override
  String get exportSettingsLabel => 'Settings';

  @override
  String get exportCloseTab => 'Close';

  @override
  String get projectTabCloseTooltip => 'Close (Ctrl+W)';

  @override
  String get projectTabNotSaved => 'Not saved yet';

  @override
  String layerDefaultGroup(int number) {
    return 'Group $number';
  }

  @override
  String editorCaret(int line, int column) {
    return 'Ln $line, Col $column';
  }

  @override
  String editorCaretSelection(int line, int column, int selected) {
    return 'Ln $line, Col $column ($selected selected)';
  }

  @override
  String editorLineCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lines',
      one: '1 line',
    );
    return '$_temp0';
  }

  @override
  String editorSpaceCount(int count) {
    return 'Spaces: $count';
  }

  @override
  String exportRegenerated(int count) {
    return '$count file(s) regenerated';
  }

  @override
  String exportFormatted(String name) {
    return 'Formatted $name';
  }

  @override
  String exportCopied(String name) {
    return 'Copied $name to the clipboard';
  }

  @override
  String get projectUnavailable => 'No active project is available here.';

  @override
  String get untitledProject => 'Untitled';

  @override
  String untitledProjectNumbered(int number) {
    return 'Untitled $number';
  }

  @override
  String defaultLayerName(int number) {
    return 'Layer $number';
  }

  @override
  String defaultGroupName(int number) {
    return 'Group $number';
  }

  @override
  String projectFileDamaged(String path) {
    return 'Could not open $path: the file is damaged or is not a project.';
  }

  @override
  String projectFileTooNew(String path) {
    return '$path was made with a newer version of Flutter Painter. Update the app to open it.';
  }

  @override
  String get statusNotBackedUp => 'Not backed up';

  @override
  String get statusNotBackedUpTooltip =>
      'A recovery copy could not be saved. Save your project to avoid losing work.';

  @override
  String get layerCopyItem => 'Copy item';

  @override
  String get layerDragReorder => 'Drag to reorder layers';
}
