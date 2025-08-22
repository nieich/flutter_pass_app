import 'package:flutter/material.dart';
import 'package:flutter_pass_app/navigation/routes.dart';
import 'package:flutter_pass_app/pages/home_page.dart';
import 'package:flutter_pass_app/pages/pass_page.dart';
import 'package:flutter_pass_app/pages/settings_page.dart';

import 'package:go_router/go_router.dart';

final _rootNavigationKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final router = GoRouter(
  navigatorKey: _rootNavigationKey,
  initialLocation: Routes.pathHome,
  routes: [
    GoRoute(
      path: Routes.pathHome,
      builder: (context, state) {
        return const HomePage();
      },
      routes: [
        GoRoute(
          path: '${Routes.pass}/:serialNumber',
          builder: (context, state) {
            final serialNumber = state.pathParameters['serialNumber'];
            return PassPage(serialNumber: serialNumber);
          },
        ),
      ],
    ),
    GoRoute(
      path: Routes.pathSettings,
      builder: (context, state) {
        return const SettingsPage();
      },
    ),
  ],
);
