// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get title => 'Pässe';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get share => 'Teilen';

  @override
  String get addPassFromFile => 'Pass aus Datei hinzufügen';

  @override
  String pickedFile(String fileName) {
    return 'Ausgewählte Datei: $fileName';
  }

  @override
  String get invalidFileType =>
      'Ungültiger Dateityp. Bitte wählen Sie eine .pkpass-Datei aus.';

  @override
  String get sharingPass => 'Pass teilen';

  @override
  String get noPasses => 'Keine Pässe';

  @override
  String get passParseError => 'Fehler beim Parsen des Passes';

  @override
  String get settings => 'Einstellungen';

  @override
  String get theme => 'Thema';

  @override
  String get themeColor => 'Designfarbe';

  @override
  String get themeColorDescription =>
      'Wählen Sie eine Farbe für das App-Design';

  @override
  String get themeMode => 'Thema-Modus';

  @override
  String get systemTheme => 'System';

  @override
  String get lightTheme => 'Hell';

  @override
  String get darkTheme => 'Dunkel';

  @override
  String get colorMode => 'Farbmodus';

  @override
  String get colorModeSystem => 'Systemfarbe';

  @override
  String get colorModeSystemDescription => 'Die Systemfarbe verwenden';

  @override
  String get colorModeSeed => 'Seed-Farbe';

  @override
  String get colorModeIndividual => 'Individuelle Farbe';

  @override
  String get individualColorMode => 'Individueller Farbmodus';

  @override
  String get individualColorModeDescription =>
      'Wählen Sie für jedes Element in der App eine benutzerdefinierte Farbe aus.';

  @override
  String get primaryColor => 'Primärfarbe';

  @override
  String get onPrimaryColor => 'Auf Primärfarbe';

  @override
  String get secondaryColor => 'Sekundärfarbe';

  @override
  String get onSecondaryColor => 'Auf Sekundärfarbe';

  @override
  String get surfaceColor => 'Oberflächenfarbe';

  @override
  String get onSurfaceColor => 'Auf Oberflächenfarbe';

  @override
  String get errorColor => 'Fehlerfarbe';

  @override
  String get onErrorColor => 'Auf Fehlerfarbe';

  @override
  String get passDoesNotSupportUpdates =>
      'Dieser Pass unterstützt keine Aktualisierungen.';

  @override
  String get passUpdateFailedOrNoUpdateAvailable =>
      'Pass-Aktualisierung fehlgeschlagen oder keine Aktualisierung verfügbar.';

  @override
  String get deletePass => 'Pass löschen';

  @override
  String get deletePassConfirmation =>
      'Sind Sie sicher, dass Sie diesen Pass löschen möchten? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get general => 'Allgemein';

  @override
  String get generalSettingsDesc => 'Allgemeine Einstellungen';

  @override
  String get themeSettingsDesc => 'Thema und Farben einstellen';

  @override
  String get dev => 'Entwicklung';

  @override
  String get devSettingsDesc => 'Entwicklungseinstellungen';

  @override
  String get settingsSaved => 'Einstellungen gespeichert';

  @override
  String get passRefresh => 'Pass aktualisieren';

  @override
  String get activate => 'Aktivieren';

  @override
  String get passRefreshHintText => 'Pass-Aktualisierungsintervall (min)';

  @override
  String get devLogs => 'Entwickler-Protokolle';

  @override
  String get clearLogs => 'Protokolle löschen';

  @override
  String get shareLogs => 'Protokolle teilen';

  @override
  String get appLogs => 'App-Protokolle';

  @override
  String get noLogsToShare => 'Keine Protokolle zum Teilen';

  @override
  String get noLogsRecordedYet => 'Noch keine Protokolle aufgezeichnet';

  @override
  String get invalidBoardingPassData => 'Ungültige Bordkartendaten';

  @override
  String get invalidEventTicketData => 'Ungültige Veranstaltungsticketdaten';
}
