import 'package:ez_english/core/constants.dart';
import 'package:ez_english/utils/utils.dart';
import 'package:ez_english/widgets/audio_control_button.dart';
import 'package:ez_english/widgets/text_field.dart';
import 'package:flutter/material.dart';

import '../models/dictation_question_model.dart';

class DictationQuestion extends StatefulWidget {
  final TextEditingController controller = TextEditingController();
  final Function(String) onAnswerChanged;
  final DictationQuestionModel question;
  DictationQuestion({
    super.key,
    required this.onAnswerChanged,
    required this.question,
  });

  @override
  State<DictationQuestion> createState() => _DictationQuestionState();
}

class _DictationQuestionState extends State<DictationQuestion> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(height: Constants.padding20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Type the sentence you hear"),
              ],
            ),
            SizedBox(height: Constants.padding20),
            AudioControlButton(
              onPressed: () {
                Utils.speakText(widget.question.answer?.answer ?? "");
              },
              type: AudioControlType.speaker,
            ),
            SizedBox(height: Constants.padding20),
            const Text(
              "Tap the speaker button and listen to the sentence.\nType the sentence out in the box below.",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Constants.padding20),
            CustomTextField(
              // TODO: test onChanged function
              onChanged: widget.onAnswerChanged,
              controller: widget.controller,
              maxLines: 10,
              hintText: "Type your answer here",
            ),
          ],
        ),
      ],
    );
  }
}
