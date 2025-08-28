class Routes {
  Routes._();
  static const String root = '/';

  static const String home = 'Home';
  static const String pathHome = '$root$home';
  static const String homeQRCode = 'QRCode';
  static const String pathHomeQRCode = '$pathHome/$homeQRCode';

  static const String settings = 'Settings';
  static const String pathSettings = '$pathHome/$settings';
  static const String settingsGeneral = 'General';
  static const String pathSettingsGeneral = '$pathSettings/$settingsGeneral';
  static const String settingsTheme = 'Theme';
  static const String pathSettingsTheme = '$pathSettings/$settingsTheme';
  static const String settingsDev = 'Dev';
  static const String pathSettingsDev = '$pathSettings/$settingsDev';

  static const String pass = 'Pass';
  static const String pathPass = '$pathHome/$pass';
  static const String passQrCode = 'PassQrCode';
  static const String pathPassQrCode = '$pathPass/$passQrCode';
}
