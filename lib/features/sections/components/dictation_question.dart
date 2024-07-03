import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/sections/components/view_model/dictation_question_view.model.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/audio_control_button.dart';
import 'package:ez_english/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    viewmodel = Provider.of<DictationQuestionViewModel>(context, listen: false);
  }

  @override
  void dispose() {
    player.stop();
    player.dispose();
    super.dispose();
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Type the sentence you hear",
                  style: TextStyles.questionTextStyle.copyWith(height: 2),
                ),
              ],
            ),
            SizedBox(height: Constants.padding20),
            AudioControlButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });
                String audioUrl =
                    await viewmodel.getAudioBytes(widget.question);
                await player.setUrl(audioUrl);
                setState(() {
                  _isLoading = false;
                });
                await player.play();
              },
              type: AudioControlType.speaker,
              isLoading: _isLoading,
            ),
            SizedBox(height: Constants.padding20),
            Text(
              "Tap the speaker button and listen to the sentence.\nType the sentence out in the box below.",
              textAlign: TextAlign.center,
              style: TextStyles.questionTextStyle.copyWith(fontSize: 8.sp),
            ),
            SizedBox(height: Constants.padding20),
            CustomTextField(
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
