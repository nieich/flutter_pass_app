import 'package:flutter/material.dart';
import 'package:flutter_pass_app/navigation/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ScaffoldBasic extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final String? currentRoutePath;

  const ScaffoldBasic({required this.navigationShell, required this.currentRoutePath, Key? key})
    : super(key: key ?? const ValueKey<String>('ScaffoldBasic'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          DateFormat("HH:mm").format(DateTime.now()),
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
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
      body: navigationShell,
    );
  }
}
