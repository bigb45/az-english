// ignore_for_file: prefer_const_constructors

import 'package:ez_english/components.dart';
import 'package:ez_english/features/auth/screens/sign_in.dart';
import 'package:ez_english/features/levels/screens/level_selection.dart';
import 'package:ez_english/features/sections/grammar/landing_page.dart';
import 'package:ez_english/features/sections/grammar/practice.dart';
import 'package:ez_english/features/sections/practice_screen.dart';
import 'package:ez_english/features/sections/reading/landing_page.dart';
import 'package:ez_english/features/sections/reading/practice.dart';
import 'package:ez_english/features/sections/vocabulary/components/word_list_tile.dart';
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
  ],
);

final loggedInRouter = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: ((context, state) => MainApp()),
  ),
  GoRoute(
    path: '/level/:levelId',
    builder: ((context, state) {
      return PracticeScreen(levelId: state.pathParameters['levelId'] ?? "-1");
    }),
  ),
  GoRoute(
    path: '/section/:sectionId',
    builder: ((context, state) {
      return switch (state.pathParameters['sectionId']) {
        "reading" => ReadingSection(),
        "grammar" => GrammarSection(),
        "listening" => WritingSection(),
        "vocabulary" => VocabularySection(),
        String() || null => const Placeholder(),
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
        "vocabulary" => WordsListView(
            words: const [
              WordModel(word: "word", type: WordType.noun, isNew: true),
              WordModel(word: "word", type: WordType.noun, isNew: true),
              WordModel(word: "word", type: WordType.noun, isNew: true),
              WordModel(word: "word", type: WordType.noun, isNew: true),
            ],
          ),
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
]);
