import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/sections/models/word_definition.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/utils/utils.dart';
import 'package:ez_english/widgets/audio_control_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WordViewQuestion extends StatelessWidget {
  final WordDefinition wordData;
  const WordViewQuestion({
    super.key,
    required this.wordData,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Constants.padding12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: Constants.padding30),
            child: Text("${wordData.questionTextInEnglish}",
                style: TextStyles.practiceCardSecondaryText.copyWith(
                  color: Palette.primaryText,
                  fontSize: 24.sp,
                )),
          ),
          Card(
            color: Palette.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Palette.secondaryStroke, width: 1),
            ),
            elevation: 0,
            child: Padding(
              padding: EdgeInsets.all(Constants.padding12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          wordData.englishWord,
                          style: TextStyles.vocabularyTerm.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        wordData.arabicWord != null
                            ? Text(
                                wordData.arabicWord!,
                                style: TextStyles.vocabularyTerm.copyWith(
                                  color: Colors.white,
                                ),
                              )
                            : const SizedBox(),
                        Text(
                          wordData.type.toShortString(),
                          style: TextStyles.wordType.copyWith(
                            fontSize: 20.sp,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          wordData.definition ?? "",
                          style: TextStyles.practiceCardSecondaryText.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AudioControlButton(
                                size: 50.w,
                                onPressed: () {
                                  Utils.speakText(wordData.englishWord);
                                },
                                type: AudioControlType.speaker),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 30.h),
          wordData.exampleUsageInEnglish == null ||
                  wordData.exampleUsageInEnglish!.isEmpty
              ? const SizedBox()
              : Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(
                        color: Palette.secondaryStroke, width: 1),
                  ),
                  elevation: 0,
                  child: Padding(
                    padding: EdgeInsets.all(Constants.padding12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Examples",
                          style: TextStyles.practiceCardSecondaryText.copyWith(
                            color: Palette.primaryText,
                            fontSize: 18.sp,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        ...List.generate(
                          wordData.exampleUsageInEnglish?.length ?? 0,
                          (index) {
                            bool printArabicExample =
                                wordData.exampleUsageInArabic != null &&
                                    wordData.exampleUsageInArabic!.isNotEmpty;
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.h),
                              child: Text(
                                "\"${wordData.exampleUsageInEnglish![index]}\""
                                "${printArabicExample ? "\n\"${wordData.exampleUsageInArabic![index]}\"" : ""}",
                                textAlign: TextAlign.left,
                                style: TextStyles.vocabularyExample.copyWith(
                                  color: Palette.primaryText,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
          SizedBox(height: 30.h),
          wordData.tenses == null || wordData.tenses!.isEmpty
              ? const SizedBox()
              : Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(
                        color: Palette.secondaryStroke, width: 1),
                  ),
                  elevation: 0,
                  child: Padding(
                    padding: EdgeInsets.all(Constants.padding12),
                    child: Text(
                      wordData.tenses ?? "",
                      style: TextStyles.practiceCardSecondaryText.copyWith(
                        color: Palette.primaryText,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
