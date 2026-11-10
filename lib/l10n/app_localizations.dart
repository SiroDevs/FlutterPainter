import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_sw.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
    Locale('en'),
    Locale('sw'),
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
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'sw'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'sw':
      return AppLocalizationsSw();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
