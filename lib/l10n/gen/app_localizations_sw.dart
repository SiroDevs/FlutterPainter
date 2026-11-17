// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swahili (`sw`).
class AppLocalizationsSw extends AppLocalizations {
  AppLocalizationsSw([String locale = 'sw']) : super(locale);

  @override
  String get newProject => 'Mradi Mpya';

  @override
  String get newProjectTooltip => 'Anzisha mradi mpya (Ctrl+N)';

  @override
  String get inlineCode => 'Msimbo wa Ndani';

  @override
  String get inlineCodeTooltip =>
      'Onyesha au ficha mwonekano wa msimbo wa ndani';

  @override
  String get quickCode => 'Msimbo wa Haraka';

  @override
  String get quickCodeTooltip => 'Hariri au bandika viwianishi vya umbo';

  @override
  String get quickCodePolygonMenu => 'Msimbo';

  @override
  String get quickCodeToolMenuHint =>
      'Bofya kulia au shikilia ili kuona chaguo zaidi';

  @override
  String get quickCodeCoordinates => 'Viwianishi';

  @override
  String get quickCodeDartCode => 'Msimbo wa Dart';

  @override
  String get quickCodeFormatTooltip =>
      'Badili kati ya msimbo wa Dart na viwianishi vifupi';

  @override
  String get quickCodeHint =>
      'Bandika nukta za Offset(x, y) au jozi za x,y zilizotenganishwa kwa nafasi.';

  @override
  String get quickCodeInvalid => 'Msimbo uwe orodha ya nukta za Offset(x, y).';

  @override
  String get quickCodeNeedMorePoints =>
      'Ongeza nukta za kutosha kwa umbo hili.';

  @override
  String get quickCodePolygonReady => 'Muhtasari wa poligoni uko tayari.';

  @override
  String get quickCodeShapeReady => 'Turubai imesasishwa kwa nukta hizi.';

  @override
  String get quickCodeAddPolygon => 'Ongeza poligoni';

  @override
  String get quickCodeAddShapes => 'Ongeza maumbo';

  @override
  String get quickCodeClose => 'Funga Msimbo wa Haraka';

  @override
  String get openFullEditor => 'Fungua kihariri kamili cha msimbo';

  @override
  String get undo => 'Tendua';

  @override
  String get removeFileTooltip => 'Ondoa faili hili na maumbo yake';

  @override
  String get statusIdle => 'Hariri msimbo ili turubai ifuate';

  @override
  String get statusRendered => 'Turubai imesasishwa kutoka kwenye msimbo';

  @override
  String get statusUnreadable =>
      'Msimbo huu hauwezi kusomwa bado; turubai haijabadilika';

  @override
  String statusSkipped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kauli $count zimerukwa',
      one: 'Kauli 1 imerukwa',
    );
    return '$_temp0';
  }

  @override
  String get colorMoreTooltip => 'Fungua kichagua rangi';

  @override
  String get paintBucketTool => 'Ndoo ya rangi';

  @override
  String get paintBucketHint =>
      'Bofya ndani ya umbo lililofungwa kulijaza kwa rangi ya sasa ya kujaza.';

  @override
  String get colorPickerTitle => 'Kichagua rangi';

  @override
  String get colorSolid => 'Rangi moja';

  @override
  String get colorGradient => 'Mchanganyiko wa rangi';

  @override
  String get colorWheel => 'Gurudumu';

  @override
  String get colorSquare => 'Mraba';

  @override
  String get colorHexCode => 'Msimbo wa Hex';

  @override
  String get colorBrightness => 'Mwangaza';

  @override
  String get colorOpacity => 'Uwazi';

  @override
  String get gradientLinear => 'Mstari';

  @override
  String get gradientRadial => 'Duara';

  @override
  String get gradientSweep => 'Mzunguko';

  @override
  String get gradientAngle => 'Pembe';

  @override
  String get gradientRadius => 'Kipenyo';

  @override
  String get gradientAddStop => 'Ongeza kikomo';

  @override
  String get gradientRemoveStop => 'Ondoa kikomo';

  @override
  String get gradientStopPosition => 'Nafasi';

  @override
  String get apply => 'Tumia';

  @override
  String get cancel => 'Ghairi';

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
  String get shapeActionsPanelTitle => 'Vitendo vya umbo';

  @override
  String get shapeActionsPanelEmpty => 'Chagua umbo ili kuona vitendo vyake.';

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
  String get shapeCopyGroup => 'Nakili kikundi';

  @override
  String get shapePasteGroup => 'Bandika kikundi';

  @override
  String get shapeDelete => 'Futa';

  @override
  String get shapeForward => 'Peleka mbele';

  @override
  String get shapeBack => 'Rudisha nyuma';

  @override
  String get shapeBringToFront => 'Peleka mbele kabisa';

  @override
  String get shapeSendToBack => 'Rudisha nyuma kabisa';

  @override
  String get shapeBringForward => 'Peleka mbele';

  @override
  String get shapeSendBackward => 'Rudisha nyuma';

  @override
  String get shapeOrderGroup => 'Mpangilio';

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
  String get ribbonArrangeTab => 'Panga';

  @override
  String get projectTransferGroup => 'Hamisha kati ya miradi';

  @override
  String get projectCopySelection => 'Nakili vilivyochaguliwa';

  @override
  String get projectCopyLayer => 'Nakili tabaka';

  @override
  String get projectPaste => 'Bandika';

  @override
  String get projectImportGroup => 'Leta';

  @override
  String get projectImport => 'Leta mradi…';

  @override
  String projectImportComplete(int count) {
    return 'Tabaka $count yameletwa.';
  }

  @override
  String projectImportFailed(String path) {
    return 'Imeshindwa kuleta $path.';
  }

  @override
  String get shapeTransformGroup => 'Badilisha umbo';

  @override
  String get shapeSelectionGroup => 'Chaguo';

  @override
  String get shapeFlipHorizontal => 'Geuza mlalo';

  @override
  String get shapeFlipVertical => 'Geuza wima';

  @override
  String get shapeClosedPath => 'Njia iliyofungwa';

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

  @override
  String get settingsTitle => 'Mipangilio';

  @override
  String get settingsGeneral => 'Jumla';

  @override
  String get settingsProject => 'Mradi';

  @override
  String get settingsAbout => 'Kuhusu';

  @override
  String get settingsLanguage => 'Lugha';

  @override
  String get settingsLanguageHelp => 'Chagua lugha itakayotumiwa na programu.';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageSwahili => 'Kiswahili';

  @override
  String get previewNone => 'Zima (rangi halisi)';

  @override
  String get previewGrayscale => 'Vivuli vya kijivu';

  @override
  String get previewProtanopia => 'Protanopia (bila nyekundu)';

  @override
  String get previewDeuteranopia => 'Deuteranopia (bila kijani)';

  @override
  String get previewTritanopia => 'Tritanopia (bila bluu)';

  @override
  String get settingsAppearance => 'Mwonekano';

  @override
  String get settingsTheme => 'Mandhari';

  @override
  String get themeLight => 'Nyepesi';

  @override
  String get themeDark => 'Giza';

  @override
  String get themeSystem => 'Mfumo';

  @override
  String get settingsInterface => 'Kiolesura';

  @override
  String get interfaceMinimal => 'Rahisi';

  @override
  String get interfaceAdvanced => 'Kina';

  @override
  String get interfaceHelp =>
      'Mwonekano wa kina huonyesha utepe na paneli za pembeni. Mwonekano rahisi huacha turubai, zana na rangi; amri hubaki kwenye menyu.';

  @override
  String get settingsCodeExport => 'Utoaji wa msimbo';

  @override
  String get settingsCodeStructure => 'Muundo wa msimbo';

  @override
  String get codeRefactored => 'Uliopangwa upya';

  @override
  String get codeMonolithic => 'Faili moja';

  @override
  String get codeRefactoredHelp =>
      'Mchoraji, darasa moja kwa kila tabaka kwenye faili lake, kitendaji kimoja kwa kila umbo, na paleti ya rangi.';

  @override
  String get codeMonolithicHelp =>
      'Faili moja ya msimbo yenye darasa la mchoraji na mbinu moja kwa kila tabaka.';

  @override
  String get settingsColourManagement => 'Udhibiti wa rangi';

  @override
  String get settingsColourVision => 'Muhtasari wa uoni wa rangi';

  @override
  String get settingsColourVisionHelp =>
      'Hukadiria jinsi turubai inaweza kuonekana kwa mtu mwenye tofauti ya uoni wa rangi. Haibadilishi mradi wala msimbo unaotolewa.';

  @override
  String get settingsColourFormat => 'Muundo wa rangi kwenye msimbo unaotolewa';

  @override
  String get settingsColourFormatHelp =>
      'Chagua jinsi rangi zinavyoandikwa kwenye Dart inayozalishwa.';

  @override
  String get settingsColourConstants =>
      'Kusanya rangi kwenye vigezo vyenye majina';

  @override
  String get settingsColourConstantsHelp =>
      'Andika kila rangi tofauti mara moja kama kigezo, kisha maumbo yataitumia.';

  @override
  String get settingsUpdates => 'Updates';

  @override
  String get settingsAutoDownloadUpdates => 'Download updates automatically';

  @override
  String get settingsAutoDownloadUpdatesHelp =>
      'Check for updates when Flutter Painter starts and while it is open. When enabled, download the matching installer and ask before installing it.';

  @override
  String get updateNotificationTitle => 'Flutter Painter update available';

  @override
  String get updateOpenReleaseAction => 'Open release page';

  @override
  String updateNotificationBody(String version) {
    return 'Version $version is available. Select to open its release page.';
  }

  @override
  String get updateInstallTitle => 'Update ready to install';

  @override
  String updateInstallBody(String version) {
    return 'Flutter Painter $version has been downloaded. Save your work before installing it.';
  }

  @override
  String get updateInstallAction => 'Install';

  @override
  String get updateLaterAction => 'Later';

  @override
  String get updateDownloadFailed =>
      'The update could not be downloaded. Flutter Painter will try again later.';

  @override
  String get updateInstallerFailed =>
      'Flutter Painter could not open the installer. Try opening the downloaded file from your system\'s app support folder.';

  @override
  String get settingsReset => 'Rejesha chaguo-msingi';

  @override
  String get settingsDone => 'Imekamilika';

  @override
  String get projectSettingsDescription =>
      'Dhibiti jina na turubai ya muundo wa mradi huu.';

  @override
  String get projectCurrentName => 'Jina la mradi';

  @override
  String get projectCanvasSize => 'Ukubwa wa turubai';

  @override
  String get projectRename => 'Badilisha jina la mradi';

  @override
  String get projectResizeCanvas => 'Badilisha ukubwa wa turubai';

  @override
  String projectDimensions(String width, String height) {
    return '$width × $height vipimo vya usanifu';
  }

  @override
  String get aboutDescription =>
      'Studio ya uchoraji ya kuunda wachoraji maalum wa Flutter.';

  @override
  String get aboutCredits => 'Imetengenezwa na Siro Devs';

  @override
  String get buttonOk => 'Sawa';

  @override
  String get canvasSizeTitle => 'Ukubwa wa turubai (vipimo vya usanifu)';

  @override
  String get fieldWidth => 'Upana';

  @override
  String get fieldHeight => 'Urefu';

  @override
  String get buttonResize => 'Badilisha ukubwa';

  @override
  String saveChangesTitle(String name) {
    return 'Hifadhi mabadiliko ya \"$name\"?';
  }

  @override
  String get unsavedChangesMessage =>
      'Mabadiliko yako yatapotea usipoyahifadhi.';

  @override
  String get buttonDontSave => 'Usihifadhi';

  @override
  String get recoverUnsavedTitle => 'Rejesha kazi ambayo haijahifadhiwa?';

  @override
  String get recoverUnsavedIntro =>
      'Miradi hii ilikuwa na mabadiliko ambayo hayakuhifadhiwa Flutter Painter ilipofungwa mara ya mwisho:';

  @override
  String get buttonDiscard => 'Tupa';

  @override
  String get buttonRestore => 'Rejesha';

  @override
  String get fileNewBlank => 'Nouveau turubai tupu';

  @override
  String get fileOpen => 'Fungua…';

  @override
  String get fileSave => 'Hifadhi';

  @override
  String get fileSaveAs => 'Hifadhi kama…';

  @override
  String get fileAutoSave => 'Hifadhi kiotomatiki';

  @override
  String get fileAutoSaveHelp =>
      'Ikiwashwa: andika mabadiliko moja kwa moja kwenye faili la .flp lililofunguliwa. Ikizimwa: hifadhi nakala ya kurejesha hadi uhifadhi.';

  @override
  String get fileExportDart => 'Hamisha Dart…';

  @override
  String get fileCodeEditorTooltip => 'Fungua kihariri cha msimbo';

  @override
  String get fileSettings => 'Mipangilio…';

  @override
  String get fileRenameProject => 'Badilisha jina la mradi…';

  @override
  String get projectNameTooltip =>
      'Jina la mradi (pia hutumika kwa majina ya madarasa)';

  @override
  String get fileCanvasSize => 'Ukubwa wa turubai…';

  @override
  String get fileCloseProject => 'Funga mradi';

  @override
  String get fileExit => 'Toka';

  @override
  String aboutMenu(String appName) {
    return 'Kuhusu $appName';
  }

  @override
  String get editRedo => 'Rudia';

  @override
  String get editDeleteTooltip => 'Futa umbo au picha iliyochaguliwa';

  @override
  String get editPathClosedTooltip =>
      'Funga au fungua njia ya poligoni au mstari iliyochaguliwa';

  @override
  String get editFill => 'Jaza';

  @override
  String get editOutline => 'Muhtasari';

  @override
  String get editStrokeTooltip => 'Mstari wa nje';

  @override
  String get imageReplace => 'Badilisha picha…';

  @override
  String get imageLoad => 'Pakia picha…';

  @override
  String get imageLoadNewLayer => 'Picha kwenye tabaka jipya…';

  @override
  String get imagePutLayerTooltip => 'Weka picha kwenye tabaka hili';

  @override
  String get imageLoadNewLayerTooltip => 'Pakia picha kwenye tabaka jipya';

  @override
  String get imageSelect => 'Chagua picha';

  @override
  String get imageSelectTooltip =>
      'Chagua picha ya tabaka hili (huonyesha vishikio vya kubadilisha ukubwa)';

  @override
  String get imageMoveResize => 'Sogeza / badilisha ukubwa wa picha';

  @override
  String get imageMoveResizeTooltip =>
      'Zana ya kusogeza / kubadilisha ukubwa wa picha';

  @override
  String get imageFit => 'Tosheleza picha kwenye turubai';

  @override
  String get imageFitTooltip => 'Tosheleza turubai (weka upya unyooshaji)';

  @override
  String get imageShow => 'Onyesha picha';

  @override
  String get imageRemove => 'Ondoa picha';

  @override
  String get imageLoadTooltip => 'Pakia picha kwenye tabaka jipya';

  @override
  String get imagePanelShow => 'Onyesha';

  @override
  String imageOpacity(String value) {
    return 'Uwazi $value%';
  }

  @override
  String imageScale(String value) {
    return 'Kipimo $value';
  }

  @override
  String imagePanelTitle(String name) {
    return 'Picha kwenye “$name”';
  }

  @override
  String get imagePanelPrompt =>
      'Pakia picha kwenye tabaka hili ili uchore juu yake au uitumie kama mandharinyuma.';

  @override
  String get viewZoomIn => 'Kuza';

  @override
  String get viewZoomOut => 'Punguza ukubwa';

  @override
  String get viewFitWindow => 'Tosheleza dirisha';

  @override
  String get viewGrid => 'Gridi';

  @override
  String get viewSnap => 'Shikiza kwenye gridi';

  @override
  String get viewCanvasBackground => 'Mandharinyuma ya turubai';

  @override
  String get viewCanvasBackgroundTooltip =>
      'Badili rangi ya mandharinyuma ya turubai';

  @override
  String get viewLightTheme => 'Mandhari nyepesi';

  @override
  String get viewDarkTheme => 'Mandhari ya giza';

  @override
  String get viewThemeTooltip => 'Badili kati ya mandhari nyepesi na ya giza';

  @override
  String get menuFile => 'Faili';

  @override
  String get menuEdit => 'Hariri';

  @override
  String get menuLayer => 'Tabaka';

  @override
  String get menuView => 'Tazama';

  @override
  String get menuTools => 'Zana';

  @override
  String get menuHelp => 'Msaada';

  @override
  String get menuWindow => 'Dirisha';

  @override
  String get ribbonExport => 'Hamisha';

  @override
  String get ribbonExpand => 'Panua utepe';

  @override
  String get ribbonCollapse => 'Kunja utepe';

  @override
  String get ribbonLayers => 'Tabaka';

  @override
  String get ribbonOrder => 'Mpangilio';

  @override
  String get ribbonHistory => 'Historia';

  @override
  String get ribbonStyle => 'Mtindo';

  @override
  String get ribbonNew => 'Mpya';

  @override
  String get ribbonOpen => 'Fungua';

  @override
  String get ribbonBlankCanvas => 'Turubai tupu';

  @override
  String get ribbonProject => 'Mradi';

  @override
  String get ribbonApp => 'Programu';

  @override
  String get ribbonShapes => 'Maumbo';

  @override
  String get ribbonPaths => 'Njia';

  @override
  String get ribbonPolygon => 'Poligoni';

  @override
  String get ribbonPictures => 'Picha';

  @override
  String get ribbonPicture => 'Picha';

  @override
  String get ribbonOnNewLayer => 'Kwenye tabaka jipya';

  @override
  String get ribbonLayersGroup => 'Tabaka';

  @override
  String get ribbonZoom => 'Kuza';

  @override
  String get ribbonFit => 'Tosheleza';

  @override
  String get ribbonShow => 'Onyesha';

  @override
  String get ribbonCanvas => 'Turubai';

  @override
  String get ribbonAppearance => 'Mwonekano';

  @override
  String get ribbonLightDark => 'Nyepesi / giza';

  @override
  String get ribbonArrange => 'Panga';

  @override
  String get ribbonAdjust => 'Rekebisha';

  @override
  String get toolSelectMove => 'Chagua / sogeza';

  @override
  String get toolMoveImage => 'Sogeza / badilisha ukubwa wa picha ya tabaka';

  @override
  String get toolRectangle => 'Mstatili';

  @override
  String get toolEllipse => 'Duara bapa';

  @override
  String get toolLine => 'Mstari';

  @override
  String get toolPolygonPath => 'Njia ya poligoni / mstari';

  @override
  String get toolFreehand => 'Mchoro huru';

  @override
  String get propertyTitle => 'Sifa';

  @override
  String get propertyNoSelection =>
      'Hakuna umbo lililochaguliwa. Mipangilio hii itatumika kwa umbo linalofuata utakalochora.';

  @override
  String get propertyFill => 'Jaza';

  @override
  String get propertyStroke => 'Mstari wa mpaka';

  @override
  String get propertyClosedShape => 'Umbo lililofungwa (linaweza kujazwa)';

  @override
  String get propertyRenameShape => 'Badili jina la umbo';

  @override
  String propertyCornerRadius(String value) {
    return 'Mviringo wa kona: $value';
  }

  @override
  String propertyStrokeWidth(String value) {
    return 'Upana wa mpaka: $value';
  }

  @override
  String imageOnLayer(Object name) {
    return 'Picha kwenye “$name”';
  }

  @override
  String get imagePanelHint =>
      'Pakia picha kwenye tabaka hili ili kuichorea juu yake au kuitumia kama mandharinyuma.';

  @override
  String statusPreview(String value) {
    return 'Onyesho la awali: $value';
  }

  @override
  String get statusCtrlWheel => 'Ctrl + gurudumu la kipanya hukuza.';

  @override
  String get buttonClose => 'Funga';

  @override
  String get buttonReplace => 'Badilisha';

  @override
  String get buttonLoad => 'Pakia';

  @override
  String get buttonUse => 'Tumia';

  @override
  String get buttonNone => 'Hakuna';

  @override
  String get colorFillTooltip => 'Rangi ya kujaza';

  @override
  String get colorStrokeTooltip => 'Rangi ya mpaka';

  @override
  String get buttonExport => 'Hamisha';

  @override
  String get interfaceSwitchAdvanced => 'Badili kwenda kiolesura cha kina';

  @override
  String get toolHintSelect =>
      'Bofya umbo au picha ili kuichagua. Buruta ili kuisogeza, au buruta vishikio ili kubadilisha ukubwa. Bofya mara mbili kwenye ukingo kuongeza nukta, au Alt-bofya nukta ili kuiondoa.';

  @override
  String get toolHintRectangle =>
      'Buruta kuchora mstatili. Shikilia Shift kupata mraba.';

  @override
  String get toolHintEllipse =>
      'Buruta kuchora duara bapa. Shikilia Shift kupata duara.';

  @override
  String get toolHintLine =>
      'Buruta kuchora mstari. Shikilia Shift kupata pembe za 45°.';

  @override
  String get toolHintPolygon =>
      'Bofya kuongeza nukta. Bofya nukta ya kwanza au bofya mara mbili kufunga umbo. Bonyeza Enter kuacha njia ya mstari wazi; Esc kughairi.';

  @override
  String get toolHintFreehand => 'Buruta kuchora mstari laini wa mkono huru.';

  @override
  String get toolHintImage =>
      'Buruta picha ya tabaka hili ili kuisogeza; buruta kishikio kubadilisha ukubwa. Kona huhifadhi uwiano; Shift au kishikio cha ukingo hunyoosha.';

  @override
  String get ribbonFile => 'Faili';

  @override
  String get ribbonHome => 'Nyumbani';

  @override
  String get ribbonInsert => 'Ingiza';

  @override
  String get ribbonLayer => 'Tabaka';

  @override
  String get ribbonImage => 'Picha';

  @override
  String get ribbonView => 'Tazama';

  @override
  String viewZoomLabel(String value) {
    return 'Kuza $value';
  }

  @override
  String get statusMousePan =>
      'Tembeza au buruta kwa kitufe cha kulia kusogeza mwonekano.';

  @override
  String get fileTypeProject => 'Mradi wa Flutter Painter';

  @override
  String get fileTypeImages => 'Picha';

  @override
  String get fileTypeDart => 'Dart';

  @override
  String get fileTypeZip => 'Kumbukumbu ya ZIP';

  @override
  String get fileSaveHere => 'Hifadhi hapa';

  @override
  String workspaceInvalidProject(String path) {
    return 'Hii si miradi wa Flutter Painter: $path';
  }

  @override
  String workspaceOpenFailed(String path, String error) {
    return 'Imeshindwa kufungua $path: $error';
  }

  @override
  String workspaceSaved(String path) {
    return 'Imehifadhiwa $path';
  }

  @override
  String workspaceSaveFailed(String error) {
    return 'Imeshindwa kuhifadhi: $error';
  }

  @override
  String imageLoadFailed(String error) {
    return 'Imeshindwa kupakia picha hiyo: $error';
  }

  @override
  String get dropProjectHint =>
      'Dondosha mradi wa .flp kuufungua kwenye kichupo kipya, au picha kuiweka kwenye tabaka linalotumika.';

  @override
  String get exportReplaceTitle => 'Badilisha faili zilizopo?';

  @override
  String exportReplaceMessage(int existing, int total) {
    return 'Faili $existing kati ya $total tayari zipo kwenye folda hiyo na zitabadilishwa.';
  }

  @override
  String get exportReplace => 'Badilisha';

  @override
  String exportSavedFolder(int count, String path) {
    return 'Faili $count zimehifadhiwa kwenye $path';
  }

  @override
  String exportSavedArchive(int count, String path) {
    return 'Faili $count zimehifadhiwa kwenye $path';
  }

  @override
  String exportSaveFailed(String error) {
    return 'Imeshindwa kuhifadhi: $error';
  }

  @override
  String get exportCloseTitle => 'Funga kihariri cha msimbo?';

  @override
  String get exportCloseMessage =>
      'Mabadiliko yako kwenye faili zilizozalishwa hayajahifadhiwa na yatapotea.';

  @override
  String get exportClose => 'Funga';

  @override
  String get exportRegenerateTitle => 'Tengeneza faili upya?';

  @override
  String get exportRegenerateMessage =>
      'Hii itaunda kila faili upya kutoka kwenye mchoro na kufuta mabadiliko yako.';

  @override
  String get exportRegenerate => 'Tengeneza upya';

  @override
  String get exportSettingsChanged =>
      'Mipangilio ya uhamishaji imebadilika. Tengeneza upya ili kuitumia (mabadiliko yako yatafutwa).';

  @override
  String exportTitle(String name) {
    return 'Kihariri cha msimbo — $name';
  }

  @override
  String get exportSaveFolder => 'Hifadhi kwenye folda';

  @override
  String exportSaveFolderTooltip(String modifier) {
    return 'Hifadhi faili zote kwenye folda ($modifier+S)';
  }

  @override
  String get exportSaveArchive => 'Hifadhi kama kumbukumbu';

  @override
  String exportSaveArchiveTooltip(String modifier) {
    return 'Hifadhi faili zote kama .zip moja ($modifier+Shift+S)';
  }

  @override
  String get exportCopy => 'Nakili';

  @override
  String get exportCopyTooltip =>
      'Nakili faili lililofunguliwa kwenye ubao wa kunakili';

  @override
  String get exportFormatDocument => 'Panga hati';

  @override
  String get exportFormatTooltip => 'Panga faili lililofunguliwa (Shift+Alt+F)';

  @override
  String get exportBuildAgain => 'Tengeneza tena';

  @override
  String get exportBuildAgainTooltip =>
      'Tengeneza faili upya kutoka kwenye mchoro (hufuta mabadiliko yako)';

  @override
  String get exportBackToDrawing => 'Rudi kwenye mchoro';

  @override
  String get exportSelectFileHint =>
      'Chagua faili kwenye kichunguzi ili uifungue';

  @override
  String get exportExplorer => 'Kichunguzi';

  @override
  String get exportSettingsLabel => 'Mipangilio';

  @override
  String get exportCloseTab => 'Funga';

  @override
  String get projectTabCloseTooltip => 'Funga (Ctrl+W)';

  @override
  String get projectTabNotSaved => 'Bado haijahifadhiwa';

  @override
  String layerDefaultGroup(int number) {
    return 'Kikundi $number';
  }

  @override
  String editorCaret(int line, int column) {
    return 'Mst $line, Safu $column';
  }

  @override
  String editorCaretSelection(int line, int column, int selected) {
    return 'Mst $line, Safu $column ($selected zimechaguliwa)';
  }

  @override
  String editorLineCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'mistari $count',
      one: 'mstari 1',
    );
    return '$_temp0';
  }

  @override
  String editorSpaceCount(int count) {
    return 'Nafasi: $count';
  }

  @override
  String exportRegenerated(int count) {
    return 'Faili $count zimetengenezwa upya';
  }

  @override
  String exportFormatted(String name) {
    return 'Imepangiliwa $name';
  }

  @override
  String exportCopied(String name) {
    return 'Imenakili $name kwenye ubao wa kunakili';
  }

  @override
  String get projectUnavailable => 'Hakuna mradi unaotumika unaopatikana hapa.';

  @override
  String get untitledProject => 'Bila jina';

  @override
  String untitledProjectNumbered(int number) {
    return 'Bila jina $number';
  }

  @override
  String defaultLayerName(int number) {
    return 'Tabaka $number';
  }

  @override
  String defaultGroupName(int number) {
    return 'Kundi $number';
  }

  @override
  String projectFileDamaged(String path) {
    return 'Imeshindikana kufungua $path: faili limeharibika au si mradi.';
  }

  @override
  String projectFileTooNew(String path) {
    return '$path liliundwa na toleo jipya zaidi la Flutter Painter. Sasisha programu ili kulifungua.';
  }

  @override
  String get statusNotBackedUp => 'Haijahifadhiwa nakala';

  @override
  String get statusNotBackedUpTooltip =>
      'Nakala ya kurejesha haikuweza kuhifadhiwa. Hifadhi mradi wako ili kuepuka kupoteza kazi.';

  @override
  String get layerCopyItem => 'Nakili kipengee';

  @override
  String get layerDragReorder => 'Buruta kupanga upya tabaka';

  @override
  String get ribbon3d => '3D';

  @override
  String get layerMake3d => 'Make 3D layer';

  @override
  String get layerRemove3d => 'Back to flat layer';

  @override
  String get model3dViewStraight => 'Straight';

  @override
  String get model3dViewLeft => 'Left';

  @override
  String get model3dViewRight => 'Right';

  @override
  String model3dTitle(String name) {
    return '3D setup of “$name”';
  }

  @override
  String get model3dPreview => 'Preview on canvas';

  @override
  String get model3dPreviewNote =>
      'Drawing and selecting are paused while previewing.';

  @override
  String get model3dViews => 'Views';

  @override
  String get model3dViewAdd => 'Add view';

  @override
  String get model3dViewRename => 'Rename view';

  @override
  String get model3dViewDelete => 'Delete view';

  @override
  String model3dDefaultViewName(String number) {
    return 'View $number';
  }

  @override
  String get model3dTurn => 'Turn';

  @override
  String get model3dTilt => 'Tilt';

  @override
  String get model3dZoom => 'Zoom';

  @override
  String model3dValue(String name, String value) {
    return '$name: $value';
  }

  @override
  String get model3dShape => 'Selected shapes';

  @override
  String get model3dNoShape => 'Select a shape to set its depth and thickness.';

  @override
  String get model3dDepth => 'Depth';

  @override
  String get model3dThickness => 'Thickness';

  @override
  String get model3dPivot => 'Turning point';

  @override
  String get model3dAcross => 'Across';

  @override
  String get model3dDown => 'Down';

  @override
  String get model3dTyres => 'Tyres';

  @override
  String get model3dTyreAdd => 'Add tyre';

  @override
  String get model3dTyreRename => 'Rename tyre';

  @override
  String get model3dTyreDelete => 'Delete tyre';

  @override
  String model3dDefaultTyreName(String number) {
    return 'Tyre $number';
  }

  @override
  String get model3dTyreNone => 'No tyres yet. Add one to build a round part.';

  @override
  String get model3dRadius => 'Radius';

  @override
  String get model3dWidth => 'Width';

  @override
  String get model3dTreads => 'Treads';

  @override
  String get model3dSpin => 'Spin';

  @override
  String get model3dShoulder => 'Round edges';

  @override
  String get model3dSidewall => 'Sidewall size';

  @override
  String get model3dHub => 'Hub size';

  @override
  String get model3dColorBody => 'Body';

  @override
  String get model3dColorTread => 'Tread lines';

  @override
  String get model3dColorSidewall => 'Sidewall';

  @override
  String get model3dColorHub => 'Hub';

  @override
  String get model3dParts => 'Parts';

  @override
  String get model3dPartsNone =>
      'No parts yet. Group shapes to move them as one part.';

  @override
  String get model3dPartJoint => 'Joint';

  @override
  String get model3dPartParent => 'Attached to';

  @override
  String get model3dPartParentNone => 'Nothing';

  @override
  String model3dPartPose(String view) {
    return 'Pose in “$view”';
  }

  @override
  String get model3dLean => 'Lean';

  @override
  String get model3dGhost => 'Compare with';

  @override
  String get model3dGhostNone => 'Nothing';

  @override
  String get model3dPartVisible => 'Visible in this view';
}
