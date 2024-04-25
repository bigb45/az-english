import 'package:ez_english/core/constants.dart';
import 'package:ez_english/widgets/microphone_button.dart';
import 'package:ez_english/widgets/progress_bar.dart';
import 'package:ez_english/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class DictationQuestion extends StatefulWidget {
  final TextEditingController controller;
  final String text;
  final FlutterTts flutterTts;

  const DictationQuestion(
      {super.key,
      required this.controller,
      required this.text,
      required this.flutterTts});

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
                widget.flutterTts.speak(widget.text);
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
