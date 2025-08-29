import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pass_app/l10n/app_localizations.dart';
import 'package:flutter_pass_app/navigation/router.dart';
import 'package:flutter_pass_app/services/service_locator.dart';
import 'package:flutter_pass_app/services/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logging/logging.dart';

Future<void> main() async {
  // Ensures that the plugin services are initialized before the app is executed.
  WidgetsFlutterBinding.ensureInitialized();

  // Set up the service locator before running the app.
  setupLocator();

  await locator<SharedPreferenceService>().init();

  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('${record.level.name}: ${record.time}: ${record.message}');
    locator<LogService>().add(record);
  });

  await initializeDateFormatting('de', null);

  await locator<PassService>().initialize();

  // Initialize and sync the background refresh service
  await locator<BackgroundRefreshService>().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

        if (lightDynamic != null && darkDynamic != null) {
          // On Android S+ devices, use the dynamic color scheme.
          // harmonized() ensures that the dynamic colors will work well
          // with any custom colors in your app.
          lightColorScheme = lightDynamic.harmonized();
          darkColorScheme = darkDynamic.harmonized();
        } else {
          // Otherwise, use a fallback scheme based on a seed color.
          lightColorScheme = ColorScheme.fromSeed(seedColor: Colors.indigo);
          darkColorScheme = ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: Brightness.dark);
        }

        return MaterialApp.router(
          title: 'Flutter Pass App',
          theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
          darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
          themeMode: ThemeMode.system,
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        );
      },
    );
  }
}
