import 'package:flutter/material.dart';
import 'package:flutter_pass_app/l10n/app_localizations.dart';
import 'package:flutter_pass_app/services/settings_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsGeneralPage extends StatefulWidget {
  const SettingsGeneralPage({super.key});

  @override
  State<SettingsGeneralPage> createState() => _SettingsGeneralPageState();
}

class _SettingsGeneralPageState extends State<SettingsGeneralPage> {
  final SettingsService _settingsService = SettingsService();

  bool _isActivated = true; // Default value
  late TextEditingController _intervalController; // State variable for the text field

  @override
  void initState() {
    super.initState();
    _intervalController = TextEditingController();
    _loadSettings();
  }

  // Load settings
  Future<void> _loadSettings() async {
    final newIsActivated = await _settingsService.getBool(SettingsService.isUpdateIntervalActivatedKey, defaultValue: true);
    final newIntervalText = await _settingsService.getString(SettingsService.updateIntervalKey, defaultValue: '60');

    setState(() {
      // Load the switch state, default to true if not found
      _isActivated = newIsActivated;
      // Load the interval text, default to '60' if not found
      _intervalController.text = newIntervalText;
    });
  }

  // Save settings
  Future<void> _saveSettings() async {
    _settingsService.saveBool(SettingsService.isUpdateIntervalActivatedKey, _isActivated);
    _settingsService.saveString(SettingsService.updateIntervalKey, _intervalController.text);
  }

  @override
  void dispose() {
    _intervalController.dispose(); // Dispose the controller when the widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pass the state variables and update callbacks to the child widget
            _buildGeneralSettingsTileSwitchTextField(
              context,
              _intervalController, // Pass the controller
              _isActivated,
              (value) {
                setState(() {
                  // Update UI immediately
                  _isActivated = value; // Update state and trigger rebuild
                });
                _saveSettings(); // Save the new state
              },
              () {
                _saveSettings(); // Save the current text field value
                // Optional: Show a confirmation message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Einstellungen gespeichert!')), // "Settings saved!"
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Update the signature of the helper function to accept the TextEditingController
Widget _buildGeneralSettingsTileSwitchTextField(
  BuildContext context,
  TextEditingController intervalController, // New parameter
  bool isActivated,
  ValueChanged<bool> onToggle,
  VoidCallback onPressed,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Pass Aktualisierung', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 16),
      Container(
        // Container to represent the dark card-like element.
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(color: Colors.blueGrey, borderRadius: BorderRadius.circular(16.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Keep the column compact.
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Aktivieren', // "Activate" in German.
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                Switch(
                  value: isActivated,
                  onChanged: onToggle,
                  activeColor: Colors.grey, // Active color to match the image
                  inactiveTrackColor: Colors.grey[700], // Inactive track color
                  inactiveThumbColor: Colors.grey[400], // Inactive thumb color
                ),
              ],
            ),
            const SizedBox(height: 25), // Spacer between the switch and the text field.
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      // "Pass Update Interval (min)" in German.
                      labelText: 'Pass Aktualisierungsintervall (min)', // Changed to hintText
                      hintStyle: TextStyle(color: Theme.of(context).hintColor),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                    ),
                    controller: intervalController, // Use the passed controller
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(onPressed: onPressed, icon: const Icon(Icons.save)),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}
