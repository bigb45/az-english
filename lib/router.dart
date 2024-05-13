import 'package:ez_english/features/levels/screens/level_selection.dart';
import 'package:ez_english/features/sections/practice_screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import 'package:ez_english/main.dart';

final loggedOutRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: Components()),
  },
);

final loggedInRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: LevelSelection()),
    '/settings': (_) => const MaterialPage(
          child: Scaffold(
            body: Center(
              child: Text('Settings'),
            ),
          ),
        ),
    '/level/:levelId': (info) {
      final levelId = info.pathParameters['levelId'];
      return const MaterialPage(
        child: PracticeScreen(),
      );
    },
    '/components': (_) => const MaterialPage(child: Components()),
  },
);
