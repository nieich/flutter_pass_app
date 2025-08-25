import 'package:flutter/material.dart';
import 'package:flutter_pass_app/navigation/routes.dart';
import 'package:flutter_pass_app/pages/home_page.dart';
import 'package:flutter_pass_app/pages/pass_page.dart';
import 'package:flutter_pass_app/pages/settings/settings_dev_page.dart';
import 'package:flutter_pass_app/pages/settings/settings_general_page.dart';
import 'package:flutter_pass_app/pages/settings/settings_page.dart';
import 'package:flutter_pass_app/pages/settings/settings_theme_page.dart';

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
      routes: [
        GoRoute(
          path: Routes.settingsGeneral,
          builder: (context, state) {
            return const SettingsGeneralPage();
          },
        ),
        GoRoute(
          path: Routes.settingsTheme,
          builder: (context, state) {
            return const SettingsThemePage();
          },
        ),
        GoRoute(
          path: Routes.settingsDev,
          builder: (context, state) {
            return const SettingsDevPage();
          },
        ),
      ],
    ),
  ],
);
