// ignore_for_file: prefer_const_constructors

import 'package:ez_english/components.dart';
import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/auth/screens/sign_in.dart';
import 'package:ez_english/features/auth/screens/sign_up.dart';
import 'package:ez_english/features/sections/grammar/landing_page.dart';
import 'package:ez_english/features/sections/grammar/practice.dart';
import 'package:ez_english/features/sections/practice_screen.dart';
import 'package:ez_english/features/sections/reading/landing_page.dart';
import 'package:ez_english/features/sections/reading/practice.dart';
import 'package:ez_english/features/sections/vocabulary/landing_page.dart';
import 'package:ez_english/features/sections/vocabulary/words_list.dart';
import 'package:ez_english/features/sections/writing/landing_page.dart';
import 'package:ez_english/features/sections/writing/practice.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/main_app.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final loggedOutRotuer = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/sign_in',
  routes: [
    GoRoute(
      path: '/sign_in',
      builder: (context, state) => SignInScreen(),
    ),
    GoRoute(
      path: '/sign_up',
      builder: (context, state) => SignUpScreen(),
    ),
  ],
);

final loggedInRouter = GoRouter(
  navigatorKey: navigatorKey,
  routes: [
    GoRoute(
      path: '/',
      builder: ((context, state) => MainApp()),
    ),
    GoRoute(
      path: '/level/:levelId',
      builder: ((context, state) {
        final levelId = state.pathParameters['levelId'] ?? "-1";
        return PracticeScreen(
          levelId: levelId,
          levelName: RouteConstants.getLevelName(levelId),
        );
      }),
    ),
    GoRoute(
      path: '/landing_page/:levelId/:sectionId',
      builder: ((context, state) {
        final levelId = state.pathParameters['levelId'] ?? "-1";
        final sectionId = state.pathParameters['sectionId'] ?? "-1";
        return switch (sectionId) {
          // TODO: find a better solution than this
          "0" => ReadingSection(
              levelId: levelId,
            ),
          "1" => WritingSection(
              levelId: levelId,
            ),
          "2" => VocabularySection(),
          "3" => GrammarSection(),
          String() => const Placeholder(),
        };
      }),
    ),
    GoRoute(
      path: '/components',
      builder: ((context, state) => Components()),
    ),
    GoRoute(
      path: '/practice/:sectionId',
      builder: ((context, state) {
        return switch (state.pathParameters['sectionId']) {
          "reading" => ReadingPractice(),
          "grammar" => GrammarPractice(),
          "listening" => WritingPractice(),
          "vocabulary" => WordsListView(),
          String() || null => const Placeholder(),
        };
      }),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => Scaffold(
        body: Center(
          child: Text('Settings'),
        ),
      ),
    ),
  ],
);
