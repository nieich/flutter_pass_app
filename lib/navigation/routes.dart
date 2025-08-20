class Routes {
  Routes._();
  static const String root = '/';

  static const String home = 'Home';
  static const String pathHome = '$root$home';
  static const String homeQRCode = 'QRCode';
  static const String pathHomeQRCode = '$pathHome/$homeQRCode';

  static const String settings = 'Settings';
  static const String pathSettings = '$pathHome/$settings';

  static const String pass = 'Pass';
  static const String pathPass = '$pathHome/$pass';
  static const String passQrCode = 'PassQrCode';
  static const String pathPassQrCode = '$pathPass/$passQrCode';
}
