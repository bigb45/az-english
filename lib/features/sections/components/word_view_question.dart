import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/sections/models/word_definition.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/utils/utils.dart';
import 'package:ez_english/widgets/audio_control_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';

class WordViewQuestion extends StatefulWidget {
  final WordDefinition wordData;

  WordViewQuestion({
    super.key,
    required this.wordData,
  });

  @override
  State<WordViewQuestion> createState() => _WordViewQuestionState();
}

class _WordViewQuestionState extends State<WordViewQuestion> {
  final AudioPlayer player = AudioPlayer();
  @override
  void dispose() {
    player.stop(); // Stop the player if it's currently playing
    player.dispose(); // Dispose of the player
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Constants.padding12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: Constants.padding30),
            child: Text("${widget.wordData.questionTextInEnglish}",
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
                          widget.wordData.englishWord,
                          style: TextStyles.vocabularyTerm.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        widget.wordData.arabicWord != null
                            ? Text(
                                widget.wordData.arabicWord!,
                                style: TextStyles.vocabularyTerm.copyWith(
                                  color: Colors.white,
                                ),
                              )
                            : const SizedBox(),
                        Text(
                          widget.wordData.type.toShortString(),
                          style: TextStyles.wordType.copyWith(
                            fontSize: 20.sp,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          widget.wordData.definition ?? "",
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
                                  Utils.speakText(
                                      widget.wordData.englishWord, player);
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
          widget.wordData.exampleUsageInEnglish == null ||
                  widget.wordData.exampleUsageInEnglish!.isEmpty
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
                          widget.wordData.exampleUsageInEnglish?.length ?? 0,
                          (index) {
                            bool printArabicExample =
                                widget.wordData.exampleUsageInArabic != null &&
                                    widget.wordData.exampleUsageInArabic!
                                        .isNotEmpty;
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.h),
                              child: Text(
                                "\"${widget.wordData.exampleUsageInEnglish![index]}\""
                                "${printArabicExample ? "\n\"${widget.wordData.exampleUsageInArabic![index]}\"" : ""}",
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
          widget.wordData.tenses == null || widget.wordData.tenses!.isEmpty
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
                      widget.wordData.tenses ?? "",
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
