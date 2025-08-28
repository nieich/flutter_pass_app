import 'package:workmanager/workmanager.dart';

import 'services.dart';
import 'package:get_it/get_it.dart';

final GetIt locator = GetIt.instance;

/// Sets up the service locator.
///
/// This function should be called once at application startup, for example
/// in `main.dart`.
void setupLocator() {
  // Register services as lazy singletons. They will be created once, the first
  // time they are requested.

  // By registering an interface (`LogService`) with a concrete implementation
  // (`LogServiceImpl`), we can easily swap it out for a mock in tests.
  locator.registerLazySingleton<LogService>(() => LogServiceImpl());

  // Register Workmanager as a lazy singleton
  locator.registerLazySingleton<Workmanager>(() => Workmanager());

  // Register our new background service
  locator.registerLazySingleton<BackgroundRefreshService>(
    () => BackgroundRefreshService(workmanager: locator<Workmanager>(), settingsService: locator<SettingsService>()),
  );

  // You can now do the same for your other services.
  // This assumes you have created interfaces and implementations for them.
  locator.registerLazySingleton<PassFileStorageService>(() => PassFileStorageServiceImpl());

  // For services that depend on others, get_it can resolve them automatically.
  // Just pass the dependency in the constructor.
  locator.registerLazySingleton<PassImportService>(() => PassImportServiceImpl(locator<PassFileStorageService>()));
  locator.registerLazySingleton<PassService>(
    () => PassServiceImpl(locator<PassFileStorageService>(), locator<PassImportService>()),
  );

  // Keep this registration as is
  locator.registerLazySingleton(() => SharedPreferenceService());

  // Update the SettingsService registration
  locator.registerLazySingleton(() => SettingsService(locator<SharedPreferenceService>()));
}
