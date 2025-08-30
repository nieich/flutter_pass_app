// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get title => 'Pass';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get share => 'Partager';

  @override
  String get addPassFromFile => 'Ajouter un Pass Depuis un Fichier';

  @override
  String pickedFile(String fileName) {
    return 'Fichier sélectionné : $fileName';
  }

  @override
  String get invalidFileType =>
      'Type de fichier invalide. Veuillez sélectionner un fichier .pkpass.';

  @override
  String get sharingPass => 'Partage du Pass';

  @override
  String get noPasses => 'Aucun Pass';

  @override
  String get passParseError => 'Erreur lors de l\'analyse du pass';

  @override
  String get settings => 'Paramètres';

  @override
  String get theme => 'Thème';

  @override
  String get themeColor => 'Couleur du Thème';

  @override
  String get themeColorDescription =>
      'Sélectionnez une couleur pour le thème de l\'application';

  @override
  String get themeMode => 'Mode du Thème';

  @override
  String get systemTheme => 'Système';

  @override
  String get lightTheme => 'Clair';

  @override
  String get darkTheme => 'Sombre';

  @override
  String get colorMode => 'Mode Couleur';

  @override
  String get colorModeSystem => 'Couleur du Système';

  @override
  String get colorModeSystemDescription => 'Utiliser la couleur du système';

  @override
  String get colorModeSeed => 'Couleur de Base';

  @override
  String get colorModeIndividual => 'Couleur Individuelle';

  @override
  String get individualColorMode => 'Mode Couleur Individuel';

  @override
  String get individualColorModeDescription =>
      'Sélectionnez une couleur personnalisée pour chaque élément de l\'application.';

  @override
  String get primaryColor => 'Couleur Primaire';

  @override
  String get onPrimaryColor => 'Sur Couleur Primaire';

  @override
  String get secondaryColor => 'Couleur Secondaire';

  @override
  String get onSecondaryColor => 'Sur Couleur Secondaire';

  @override
  String get surfaceColor => 'Couleur de Surface';

  @override
  String get onSurfaceColor => 'Sur Couleur de Surface';

  @override
  String get errorColor => 'Couleur d\'Erreur';

  @override
  String get onErrorColor => 'Sur Couleur d\'Erreur';

  @override
  String get passDoesNotSupportUpdates =>
      'Ce pass ne prend pas en charge les mises à jour.';

  @override
  String get passUpdateFailedOrNoUpdateAvailable =>
      'La mise à jour du pass a échoué ou aucune mise à jour n\'est disponible.';

  @override
  String get deletePass => 'Supprimer le Pass';

  @override
  String get deletePassConfirmation =>
      'Êtes-vous sûr de vouloir supprimer ce pass ? Cette action est irréversible.';

  @override
  String get general => 'Général';

  @override
  String get generalSettingsDesc => 'Paramètres généraux';

  @override
  String get themeSettingsDesc => 'Définir le thème et les couleurs';

  @override
  String get dev => 'Développement';

  @override
  String get devSettingsDesc => 'Paramètres de développement';

  @override
  String get settingsSaved => 'Paramètres enregistrés';

  @override
  String get passRefresh => 'Actualiser le Pass';

  @override
  String get activate => 'Activer';

  @override
  String get passRefreshHintText =>
      'Intervalle de rafraîchissement du pass (min)';

  @override
  String get devLogs => 'Logs de Développement';

  @override
  String get clearLogs => 'Effacer les Logs';

  @override
  String get shareLogs => 'Partager les Logs';

  @override
  String get appLogs => 'Logs de l\'Application';

  @override
  String get noLogsToShare => 'Aucun log à partager';

  @override
  String get noLogsRecordedYet => 'Aucun log enregistré pour le moment';

  @override
  String get invalidBoardingPassData =>
      'Données de carte d\'embarquement invalides';

  @override
  String get invalidEventTicketData =>
      'Données de billet d\'événement invalides';
}
