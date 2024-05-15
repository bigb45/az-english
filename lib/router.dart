// ignore_for_file: prefer_const_constructors

import 'package:ez_english/features/auth/screens/practice_frequency.dart';
import 'package:ez_english/features/auth/screens/sign_in.dart';
import 'package:ez_english/features/auth/screens/sign_up.dart';
import 'package:ez_english/features/azure_tts_test.dart';
import 'package:ez_english/features/levels/screens/level_selection.dart';
import 'package:ez_english/features/sections/grammar/landing_page.dart';
import 'package:ez_english/features/sections/practice_screen.dart';
import 'package:ez_english/features/sections/reading/landing_page.dart';
import 'package:ez_english/features/sections/vocabulary/landing_page.dart';
import 'package:ez_english/features/sections/writing/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:ez_english/features/azure_tts_test.dart';
import 'package:ez_english/main.dart';

final loggedOutRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: Components()),
  },
);

final loggedInRoute = RouteMap(
  routes: {
    '/': (_) => MaterialPage(child: PracticeFrequencyScreen()),
    '/settings': (_) => const MaterialPage(
          child: Scaffold(
            body: Center(
              child: Text('Settings'),
            ),
          ),
        ),
    '/level/:levelId': (info) {
      final levelId = info.pathParameters['levelId'] ?? "-1";
      return MaterialPage(
        child: PracticeScreen(levelId: levelId),
      );
    },
    '/section/:sectionId': (info) {
      final sectionId = info.pathParameters['sectionId'] ?? "-1";
      return MaterialPage(
        child: switch (sectionId) {
          "reading" => ReadingSection(),
          "grammar" => GrammarSection(),
          "listening" => WritingSection(),
          "vocabulary" => VocabularySection(),
          String() => const Placeholder(),
        },
      );
    },
    '/components': (_) => const MaterialPage(child: Components()),
  },
);
