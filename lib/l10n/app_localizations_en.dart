// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get newProject => 'New Project';

  @override
  String get newProjectTooltip => 'Start a new project (Ctrl+N)';

  @override
  String get inlineCode => 'Inline Code';

  @override
  String get inlineCodeTooltip => 'Show or hide the inline code view';

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
  String get shapeDelete => 'Delete';

  @override
  String get shapeForward => 'Forward';

  @override
  String get shapeBack => 'Back';

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
  String get layerEditGroup => 'Edit group name';

  @override
  String get shapeScaleDown => 'Scale down 10%';
}
