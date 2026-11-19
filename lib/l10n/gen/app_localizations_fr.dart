// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get newProject => 'Nouveau projet';

  @override
  String get newProjectTooltip => 'Démarrer un nouveau projet (Ctrl+N)';

  @override
  String get inlineCode => 'Code intégré';

  @override
  String get inlineCodeTooltip => 'Afficher ou masquer le code intégré';

  @override
  String get quickCode => 'Code rapide';

  @override
  String get quickCodeTooltip =>
      'Modifier ou coller les coordonnées d’une forme';

  @override
  String get quickCodePolygonMenu => 'Code';

  @override
  String get quickCodeToolMenuHint =>
      'Clic droit ou appui prolongé pour plus d’options';

  @override
  String get quickCodeCoordinates => 'Coordonnées';

  @override
  String get quickCodeDartCode => 'Code Dart';

  @override
  String get quickCodeFormatTooltip =>
      'Basculer entre le code Dart et les coordonnées compactes';

  @override
  String get quickCodeHint =>
      'Collez des points Offset(x, y) ou des paires x,y séparées par des espaces.';

  @override
  String get quickCodeInvalid =>
      'Le code doit être une liste de points Offset(x, y).';

  @override
  String get quickCodeNeedMorePoints =>
      'Ajoutez suffisamment de points pour cette forme.';

  @override
  String get quickCodePolygonReady => 'Aperçu du polygone prêt.';

  @override
  String get quickCodeShapeReady =>
      'Le canevas a été mis à jour avec ces points.';

  @override
  String get quickCodeAddPolygon => 'Ajouter le polygone';

  @override
  String get quickCodeAddShapes => 'Ajouter les formes';

  @override
  String get quickCodeClose => 'Fermer le Code rapide';

  @override
  String get openFullEditor => 'Ouvrir l’éditeur de code complet';

  @override
  String get undo => 'Annuler';

  @override
  String get removeFileTooltip => 'Supprimer ce fichier et ses formes';

  @override
  String get statusIdle => 'Modifiez le code pour mettre à jour le canevas';

  @override
  String get statusRendered => 'Canevas mis à jour depuis le code';

  @override
  String get statusUnreadable =>
      'Impossible de lire ce code pour le moment ; le canevas est inchangé';

  @override
  String statusSkipped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count instructions ignorées',
      one: '1 instruction ignorée',
    );
    return '$_temp0';
  }

  @override
  String get colorMoreTooltip => 'Ouvrir le sélecteur de couleur';

  @override
  String get paintBucketTool => 'Pot de peinture';

  @override
  String get paintBucketHint =>
      'Cliquez dans une forme fermée pour la remplir avec la couleur de remplissage active.';

  @override
  String get colorPickerTitle => 'Sélecteur de couleur';

  @override
  String get colorSolid => 'Uni';

  @override
  String get colorGradient => 'Dégradé';

  @override
  String get colorWheel => 'Roue';

  @override
  String get colorSquare => 'Carré';

  @override
  String get colorHexCode => 'Code hexadécimal';

  @override
  String get colorBrightness => 'Luminosité';

  @override
  String get colorOpacity => 'Opacité';

  @override
  String get gradientLinear => 'Linéaire';

  @override
  String get gradientRadial => 'Radial';

  @override
  String get gradientSweep => 'Balayage';

  @override
  String get gradientAngle => 'Angle';

  @override
  String get gradientRadius => 'Rayon';

  @override
  String get gradientAddStop => 'Ajouter un point';

  @override
  String get gradientRemoveStop => 'Supprimer le point';

  @override
  String get gradientStopPosition => 'Position';

  @override
  String get apply => 'Appliquer';

  @override
  String get cancel => 'Annuler';

  @override
  String get shapeGroup => 'Grouper';

  @override
  String get shapeUngroup => 'Dissocier';

  @override
  String get shapeGroupTooltip =>
      'Grouper les formes sélectionnées pour les déplacer ensemble';

  @override
  String get shapeUngroupTooltip => 'Dissocier les formes sélectionnées';

  @override
  String get shapeActionsPanelTitle => 'Actions sur les formes';

  @override
  String get shapeActionsPanelEmpty =>
      'Sélectionnez une forme pour afficher ses actions.';

  @override
  String shapeSelectionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count formes sélectionnées',
      one: '1 forme sélectionnée',
    );
    return '$_temp0';
  }

  @override
  String get shapeRotateHint =>
      'Faites glisser la poignée ronde pour pivoter. Maintenez Maj pour un incrément de 15°.';

  @override
  String get vertexDelete => 'Supprimer ce point';

  @override
  String get vertexSplit => 'Scinder ce point';

  @override
  String get shapeDuplicate => 'Dupliquer';

  @override
  String get shapeCopyGroup => 'Copier le groupe';

  @override
  String get shapePasteGroup => 'Coller le groupe';

  @override
  String get shapeDelete => 'Supprimer';

  @override
  String get shapeForward => 'Avancer';

  @override
  String get shapeBack => 'Reculer';

  @override
  String get shapeBringToFront => 'Mettre tout devant';

  @override
  String get shapeSendToBack => 'Envoyer tout derrière';

  @override
  String get shapeBringForward => 'Avancer d’un rang';

  @override
  String get shapeSendBackward => 'Reculer d’un rang';

  @override
  String get shapeOrderGroup => 'Ordre';

  @override
  String get shapeMoveToLayer => 'Déplacer vers le calque';

  @override
  String get shapeToLayer => 'Vers le calque';

  @override
  String get layersTitle => 'Calques';

  @override
  String get layerAdd => 'Ajouter un calque';

  @override
  String get layerRename => 'Renommer le calque';

  @override
  String get layerMoveUp => 'Monter le calque';

  @override
  String get layerMoveDown => 'Descendre le calque';

  @override
  String get layerDelete => 'Supprimer le calque';

  @override
  String get layerHide => 'Masquer';

  @override
  String get layerShow => 'Afficher';

  @override
  String get layerGroup => 'Groupe';

  @override
  String get layerPicture => 'Image';

  @override
  String get layerItemRectangle => 'Rectangle';

  @override
  String get layerItemEllipse => 'Ellipse';

  @override
  String get layerItemLine => 'Ligne';

  @override
  String get layerItemPolygon => 'Polygone';

  @override
  String get layerItemFreehand => 'Dessin à main levée';

  @override
  String get layerEditItem => 'Modifier le nom de l’élément';

  @override
  String get canvasSelectGroupMemberHint =>
      'Ctrl-clic pour sélectionner uniquement cet élément du groupe';

  @override
  String get layerEditGroup => 'Modifier le nom du groupe';

  @override
  String get shapeScaleDown => 'Réduire de 10 %';

  @override
  String get ribbonArrangeTab => 'Disposition';

  @override
  String get projectTransferGroup => 'Transfert entre projets';

  @override
  String get projectCopySelection => 'Copier la sélection';

  @override
  String get projectCopyLayer => 'Copier le calque';

  @override
  String get projectPaste => 'Coller';

  @override
  String get projectImportGroup => 'Importer';

  @override
  String get projectImport => 'Importer un projet…';

  @override
  String projectImportComplete(int count) {
    return '$count calques importés.';
  }

  @override
  String projectImportFailed(String path) {
    return 'Impossible d’importer $path.';
  }

  @override
  String get shapeTransformGroup => 'Transformation';

  @override
  String get shapeSelectionGroup => 'Sélection';

  @override
  String get shapeFlipHorizontal => 'Retourner horizontalement';

  @override
  String get shapeFlipVertical => 'Retourner verticalement';

  @override
  String get shapeClosedPath => 'Tracé fermé';

  @override
  String get groupMethodsPublic => 'Exposer les méthodes des formes du groupe';

  @override
  String get groupMethodsPublicHelp =>
      'Activé : le calque appelle chaque méthode publique de forme. Désactivé : le groupe expose une méthode paint() et garde ses méthodes de forme privées.';

  @override
  String get exportGenerating => 'Génération du code Dart…';

  @override
  String get exportSaving => 'Préparation de l’exportation…';

  @override
  String get exportGenerationFailed => 'Impossible de générer le code Dart.';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsGeneral => 'Général';

  @override
  String get settingsProject => 'Projet';

  @override
  String get settingsAbout => 'À propos';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLanguageHelp => 'Choisissez la langue de l’application.';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageSwahili => 'Kiswahili';

  @override
  String get previewNone => 'Désactivé (couleurs réelles)';

  @override
  String get previewGrayscale => 'Niveaux de gris';

  @override
  String get previewProtanopia => 'Protanopie (sans rouge)';

  @override
  String get previewDeuteranopia => 'Deutéranopie (sans vert)';

  @override
  String get previewTritanopia => 'Tritanopie (sans bleu)';

  @override
  String get settingsAppearance => 'Apparence';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeSystem => 'Système';

  @override
  String get settingsInterface => 'Interface';

  @override
  String get interfaceMinimal => 'Minimale';

  @override
  String get interfaceAdvanced => 'Avancée';

  @override
  String get interfaceHelp =>
      'Le mode avancé affiche le ruban et les panneaux latéraux. Le mode minimal garde le canevas, les outils et les couleurs ; les commandes restent dans les menus.';

  @override
  String get settingsCodeExport => 'Exportation du code';

  @override
  String get settingsCodeStructure => 'Structure du code';

  @override
  String get codeRefactored => 'Modulaire';

  @override
  String get codeMonolithic => 'Monolithique';

  @override
  String get codeRefactoredHelp =>
      'Un peintre, une classe par calque dans son propre fichier, une fonction par forme et une palette de couleurs.';

  @override
  String get codeMonolithicHelp =>
      'Un seul fichier de code avec une classe de peintre et une méthode par calque.';

  @override
  String get settingsColourManagement => 'Gestion des couleurs';

  @override
  String get settingsColourVision => 'Aperçu de la vision des couleurs';

  @override
  String get settingsColourVisionHelp =>
      'Approxime l’apparence du canevas pour une personne ayant une différence de vision des couleurs. Cela ne modifie ni le projet ni le code exporté.';

  @override
  String get settingsColourFormat => 'Format des couleurs dans le code exporté';

  @override
  String get settingsColourFormatHelp =>
      'Choisissez comment les couleurs sont écrites dans le code Dart généré.';

  @override
  String get settingsColourConstants =>
      'Regrouper les couleurs dans des constantes nommées';

  @override
  String get settingsColourConstantsHelp =>
      'Écrire chaque couleur distincte une seule fois comme constante et la référencer depuis les formes.';

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
  String get settingsReset => 'Rétablir les valeurs par défaut';

  @override
  String get settingsDone => 'Terminé';

  @override
  String get projectSettingsDescription =>
      'Gérer le nom et le canevas de conception de ce projet.';

  @override
  String get projectCurrentName => 'Nom du projet';

  @override
  String get projectCanvasSize => 'Taille du canevas';

  @override
  String get projectRename => 'Renommer le projet';

  @override
  String get projectResizeCanvas => 'Modifier la taille du canevas';

  @override
  String projectDimensions(String width, String height) {
    return '$width × $height unités de conception';
  }

  @override
  String get aboutDescription =>
      'Un atelier de dessin pour créer des peintres personnalisés Flutter.';

  @override
  String get aboutCredits => 'Créé par Siro Devs';

  @override
  String get buttonOk => 'OK';

  @override
  String get canvasSizeTitle => 'Taille du canevas (unités de conception)';

  @override
  String get fieldWidth => 'Largeur';

  @override
  String get fieldHeight => 'Hauteur';

  @override
  String get buttonResize => 'Redimensionner';

  @override
  String saveChangesTitle(String name) {
    return 'Enregistrer les modifications de « $name » ?';
  }

  @override
  String get unsavedChangesMessage =>
      'Vos modifications seront perdues si vous ne les enregistrez pas.';

  @override
  String get buttonDontSave => 'Ne pas enregistrer';

  @override
  String get recoverUnsavedTitle => 'Récupérer le travail non enregistré ?';

  @override
  String get recoverUnsavedIntro =>
      'Ces projets contenaient des modifications non enregistrées lors de la dernière fermeture de Flutter Painter :';

  @override
  String get buttonDiscard => 'Abandonner';

  @override
  String get buttonRestore => 'Restaurer';

  @override
  String get fileNewBlank => 'Nouveau canevas vierge';

  @override
  String get fileOpen => 'Ouvrir…';

  @override
  String get fileSave => 'Enregistrer';

  @override
  String get fileSaveAs => 'Enregistrer sous…';

  @override
  String get fileAutoSave => 'Enregistrement automatique';

  @override
  String get fileAutoSaveHelp =>
      'Activé : écrire les modifications directement dans le fichier .flp ouvert. Désactivé : garder une copie de récupération jusqu’à l’enregistrement.';

  @override
  String get fileExportDart => 'Exporter le code Dart…';

  @override
  String get fileCodeEditorTooltip => 'Ouvrir l’éditeur de code';

  @override
  String get fileSettings => 'Paramètres…';

  @override
  String get fileRenameProject => 'Renommer le projet…';

  @override
  String get projectNameTooltip =>
      'Nom du projet (également utilisé pour les noms de classes)';

  @override
  String get fileCanvasSize => 'Taille du canevas…';

  @override
  String get fileCloseProject => 'Fermer le projet';

  @override
  String get fileExit => 'Quitter';

  @override
  String aboutMenu(String appName) {
    return 'À propos de $appName';
  }

  @override
  String get editRedo => 'Rétablir';

  @override
  String get editDeleteTooltip => 'Supprimer la forme ou l’image sélectionnée';

  @override
  String get editPathClosedTooltip =>
      'Fermer ou ouvrir le tracé de polygone ou de ligne sélectionné';

  @override
  String get editFill => 'Remplissage';

  @override
  String get editOutline => 'Contour';

  @override
  String get editStrokeTooltip => 'Contour';

  @override
  String get imageReplace => 'Remplacer l’image…';

  @override
  String get imageLoad => 'Charger une image…';

  @override
  String get imageLoadNewLayer => 'Image sur un nouveau calque…';

  @override
  String get imagePutLayerTooltip => 'Ajouter une image à ce calque';

  @override
  String get imageLoadNewLayerTooltip =>
      'Charger une image sur un nouveau calque';

  @override
  String get imageSelect => 'Sélectionner l’image';

  @override
  String get imageSelectTooltip =>
      'Sélectionner l’image de ce calque (affiche les poignées de redimensionnement)';

  @override
  String get imageMoveResize => 'Déplacer / redimensionner l’image';

  @override
  String get imageMoveResizeTooltip =>
      'Outil de déplacement / redimensionnement de l’image';

  @override
  String get imageFit => 'Adapter l’image au canevas';

  @override
  String get imageFitTooltip => 'Adapter au canevas (réinitialise l’étirement)';

  @override
  String get imageShow => 'Afficher l’image';

  @override
  String get imageRemove => 'Supprimer l’image';

  @override
  String get imageLoadTooltip => 'Charger une image sur un nouveau calque';

  @override
  String get imagePanelShow => 'Afficher';

  @override
  String imageOpacity(String value) {
    return 'Opacité $value %';
  }

  @override
  String imageScale(String value) {
    return 'Échelle $value';
  }

  @override
  String get imageOpacityName => 'Opacity';

  @override
  String get imageScaleName => 'Scale';

  @override
  String imagePanelTitle(String name) {
    return 'Image sur « $name »';
  }

  @override
  String get imagePanelPrompt =>
      'Chargez une image sur ce calque pour la décalquer ou l’utiliser comme arrière-plan.';

  @override
  String get viewZoomIn => 'Zoom avant';

  @override
  String get viewZoomOut => 'Zoom arrière';

  @override
  String get viewFitWindow => 'Ajuster à la fenêtre';

  @override
  String get viewGrid => 'Grille';

  @override
  String get viewSnap => 'Aligner sur la grille';

  @override
  String get viewCanvasBackground => 'Arrière-plan du canevas';

  @override
  String get viewCanvasBackgroundTooltip =>
      'Faire défiler les couleurs d’arrière-plan du canevas';

  @override
  String get viewLightTheme => 'Thème clair';

  @override
  String get viewDarkTheme => 'Thème sombre';

  @override
  String get viewThemeTooltip => 'Basculer entre les thèmes clair et sombre';

  @override
  String get menuFile => 'Fichier';

  @override
  String get menuEdit => 'Édition';

  @override
  String get menuLayer => 'Calque';

  @override
  String get menuView => 'Affichage';

  @override
  String get menuTools => 'Outils';

  @override
  String get menuHelp => 'Aide';

  @override
  String get menuWindow => 'Fenêtre';

  @override
  String get ribbonExport => 'Exporter';

  @override
  String get ribbonExpand => 'Développer le ruban';

  @override
  String get ribbonCollapse => 'Réduire le ruban';

  @override
  String get ribbonLayers => 'Calques';

  @override
  String get ribbonOrder => 'Ordre';

  @override
  String get ribbonHistory => 'Historique';

  @override
  String get ribbonStyle => 'Style';

  @override
  String get ribbonNew => 'Nouveau';

  @override
  String get ribbonOpen => 'Ouvrir';

  @override
  String get ribbonBlankCanvas => 'Canevas vierge';

  @override
  String get ribbonProject => 'Projet';

  @override
  String get ribbonApp => 'Application';

  @override
  String get ribbonShapes => 'Formes';

  @override
  String get ribbonPaths => 'Tracés';

  @override
  String get ribbonPolygon => 'Polygone';

  @override
  String get ribbonPictures => 'Images';

  @override
  String get ribbonPicture => 'Image';

  @override
  String get ribbonOnNewLayer => 'Sur un nouveau calque';

  @override
  String get ribbonLayersGroup => 'Calques';

  @override
  String get ribbonZoom => 'Zoom';

  @override
  String get ribbonFit => 'Ajuster';

  @override
  String get ribbonShow => 'Afficher';

  @override
  String get ribbonCanvas => 'Canevas';

  @override
  String get ribbonAppearance => 'Apparence';

  @override
  String get ribbonLightDark => 'Clair / sombre';

  @override
  String get ribbonArrange => 'Disposition';

  @override
  String get ribbonAdjust => 'Ajuster';

  @override
  String get toolSelectMove => 'Sélectionner / déplacer';

  @override
  String get toolMoveImage => 'Déplacer / redimensionner l’image du calque';

  @override
  String get toolRectangle => 'Rectangle';

  @override
  String get toolEllipse => 'Ellipse';

  @override
  String get toolLine => 'Ligne';

  @override
  String get toolPolygonPath => 'Tracé polygonal / ligne';

  @override
  String get toolFreehand => 'Main levée';

  @override
  String get propertyTitle => 'Propriétés';

  @override
  String get propertyNoSelection =>
      'Aucune forme sélectionnée. Ces paramètres s’appliqueront à la prochaine forme dessinée.';

  @override
  String get propertyFill => 'Remplissage';

  @override
  String get propertyStroke => 'Contour';

  @override
  String get propertyClosedShape => 'Forme fermée (peut être remplie)';

  @override
  String get propertyRenameShape => 'Renommer la forme';

  @override
  String propertyCornerRadius(String value) {
    return 'Rayon des coins : $value';
  }

  @override
  String propertyStrokeWidth(String value) {
    return 'Épaisseur du contour : $value';
  }

  @override
  String get propertyStrokeWidthName => 'Stroke width';

  @override
  String get propertyCornerRadiusName => 'Corner radius';

  @override
  String imageOnLayer(Object name) {
    return 'Image sur « $name »';
  }

  @override
  String get imagePanelHint =>
      'Chargez une image sur ce calque pour la décalquer ou l’utiliser comme arrière-plan.';

  @override
  String statusPreview(String value) {
    return 'Aperçu : $value';
  }

  @override
  String get statusCtrlWheel => 'Ctrl + molette : zoomer.';

  @override
  String get buttonClose => 'Fermer';

  @override
  String get buttonReplace => 'Remplacer';

  @override
  String get buttonLoad => 'Charger';

  @override
  String get buttonUse => 'Utiliser';

  @override
  String get buttonNone => 'Aucun';

  @override
  String get colorFillTooltip => 'Couleur de remplissage';

  @override
  String get colorStrokeTooltip => 'Couleur du contour';

  @override
  String get buttonExport => 'Exporter';

  @override
  String get interfaceSwitchAdvanced => 'Passer à l’interface avancée';

  @override
  String get toolHintSelect =>
      'Cliquez sur une forme ou une image pour la sélectionner. Faites-la glisser pour la déplacer, ou faites glisser ses poignées pour la redimensionner. Double-cliquez sur un bord pour ajouter un point ou faites Alt-clic sur un point pour le supprimer.';

  @override
  String get toolHintRectangle =>
      'Faites glisser pour dessiner un rectangle. Maintenez Maj pour obtenir un carré.';

  @override
  String get toolHintEllipse =>
      'Faites glisser pour dessiner une ellipse. Maintenez Maj pour obtenir un cercle.';

  @override
  String get toolHintLine =>
      'Faites glisser pour dessiner une ligne. Maintenez Maj pour des angles de 45°.';

  @override
  String get toolHintPolygon =>
      'Cliquez pour ajouter des points. Cliquez sur le premier point ou double-cliquez pour fermer la forme. Appuyez sur Entrée pour garder un tracé ouvert ; Échap annule.';

  @override
  String get toolHintFreehand =>
      'Faites glisser pour tracer un trait à main levée lissé.';

  @override
  String get toolHintImage =>
      'Faites glisser l’image de ce calque pour la déplacer, ou une poignée pour la redimensionner. Les coins conservent les proportions ; Maj ou une poignée de bord étire l’image.';

  @override
  String get ribbonFile => 'Fichier';

  @override
  String get ribbonHome => 'Accueil';

  @override
  String get ribbonInsert => 'Insertion';

  @override
  String get ribbonLayer => 'Calque';

  @override
  String get ribbonImage => 'Image';

  @override
  String get ribbonView => 'Affichage';

  @override
  String viewZoomLabel(String value) {
    return 'Zoom $value';
  }

  @override
  String get statusMousePan =>
      'Faites défiler ou faites glisser avec le bouton droit pour déplacer la vue.';

  @override
  String get fileTypeProject => 'Projet Flutter Painter';

  @override
  String get fileTypeImages => 'Images';

  @override
  String get fileTypeDart => 'Dart';

  @override
  String get fileTypeZip => 'Archive ZIP';

  @override
  String get fileSaveHere => 'Enregistrer ici';

  @override
  String workspaceInvalidProject(String path) {
    return 'Ce fichier n’est pas un projet Flutter Painter : $path';
  }

  @override
  String workspaceOpenFailed(String path, String error) {
    return 'Impossible d’ouvrir $path : $error';
  }

  @override
  String workspaceSaved(String path) {
    return 'Enregistré : $path';
  }

  @override
  String workspaceSaveFailed(String error) {
    return 'Impossible d’enregistrer : $error';
  }

  @override
  String imageLoadFailed(String error) {
    return 'Impossible de charger cette image : $error';
  }

  @override
  String get dropProjectHint =>
      'Déposez un projet .flp pour l’ouvrir dans un nouvel onglet, ou une image pour la placer sur le calque actif.';

  @override
  String get exportReplaceTitle => 'Remplacer les fichiers existants ?';

  @override
  String exportReplaceMessage(int existing, int total) {
    return '$existing fichiers sur $total existent déjà dans ce dossier et seront remplacés.';
  }

  @override
  String get exportReplace => 'Remplacer';

  @override
  String exportSavedFolder(int count, String path) {
    return '$count fichier(s) enregistré(s) dans $path';
  }

  @override
  String exportSavedArchive(int count, String path) {
    return '$count fichier(s) enregistré(s) dans $path';
  }

  @override
  String exportSaveFailed(String error) {
    return 'Impossible d’enregistrer : $error';
  }

  @override
  String get exportCloseTitle => 'Fermer l’éditeur de code ?';

  @override
  String get exportCloseMessage =>
      'Vos modifications des fichiers générés ne sont pas enregistrées et seront perdues.';

  @override
  String get exportClose => 'Fermer';

  @override
  String get exportRegenerateTitle => 'Régénérer les fichiers ?';

  @override
  String get exportRegenerateMessage =>
      'Cette action recrée chaque fichier à partir du dessin et supprime vos modifications.';

  @override
  String get exportRegenerate => 'Régénérer';

  @override
  String get exportSettingsChanged =>
      'Les paramètres d’exportation ont changé. Régénérez pour les appliquer (vos modifications seront supprimées).';

  @override
  String exportTitle(String name) {
    return 'Éditeur de code — $name';
  }

  @override
  String get exportSaveFolder => 'Enregistrer dans un dossier';

  @override
  String exportSaveFolderTooltip(String modifier) {
    return 'Enregistrer tous les fichiers dans un dossier ($modifier+S)';
  }

  @override
  String get exportSaveArchive => 'Enregistrer dans une archive';

  @override
  String exportSaveArchiveTooltip(String modifier) {
    return 'Enregistrer tous les fichiers dans un seul .zip ($modifier+Maj+S)';
  }

  @override
  String get exportCopy => 'Copier';

  @override
  String get exportCopyTooltip =>
      'Copier le fichier ouvert dans le presse-papiers';

  @override
  String get exportFormatDocument => 'Formater le document';

  @override
  String get exportFormatTooltip => 'Formater le fichier ouvert (Maj+Alt+F)';

  @override
  String get exportBuildAgain => 'Reconstruire';

  @override
  String get exportBuildAgainTooltip =>
      'Reconstruire les fichiers depuis le dessin (supprime vos modifications)';

  @override
  String get exportBackToDrawing => 'Retour au dessin';

  @override
  String get exportSelectFileHint =>
      'Sélectionnez un fichier dans l’explorateur pour l’ouvrir';

  @override
  String get exportExplorer => 'Explorateur';

  @override
  String get exportSettingsLabel => 'Paramètres';

  @override
  String get exportCloseTab => 'Fermer';

  @override
  String get projectTabCloseTooltip => 'Fermer (Ctrl+W)';

  @override
  String get projectTabNotSaved => 'Pas encore enregistré';

  @override
  String layerDefaultGroup(int number) {
    return 'Groupe $number';
  }

  @override
  String editorCaret(int line, int column) {
    return 'Lig. $line, Col. $column';
  }

  @override
  String editorCaretSelection(int line, int column, int selected) {
    return 'Lig. $line, Col. $column ($selected sélectionnés)';
  }

  @override
  String editorLineCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lignes',
      one: '1 ligne',
    );
    return '$_temp0';
  }

  @override
  String editorSpaceCount(int count) {
    return 'Espaces : $count';
  }

  @override
  String exportRegenerated(int count) {
    return '$count fichier(s) régénéré(s)';
  }

  @override
  String exportFormatted(String name) {
    return '$name formaté';
  }

  @override
  String exportCopied(String name) {
    return '$name copié dans le presse-papiers';
  }

  @override
  String get projectUnavailable => 'Aucun projet actif n’est disponible ici.';

  @override
  String get untitledProject => 'Sans titre';

  @override
  String untitledProjectNumbered(int number) {
    return 'Sans titre $number';
  }

  @override
  String defaultLayerName(int number) {
    return 'Calque $number';
  }

  @override
  String defaultGroupName(int number) {
    return 'Groupe $number';
  }

  @override
  String projectFileDamaged(String path) {
    return 'Impossible d’ouvrir $path : le fichier est endommagé ou n’est pas un projet.';
  }

  @override
  String projectFileTooNew(String path) {
    return '$path a été créé avec une version plus récente de Flutter Painter. Mettez l’application à jour pour l’ouvrir.';
  }

  @override
  String get statusNotBackedUp => 'Non sauvegardé';

  @override
  String get statusNotBackedUpTooltip =>
      'La copie de récupération n’a pas pu être enregistrée. Enregistrez votre projet pour ne rien perdre.';

  @override
  String get layerCopyItem => 'Copier l’élément';

  @override
  String get layerDragReorder => 'Faire glisser pour réorganiser les calques';

  @override
  String get ribbon3d => '3D';

  @override
  String get layerMake3d => 'Make 3D layer';

  @override
  String get layerRemove3d => 'Back to flat layer';

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

  @override
  String get model3dViewFront => 'Front';

  @override
  String get model3dFold => 'Fold';

  @override
  String get model3dBend => 'Bend';

  @override
  String get model3dAxis => 'Fold line angle';

  @override
  String get model3dFoldHint =>
      'Positive folds and bends the part away from you.';

  @override
  String get model3dLive => 'Live 3D';

  @override
  String get model3dTabPreview => 'Canvas Preview';

  @override
  String get model3dTabLive => 'Live 3D';

  @override
  String get model3dLiveNote =>
      'Drag empty space to turn the view. Drag a shape to move it in depth, or hold Alt and drag to tilt it.';

  @override
  String get model3dLiveSave => 'Save angle as view';

  @override
  String get model3dForm => 'Shape form';

  @override
  String get model3dFormThicknessNote =>
      'Give the shape a thickness to see its form.';

  @override
  String get model3dSectionBox => 'Box';

  @override
  String get model3dSectionEllipse => 'Ellipse';

  @override
  String get model3dSectionPolygon => 'Polygon';

  @override
  String get model3dSectionSides => 'Sides';

  @override
  String get model3dSectionAcrossWidth => 'Across width';

  @override
  String get model3dSectionAcrossHeight => 'Across height';

  @override
  String get model3dShapeTilt => 'Tilt (3D only)';

  @override
  String get model3dWorkStart => 'Work on this part';

  @override
  String get model3dWorkStop => 'Stop working on this part';

  @override
  String model3dWorkNote(String part) {
    return 'Working on “$part”. Other parts are shown faded.';
  }

  @override
  String get model3dAddFaceOn => 'Add a face on';

  @override
  String get model3dAddFace => 'Add face';

  @override
  String get model3dEdgeTop => 'Top edge';

  @override
  String get model3dEdgeRight => 'Right edge';

  @override
  String get model3dEdgeBottom => 'Bottom edge';

  @override
  String get model3dEdgeLeft => 'Left edge';

  @override
  String model3dEdgeNumber(String number) {
    return 'Edge $number';
  }

  @override
  String model3dFaceName(String number) {
    return 'Face $number';
  }
}
