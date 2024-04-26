import 'package:ez_english/core/constants.dart';
import 'package:ez_english/widgets/radio_button.dart';
import 'package:flutter/material.dart';

class MultipleChoiceQuestion extends StatefulWidget {
  final String question;
  final List<RadioItemData> options;
  final Function(RadioItemData) onChanged;
  const MultipleChoiceQuestion(
      {super.key,
      required this.question,
      required this.options,
      required this.onChanged});

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
            SizedBox(height: Constants.padding20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(widget.question),
              ],
            ),
            RadioGroup(
                onChanged: (newValue) {
                  print("new value: ${newValue.title}");
                },
                options: widget.options),
            SizedBox(height: Constants.padding20),
          ],
        ),
      ],
    );
  }
}
