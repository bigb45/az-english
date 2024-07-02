// ignore_for_file: prefer_const_constructors

import 'package:ez_english/components.dart';
import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/auth/screens/sign_in.dart';
import 'package:ez_english/features/auth/screens/sign_up.dart';
import 'package:ez_english/features/home/test_overview.dart';
import 'package:ez_english/features/models/test_result.dart';
import 'package:ez_english/features/sections/components/youtube_lesson.dart';
import 'package:ez_english/features/sections/exam/test.dart';
import 'package:ez_english/features/sections/grammar/landing_page.dart';
import 'package:ez_english/features/sections/grammar/practice.dart';
import 'package:ez_english/features/sections/reading/landing_page.dart';
import 'package:ez_english/features/sections/reading/practice.dart';
import 'package:ez_english/features/sections/sections_screen.dart';
import 'package:ez_english/features/sections/vocabulary/landing_page.dart';
import 'package:ez_english/features/sections/vocabulary/words_list.dart';
import 'package:ez_english/features/sections/writing/landing_page.dart';
import 'package:ez_english/features/sections/writing/practice.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/home/home_screen.dart';

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
      builder: ((context, state) => HomeScreen()),
    ),
    GoRoute(
      path: '/level/:levelId',
      builder: ((context, state) {
        final levelId = state.pathParameters['levelId'] ?? "-1";
        return PracticeSections(
          levelId: levelId,
          levelName: RouteConstants.getLevelName(levelId),
        );
      }),
    ),
    GoRoute(
        path: '/youtube',
        builder: (context, state) => Scaffold(
                body: Column(
              children: const [
                Text("widgets"),
                YouTubeVideoPlayer(
                  videoId: "DoKYYLZVU98",
                ),
                Text("other widgets")
              ],
            ))),
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
          "2" => VocabularySection(
              levelId: levelId,
            ),
          "3" => GrammarSection(
              levelId: levelId,
            ),
          "4" => TestSection(levelId: levelId),
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
      path: '/result_overview/:examId',
      builder: ((context, state) {
        String examId = state.pathParameters['examId'] ?? "-1";
        return TestOverview(
          result: TestResult(
            examId: examId,
            examName: "First exam",
            examDate: "24/3/2023",
            examScore: "10",
            examStatus: ExamStatus.failed,
          ),
        );
      }),
    ),
  ],
);
