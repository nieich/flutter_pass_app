import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return Center(
      child: Text('Settings', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
    );
  }
}
