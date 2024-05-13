// ignore_for_file: avoid_print, unused_import

import 'package:easy_localization/easy_localization.dart';
import 'package:ez_english/features/auth/screens/sign_in.dart';
import 'package:ez_english/features/auth/screens/sign_up.dart';
import 'package:ez_english/features/azure_tts_test.dart';
import 'package:ez_english/features/sections/grammar/landing_page.dart';
import 'package:ez_english/features/sections/grammar/practice.dart';
import 'package:ez_english/features/sections/reading/practice.dart';
import 'package:ez_english/features/sections/vocabulary/word_list.dart';
import 'package:ez_english/features/sections/vocabulary/word_view.dart';
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
import 'package:routemaster/routemaster.dart';

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

        routerDelegate: RoutemasterDelegate(routesBuilder: (_) {
          // ignore: dead_code
          return isLoggedIn ? loggedInRoute : loggedOutRoute;
        }),
        routeInformationParser: const RoutemasterParser(),
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

class Components extends StatelessWidget {
  const Components({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Flex(direction: Axis.vertical, children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Button(
                      onPressed: () {
                        Routemaster.of(context).push('/settings');
                      },
                      type: ButtonType.primary,
                      child: Text(
                        AppStrings.continueButton,
                        style: TextStyle(
                          color: Palette.secondary,
                          fontFamily: 'Inter',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    CustomTextField(
                      controller: TextEditingController(),
                    ),
                    SizedBox(height: 20.h),
                    SelectableCard(
                      selected: false,
                      onPressed: () {},
                      child: Text(
                        "Long Vocabulary Card",
                        style: TextStyle(
                          color: Palette.primaryText,
                          fontFamily: 'Inter',
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    // WordChip(
                    //   onPressed: () {},
                    //   text: "word",
                    // ),
                    SizedBox(height: 20.h),
                    const ResultCard(
                      topText: "BAD",
                      score: Score.bad,
                      mainText: "2/10 ANSWERED CORRECTLY",
                    ),
                    SizedBox(height: 20.h),
                    AudioControlButton(
                      onPressed: () {},
                      type: AudioControlType.speaker,
                    ),
                    SizedBox(height: 20.h),
                    Menu(
                      onItemSelected: (index) {
                        print(index);
                      },
                      items: const [
                        MenuItemData(
                          mainText: "Item 1",
                          description: "Item 1 description",
                        ),
                        MenuItemData(
                          mainText: "Item 2",
                          description: "Item 2 description",
                        ),
                        MenuItemData(
                          mainText: "Item 3",
                          description: "Item 3 description",
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    ExerciseCard(
                      attempted: false,
                      onPressed: () {},
                      image: null,
                      cardBackgroundColor: const Color(0xFF34495E),
                      child: Text(
                        "Exercise Card",
                        style: TextStyle(
                            color: Palette.secondary,
                            fontFamily: 'Inter',
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    RadioGroup(
                      onChanged: (value) {
                        print(value.title);
                      },
                      options: [
                        RadioItemData(
                          value: "1",
                          title: "A Bag",
                        ),
                        RadioItemData(
                          value: "2",
                          title: "A Backpack",
                        ),
                        RadioItemData(
                          value: "3",
                          title: "A Suitcase",
                        ),
                        RadioItemData(
                          value: "4",
                          title: "A Duffle Bag",
                        )
                      ],
                      selectedOption: null,
                    ),
                    SizedBox(height: 20.h),
                    CheckboxGroup(
                        onChanged: (selections) {
                          List<bool?> options =
                              selections.map((e) => e.value).toList();
                          print("new selections: $options");
                        },
                        options: [
                          CheckboxData(
                            title: "Option 1",
                          ),
                          CheckboxData(
                            title: "Option 2",
                          ),
                          CheckboxData(
                            title: "Option 3",
                          ),
                          CheckboxData(
                            title: "Option 4",
                          ),
                        ]),
                    SizedBox(height: 20.h),
                    const ProgressBar(
                      value: 20,
                    ),
                    SizedBox(height: 20.h),
                    WordListTile(
                        word: "View",
                        type: WordType.noun,
                        isNew: false,
                        onTap: () {
                          print("navigate to word details");
                        }),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
