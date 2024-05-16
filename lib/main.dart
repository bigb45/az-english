// ignore_for_file: avoid_print, unused_import, prefer_const_constructors

import 'package:easy_localization/easy_localization.dart';
import 'package:ez_english/features/auth/screens/sign_in.dart';
import 'package:ez_english/features/auth/screens/sign_up.dart';
import 'package:ez_english/features/azure_tts_test.dart';
import 'package:ez_english/features/levels/screens/level_selection.dart';
import 'package:ez_english/features/sections/grammar/landing_page.dart';
import 'package:ez_english/features/sections/grammar/practice.dart';
import 'package:ez_english/features/sections/reading/landing_page.dart';
import 'package:ez_english/features/sections/reading/practice.dart';
import 'package:ez_english/features/sections/vocabulary/landing_page.dart';
import 'package:ez_english/features/sections/vocabulary/words_list.dart';
import 'package:ez_english/features/sections/vocabulary/word_view.dart';
import 'package:ez_english/features/sections/writing/landing_page.dart';
import 'package:ez_english/features/sections/writing/practice.dart';
import 'package:ez_english/firebase_options.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/router.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:ez_english/widgets/selectable_card.dart';
import 'package:ez_english/widgets/checkbox.dart';
import 'package:ez_english/widgets/exercise_card.dart';
import 'package:ez_english/widgets/menu.dart';
import 'package:ez_english/widgets/microphone_button.dart';
import 'package:ez_english/widgets/progress_bar.dart';
import 'package:ez_english/widgets/radio_button.dart';
import 'package:ez_english/widgets/result_card.dart';
import 'package:ez_english/widgets/text_field.dart';
import 'package:ez_english/features/sections/vocabulary/components/word_list_tile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
        Locale('tr'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // this value will be initially false, after the user creates an account
    // or logs in, it will be set to true and retreived from sharedPreferences
    bool isLoggedIn = true;
    context.setLocale(const Locale('en'));
    return
        // AppProviders(
        //   child:
        ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, child) => MaterialApp.router(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        title: 'EZ English',
        theme: Palette.lightModeAppTheme,
        routerConfig: loggedInRouter,
        // routes: {
        //   '/': (_) => LevelSelection(),
        //   '/settings': (_) => Scaffold(
        //         body: Center(
        //           child: Text('Settings'),
        //         ),
        //       ),

        //   '/level/:levelId': (info) {
        //     final levelId = info.['levelId'] ?? "-1";
        //     return PracticeScreen(levelId: levelId);
        //   },
        //   '/section/:sectionId': (info) {
        //     final sectionId = info.pathParameters['sectionId'] ?? "-1";
        //     return switch (sectionId) {
        //         "reading" => ReadingSection(),
        //         "grammar" => GrammarSection(),
        //         "listening" => WritingSection(),
        //         "vocabulary" => VocabularySection(),
        //         String() => const Placeholder(),
        //       };
        //   },
        //   '/practice/:sectionId': (info) {
        //     final sectionId = info.pathParameters['sectionId'] ?? "-1";
        //     return switch (sectionId) {
        //         "reading" => ReadingPractice(),
        //         "grammar" => GrammarPractice(),
        //         "listening" => WritingPractice(),
        //         "vocabulary" => WordListView(
        //             words: const [
        //               WordModel(
        //                   word: "word", type: WordType.noun, isNew: true),
        //               WordModel(
        //                   word: "word", type: WordType.noun, isNew: true),
        //               WordModel(
        //                   word: "word", type: WordType.noun, isNew: true),
        //               WordModel(
        //                   word: "word", type: WordType.noun, isNew: true),
        //             ],
        //           ),
        //         String() => const Placeholder(),
        //       };
        //   },
        //   '/components': (_) => const Components(),
        // }

        // routerDelegate: RoutemasterDelegate(routesBuilder: (_) {
        //   // ignore: dead_code
        //   return isLoggedIn ? loggedInRoute : loggedOutRoute;
        // }),
        // routeInformationParser: const RoutemasterParser(),

        // home: const WordListView(
        //     pageTitle: "Vocabulary",
        //     pageSubtitle: "Daily Conversations",
        //     words: [
        //       WordModel(
        //         word: "View",
        //         type: WordType.noun,
        //         isNew: false,
        //       ),
        //       WordModel(
        //         word: "Combine",
        //         type: WordType.verb,
        //         isNew: true,
        //       ),
        //     ]),

        // home: Router(routerDelegate: R),

        // home: const GrammarPractice(
        //   fullSentence: "The dog jumps over the fence",
        //   options:
        //       "the dog jumps over fence the under jumped jumping above below",
        // ),
      ),
      // ),
    );
  }
}
