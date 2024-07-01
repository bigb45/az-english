// ignore_for_file: prefer_const_constructors

import 'package:ez_english/components.dart';
import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/auth/screens/sign_in.dart';
import 'package:ez_english/features/auth/screens/sign_up.dart';
import 'package:ez_english/features/home/exam_overview.dart';
import 'package:ez_english/features/models/exam_result.dart';
import 'package:ez_english/features/sections/components/evaluation_section.dart';
import 'package:ez_english/features/sections/components/youtube_lesson.dart';
import 'package:ez_english/features/sections/exam/exam.dart';
import 'package:ez_english/features/sections/grammar/landing_page.dart';
import 'package:ez_english/features/sections/grammar/practice.dart';
import 'package:ez_english/features/sections/models/fill_the_blanks_question_model.dart';
import 'package:ez_english/features/sections/models/string_answer.dart';
import 'package:ez_english/features/sections/reading/landing_page.dart';
import 'package:ez_english/features/sections/reading/practice.dart';
import 'package:ez_english/features/sections/sections_screen.dart';
import 'package:ez_english/features/sections/util/build_question.dart';
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
          "4" => ExamSection(levelId: levelId),
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
        return ExamOverview(
          result: ExamResult(
            examId: examId,
            examName: "First exam",
            examDate: "24/3/2023",
            examScore: "10",
            examStatus: ExamStatus.failed,
          ),
        );
      }),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => Scaffold(
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 300,
              ),
              buildQuestion(
                question: FillTheBlanksQuestionModel(
                    answer: StringAnswer(answer: "good"),
                    questionTextInEnglish: "Complete the following sentence",
                    incompleteSentenceInEnglish: "Ahmad is a ______ boy",
                    incompleteSentenceInArabic: "أحمد ولد ______",
                    questionTextInArabic: null,
                    imageUrl: "imageUrl",
                    voiceUrl: "voiceUrl"),
                onChanged: (value) {
                  print(value.answer);
                },
                answerState: EvaluationState.correct,
              ),
              // GenericMultipleChoiceQuestion(
              //   onChanged: (value) =>
              //       {print("new value: ${value.answer?.title}")},
              //   question: MultipleChoiceQuestionModel(
              //       paragraph: "This is a paragraph",
              //       options: [
              //         RadioItemData(
              //           title: "option1",
              //           value: "option1",
              //         ),
              //         RadioItemData(
              //           title: "option2",
              //           value: "option2",
              //         ),
              //         RadioItemData(
              //           title: "option3",
              //           value: "option3",
              //         ),
              //       ],
              //       answer: MultipleChoiceAnswer(
              //           answer: RadioItemData(title: "test", value: "test")),
              //       questionTextInArabic: "Select the correct answer",
              //       questionTextInEnglish: "Select the correct answer",
              //       imageUrl: ""),
              // ),
              // CheckboxQuestion(
              //   question: CheckboxQuestionModel(
              //     onChanged: (value) =>
              //         // ignore: avoid_print
              //         {print("new value: ${value.map((e) => e.title)}")},
              //     answer: CheckboxAnswer(
              //       answer: [
              //         CheckboxData(
              //           title: "Option 1",
              //         ),
              //       ],
              //     ),
              //     questionText: "Select the correct sentences",
              //     paragraph: "This is a paragraph",
              //     options: [
              //       CheckboxData(
              //         title: "Option 1",
              //       ),
              //       CheckboxData(
              //         title: "Option 2",
              //       ),
              //       CheckboxData(
              //         title: "Option 3",
              //       ),
              //       CheckboxData(
              //         title: "Option 4",
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    ),
  ],
);
