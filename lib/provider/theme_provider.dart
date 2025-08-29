import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ColorMode { system, seed, individual }

class ThemeProvider with ChangeNotifier {
  static const String _themeColorKey = 'theme_color';
  static const String _themeModeKey = 'theme_mode';
  static const String _colorModeKey = 'color_mode';
  static const String _primaryColorKey = 'primary_color';
  static const String _onPrimaryColorKey = 'on_primary_color';
  static const String _secondaryColorKey = 'secondary_color';
  static const String _onSecondaryColorKey = 'on_secondary_color';
  static const String _errorColorKey = 'error_color';
  static const String _onErrorColorKey = 'on_error_color';
  static const String _surfaceColorKey = 'surface_color';
  static const String _onSurfaceColorKey = 'on_surface_color';

  Color _seedColor = Colors.deepPurple;
  ThemeMode _themeMode = ThemeMode.system;
  ColorMode _colorMode = ColorMode.system;

  // Individual colors
  Color _primary = Colors.blueAccent;
  Color _onPrimary = Colors.black;
  Color _secondary = Colors.greenAccent;
  Color _onSecondary = Colors.black;
  Color _error = Colors.redAccent;
  Color _onError = Colors.black;
  Color _surface = const Color(0xFF121212);
  Color _onSurface = Colors.white;

  ThemeProvider() {
    _loadTheme();
  }

  Color get seedColor => _seedColor;
  ThemeMode get themeMode => _themeMode;
  ColorMode get colorMode => _colorMode;
  Color get primary => _primary;
  Color get onPrimary => _onPrimary;
  Color get secondary => _secondary;
  Color get onSecondary => _onSecondary;
  Color get error => _error;
  Color get onError => _onError;
  Color get surface => _surface;
  Color get onSurface => _onSurface;

  /// The ColorScheme for the light theme.
  /// It is generated dynamically based on the selected [colorMode].
  ColorScheme get lightColorScheme {
    if (_colorMode == ColorMode.individual) {
      return ColorScheme(
        brightness: Brightness.light,
        primary: _primary,
        onPrimary: _onPrimary,
        secondary: _secondary,
        onSecondary: _onSecondary,
        error: _error,
        onError: _onError,
        surface: _surface,
        onSurface: _onSurface,
      );
    }
    return ColorScheme.fromSeed(seedColor: _seedColor, brightness: Brightness.light);
  }

  /// The ColorScheme for the dark theme.
  /// It is generated dynamically based on the selected [colorMode].
  ColorScheme get darkColorScheme {
    if (_colorMode == ColorMode.individual) {
      return ColorScheme(
        brightness: Brightness.dark,
        primary: _primary,
        onPrimary: _onPrimary,
        secondary: _secondary,
        onSecondary: _onSecondary,
        error: _error,
        onError: _onError,
        surface: _surface,
        onSurface: _onSurface,
      );
    }
    return ColorScheme.fromSeed(seedColor: _seedColor, brightness: Brightness.dark);
  }

  void _loadTheme() async {
    final logger = Logger('ThemeProvider');
    final prefs = await SharedPreferences.getInstance();
    final colorValue = prefs.getInt(_themeColorKey);

    if (colorValue != null) {
      _seedColor = Color(colorValue);
    }

    final themeModeName = prefs.getString(_themeModeKey);
    if (themeModeName != null) {
      try {
        _themeMode = ThemeMode.values.byName(themeModeName);
      } catch (e) {
        // If the theme mode is not recognized, default to system.
        logger.info('Unknown theme mode: $themeModeName, defaulting to system.');
        _themeMode = ThemeMode.system;
      }
    }

    final colorModeName = prefs.getString(_colorModeKey);
    if (colorModeName != null) {
      try {
        _colorMode = ColorMode.values.byName(colorModeName);
      } catch (e) {
        // If the color mode is not recognized, default to seed.
        logger.info('Unknown color mode: $colorModeName, defaulting to seed.');
        _colorMode = ColorMode.seed;
      }
    }

    // Helper to reduce repetition when loading colors.
    Color getColor(String key, Color defaultColor) => Color(prefs.getInt(key) ?? defaultColor.toARGB32());

    _primary = getColor(_primaryColorKey, Colors.blueAccent);
    _onPrimary = getColor(_onPrimaryColorKey, Colors.black);
    _secondary = getColor(_secondaryColorKey, Colors.greenAccent);
    _onSecondary = getColor(_onSecondaryColorKey, Colors.black);
    _error = getColor(_errorColorKey, Colors.redAccent);
    _onError = getColor(_onErrorColorKey, Colors.black);
    _surface = getColor(_surfaceColorKey, const Color(0xFF121212));
    _onSurface = getColor(_onSurfaceColorKey, Colors.white);
    notifyListeners();
  }

  Future<void> setSeedColor(Color color) async {
    _seedColor = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeColorKey, color.toARGB32());
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode.name);
    notifyListeners();
  }

  Future<void> setColorMode(ColorMode mode) async {
    _colorMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_colorModeKey, mode.name);
    notifyListeners();
  }

  Future<void> setPrimary(Color color) async {
    _primary = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_primaryColorKey, color.toARGB32());
    notifyListeners();
  }

  Future<void> setOnPrimary(Color color) async {
    _onPrimary = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_onPrimaryColorKey, color.toARGB32());
    notifyListeners();
  }

  Future<void> setSecondary(Color color) async {
    _secondary = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_secondaryColorKey, color.toARGB32());
    notifyListeners();
  }

  Future<void> setOnSecondary(Color color) async {
    _onSecondary = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_onSecondaryColorKey, color.toARGB32());
    notifyListeners();
  }

  Future<void> setError(Color color) async {
    _error = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_errorColorKey, color.toARGB32());
    notifyListeners();
  }

  Future<void> setOnError(Color color) async {
    _onError = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_onErrorColorKey, color.toARGB32());
    notifyListeners();
  }

  Future<void> setSurface(Color color) async {
    _surface = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_surfaceColorKey, color.toARGB32());
    notifyListeners();
  }

  Future<void> setOnSurface(Color color) async {
    _onSurface = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_onSurfaceColorKey, color.toARGB32());
    notifyListeners();
  }
}
