// ignore_for_file: avoid_print

import 'package:ez_english/features/sections/components/evaluation_section.dart';
import 'package:ez_english/features/sections/components/leave_alert_dialog.dart';
import 'package:ez_english/features/sections/writing/components/dictation_question.dart';
import 'package:ez_english/features/sections/writing/dication_question_model.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/progress_bar.dart';
import 'package:ez_english/widgets/radio_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:flutter_tts/flutter_tts.dart';

class WritingPractice extends StatefulWidget {
  const WritingPractice({super.key});

  @override
  State<WritingPractice> createState() => _WritingPracticeState();
}

class _WritingPracticeState extends State<WritingPractice> {
  late FlutterTts flutterTts;
  bool isSpeaking = false;
  final DictationQuestionModel question = DictationQuestionModel(
    question: "Write the following sentence",
    answer: "The quick brown fox jumps over the lazy dog.",
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    });
  }

  final TextEditingController _controller = TextEditingController();
  String text = "The quick brown fox jumps over the lazy dog.";

  RadioItemData? selectedOption;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (canPop) {
        showLeaveAlertDialog(context);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.close,
                color: Palette.primaryText,
              ),
              onPressed: () {
                showLeaveAlertDialog(context);
              },
            ),
          ],
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.white,
          title: ListTile(
            contentPadding: const EdgeInsets.only(left: 0, right: 0),
            title: Text(
              'Writing & Listening Practice',
              style: TextStyles.titleTextStyle.copyWith(
                color: Palette.primaryText,
              ),
            ),
            subtitle: Text(
              "Daily Conversations",
              style: TextStyles.subtitleTextStyle.copyWith(
                color: Palette.primaryText,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: ProgressBar(value: 20),
                      ),
                      DictationQuestion(
                        controller: _controller,
                        question: question,
                      ),
                      // MultipleChoiceQuestion(
                      //   question:
                      //       "Select the sentence that best describes the image above",
                      //   image: "assets/images/writing_question_image.png",
                      //   options: [
                      //     RadioItemData(title: "A Backpack", value: "1"),
                      //     RadioItemData(title: "A Leather Purse", value: "2"),
                      //     RadioItemData(title: "A Suitcase", value: "3"),
                      //     RadioItemData(title: "A Shopping Bag", value: "4"),
                      //   ],
                      //   onChanged: (value) {
                      //     selectedOption = value;
                      //   },
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            EvaluationSection(
              onPressed: () {
                question.validateQuestion(userAnswer: _controller.text);
              },
            )
          ],
        ),
      ),
    );
  }
}
