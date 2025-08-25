import 'package:flutter/material.dart';
import 'package:flutter_pass_app/l10n/app_localizations.dart';
import 'package:flutter_pass_app/navigation/routes.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSettingTile(context, 'General', 'General Settings', Icons.settings_applications_sharp, () {
            context.push(Routes.pathSettingsGeneral);
          }),
          _buildSettingTile(context, 'Theme', 'Set the Theme and colors', Icons.color_lens, () {
            context.push(Routes.pathSettingsTheme);
          }),
          _buildSettingTile(context, 'Dev', 'Developer Settings', Icons.developer_mode, () {
            context.push(Routes.pathSettingsDev);
          }),
        ],
      ),
    );
  }

  Card _buildSettingTile(BuildContext context, String title, String subtitle, IconData leadingIcon, Function() onTap) {
    return Card(
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
            fontWeight: Theme.of(context).textTheme.titleLarge?.fontWeight,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
        subtitle: Text(subtitle, style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        tileColor: Theme.of(context).colorScheme.secondary,
        leading: Icon(leadingIcon, color: Theme.of(context).colorScheme.onSecondary),
        onTap: onTap,
      ),
    );
  }
}
