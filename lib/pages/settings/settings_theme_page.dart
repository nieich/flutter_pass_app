import 'package:flutter/material.dart';
import 'package:flutter_pass_app/l10n/app_localizations.dart';
import 'package:flutter_pass_app/provider/theme_provider.dart';
import 'package:flutter_pass_app/widgets/settings_theme_widget.dart';
import 'package:provider/provider.dart';

class SettingsThemePage extends StatelessWidget {
  const SettingsThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(l10n.themeMode, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              return DropdownMenu<ThemeMode>(
                // Use LayoutBuilder to get the available width and make the menu expand.
                width: constraints.maxWidth,
                // This is the key property to ensure the menu always opens downwards.
                //position: DropdownMenuPosition.below,
                initialSelection: themeProvider.themeMode,
                onSelected: (ThemeMode? mode) {
                  if (mode != null) {
                    themeProvider.setThemeMode(mode);
                  }
                },
                // Convert the ThemeMode enum into a list of menu entries.
                dropdownMenuEntries: ThemeMode.values.map<DropdownMenuEntry<ThemeMode>>((ThemeMode mode) {
                  return DropdownMenuEntry<ThemeMode>(value: mode, label: _getThemeModeName(mode, l10n));
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            l10n.colorMode,
            style: Theme.of(context).textTheme.titleLarge,
          ), // You will need to add 'colorMode' to your .arb files
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              return DropdownMenu<ColorMode>(
                // Use LayoutBuilder to get the available width and make the menu expand.
                width: constraints.maxWidth,
                // This is the key property to ensure the menu always opens downwards.
                //position: DropdownMenuPosition.below,
                initialSelection: themeProvider.colorMode,
                onSelected: (ColorMode? mode) {
                  if (mode != null) {
                    themeProvider.setColorMode(mode);
                  }
                },
                // Convert the ThemeMode enum into a list of menu entries.
                dropdownMenuEntries: ColorMode.values.map<DropdownMenuEntry<ColorMode>>((ColorMode mode) {
                  return DropdownMenuEntry<ColorMode>(value: mode, label: _getColorModeName(mode, l10n));
                }).toList(),
              );
            },
          ),
          if (themeProvider.colorMode == ColorMode.seed)
            const ColorSchemePicker()
          else if (themeProvider.colorMode == ColorMode.individual)
            const IndividualColorPicker()
          else ...[
            const SizedBox(height: 16),
            // You will need to add 'colorModeSystemDescription' to your .arb files
            Center(child: Text(l10n.colorModeSystemDescription)),
          ],
        ],
      ),
    );
  }

  String _getThemeModeName(ThemeMode mode, AppLocalizations l10n) {
    // You will need to add the corresponding keys to your .arb files.
    switch (mode) {
      case ThemeMode.system:
        // e.g., "systemTheme": "System Default"
        return l10n.systemTheme;
      case ThemeMode.light:
        // e.g., "lightTheme": "Light"
        return l10n.lightTheme;
      case ThemeMode.dark:
        // e.g., "darkTheme": "Dark"
        return l10n.darkTheme;
    }
  }

  String _getColorModeName(ColorMode mode, AppLocalizations l10n) {
    // You will need to add the corresponding keys to your .arb files.
    switch (mode) {
      case ColorMode.system:
        return l10n.colorModeSystem;
      case ColorMode.seed:
        return l10n.colorModeSeed;
      case ColorMode.individual:
        return l10n.colorModeIndividual;
    }
  }
}
