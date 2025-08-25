import 'package:flutter/material.dart';
import 'package:flutter_pass_app/l10n/app_localizations.dart';
import 'package:flutter_pass_app/navigation/router.dart';
import 'package:flutter_pass_app/services/log_service.dart';
import 'package:flutter_pass_app/services/pass_service.dart';
import 'package:flutter_pass_app/services/settings_service.dart';
import 'package:flutter_pass_app/utils/constants.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logging/logging.dart';
import 'package:workmanager/workmanager.dart';

// This callback needs to be a top-level or static function.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final logger = Logger('Workmanager');
    logger.info("WorkManager: Executing background pass refresh.");
    try {
      // In a real app, initializing services for background isolates can be complex.
      // You might need a dependency injection setup that can be initialized here.
      // For this example, we assume the singleton can be accessed.
      final service = PassService.instance;
      service.initialize();

      service.updateAllPasses();
      return true;
    } catch (e) {
      logger.severe("WorkManager error: $e");
      return false;
    }
  });
}

Future<void> main() async {
  // Ensures that the plugin services are initialized before the app is executed.
  WidgetsFlutterBinding.ensureInitialized();

  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('${record.level.name}: ${record.time}: ${record.message}');
    LogService().add(record);
  });

  await initializeDateFormatting('de', null);

  await PassService.instance.initialize();

  final isRefreshActivated = await SettingsService().getBool(
    SettingsService.isUpdateIntervalActivatedKey,
    defaultValue: false,
  );
  if (isRefreshActivated) {
    final frequenceString = await SettingsService().getString(SettingsService.updateIntervalKey, defaultValue: '60');
    final frequence = int.parse(frequenceString);

    await Workmanager().initialize(callbackDispatcher);

    // Register a periodic task.
    Workmanager().registerPeriodicTask(
      Constants.workmanagerRefreshTaskId,
      Constants.workmanagerRefreshTaskName,
      frequency: Duration(minutes: frequence),
      constraints: Constraints(networkType: NetworkType.connected),
    );
  } else {
    Workmanager().cancelByUniqueName(Constants.workmanagerRefreshTaskName);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.dark,
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
