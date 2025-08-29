// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get title => 'Passes';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

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
}
