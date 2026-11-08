// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swahili (`sw`).
class AppLocalizationsSw extends AppLocalizations {
  AppLocalizationsSw([String locale = 'sw']) : super(locale);

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
  String get shapeGroup => 'Unganisha';

  @override
  String get shapeUngroup => 'Tenganisha';

  @override
  String get shapeGroupTooltip =>
      'Unganisha maumbo yaliyochaguliwa ili yahame pamoja';

  @override
  String get shapeUngroupTooltip => 'Tenganisha maumbo yaliyochaguliwa';

  @override
  String shapeSelectionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Maumbo $count yamechaguliwa',
      one: 'Umbo 1 limechaguliwa',
    );
    return '$_temp0';
  }

  @override
  String get shapeRotateHint =>
      'Buruta kishikio cha duara ili kuzungusha. Shikilia Shift ili kuruka kwa kila 15°.';

  @override
  String get vertexDelete => 'Futa nukta hii';

  @override
  String get vertexSplit => 'Gawa nukta hii';

  @override
  String get shapeDuplicate => 'Nakili';

  @override
  String get shapeDelete => 'Futa';

  @override
  String get shapeForward => 'Peleka mbele';

  @override
  String get shapeBack => 'Rudisha nyuma';

  @override
  String get shapeMoveToLayer => 'Hamisha kwenye tabaka';

  @override
  String get shapeToLayer => 'Kwa tabaka';

  @override
  String get layersTitle => 'Tabaka';

  @override
  String get layerAdd => 'Ongeza tabaka';

  @override
  String get layerRename => 'Badilisha jina la tabaka';

  @override
  String get layerMoveUp => 'Peleka tabaka juu';

  @override
  String get layerMoveDown => 'Peleka tabaka chini';

  @override
  String get layerDelete => 'Futa tabaka';

  @override
  String get layerHide => 'Ficha';

  @override
  String get layerShow => 'Onyesha';

  @override
  String get layerGroup => 'Kikundi';

  @override
  String get layerPicture => 'Picha';

  @override
  String get layerItemRectangle => 'Mstatili';

  @override
  String get layerItemEllipse => 'Duara bapa';

  @override
  String get layerItemLine => 'Mstari';

  @override
  String get layerItemPolygon => 'Poligoni';

  @override
  String get layerItemFreehand => 'Mchoro huru';

  @override
  String get layerEditItem => 'Hariri jina la kitu';

  @override
  String get canvasSelectGroupMemberHint =>
      'Bonyeza Ctrl na ubofye ili kuchagua kipengee hiki pekee kutoka kwenye kundi lake';

  @override
  String get layerEditGroup => 'Hariri jina la kikundi';

  @override
  String get shapeScaleDown => 'Punguza ukubwa kwa 10%';

  @override
  String get groupMethodsPublic => 'Onyesha mbinu za maumbo ya kikundi';

  @override
  String get groupMethodsPublicHelp =>
      'Ikiwashwa, tabaka huita mbinu ya kila umbo moja kwa moja. Ikizimwa, kikundi huwa na mbinu moja ya paint() na mbinu za maumbo hubaki za ndani.';

  @override
  String get exportGenerating => 'Inatengeneza msimbo wa Dart…';

  @override
  String get exportSaving => 'Inaandaa faili la nje…';

  @override
  String get exportGenerationFailed => 'Imeshindwa kutengeneza msimbo wa Dart.';
}
