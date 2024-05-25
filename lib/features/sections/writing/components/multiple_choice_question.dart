import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/sections/writing/practice.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/radio_button.dart';
import 'package:flutter/material.dart';

class MultipleChoiceQuestion extends StatefulWidget {
  final MultipleChoiceQuestionModel question;
  final List<RadioItemData> options;
  final String? image;
  final Function(RadioItemData) onChanged;
  const MultipleChoiceQuestion(
      {super.key,
      required this.question,
      required this.options,
      required this.onChanged,
      this.image});

  @override
  State<MultipleChoiceQuestion> createState() => _MultipleChoiceQuestionState();
}

class _MultipleChoiceQuestionState extends State<MultipleChoiceQuestion> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (widget.image == null)
              const SizedBox() // placeholder
            else
              Image.asset(widget.image!),
            SizedBox(height: Constants.padding20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.question.questionText,
                    style: TextStyles.practiceCardSecondaryText
                        .copyWith(height: 2),
                    maxLines: 5,
                  ),
                ),
              ],
            ),
            RadioGroup(
              onChanged: (newValue) {
                widget.onChanged(newValue);
                print("new value: ${newValue.title}");
              },
              options: widget.options,
              // TODO: fix selection removal on setState issue
              selectedOption: null,
            ),
            SizedBox(height: Constants.padding20),
          ],
        ),
      ],
    );
  }
}
