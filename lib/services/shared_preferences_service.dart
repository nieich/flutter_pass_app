import 'package:shared_preferences/shared_preferences.dart';

/// A service class that handles loading and saving user settings.
/// This encapsulates the SharedPreferences logic, separating it from the UI.
class SharedPreferenceService {
  late final SharedPreferences _prefs;

  /// Initializes the SharedPreferences instance.
  /// Must be called before any other methods.
  /// Throws an exception if SharedPreferences fails to initialize.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  Future<void> saveInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  Future<void> saveDouble(String key, double value) async {
    await _prefs.setDouble(key, value);
  }

  Future<void> saveString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  Future<bool> getBool(String key, {bool defaultValue = false}) async {
    return _prefs.getBool(key) ?? defaultValue;
  }

  Future<int> getInt(String key, {int defaultValue = 0}) async {
    return _prefs.getInt(key) ?? 0;
  }

  Future<double> getDouble(String key, {double defaultValue = 0.0}) async {
    return _prefs.getDouble(key) ?? defaultValue;
  }

  Future<String> getString(String key, {String defaultValue = ''}) async {
    return _prefs.getString(key) ?? defaultValue;
  }
}
