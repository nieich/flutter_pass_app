// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get title => 'Pases';

  @override
  String get ok => 'Aceptar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get share => 'Compartir';

  @override
  String get addPassFromFile => 'Añadir Pase Desde Archivo';

  @override
  String pickedFile(String fileName) {
    return 'Archivo seleccionado: $fileName';
  }

  @override
  String get invalidFileType =>
      'Tipo de archivo no válido. Por favor, seleccione un archivo .pkpass.';

  @override
  String get sharingPass => 'Compartiendo Pase';

  @override
  String get noPasses => 'No Hay Pases';

  @override
  String get passParseError => 'Error al analizar el pase';

  @override
  String get settings => 'Ajustes';

  @override
  String get theme => 'Tema';

  @override
  String get themeColor => 'Color del Tema';

  @override
  String get themeColorDescription =>
      'Seleccione un color para el tema de la aplicación';

  @override
  String get themeMode => 'Modo del Tema';

  @override
  String get systemTheme => 'Sistema';

  @override
  String get lightTheme => 'Claro';

  @override
  String get darkTheme => 'Oscuro';

  @override
  String get colorMode => 'Modo de Color';

  @override
  String get colorModeSystem => 'Color del Sistema';

  @override
  String get colorModeSystemDescription => 'Usar el color del sistema';

  @override
  String get colorModeSeed => 'Color Semilla';

  @override
  String get colorModeIndividual => 'Color Individual';

  @override
  String get individualColorMode => 'Modo de Color Individual';

  @override
  String get individualColorModeDescription =>
      'Seleccione un color personalizado para cada elemento en la aplicación.';

  @override
  String get primaryColor => 'Color Primario';

  @override
  String get onPrimaryColor => 'Sobre Color Primario';

  @override
  String get secondaryColor => 'Color Secundario';

  @override
  String get onSecondaryColor => 'Sobre Color Secundario';

  @override
  String get surfaceColor => 'Color de Superficie';

  @override
  String get onSurfaceColor => 'Sobre Color de Superficie';

  @override
  String get errorColor => 'Color de Error';

  @override
  String get onErrorColor => 'Sobre Color de Error';

  @override
  String get passDoesNotSupportUpdates =>
      'Este pase no admite actualizaciones.';

  @override
  String get passUpdateFailedOrNoUpdateAvailable =>
      'La actualización del pase falló o no hay actualizaciones disponibles.';

  @override
  String get deletePass => 'Eliminar Pase';

  @override
  String get deletePassConfirmation =>
      '¿Está seguro de que desea eliminar este pase? Esta acción no se puede deshacer.';

  @override
  String get general => 'General';

  @override
  String get generalSettingsDesc => 'Ajustes generales';

  @override
  String get themeSettingsDesc => 'Establecer tema y colores';

  @override
  String get dev => 'Desarrollo';

  @override
  String get devSettingsDesc => 'Ajustes de desarrollo';

  @override
  String get settingsSaved => 'Ajustes guardados';

  @override
  String get passRefresh => 'Actualizar Pase';

  @override
  String get activate => 'Activar';

  @override
  String get passRefreshHintText => 'Intervalo de actualización del pase (min)';

  @override
  String get devLogs => 'Registros de Desarrollador';

  @override
  String get clearLogs => 'Limpiar Registros';

  @override
  String get shareLogs => 'Compartir Registros';

  @override
  String get appLogs => 'Registros de la Aplicación';

  @override
  String get noLogsToShare => 'No hay registros para compartir';

  @override
  String get noLogsRecordedYet => 'Aún no hay registros grabados';

  @override
  String get invalidBoardingPassData =>
      'Datos de tarjeta de embarque no válidos';

  @override
  String get invalidEventTicketData => 'Datos de entrada de evento no válidos';
}
