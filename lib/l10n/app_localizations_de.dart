// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get title => 'Passes';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Delete';

  @override
  String get share => 'Share';

  @override
  String get addPassFromFile => 'Add Pass from File';

  @override
  String pickedFile(String fileName) {
    return 'Picked file: $fileName';
  }

  @override
  String get invalidFileType =>
      'Invalid file type. Please select a .pkpass file.';

  @override
  String get sharingPass => 'Sharing Pass';

  @override
  String get noPasses => 'No Passes';

  @override
  String get passParseError => 'Error parsing pass';

  @override
  String get settings => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get themeColor => 'Design Color';

  @override
  String get themeColorDescription => 'Choose a color for the app design';

  @override
  String get themeMode => 'Theme Mode';

  @override
  String get systemTheme => 'System';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get colorMode => 'Color Mode';

  @override
  String get colorModeSystem => 'System Color';

  @override
  String get colorModeSystemDescription => 'Use the system\'s color';

  @override
  String get colorModeSeed => 'Seed Color';

  @override
  String get colorModeIndividual => 'Individual Color';

  @override
  String get individualColorMode => 'Individual Color Mode';

  @override
  String get individualColorModeDescription =>
      'Select a custom color for each element in the app.';

  @override
  String get primaryColor => 'Primary Color';

  @override
  String get onPrimaryColor => 'On Primary Color';

  @override
  String get secondaryColor => 'Secondary Color';

  @override
  String get onSecondaryColor => 'On Secondary Color';

  @override
  String get surfaceColor => 'Surface Color';

  @override
  String get onSurfaceColor => 'On Surface Color';

  @override
  String get errorColor => 'Error Color';

  @override
  String get onErrorColor => 'On Error Color';

  @override
  String get passDoesNotSupportUpdates => 'This pass does not support updates.';

  @override
  String get passUpdateFailedOrNoUpdateAvailable =>
      'Failed to update pass or no update available.';

  @override
  String get deletePass => 'Delete Pass';

  @override
  String get deletePassConfirmation =>
      'Are you sure you want to delete this pass? This action cannot be undone.';

  @override
  String get general => 'General';

  @override
  String get generalSettingsDesc => 'General Settings';

  @override
  String get themeSettingsDesc => 'Set the Theme and colors';

  @override
  String get dev => 'Dev';

  @override
  String get devSettingsDesc => 'Development Settings';

  @override
  String get settingsSaved => 'Settings Saved';

  @override
  String get passRefresh => 'Pass Refresh';

  @override
  String get activate => 'Activate';

  @override
  String get passRefreshHintText => 'Pass Refreshintervall (min)';

  @override
  String get devLogs => 'Developer Logs';

  @override
  String get clearLogs => 'Clear Logs';

  @override
  String get shareLogs => 'Share Logs';

  @override
  String get appLogs => 'App Logs';

  @override
  String get noLogsToShare => 'No logs to share';

  @override
  String get noLogsRecordedYet => 'No logs recorded yet';
}
