import 'package:flutter_pass_app/services/service_locator.dart';
import 'package:flutter_pass_app/services/services.dart';
import 'package:flutter_pass_app/utils/constants.dart';
import 'package:logging/logging.dart';
import 'package:workmanager/workmanager.dart';

/// This callback needs to be a top-level or static function.
/// It is the entry point for the background task.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final logger = Logger('Workmanager');
    logger.info("WorkManager: Executing background pass refresh.");

    try {
      // IMPORTANT: You must initialize services within the background isolate.
      // Singletons from the main isolate are not available here.
      // This setup assumes your services can be initialized without a Flutter context.
      setupLocator();
      await locator<SharedPreferenceService>().init();
      await locator<PassService>().initialize();

      final passService = locator<PassService>();
      await passService.updateAllPasses();

      logger.info("WorkManager: Background pass refresh completed successfully.");
      return true;
    } catch (e, stacktrace) {
      logger.severe("WorkManager error: $e", e, stacktrace);
      return false;
    }
  });
}

/// A service to manage the background pass refresh logic using Workmanager.
class BackgroundRefreshService {
  final Workmanager _workmanager;
  final SettingsService _settingsService;
  final _logger = Logger('BackgroundRefreshService');

  BackgroundRefreshService({required Workmanager workmanager, required SettingsService settingsService})
    : _workmanager = workmanager,
      _settingsService = settingsService;

  /// Initializes the Workmanager and syncs its state with the current settings.
  /// Should be called once on app startup.
  Future<void> initialize() async {
    await _workmanager.initialize(callbackDispatcher);
    await syncStateWithSettings();
  }

  /// Reads settings and enables or disables the background task accordingly.
  Future<void> syncStateWithSettings() async {
    final isEnabled = await _settingsService.isUpdateIntervalActivated();
    if (isEnabled) {
      final interval = await _settingsService.getUpdateInterval();
      await _registerPeriodicTask(interval);
    } else {
      await _cancelPeriodicTask();
    }
  }

  Future<void> _registerPeriodicTask(int minutes) async {
    // Workmanager's minimum frequency is 15 minutes on Android.
    final frequency = Duration(minutes: minutes < 15 ? 15 : minutes);

    _logger.info('Registering periodic task with frequency: $frequency.');
    await _workmanager.registerPeriodicTask(
      Constants.workmanagerRefreshTaskId,
      Constants.workmanagerRefreshTaskName,
      frequency: frequency,
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }

  Future<void> _cancelPeriodicTask() async {
    _logger.info('Cancelling background refresh task.');
    await _workmanager.cancelByUniqueName(Constants.workmanagerRefreshTaskName);
  }
}
