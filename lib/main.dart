// ignore_for_file: prefer_const_constructors

import 'package:ez_english/features/levels/screens/level_selection.dart';
import 'package:ez_english/firebase_options.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:ez_english/widgets/card.dart';
import 'package:ez_english/widgets/checkbox.dart';
import 'package:ez_english/widgets/exercise_card.dart';
import 'package:ez_english/widgets/menu.dart';
import 'package:ez_english/widgets/microphone_button.dart';
import 'package:ez_english/widgets/radio_button.dart';
import 'package:ez_english/widgets/result_card.dart';
import 'package:ez_english/widgets/text_field.dart';
import 'package:ez_english/widgets/word_chip.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return
        // AppProviders(
        //   child:
        ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, child) => MaterialApp(
        title: 'EZ English',
        theme: ThemeData(
          primaryColor: Palette.primary,
          scaffoldBackgroundColor: Palette.secondary,
        ),
        home: const Components(),
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
                        "CONTINUE",
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
                      onPressed: null,
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
                    WordChip(
                      onPressed: () {},
                      child: Text(
                        "word",
                        style: TextStyle(
                          color: Palette.primaryText,
                          fontFamily: 'Inter',
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    ResultCard(
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
                      attempted: true,
                      onPressed: () {},
                      image: null,
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
                      defaultOption: RadioItemData(
                        value: "",
                        title: "",
                      ),
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
