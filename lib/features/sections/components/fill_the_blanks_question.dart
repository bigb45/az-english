import 'package:ez_english/core/Constants.dart';
import 'package:ez_english/features/sections/components/evaluation_section.dart';
import 'package:ez_english/features/sections/models/fill_the_blanks_question_model.dart';
import 'package:ez_english/features/sections/models/string_answer.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/utils/utils.dart';
import 'package:ez_english/widgets/word_chip_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FillTheBlanksQuestion extends StatefulWidget {
  final Function(StringAnswer) onChanged;
  final FillTheBlanksQuestionModel question;
  final EvaluationState answerState;

  const FillTheBlanksQuestion({
    super.key,
    required this.answerState,
    required this.question,
    required this.onChanged,
  });

  @override
  State<FillTheBlanksQuestion> createState() => _FillTheBlanksQuestionState();
}

class _FillTheBlanksQuestionState extends State<FillTheBlanksQuestion> {
  late String incompleteSentence, firstPart, secondPart;
  @override
  void initState() {
    super.initState();
    String incompleteSentence =
        (widget.question.incompleteSentenceInEnglish ?? "")
            .replaceAll(RegExp(r'_+'), '_');
    List<String> parts = incompleteSentence.split("_");
    firstPart = parts[0];
    secondPart = parts[1];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Constants.padding12),
      child: Container(
        constraints: BoxConstraints(minHeight: 40.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.question.questionTextInEnglish ?? "",
                style: TextStyles.bodyLarge),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  widget.question.questionTextInArabic ?? "",
                  style: TextStyles.bodyLarge,
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
            Stack(
              children: [
                Positioned(
                  top: 40.h,
                  left: 0,
                  right: 0,
                  child: const Divider(
                    thickness: 2,
                    color: Palette.secondaryStroke,
                  ),
                ),
                Positioned(
                  top: 100.h,
                  left: 0,
                  right: 0,
                  child: const Divider(
                    thickness: 2,
                    color: Palette.secondaryStroke,
                  ),
                ),
                Positioned(
                  top: 160.h,
                  left: 0,
                  right: 0,
                  child: const Divider(
                    thickness: 2,
                    color: Palette.secondaryStroke,
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 200.h,
                      width: double.infinity,
                      child: Wrap(
                        runSpacing: 30.h,
                        children: [
                          Text(
                            firstPart,
                            style: TextStyles.bodyLarge,
                          ),
                          WordChipTextField(
                            onChanged: (value) {
                              widget.onChanged(StringAnswer(answer: value));
                            },
                          ),
                          Text(
                            secondPart,
                            style: TextStyles.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: 0,
                  top: 70.h,
                  child: RichText(
                    textDirection: TextDirection.rtl,
                    text: TextSpan(
                      children: stringToRichText(
                        widget.question.incompleteSentenceInArabic ?? "",
                      ),
                    ),
                    // style: TextStyles.bodyLarge,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
