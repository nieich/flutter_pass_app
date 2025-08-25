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
}
