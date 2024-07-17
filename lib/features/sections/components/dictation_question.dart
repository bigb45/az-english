import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/sections/components/view_model/dictation_question_view.model.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/audio_control_button.dart';
import 'package:ez_english/widgets/text_field.dart';
import 'package:flutter/material.dart';
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
  late DictationQuestionViewModel viewmodel;
  bool _isLoading = false;
  bool _isPlaying = false;
  bool _isPaused = false;
  @override
  void initState() {
    super.initState();
    viewmodel = Provider.of<DictationQuestionViewModel>(context, listen: false);
    player.playerStateStream.listen((playerState) {
      setState(() {
        _isPlaying = playerState.playing;
        if (playerState.processingState == ProcessingState.completed) {
          _isPlaying = false;
          _isPaused = false;
        }
      });
    });
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
                  widget.question.questionTextInEnglish ??
                      "Type the sentence you hear",
                  style: TextStyles.questionTextStyle.copyWith(height: 2),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  textDirection: TextDirection.rtl,
                  widget.question.questionTextInArabic ?? "",
                  style: TextStyles.questionTextStyle.copyWith(height: 2),
                ),
              ],
            ),
            SizedBox(height: Constants.padding20),
            AudioControlButton(
              onPressed: () async {
                if (_isPlaying) {
                  await player.pause();
                  setState(() {
                    _isPaused = true;
                  });
                } else if (_isPaused) {
                  await player.play();
                  setState(() {
                    _isPaused = false;
                  });
                } else {
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
                }
              },
              type: _isPlaying
                  ? AudioControlType.pause
                  : _isPaused
                      ? AudioControlType.play
                      : AudioControlType.speaker,
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
