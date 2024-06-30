import 'package:ez_english/features/models/exam_result.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/widgets/audio_control_button.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:ez_english/widgets/checkbox.dart';
import 'package:ez_english/widgets/menu.dart';
import 'package:ez_english/widgets/progress_bar.dart';
import 'package:ez_english/widgets/radio_button.dart';
import 'package:ez_english/widgets/result_card.dart';
import 'package:ez_english/widgets/selectable_card.dart';
import 'package:ez_english/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

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
                        context.push('/settings');
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
                    ResultCard(
                      result: ExamResult(
                        examId: "1",
                        examName: "",
                        examDate: "14/2/2024",
                        examScore: "80%",
                        examStatus: ExamStatus.passed,
                      ),
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
                    // ExerciseCard(
                    //   attempted: false,
                    //   onPressed: () {},
                    //   image: null,
                    //   cardBackgroundColor: const Color(0xFF34495E),
                    //   text: "Exercise Card",
                    // ),
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
                    // WordListTile(
                    //     word: "View",
                    //     type: WordType.word,
                    //     isNew: false,
                    //     onTap: () {
                    //       print("navigate to word details");
                    //     }),
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
