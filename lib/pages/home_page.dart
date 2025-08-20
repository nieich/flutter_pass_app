import 'package:flutter/material.dart';
import 'package:flutter_pass_app/navigation/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Passes', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Theme.of(context).colorScheme.onPrimary),
            onPressed: () {
              context.push(Routes.pathSettings);
            },
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return Center(
      child: Text(
        DateFormat("HH:mm").format(DateTime.now()),
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      ),
    );
  }
}
