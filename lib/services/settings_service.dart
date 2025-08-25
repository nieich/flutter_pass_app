import 'package:flutter_pass_app/services/shared_preferences_service.dart';

/// A service class that handles loading and saving user settings.
/// This encapsulates the SharedPreferences logic, separating it from the UI.
class SettingsService extends SharedPreferenceService {
  // Private constants for SharedPreferences keys to avoid typos.
  static const isUpdateIntervalActivatedKey = 'isUpdateIntervalActivated';
  static const updateIntervalKey = 'updateInterval';
}
