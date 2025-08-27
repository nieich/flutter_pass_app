import 'package:flutter_pass_app/services/shared_preferences_service.dart';

/// A service class that handles loading and saving user settings.
/// This encapsulates the SharedPreferences logic, separating it from the UI.
class SettingsService {
  final SharedPreferenceService _prefsService;

  SettingsService(this._prefsService);

  // Private constants for SharedPreferences keys to avoid typos.
  static const _isUpdateIntervalActivatedKey = 'isUpdateIntervalActivated';
  static const _updateIntervalKey = 'updateInterval';

  // --- Update Interval Activated ---

  /// Returns whether the update interval is activated.
  ///
  /// Defaults to `false` if not set.
  Future<bool> isUpdateIntervalActivated() async {
    return _prefsService.getBool(_isUpdateIntervalActivatedKey, defaultValue: false);
  }

  /// Sets whether the update interval is activated.
  Future<void> setUpdateIntervalActivated(bool value) async {
    await _prefsService.saveBool(_isUpdateIntervalActivatedKey, value);
  }

  // --- Update Interval ---

  /// Returns the update interval in minutes.
  ///
  /// Defaults to `60` if not set.
  Future<int> getUpdateInterval() {
    return _prefsService.getInt(_updateIntervalKey, defaultValue: 60);
  }

  /// Sets the update interval in hours.
  Future<void> setUpdateInterval(int hours) async {
    await _prefsService.saveInt(_updateIntervalKey, hours);
  }
}
