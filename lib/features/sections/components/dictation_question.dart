import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/sections/components/view_model/dictation_question_view.model.dart';
import 'package:ez_english/widgets/audio_control_button.dart';
import 'package:ez_english/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

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
  final String apiKey = dotenv.env['AZURE_API_KEY_1'] ?? '';
  late DictationQuestionViewModel viewmodel;
  void initState() {
    super.initState();
    viewmodel = Provider.of<DictationQuestionViewModel>(context, listen: false);
  }

  final AudioPlayer player = AudioPlayer();
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
              onPressed: () async {
                // Utils.speakText(widget.question.answer?.answer ?? "");
                String audioUrl =
                    await viewmodel.getAudioBytes(widget.question);
                await player.setUrl(audioUrl);
                player.play();
                viewmodel.setLoading(false);
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
