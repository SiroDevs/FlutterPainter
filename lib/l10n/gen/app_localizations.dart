import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_gn.dart';
import 'app_localizations_ha.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sw.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_ur.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bn'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fa'),
    Locale('fr'),
    Locale('gn'),
    Locale('ha'),
    Locale('hi'),
    Locale('id'),
    Locale('ms'),
    Locale('nl'),
    Locale('pt'),
    Locale('ru'),
    Locale('sw'),
    Locale('tr'),
    Locale('ur'),
    Locale('zh'),
  ];

  /// No description provided for @newProject.
  ///
  /// In en, this message translates to:
  /// **'New Project'**
  String get newProject;

  /// No description provided for @newProjectTooltip.
  ///
  /// In en, this message translates to:
  /// **'Start a new project (Ctrl+N)'**
  String get newProjectTooltip;

  /// No description provided for @inlineCode.
  ///
  /// In en, this message translates to:
  /// **'Inline Code'**
  String get inlineCode;

  /// No description provided for @inlineCodeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Show or hide the inline code view'**
  String get inlineCodeTooltip;

  /// No description provided for @quickCode.
  ///
  /// In en, this message translates to:
  /// **'Quick Code'**
  String get quickCode;

  /// No description provided for @quickCodeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit or paste shape coordinates'**
  String get quickCodeTooltip;

  /// No description provided for @quickCodePolygonMenu.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get quickCodePolygonMenu;

  /// No description provided for @quickCodeToolMenuHint.
  ///
  /// In en, this message translates to:
  /// **'Right-click or hold for more options'**
  String get quickCodeToolMenuHint;

  /// No description provided for @quickCodeCoordinates.
  ///
  /// In en, this message translates to:
  /// **'Coordinates'**
  String get quickCodeCoordinates;

  /// No description provided for @quickCodeDartCode.
  ///
  /// In en, this message translates to:
  /// **'Dart code'**
  String get quickCodeDartCode;

  /// No description provided for @quickCodeFormatTooltip.
  ///
  /// In en, this message translates to:
  /// **'Switch between Dart code and compact coordinates'**
  String get quickCodeFormatTooltip;

  /// No description provided for @quickCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Paste Offset(x, y) points or x,y pairs separated by spaces.'**
  String get quickCodeHint;

  /// No description provided for @quickCodeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Code must be a list of Offset(x, y) points.'**
  String get quickCodeInvalid;

  /// No description provided for @quickCodeNeedMorePoints.
  ///
  /// In en, this message translates to:
  /// **'Add enough points for this shape.'**
  String get quickCodeNeedMorePoints;

  /// No description provided for @quickCodePolygonReady.
  ///
  /// In en, this message translates to:
  /// **'Polygon preview ready.'**
  String get quickCodePolygonReady;

  /// No description provided for @quickCodeShapeReady.
  ///
  /// In en, this message translates to:
  /// **'Canvas updated from these points.'**
  String get quickCodeShapeReady;

  /// No description provided for @quickCodeAddPolygon.
  ///
  /// In en, this message translates to:
  /// **'Add polygon'**
  String get quickCodeAddPolygon;

  /// No description provided for @quickCodeAddShapes.
  ///
  /// In en, this message translates to:
  /// **'Add shapes'**
  String get quickCodeAddShapes;

  /// No description provided for @quickCodeClose.
  ///
  /// In en, this message translates to:
  /// **'Close Quick Code'**
  String get quickCodeClose;

  /// No description provided for @openFullEditor.
  ///
  /// In en, this message translates to:
  /// **'Open the full code editor'**
  String get openFullEditor;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @removeFileTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove this file and its shapes'**
  String get removeFileTooltip;

  /// No description provided for @statusIdle.
  ///
  /// In en, this message translates to:
  /// **'Edit the code and the canvas follows'**
  String get statusIdle;

  /// No description provided for @statusRendered.
  ///
  /// In en, this message translates to:
  /// **'Canvas updated from the code'**
  String get statusRendered;

  /// No description provided for @statusUnreadable.
  ///
  /// In en, this message translates to:
  /// **'Cannot read this code yet; the canvas is unchanged'**
  String get statusUnreadable;

  /// No description provided for @statusSkipped.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 statement was skipped} other{{count} statements were skipped}}'**
  String statusSkipped(int count);

  /// No description provided for @colorMoreTooltip.
  ///
  /// In en, this message translates to:
  /// **'Open the color picker'**
  String get colorMoreTooltip;

  /// No description provided for @paintBucketTool.
  ///
  /// In en, this message translates to:
  /// **'Paint bucket'**
  String get paintBucketTool;

  /// No description provided for @paintBucketHint.
  ///
  /// In en, this message translates to:
  /// **'Click inside a closed shape to fill it with the active fill color.'**
  String get paintBucketHint;

  /// No description provided for @colorPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Color picker'**
  String get colorPickerTitle;

  /// No description provided for @colorSolid.
  ///
  /// In en, this message translates to:
  /// **'Solid'**
  String get colorSolid;

  /// No description provided for @colorGradient.
  ///
  /// In en, this message translates to:
  /// **'Gradient'**
  String get colorGradient;

  /// No description provided for @colorWheel.
  ///
  /// In en, this message translates to:
  /// **'Wheel'**
  String get colorWheel;

  /// No description provided for @colorSquare.
  ///
  /// In en, this message translates to:
  /// **'Square'**
  String get colorSquare;

  /// No description provided for @colorHexCode.
  ///
  /// In en, this message translates to:
  /// **'Hex code'**
  String get colorHexCode;

  /// No description provided for @colorBrightness.
  ///
  /// In en, this message translates to:
  /// **'Brightness'**
  String get colorBrightness;

  /// No description provided for @colorOpacity.
  ///
  /// In en, this message translates to:
  /// **'Opacity'**
  String get colorOpacity;

  /// No description provided for @gradientLinear.
  ///
  /// In en, this message translates to:
  /// **'Linear'**
  String get gradientLinear;

  /// No description provided for @gradientRadial.
  ///
  /// In en, this message translates to:
  /// **'Radial'**
  String get gradientRadial;

  /// No description provided for @gradientSweep.
  ///
  /// In en, this message translates to:
  /// **'Sweep'**
  String get gradientSweep;

  /// No description provided for @gradientAngle.
  ///
  /// In en, this message translates to:
  /// **'Angle'**
  String get gradientAngle;

  /// No description provided for @gradientRadius.
  ///
  /// In en, this message translates to:
  /// **'Radius'**
  String get gradientRadius;

  /// No description provided for @gradientAddStop.
  ///
  /// In en, this message translates to:
  /// **'Add stop'**
  String get gradientAddStop;

  /// No description provided for @gradientRemoveStop.
  ///
  /// In en, this message translates to:
  /// **'Remove stop'**
  String get gradientRemoveStop;

  /// No description provided for @gradientStopPosition.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get gradientStopPosition;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @shapeGroup.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get shapeGroup;

  /// No description provided for @shapeUngroup.
  ///
  /// In en, this message translates to:
  /// **'Ungroup'**
  String get shapeUngroup;

  /// No description provided for @shapeGroupTooltip.
  ///
  /// In en, this message translates to:
  /// **'Group selected shapes so they move together'**
  String get shapeGroupTooltip;

  /// No description provided for @shapeUngroupTooltip.
  ///
  /// In en, this message translates to:
  /// **'Ungroup selected shapes'**
  String get shapeUngroupTooltip;

  /// No description provided for @shapeActionsPanelTitle.
  ///
  /// In en, this message translates to:
  /// **'Shape actions'**
  String get shapeActionsPanelTitle;

  /// No description provided for @shapeActionsPanelEmpty.
  ///
  /// In en, this message translates to:
  /// **'Select a shape to see its actions.'**
  String get shapeActionsPanelEmpty;

  /// No description provided for @shapeSelectionCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 shape selected} other{{count} shapes selected}}'**
  String shapeSelectionCount(int count);

  /// No description provided for @shapeRotateHint.
  ///
  /// In en, this message translates to:
  /// **'Drag the round handle to rotate. Hold Shift to snap every 15°.'**
  String get shapeRotateHint;

  /// No description provided for @vertexDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete this point'**
  String get vertexDelete;

  /// No description provided for @vertexSplit.
  ///
  /// In en, this message translates to:
  /// **'Split this point'**
  String get vertexSplit;

  /// No description provided for @shapeDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get shapeDuplicate;

  /// No description provided for @shapeCopyGroup.
  ///
  /// In en, this message translates to:
  /// **'Copy group'**
  String get shapeCopyGroup;

  /// No description provided for @shapePasteGroup.
  ///
  /// In en, this message translates to:
  /// **'Paste group'**
  String get shapePasteGroup;

  /// No description provided for @shapeDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get shapeDelete;

  /// No description provided for @shapeForward.
  ///
  /// In en, this message translates to:
  /// **'Forward'**
  String get shapeForward;

  /// No description provided for @shapeBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get shapeBack;

  /// No description provided for @shapeBringToFront.
  ///
  /// In en, this message translates to:
  /// **'Bring to front'**
  String get shapeBringToFront;

  /// No description provided for @shapeSendToBack.
  ///
  /// In en, this message translates to:
  /// **'Send to back'**
  String get shapeSendToBack;

  /// No description provided for @shapeBringForward.
  ///
  /// In en, this message translates to:
  /// **'Bring forward'**
  String get shapeBringForward;

  /// No description provided for @shapeSendBackward.
  ///
  /// In en, this message translates to:
  /// **'Send backward'**
  String get shapeSendBackward;

  /// No description provided for @shapeOrderGroup.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get shapeOrderGroup;

  /// No description provided for @shapeMoveToLayer.
  ///
  /// In en, this message translates to:
  /// **'Move to layer'**
  String get shapeMoveToLayer;

  /// No description provided for @shapeToLayer.
  ///
  /// In en, this message translates to:
  /// **'To layer'**
  String get shapeToLayer;

  /// No description provided for @layersTitle.
  ///
  /// In en, this message translates to:
  /// **'Layers'**
  String get layersTitle;

  /// No description provided for @layerAdd.
  ///
  /// In en, this message translates to:
  /// **'Add layer'**
  String get layerAdd;

  /// No description provided for @layerRename.
  ///
  /// In en, this message translates to:
  /// **'Rename layer'**
  String get layerRename;

  /// No description provided for @layerMoveUp.
  ///
  /// In en, this message translates to:
  /// **'Move layer up'**
  String get layerMoveUp;

  /// No description provided for @layerMoveDown.
  ///
  /// In en, this message translates to:
  /// **'Move layer down'**
  String get layerMoveDown;

  /// No description provided for @layerDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete layer'**
  String get layerDelete;

  /// No description provided for @layerHide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get layerHide;

  /// No description provided for @layerShow.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get layerShow;

  /// No description provided for @layerGroup.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get layerGroup;

  /// No description provided for @layerPicture.
  ///
  /// In en, this message translates to:
  /// **'Picture'**
  String get layerPicture;

  /// No description provided for @layerItemRectangle.
  ///
  /// In en, this message translates to:
  /// **'Rectangle'**
  String get layerItemRectangle;

  /// No description provided for @layerItemEllipse.
  ///
  /// In en, this message translates to:
  /// **'Ellipse'**
  String get layerItemEllipse;

  /// No description provided for @layerItemLine.
  ///
  /// In en, this message translates to:
  /// **'Line'**
  String get layerItemLine;

  /// No description provided for @layerItemPolygon.
  ///
  /// In en, this message translates to:
  /// **'Polygon'**
  String get layerItemPolygon;

  /// No description provided for @layerItemFreehand.
  ///
  /// In en, this message translates to:
  /// **'Freehand'**
  String get layerItemFreehand;

  /// No description provided for @layerEditItem.
  ///
  /// In en, this message translates to:
  /// **'Edit item name'**
  String get layerEditItem;

  /// No description provided for @canvasSelectGroupMemberHint.
  ///
  /// In en, this message translates to:
  /// **'Ctrl-click to select only this item from its group'**
  String get canvasSelectGroupMemberHint;

  /// No description provided for @layerEditGroup.
  ///
  /// In en, this message translates to:
  /// **'Edit group name'**
  String get layerEditGroup;

  /// No description provided for @shapeScaleDown.
  ///
  /// In en, this message translates to:
  /// **'Scale down 10%'**
  String get shapeScaleDown;

  /// No description provided for @ribbonArrangeTab.
  ///
  /// In en, this message translates to:
  /// **'Arrange'**
  String get ribbonArrangeTab;

  /// No description provided for @projectTransferGroup.
  ///
  /// In en, this message translates to:
  /// **'Project transfer'**
  String get projectTransferGroup;

  /// No description provided for @projectCopySelection.
  ///
  /// In en, this message translates to:
  /// **'Copy selection'**
  String get projectCopySelection;

  /// No description provided for @projectCopyLayer.
  ///
  /// In en, this message translates to:
  /// **'Copy layer'**
  String get projectCopyLayer;

  /// No description provided for @projectPaste.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get projectPaste;

  /// No description provided for @projectImportGroup.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get projectImportGroup;

  /// No description provided for @projectImport.
  ///
  /// In en, this message translates to:
  /// **'Import project…'**
  String get projectImport;

  /// No description provided for @projectImportComplete.
  ///
  /// In en, this message translates to:
  /// **'Imported {count} layers.'**
  String projectImportComplete(int count);

  /// No description provided for @projectImportFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not import {path}.'**
  String projectImportFailed(String path);

  /// No description provided for @shapeTransformGroup.
  ///
  /// In en, this message translates to:
  /// **'Transform'**
  String get shapeTransformGroup;

  /// No description provided for @shapeSelectionGroup.
  ///
  /// In en, this message translates to:
  /// **'Selection'**
  String get shapeSelectionGroup;

  /// No description provided for @shapeFlipHorizontal.
  ///
  /// In en, this message translates to:
  /// **'Flip horizontal'**
  String get shapeFlipHorizontal;

  /// No description provided for @shapeFlipVertical.
  ///
  /// In en, this message translates to:
  /// **'Flip vertical'**
  String get shapeFlipVertical;

  /// No description provided for @shapeClosedPath.
  ///
  /// In en, this message translates to:
  /// **'Closed path'**
  String get shapeClosedPath;

  /// No description provided for @groupMethodsPublic.
  ///
  /// In en, this message translates to:
  /// **'Expose group shape methods'**
  String get groupMethodsPublic;

  /// No description provided for @groupMethodsPublicHelp.
  ///
  /// In en, this message translates to:
  /// **'On: the layer calls each public shape method. Off: the group exposes one paint() method and keeps shape methods private.'**
  String get groupMethodsPublicHelp;

  /// No description provided for @exportGenerating.
  ///
  /// In en, this message translates to:
  /// **'Generating Dart code…'**
  String get exportGenerating;

  /// No description provided for @exportSaving.
  ///
  /// In en, this message translates to:
  /// **'Preparing export…'**
  String get exportSaving;

  /// No description provided for @exportGenerationFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not generate the Dart code.'**
  String get exportGenerationFailed;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsGeneral;

  /// No description provided for @settingsProject.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get settingsProject;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageHelp.
  ///
  /// In en, this message translates to:
  /// **'Choose the language used by the app.'**
  String get settingsLanguageHelp;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// No description provided for @languageSwahili.
  ///
  /// In en, this message translates to:
  /// **'Kiswahili'**
  String get languageSwahili;

  /// No description provided for @previewNone.
  ///
  /// In en, this message translates to:
  /// **'Off (true colours)'**
  String get previewNone;

  /// No description provided for @previewGrayscale.
  ///
  /// In en, this message translates to:
  /// **'Grayscale'**
  String get previewGrayscale;

  /// No description provided for @previewProtanopia.
  ///
  /// In en, this message translates to:
  /// **'Protanopia (no red)'**
  String get previewProtanopia;

  /// No description provided for @previewDeuteranopia.
  ///
  /// In en, this message translates to:
  /// **'Deuteranopia (no green)'**
  String get previewDeuteranopia;

  /// No description provided for @previewTritanopia.
  ///
  /// In en, this message translates to:
  /// **'Tritanopia (no blue)'**
  String get previewTritanopia;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @settingsInterface.
  ///
  /// In en, this message translates to:
  /// **'Interface'**
  String get settingsInterface;

  /// No description provided for @interfaceMinimal.
  ///
  /// In en, this message translates to:
  /// **'Minimal'**
  String get interfaceMinimal;

  /// No description provided for @interfaceAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get interfaceAdvanced;

  /// No description provided for @interfaceHelp.
  ///
  /// In en, this message translates to:
  /// **'Advanced shows the ribbon and side panels. Minimal keeps the canvas, tools and colours visible; commands remain in the menus.'**
  String get interfaceHelp;

  /// No description provided for @settingsCodeExport.
  ///
  /// In en, this message translates to:
  /// **'Code export'**
  String get settingsCodeExport;

  /// No description provided for @settingsCodeStructure.
  ///
  /// In en, this message translates to:
  /// **'Code structure'**
  String get settingsCodeStructure;

  /// No description provided for @codeRefactored.
  ///
  /// In en, this message translates to:
  /// **'Refactored'**
  String get codeRefactored;

  /// No description provided for @codeMonolithic.
  ///
  /// In en, this message translates to:
  /// **'Monolithic'**
  String get codeMonolithic;

  /// No description provided for @codeRefactoredHelp.
  ///
  /// In en, this message translates to:
  /// **'A painter, one class per layer in its own file, one function per shape, and a colour palette.'**
  String get codeRefactoredHelp;

  /// No description provided for @codeMonolithicHelp.
  ///
  /// In en, this message translates to:
  /// **'One code file with a painter class and one method per layer.'**
  String get codeMonolithicHelp;

  /// No description provided for @settingsColourManagement.
  ///
  /// In en, this message translates to:
  /// **'Colour management'**
  String get settingsColourManagement;

  /// No description provided for @settingsColourVision.
  ///
  /// In en, this message translates to:
  /// **'Colour vision preview'**
  String get settingsColourVision;

  /// No description provided for @settingsColourVisionHelp.
  ///
  /// In en, this message translates to:
  /// **'Approximates how the canvas may appear to someone with a colour vision difference. It does not change the project or exported code.'**
  String get settingsColourVisionHelp;

  /// No description provided for @settingsColourFormat.
  ///
  /// In en, this message translates to:
  /// **'Colour format in exported code'**
  String get settingsColourFormat;

  /// No description provided for @settingsColourFormatHelp.
  ///
  /// In en, this message translates to:
  /// **'Choose how colours are written in generated Dart.'**
  String get settingsColourFormatHelp;

  /// No description provided for @settingsColourConstants.
  ///
  /// In en, this message translates to:
  /// **'Collect colours into named constants'**
  String get settingsColourConstants;

  /// No description provided for @settingsColourConstantsHelp.
  ///
  /// In en, this message translates to:
  /// **'Write each distinct colour once as a constant and refer to it from shapes.'**
  String get settingsColourConstantsHelp;

  /// No description provided for @settingsUpdates.
  ///
  /// In en, this message translates to:
  /// **'Updates'**
  String get settingsUpdates;

  /// No description provided for @settingsAutoDownloadUpdates.
  ///
  /// In en, this message translates to:
  /// **'Download updates automatically'**
  String get settingsAutoDownloadUpdates;

  /// No description provided for @settingsAutoDownloadUpdatesHelp.
  ///
  /// In en, this message translates to:
  /// **'Check for updates when Flutter Painter starts and while it is open. When enabled, download the matching installer and ask before installing it.'**
  String get settingsAutoDownloadUpdatesHelp;

  /// No description provided for @updateNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Flutter Painter update available'**
  String get updateNotificationTitle;

  /// No description provided for @updateOpenReleaseAction.
  ///
  /// In en, this message translates to:
  /// **'Open release page'**
  String get updateOpenReleaseAction;

  /// No description provided for @updateNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'Version {version} is available. Select to open its release page.'**
  String updateNotificationBody(String version);

  /// No description provided for @updateInstallTitle.
  ///
  /// In en, this message translates to:
  /// **'Update ready to install'**
  String get updateInstallTitle;

  /// No description provided for @updateInstallBody.
  ///
  /// In en, this message translates to:
  /// **'Flutter Painter {version} has been downloaded. Save your work before installing it.'**
  String updateInstallBody(String version);

  /// No description provided for @updateInstallAction.
  ///
  /// In en, this message translates to:
  /// **'Install'**
  String get updateInstallAction;

  /// No description provided for @updateLaterAction.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get updateLaterAction;

  /// No description provided for @updateDownloadFailed.
  ///
  /// In en, this message translates to:
  /// **'The update could not be downloaded. Flutter Painter will try again later.'**
  String get updateDownloadFailed;

  /// No description provided for @updateInstallerFailed.
  ///
  /// In en, this message translates to:
  /// **'Flutter Painter could not open the installer. Try opening the downloaded file from your system\'s app support folder.'**
  String get updateInstallerFailed;

  /// No description provided for @settingsReset.
  ///
  /// In en, this message translates to:
  /// **'Reset to defaults'**
  String get settingsReset;

  /// No description provided for @settingsDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get settingsDone;

  /// No description provided for @projectSettingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage the name and design canvas for this project.'**
  String get projectSettingsDescription;

  /// No description provided for @projectCurrentName.
  ///
  /// In en, this message translates to:
  /// **'Project name'**
  String get projectCurrentName;

  /// No description provided for @projectCanvasSize.
  ///
  /// In en, this message translates to:
  /// **'Canvas size'**
  String get projectCanvasSize;

  /// No description provided for @projectRename.
  ///
  /// In en, this message translates to:
  /// **'Rename project'**
  String get projectRename;

  /// No description provided for @projectResizeCanvas.
  ///
  /// In en, this message translates to:
  /// **'Change canvas size'**
  String get projectResizeCanvas;

  /// No description provided for @projectDimensions.
  ///
  /// In en, this message translates to:
  /// **'{width} × {height} design units'**
  String projectDimensions(String width, String height);

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'A paint studio for creating Flutter custom painters.'**
  String get aboutDescription;

  /// No description provided for @aboutCredits.
  ///
  /// In en, this message translates to:
  /// **'Made by Siro Devs'**
  String get aboutCredits;

  /// No description provided for @buttonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get buttonOk;

  /// No description provided for @canvasSizeTitle.
  ///
  /// In en, this message translates to:
  /// **'Canvas size (design units)'**
  String get canvasSizeTitle;

  /// No description provided for @fieldWidth.
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get fieldWidth;

  /// No description provided for @fieldHeight.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get fieldHeight;

  /// No description provided for @buttonResize.
  ///
  /// In en, this message translates to:
  /// **'Resize'**
  String get buttonResize;

  /// No description provided for @saveChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'Save changes to \"{name}\"?'**
  String saveChangesTitle(String name);

  /// No description provided for @unsavedChangesMessage.
  ///
  /// In en, this message translates to:
  /// **'Your changes will be lost if you do not save them.'**
  String get unsavedChangesMessage;

  /// No description provided for @buttonDontSave.
  ///
  /// In en, this message translates to:
  /// **'Don\'t save'**
  String get buttonDontSave;

  /// No description provided for @recoverUnsavedTitle.
  ///
  /// In en, this message translates to:
  /// **'Recover unsaved work?'**
  String get recoverUnsavedTitle;

  /// No description provided for @recoverUnsavedIntro.
  ///
  /// In en, this message translates to:
  /// **'These projects had unsaved changes when Flutter Painter last closed:'**
  String get recoverUnsavedIntro;

  /// No description provided for @buttonDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get buttonDiscard;

  /// No description provided for @buttonRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get buttonRestore;

  /// No description provided for @fileNewBlank.
  ///
  /// In en, this message translates to:
  /// **'New blank canvas'**
  String get fileNewBlank;

  /// No description provided for @fileOpen.
  ///
  /// In en, this message translates to:
  /// **'Open…'**
  String get fileOpen;

  /// No description provided for @fileSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get fileSave;

  /// No description provided for @fileSaveAs.
  ///
  /// In en, this message translates to:
  /// **'Save as…'**
  String get fileSaveAs;

  /// No description provided for @fileAutoSave.
  ///
  /// In en, this message translates to:
  /// **'Auto-save'**
  String get fileAutoSave;

  /// No description provided for @fileAutoSaveHelp.
  ///
  /// In en, this message translates to:
  /// **'On: write changes straight into the open .flp file. Off: keep a recovery copy until you save.'**
  String get fileAutoSaveHelp;

  /// No description provided for @fileExportDart.
  ///
  /// In en, this message translates to:
  /// **'Export Dart…'**
  String get fileExportDart;

  /// No description provided for @fileCodeEditorTooltip.
  ///
  /// In en, this message translates to:
  /// **'Open the code editor'**
  String get fileCodeEditorTooltip;

  /// No description provided for @fileSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings…'**
  String get fileSettings;

  /// No description provided for @fileRenameProject.
  ///
  /// In en, this message translates to:
  /// **'Rename project…'**
  String get fileRenameProject;

  /// No description provided for @projectNameTooltip.
  ///
  /// In en, this message translates to:
  /// **'Project name (also used for class names)'**
  String get projectNameTooltip;

  /// No description provided for @fileCanvasSize.
  ///
  /// In en, this message translates to:
  /// **'Canvas size…'**
  String get fileCanvasSize;

  /// No description provided for @fileCloseProject.
  ///
  /// In en, this message translates to:
  /// **'Close project'**
  String get fileCloseProject;

  /// No description provided for @fileExit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get fileExit;

  /// No description provided for @aboutMenu.
  ///
  /// In en, this message translates to:
  /// **'About {appName}'**
  String aboutMenu(String appName);

  /// No description provided for @editRedo.
  ///
  /// In en, this message translates to:
  /// **'Redo'**
  String get editRedo;

  /// No description provided for @editDeleteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete the selected shape or image'**
  String get editDeleteTooltip;

  /// No description provided for @editPathClosedTooltip.
  ///
  /// In en, this message translates to:
  /// **'Close or open the selected polygon or line path'**
  String get editPathClosedTooltip;

  /// No description provided for @editFill.
  ///
  /// In en, this message translates to:
  /// **'Fill'**
  String get editFill;

  /// No description provided for @editOutline.
  ///
  /// In en, this message translates to:
  /// **'Outline'**
  String get editOutline;

  /// No description provided for @editStrokeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Stroke (outline)'**
  String get editStrokeTooltip;

  /// No description provided for @imageReplace.
  ///
  /// In en, this message translates to:
  /// **'Replace image…'**
  String get imageReplace;

  /// No description provided for @imageLoad.
  ///
  /// In en, this message translates to:
  /// **'Load image…'**
  String get imageLoad;

  /// No description provided for @imageLoadNewLayer.
  ///
  /// In en, this message translates to:
  /// **'Image on new layer…'**
  String get imageLoadNewLayer;

  /// No description provided for @imagePutLayerTooltip.
  ///
  /// In en, this message translates to:
  /// **'Put a picture on this layer'**
  String get imagePutLayerTooltip;

  /// No description provided for @imageLoadNewLayerTooltip.
  ///
  /// In en, this message translates to:
  /// **'Load a picture onto a new layer'**
  String get imageLoadNewLayerTooltip;

  /// No description provided for @imageSelect.
  ///
  /// In en, this message translates to:
  /// **'Select image'**
  String get imageSelect;

  /// No description provided for @imageSelectTooltip.
  ///
  /// In en, this message translates to:
  /// **'Select this layer’s image (shows resize handles)'**
  String get imageSelectTooltip;

  /// No description provided for @imageMoveResize.
  ///
  /// In en, this message translates to:
  /// **'Move / resize image'**
  String get imageMoveResize;

  /// No description provided for @imageMoveResizeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Move / resize image tool'**
  String get imageMoveResizeTooltip;

  /// No description provided for @imageFit.
  ///
  /// In en, this message translates to:
  /// **'Fit image to canvas'**
  String get imageFit;

  /// No description provided for @imageFitTooltip.
  ///
  /// In en, this message translates to:
  /// **'Fit to canvas (resets stretch)'**
  String get imageFitTooltip;

  /// No description provided for @imageShow.
  ///
  /// In en, this message translates to:
  /// **'Show image'**
  String get imageShow;

  /// No description provided for @imageRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove image'**
  String get imageRemove;

  /// No description provided for @imageLoadTooltip.
  ///
  /// In en, this message translates to:
  /// **'Load an image onto a new layer'**
  String get imageLoadTooltip;

  /// No description provided for @imagePanelShow.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get imagePanelShow;

  /// No description provided for @imageOpacity.
  ///
  /// In en, this message translates to:
  /// **'Opacity {value}%'**
  String imageOpacity(String value);

  /// No description provided for @imageScale.
  ///
  /// In en, this message translates to:
  /// **'Scale {value}'**
  String imageScale(String value);

  /// No description provided for @imagePanelTitle.
  ///
  /// In en, this message translates to:
  /// **'Image on “{name}”'**
  String imagePanelTitle(String name);

  /// No description provided for @imagePanelPrompt.
  ///
  /// In en, this message translates to:
  /// **'Load a picture onto this layer to trace over or use as a background.'**
  String get imagePanelPrompt;

  /// No description provided for @viewZoomIn.
  ///
  /// In en, this message translates to:
  /// **'Zoom in'**
  String get viewZoomIn;

  /// No description provided for @viewZoomOut.
  ///
  /// In en, this message translates to:
  /// **'Zoom out'**
  String get viewZoomOut;

  /// No description provided for @viewFitWindow.
  ///
  /// In en, this message translates to:
  /// **'Fit to window'**
  String get viewFitWindow;

  /// No description provided for @viewGrid.
  ///
  /// In en, this message translates to:
  /// **'Grid'**
  String get viewGrid;

  /// No description provided for @viewSnap.
  ///
  /// In en, this message translates to:
  /// **'Snap to grid'**
  String get viewSnap;

  /// No description provided for @viewCanvasBackground.
  ///
  /// In en, this message translates to:
  /// **'Canvas background'**
  String get viewCanvasBackground;

  /// No description provided for @viewCanvasBackgroundTooltip.
  ///
  /// In en, this message translates to:
  /// **'Cycle the canvas background colour'**
  String get viewCanvasBackgroundTooltip;

  /// No description provided for @viewLightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light theme'**
  String get viewLightTheme;

  /// No description provided for @viewDarkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark theme'**
  String get viewDarkTheme;

  /// No description provided for @viewThemeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Switch between the light and dark theme'**
  String get viewThemeTooltip;

  /// No description provided for @menuFile.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get menuFile;

  /// No description provided for @menuEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get menuEdit;

  /// No description provided for @menuLayer.
  ///
  /// In en, this message translates to:
  /// **'Layer'**
  String get menuLayer;

  /// No description provided for @menuView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get menuView;

  /// No description provided for @menuTools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get menuTools;

  /// No description provided for @menuHelp.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get menuHelp;

  /// No description provided for @menuWindow.
  ///
  /// In en, this message translates to:
  /// **'Window'**
  String get menuWindow;

  /// No description provided for @ribbonExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get ribbonExport;

  /// No description provided for @ribbonExpand.
  ///
  /// In en, this message translates to:
  /// **'Expand the ribbon'**
  String get ribbonExpand;

  /// No description provided for @ribbonCollapse.
  ///
  /// In en, this message translates to:
  /// **'Collapse the ribbon'**
  String get ribbonCollapse;

  /// No description provided for @ribbonLayers.
  ///
  /// In en, this message translates to:
  /// **'Layers'**
  String get ribbonLayers;

  /// No description provided for @ribbonOrder.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get ribbonOrder;

  /// No description provided for @ribbonHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get ribbonHistory;

  /// No description provided for @ribbonStyle.
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get ribbonStyle;

  /// No description provided for @ribbonNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get ribbonNew;

  /// No description provided for @ribbonOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get ribbonOpen;

  /// No description provided for @ribbonBlankCanvas.
  ///
  /// In en, this message translates to:
  /// **'Blank canvas'**
  String get ribbonBlankCanvas;

  /// No description provided for @ribbonProject.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get ribbonProject;

  /// No description provided for @ribbonApp.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get ribbonApp;

  /// No description provided for @ribbonShapes.
  ///
  /// In en, this message translates to:
  /// **'Shapes'**
  String get ribbonShapes;

  /// No description provided for @ribbonPaths.
  ///
  /// In en, this message translates to:
  /// **'Paths'**
  String get ribbonPaths;

  /// No description provided for @ribbonPolygon.
  ///
  /// In en, this message translates to:
  /// **'Polygon'**
  String get ribbonPolygon;

  /// No description provided for @ribbonPictures.
  ///
  /// In en, this message translates to:
  /// **'Pictures'**
  String get ribbonPictures;

  /// No description provided for @ribbonPicture.
  ///
  /// In en, this message translates to:
  /// **'Picture'**
  String get ribbonPicture;

  /// No description provided for @ribbonOnNewLayer.
  ///
  /// In en, this message translates to:
  /// **'On new layer'**
  String get ribbonOnNewLayer;

  /// No description provided for @ribbonLayersGroup.
  ///
  /// In en, this message translates to:
  /// **'Layers'**
  String get ribbonLayersGroup;

  /// No description provided for @ribbonZoom.
  ///
  /// In en, this message translates to:
  /// **'Zoom'**
  String get ribbonZoom;

  /// No description provided for @ribbonFit.
  ///
  /// In en, this message translates to:
  /// **'Fit'**
  String get ribbonFit;

  /// No description provided for @ribbonShow.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get ribbonShow;

  /// No description provided for @ribbonCanvas.
  ///
  /// In en, this message translates to:
  /// **'Canvas'**
  String get ribbonCanvas;

  /// No description provided for @ribbonAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get ribbonAppearance;

  /// No description provided for @ribbonLightDark.
  ///
  /// In en, this message translates to:
  /// **'Light / dark'**
  String get ribbonLightDark;

  /// No description provided for @ribbonArrange.
  ///
  /// In en, this message translates to:
  /// **'Arrange'**
  String get ribbonArrange;

  /// No description provided for @ribbonAdjust.
  ///
  /// In en, this message translates to:
  /// **'Adjust'**
  String get ribbonAdjust;

  /// No description provided for @toolSelectMove.
  ///
  /// In en, this message translates to:
  /// **'Select / move'**
  String get toolSelectMove;

  /// No description provided for @toolMoveImage.
  ///
  /// In en, this message translates to:
  /// **'Move / resize layer image'**
  String get toolMoveImage;

  /// No description provided for @toolRectangle.
  ///
  /// In en, this message translates to:
  /// **'Rectangle'**
  String get toolRectangle;

  /// No description provided for @toolEllipse.
  ///
  /// In en, this message translates to:
  /// **'Ellipse'**
  String get toolEllipse;

  /// No description provided for @toolLine.
  ///
  /// In en, this message translates to:
  /// **'Line'**
  String get toolLine;

  /// No description provided for @toolPolygonPath.
  ///
  /// In en, this message translates to:
  /// **'Polygon / line path'**
  String get toolPolygonPath;

  /// No description provided for @toolFreehand.
  ///
  /// In en, this message translates to:
  /// **'Freehand'**
  String get toolFreehand;

  /// No description provided for @propertyTitle.
  ///
  /// In en, this message translates to:
  /// **'Properties'**
  String get propertyTitle;

  /// No description provided for @propertyNoSelection.
  ///
  /// In en, this message translates to:
  /// **'No shape selected. These settings apply to the next shape you draw.'**
  String get propertyNoSelection;

  /// No description provided for @propertyFill.
  ///
  /// In en, this message translates to:
  /// **'Fill'**
  String get propertyFill;

  /// No description provided for @propertyStroke.
  ///
  /// In en, this message translates to:
  /// **'Stroke'**
  String get propertyStroke;

  /// No description provided for @propertyClosedShape.
  ///
  /// In en, this message translates to:
  /// **'Closed shape (can be filled)'**
  String get propertyClosedShape;

  /// No description provided for @propertyRenameShape.
  ///
  /// In en, this message translates to:
  /// **'Rename shape'**
  String get propertyRenameShape;

  /// No description provided for @propertyCornerRadius.
  ///
  /// In en, this message translates to:
  /// **'Corner radius: {value}'**
  String propertyCornerRadius(String value);

  /// No description provided for @propertyStrokeWidth.
  ///
  /// In en, this message translates to:
  /// **'Stroke width: {value}'**
  String propertyStrokeWidth(String value);

  /// No description provided for @imageOnLayer.
  ///
  /// In en, this message translates to:
  /// **'Image on “{name}”'**
  String imageOnLayer(Object name);

  /// No description provided for @imagePanelHint.
  ///
  /// In en, this message translates to:
  /// **'Load a picture onto this layer to trace over or use as a background.'**
  String get imagePanelHint;

  /// No description provided for @statusPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview: {value}'**
  String statusPreview(String value);

  /// No description provided for @statusCtrlWheel.
  ///
  /// In en, this message translates to:
  /// **'Ctrl+wheel zooms.'**
  String get statusCtrlWheel;

  /// No description provided for @buttonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get buttonClose;

  /// No description provided for @buttonReplace.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get buttonReplace;

  /// No description provided for @buttonLoad.
  ///
  /// In en, this message translates to:
  /// **'Load'**
  String get buttonLoad;

  /// No description provided for @buttonUse.
  ///
  /// In en, this message translates to:
  /// **'Use'**
  String get buttonUse;

  /// No description provided for @buttonNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get buttonNone;

  /// No description provided for @colorFillTooltip.
  ///
  /// In en, this message translates to:
  /// **'Fill colour'**
  String get colorFillTooltip;

  /// No description provided for @colorStrokeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Stroke colour'**
  String get colorStrokeTooltip;

  /// No description provided for @buttonExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get buttonExport;

  /// No description provided for @interfaceSwitchAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Switch to the advanced interface'**
  String get interfaceSwitchAdvanced;

  /// No description provided for @toolHintSelect.
  ///
  /// In en, this message translates to:
  /// **'Click a shape or image to select it. Drag to move it; drag its handles to resize. Double-click an edge to add a point, Alt-click a point to remove it.'**
  String get toolHintSelect;

  /// No description provided for @toolHintRectangle.
  ///
  /// In en, this message translates to:
  /// **'Drag to draw a rectangle. Hold Shift for a square.'**
  String get toolHintRectangle;

  /// No description provided for @toolHintEllipse.
  ///
  /// In en, this message translates to:
  /// **'Drag to draw an ellipse. Hold Shift for a circle.'**
  String get toolHintEllipse;

  /// No description provided for @toolHintLine.
  ///
  /// In en, this message translates to:
  /// **'Drag to draw a line. Hold Shift for 45° angles.'**
  String get toolHintLine;

  /// No description provided for @toolHintPolygon.
  ///
  /// In en, this message translates to:
  /// **'Click to add points. Click the first point or double-click to close the shape. Press Enter to leave an open line path; Esc cancels.'**
  String get toolHintPolygon;

  /// No description provided for @toolHintFreehand.
  ///
  /// In en, this message translates to:
  /// **'Drag to draw a smoothed freehand stroke.'**
  String get toolHintFreehand;

  /// No description provided for @toolHintImage.
  ///
  /// In en, this message translates to:
  /// **'Drag to move this layer’s image; drag a handle to resize it. Corners keep proportions; Shift or an edge handle stretches it.'**
  String get toolHintImage;

  /// No description provided for @ribbonFile.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get ribbonFile;

  /// No description provided for @ribbonHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get ribbonHome;

  /// No description provided for @ribbonInsert.
  ///
  /// In en, this message translates to:
  /// **'Insert'**
  String get ribbonInsert;

  /// No description provided for @ribbonLayer.
  ///
  /// In en, this message translates to:
  /// **'Layer'**
  String get ribbonLayer;

  /// No description provided for @ribbonImage.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get ribbonImage;

  /// No description provided for @ribbonView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get ribbonView;

  /// No description provided for @viewZoomLabel.
  ///
  /// In en, this message translates to:
  /// **'Zoom {value}'**
  String viewZoomLabel(String value);

  /// No description provided for @statusMousePan.
  ///
  /// In en, this message translates to:
  /// **'Scroll or right-drag pans.'**
  String get statusMousePan;

  /// No description provided for @fileTypeProject.
  ///
  /// In en, this message translates to:
  /// **'Flutter Painter Project'**
  String get fileTypeProject;

  /// No description provided for @fileTypeImages.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get fileTypeImages;

  /// No description provided for @fileTypeDart.
  ///
  /// In en, this message translates to:
  /// **'Dart'**
  String get fileTypeDart;

  /// No description provided for @fileTypeZip.
  ///
  /// In en, this message translates to:
  /// **'Zip archive'**
  String get fileTypeZip;

  /// No description provided for @fileSaveHere.
  ///
  /// In en, this message translates to:
  /// **'Save here'**
  String get fileSaveHere;

  /// No description provided for @workspaceInvalidProject.
  ///
  /// In en, this message translates to:
  /// **'Not a Flutter Painter project: {path}'**
  String workspaceInvalidProject(String path);

  /// No description provided for @workspaceOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open {path}: {error}'**
  String workspaceOpenFailed(String path, String error);

  /// No description provided for @workspaceSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved {path}'**
  String workspaceSaved(String path);

  /// No description provided for @workspaceSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save: {error}'**
  String workspaceSaveFailed(String error);

  /// No description provided for @imageLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load that image: {error}'**
  String imageLoadFailed(String error);

  /// No description provided for @dropProjectHint.
  ///
  /// In en, this message translates to:
  /// **'Drop a .flp project to open it in a new tab, or an image to put it on the active layer.'**
  String get dropProjectHint;

  /// No description provided for @exportReplaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Replace existing files?'**
  String get exportReplaceTitle;

  /// No description provided for @exportReplaceMessage.
  ///
  /// In en, this message translates to:
  /// **'{existing} of {total} files already exist in that folder and will be overwritten.'**
  String exportReplaceMessage(int existing, int total);

  /// No description provided for @exportReplace.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get exportReplace;

  /// No description provided for @exportSavedFolder.
  ///
  /// In en, this message translates to:
  /// **'Saved {count} file(s) to {path}'**
  String exportSavedFolder(int count, String path);

  /// No description provided for @exportSavedArchive.
  ///
  /// In en, this message translates to:
  /// **'Saved {count} file(s) to {path}'**
  String exportSavedArchive(int count, String path);

  /// No description provided for @exportSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save: {error}'**
  String exportSaveFailed(String error);

  /// No description provided for @exportCloseTitle.
  ///
  /// In en, this message translates to:
  /// **'Close the code editor?'**
  String get exportCloseTitle;

  /// No description provided for @exportCloseMessage.
  ///
  /// In en, this message translates to:
  /// **'Your edits to the generated files have not been saved and will be lost.'**
  String get exportCloseMessage;

  /// No description provided for @exportClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get exportClose;

  /// No description provided for @exportRegenerateTitle.
  ///
  /// In en, this message translates to:
  /// **'Regenerate the files?'**
  String get exportRegenerateTitle;

  /// No description provided for @exportRegenerateMessage.
  ///
  /// In en, this message translates to:
  /// **'This rebuilds every file from the drawing and drops your edits.'**
  String get exportRegenerateMessage;

  /// No description provided for @exportRegenerate.
  ///
  /// In en, this message translates to:
  /// **'Regenerate'**
  String get exportRegenerate;

  /// No description provided for @exportSettingsChanged.
  ///
  /// In en, this message translates to:
  /// **'Export settings changed. Regenerate to apply them (this drops your edits).'**
  String get exportSettingsChanged;

  /// No description provided for @exportTitle.
  ///
  /// In en, this message translates to:
  /// **'Code editor — {name}'**
  String exportTitle(String name);

  /// No description provided for @exportSaveFolder.
  ///
  /// In en, this message translates to:
  /// **'Save locally'**
  String get exportSaveFolder;

  /// No description provided for @exportSaveFolderTooltip.
  ///
  /// In en, this message translates to:
  /// **'Save all files into a folder ({modifier}+S)'**
  String exportSaveFolderTooltip(String modifier);

  /// No description provided for @exportSaveArchive.
  ///
  /// In en, this message translates to:
  /// **'Save as an archive'**
  String get exportSaveArchive;

  /// No description provided for @exportSaveArchiveTooltip.
  ///
  /// In en, this message translates to:
  /// **'Save all files as one .zip ({modifier}+Shift+S)'**
  String exportSaveArchiveTooltip(String modifier);

  /// No description provided for @exportCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get exportCopy;

  /// No description provided for @exportCopyTooltip.
  ///
  /// In en, this message translates to:
  /// **'Copy the open file to the clipboard'**
  String get exportCopyTooltip;

  /// No description provided for @exportFormatDocument.
  ///
  /// In en, this message translates to:
  /// **'Format document'**
  String get exportFormatDocument;

  /// No description provided for @exportFormatTooltip.
  ///
  /// In en, this message translates to:
  /// **'Format the open file (Shift+Alt+F)'**
  String get exportFormatTooltip;

  /// No description provided for @exportBuildAgain.
  ///
  /// In en, this message translates to:
  /// **'Build again'**
  String get exportBuildAgain;

  /// No description provided for @exportBuildAgainTooltip.
  ///
  /// In en, this message translates to:
  /// **'Build the files again from the drawing (drops your edits)'**
  String get exportBuildAgainTooltip;

  /// No description provided for @exportBackToDrawing.
  ///
  /// In en, this message translates to:
  /// **'Back to the drawing'**
  String get exportBackToDrawing;

  /// No description provided for @exportSelectFileHint.
  ///
  /// In en, this message translates to:
  /// **'Select a file in the explorer to open it'**
  String get exportSelectFileHint;

  /// No description provided for @exportExplorer.
  ///
  /// In en, this message translates to:
  /// **'Explorer'**
  String get exportExplorer;

  /// No description provided for @exportSettingsLabel.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get exportSettingsLabel;

  /// No description provided for @exportCloseTab.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get exportCloseTab;

  /// No description provided for @projectTabCloseTooltip.
  ///
  /// In en, this message translates to:
  /// **'Close (Ctrl+W)'**
  String get projectTabCloseTooltip;

  /// No description provided for @projectTabNotSaved.
  ///
  /// In en, this message translates to:
  /// **'Not saved yet'**
  String get projectTabNotSaved;

  /// No description provided for @layerDefaultGroup.
  ///
  /// In en, this message translates to:
  /// **'Group {number}'**
  String layerDefaultGroup(int number);

  /// No description provided for @editorCaret.
  ///
  /// In en, this message translates to:
  /// **'Ln {line}, Col {column}'**
  String editorCaret(int line, int column);

  /// No description provided for @editorCaretSelection.
  ///
  /// In en, this message translates to:
  /// **'Ln {line}, Col {column} ({selected} selected)'**
  String editorCaretSelection(int line, int column, int selected);

  /// No description provided for @editorLineCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 line} other{{count} lines}}'**
  String editorLineCount(int count);

  /// No description provided for @editorSpaceCount.
  ///
  /// In en, this message translates to:
  /// **'Spaces: {count}'**
  String editorSpaceCount(int count);

  /// No description provided for @exportRegenerated.
  ///
  /// In en, this message translates to:
  /// **'{count} file(s) regenerated'**
  String exportRegenerated(int count);

  /// No description provided for @exportFormatted.
  ///
  /// In en, this message translates to:
  /// **'Formatted {name}'**
  String exportFormatted(String name);

  /// No description provided for @exportCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied {name} to the clipboard'**
  String exportCopied(String name);

  /// No description provided for @projectUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No active project is available here.'**
  String get projectUnavailable;

  /// No description provided for @untitledProject.
  ///
  /// In en, this message translates to:
  /// **'Untitled'**
  String get untitledProject;

  /// No description provided for @untitledProjectNumbered.
  ///
  /// In en, this message translates to:
  /// **'Untitled {number}'**
  String untitledProjectNumbered(int number);

  /// No description provided for @defaultLayerName.
  ///
  /// In en, this message translates to:
  /// **'Layer {number}'**
  String defaultLayerName(int number);

  /// No description provided for @defaultGroupName.
  ///
  /// In en, this message translates to:
  /// **'Group {number}'**
  String defaultGroupName(int number);

  /// No description provided for @projectFileDamaged.
  ///
  /// In en, this message translates to:
  /// **'Could not open {path}: the file is damaged or is not a project.'**
  String projectFileDamaged(String path);

  /// No description provided for @projectFileTooNew.
  ///
  /// In en, this message translates to:
  /// **'{path} was made with a newer version of Flutter Painter. Update the app to open it.'**
  String projectFileTooNew(String path);

  /// No description provided for @statusNotBackedUp.
  ///
  /// In en, this message translates to:
  /// **'Not backed up'**
  String get statusNotBackedUp;

  /// No description provided for @statusNotBackedUpTooltip.
  ///
  /// In en, this message translates to:
  /// **'A recovery copy could not be saved. Save your project to avoid losing work.'**
  String get statusNotBackedUpTooltip;

  /// No description provided for @layerCopyItem.
  ///
  /// In en, this message translates to:
  /// **'Copy item'**
  String get layerCopyItem;

  /// No description provided for @layerDragReorder.
  ///
  /// In en, this message translates to:
  /// **'Drag to reorder layers'**
  String get layerDragReorder;

  /// No description provided for @ribbon3d.
  ///
  /// In en, this message translates to:
  /// **'3D'**
  String get ribbon3d;

  /// No description provided for @layerMake3d.
  ///
  /// In en, this message translates to:
  /// **'Make 3D layer'**
  String get layerMake3d;

  /// No description provided for @layerRemove3d.
  ///
  /// In en, this message translates to:
  /// **'Back to flat layer'**
  String get layerRemove3d;

  /// No description provided for @model3dViewLeft.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get model3dViewLeft;

  /// No description provided for @model3dViewRight.
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get model3dViewRight;

  /// No description provided for @model3dTitle.
  ///
  /// In en, this message translates to:
  /// **'3D setup of “{name}”'**
  String model3dTitle(String name);

  /// No description provided for @model3dPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview on canvas'**
  String get model3dPreview;

  /// No description provided for @model3dPreviewNote.
  ///
  /// In en, this message translates to:
  /// **'Drawing and selecting are paused while previewing.'**
  String get model3dPreviewNote;

  /// No description provided for @model3dViews.
  ///
  /// In en, this message translates to:
  /// **'Views'**
  String get model3dViews;

  /// No description provided for @model3dViewAdd.
  ///
  /// In en, this message translates to:
  /// **'Add view'**
  String get model3dViewAdd;

  /// No description provided for @model3dViewRename.
  ///
  /// In en, this message translates to:
  /// **'Rename view'**
  String get model3dViewRename;

  /// No description provided for @model3dViewDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete view'**
  String get model3dViewDelete;

  /// No description provided for @model3dDefaultViewName.
  ///
  /// In en, this message translates to:
  /// **'View {number}'**
  String model3dDefaultViewName(String number);

  /// No description provided for @model3dTurn.
  ///
  /// In en, this message translates to:
  /// **'Turn'**
  String get model3dTurn;

  /// No description provided for @model3dTilt.
  ///
  /// In en, this message translates to:
  /// **'Tilt'**
  String get model3dTilt;

  /// No description provided for @model3dZoom.
  ///
  /// In en, this message translates to:
  /// **'Zoom'**
  String get model3dZoom;

  /// No description provided for @model3dValue.
  ///
  /// In en, this message translates to:
  /// **'{name}: {value}'**
  String model3dValue(String name, String value);

  /// No description provided for @model3dShape.
  ///
  /// In en, this message translates to:
  /// **'Selected shapes'**
  String get model3dShape;

  /// No description provided for @model3dNoShape.
  ///
  /// In en, this message translates to:
  /// **'Select a shape to set its depth and thickness.'**
  String get model3dNoShape;

  /// No description provided for @model3dDepth.
  ///
  /// In en, this message translates to:
  /// **'Depth'**
  String get model3dDepth;

  /// No description provided for @model3dThickness.
  ///
  /// In en, this message translates to:
  /// **'Thickness'**
  String get model3dThickness;

  /// No description provided for @model3dPivot.
  ///
  /// In en, this message translates to:
  /// **'Turning point'**
  String get model3dPivot;

  /// No description provided for @model3dAcross.
  ///
  /// In en, this message translates to:
  /// **'Across'**
  String get model3dAcross;

  /// No description provided for @model3dDown.
  ///
  /// In en, this message translates to:
  /// **'Down'**
  String get model3dDown;

  /// No description provided for @model3dParts.
  ///
  /// In en, this message translates to:
  /// **'Parts'**
  String get model3dParts;

  /// No description provided for @model3dPartsNone.
  ///
  /// In en, this message translates to:
  /// **'No parts yet. Group shapes to move them as one part.'**
  String get model3dPartsNone;

  /// No description provided for @model3dPartJoint.
  ///
  /// In en, this message translates to:
  /// **'Joint'**
  String get model3dPartJoint;

  /// No description provided for @model3dPartParent.
  ///
  /// In en, this message translates to:
  /// **'Attached to'**
  String get model3dPartParent;

  /// No description provided for @model3dPartParentNone.
  ///
  /// In en, this message translates to:
  /// **'Nothing'**
  String get model3dPartParentNone;

  /// No description provided for @model3dPartPose.
  ///
  /// In en, this message translates to:
  /// **'Pose in “{view}”'**
  String model3dPartPose(String view);

  /// No description provided for @model3dLean.
  ///
  /// In en, this message translates to:
  /// **'Lean'**
  String get model3dLean;

  /// No description provided for @model3dGhost.
  ///
  /// In en, this message translates to:
  /// **'Compare with'**
  String get model3dGhost;

  /// No description provided for @model3dGhostNone.
  ///
  /// In en, this message translates to:
  /// **'Nothing'**
  String get model3dGhostNone;

  /// No description provided for @model3dPartVisible.
  ///
  /// In en, this message translates to:
  /// **'Visible in this view'**
  String get model3dPartVisible;

  /// No description provided for @model3dViewFront.
  ///
  /// In en, this message translates to:
  /// **'Front'**
  String get model3dViewFront;

  /// No description provided for @model3dFold.
  ///
  /// In en, this message translates to:
  /// **'Fold'**
  String get model3dFold;

  /// No description provided for @model3dBend.
  ///
  /// In en, this message translates to:
  /// **'Bend'**
  String get model3dBend;

  /// No description provided for @model3dAxis.
  ///
  /// In en, this message translates to:
  /// **'Fold line angle'**
  String get model3dAxis;

  /// No description provided for @model3dFoldHint.
  ///
  /// In en, this message translates to:
  /// **'Positive folds and bends the part away from you.'**
  String get model3dFoldHint;

  /// No description provided for @model3dLive.
  ///
  /// In en, this message translates to:
  /// **'Live 3D'**
  String get model3dLive;

  /// No description provided for @model3dLiveNote.
  ///
  /// In en, this message translates to:
  /// **'Drag empty space to turn the view. Drag a shape to move it in depth, or hold Alt and drag to tilt it.'**
  String get model3dLiveNote;

  /// No description provided for @model3dLiveSave.
  ///
  /// In en, this message translates to:
  /// **'Save angle as view'**
  String get model3dLiveSave;

  /// No description provided for @model3dForm.
  ///
  /// In en, this message translates to:
  /// **'Shape form'**
  String get model3dForm;

  /// No description provided for @model3dFormThicknessNote.
  ///
  /// In en, this message translates to:
  /// **'Give the shape a thickness to see its form.'**
  String get model3dFormThicknessNote;

  /// No description provided for @model3dSectionBox.
  ///
  /// In en, this message translates to:
  /// **'Box'**
  String get model3dSectionBox;

  /// No description provided for @model3dSectionEllipse.
  ///
  /// In en, this message translates to:
  /// **'Ellipse'**
  String get model3dSectionEllipse;

  /// No description provided for @model3dSectionPolygon.
  ///
  /// In en, this message translates to:
  /// **'Polygon'**
  String get model3dSectionPolygon;

  /// No description provided for @model3dSectionSides.
  ///
  /// In en, this message translates to:
  /// **'Sides'**
  String get model3dSectionSides;

  /// No description provided for @model3dSectionAcrossWidth.
  ///
  /// In en, this message translates to:
  /// **'Across width'**
  String get model3dSectionAcrossWidth;

  /// No description provided for @model3dSectionAcrossHeight.
  ///
  /// In en, this message translates to:
  /// **'Across height'**
  String get model3dSectionAcrossHeight;

  /// No description provided for @model3dShapeTilt.
  ///
  /// In en, this message translates to:
  /// **'Tilt (3D only)'**
  String get model3dShapeTilt;

  /// No description provided for @model3dWorkStart.
  ///
  /// In en, this message translates to:
  /// **'Work on this part'**
  String get model3dWorkStart;

  /// No description provided for @model3dWorkStop.
  ///
  /// In en, this message translates to:
  /// **'Stop working on this part'**
  String get model3dWorkStop;

  /// No description provided for @model3dWorkNote.
  ///
  /// In en, this message translates to:
  /// **'Working on “{part}”. Other parts are shown faded.'**
  String model3dWorkNote(String part);

  /// No description provided for @model3dAddFaceOn.
  ///
  /// In en, this message translates to:
  /// **'Add a face on'**
  String get model3dAddFaceOn;

  /// No description provided for @model3dAddFace.
  ///
  /// In en, this message translates to:
  /// **'Add face'**
  String get model3dAddFace;

  /// No description provided for @model3dEdgeTop.
  ///
  /// In en, this message translates to:
  /// **'Top edge'**
  String get model3dEdgeTop;

  /// No description provided for @model3dEdgeRight.
  ///
  /// In en, this message translates to:
  /// **'Right edge'**
  String get model3dEdgeRight;

  /// No description provided for @model3dEdgeBottom.
  ///
  /// In en, this message translates to:
  /// **'Bottom edge'**
  String get model3dEdgeBottom;

  /// No description provided for @model3dEdgeLeft.
  ///
  /// In en, this message translates to:
  /// **'Left edge'**
  String get model3dEdgeLeft;

  /// No description provided for @model3dEdgeNumber.
  ///
  /// In en, this message translates to:
  /// **'Edge {number}'**
  String model3dEdgeNumber(String number);

  /// No description provided for @model3dFaceName.
  ///
  /// In en, this message translates to:
  /// **'Face {number}'**
  String model3dFaceName(String number);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'bn',
    'de',
    'en',
    'es',
    'fa',
    'fr',
    'gn',
    'ha',
    'hi',
    'id',
    'ms',
    'nl',
    'pt',
    'ru',
    'sw',
    'tr',
    'ur',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bn':
      return AppLocalizationsBn();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fa':
      return AppLocalizationsFa();
    case 'fr':
      return AppLocalizationsFr();
    case 'gn':
      return AppLocalizationsGn();
    case 'ha':
      return AppLocalizationsHa();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'ms':
      return AppLocalizationsMs();
    case 'nl':
      return AppLocalizationsNl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'sw':
      return AppLocalizationsSw();
    case 'tr':
      return AppLocalizationsTr();
    case 'ur':
      return AppLocalizationsUr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
