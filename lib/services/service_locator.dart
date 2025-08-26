import 'package:flutter_pass_app/services/log_service.dart';
import 'package:flutter_pass_app/services/pass_file_storage_service.dart';
import 'package:flutter_pass_app/services/pass_import_service.dart';
import 'package:flutter_pass_app/services/pass_service.dart';
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

  // You can now do the same for your other services.
  // This assumes you have created interfaces and implementations for them.
  locator.registerLazySingleton<PassFileStorageService>(() => PassFileStorageServiceImpl());

  // For services that depend on others, get_it can resolve them automatically.
  // Just pass the dependency in the constructor.
  locator.registerLazySingleton<PassImportService>(() => PassImportServiceImpl(locator<PassFileStorageService>()));
  locator.registerLazySingleton<PassService>(
    () => PassServiceImpl(locator<PassFileStorageService>(), locator<PassImportService>()),
  );
}
