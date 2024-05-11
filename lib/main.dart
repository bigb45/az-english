import 'package:easy_localization/easy_localization.dart';
import 'package:ez_english/features/sections/grammar/landing_page.dart';
import 'package:ez_english/features/sections/grammar/practice.dart';
import 'package:ez_english/features/sections/reading/practice.dart';
import 'package:ez_english/features/sections/writing/practice.dart';
import 'package:ez_english/firebase_options.dart';
import 'package:ez_english/resources/app_strings.dart';
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
import 'package:ez_english/widgets/word_chip.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

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
    context.setLocale(const Locale('en'));
    return
        // AppProviders(
        //   child:
        ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, child) => MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,

        title: 'EZ English',
        theme: Palette.lightModeAppTheme,
        home: const WritingPractice(),
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
                      onPressed: () {},
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
