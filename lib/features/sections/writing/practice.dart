import 'dart:math';

import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/sections/writing/components/dictation_question.dart';
import 'package:ez_english/features/sections/writing/components/multiple_choice_question.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:ez_english/widgets/microphone_button.dart';
import 'package:ez_english/widgets/progress_bar.dart';
import 'package:ez_english/widgets/radio_button.dart';
import 'package:ez_english/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';

class WritingPractice extends StatefulWidget {
  const WritingPractice({super.key});

  @override
  State<WritingPractice> createState() => _WritingPracticeState();
}

class _WritingPracticeState extends State<WritingPractice> {
  FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;
  @override
  void initState() {
    Future<void> configureTts() async {
      // flutterTts.setProgressHandler((_, __, ___, currentWord) {
      //   print("$currentWord");
      // });
      // TODO: set voice to female voice
      await flutterTts.setLanguage('en-US');
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(0.5);
      flutterTts.setStartHandler(() {
        setState(() {
          isSpeaking = true;
        });
      });
      flutterTts.completionHandler = () {
        setState(() {
          isSpeaking = false;
        });
      };
    }

    configureTts();
    super.initState();
  }

  void speakText(String text) async {
    await flutterTts.speak(text);
  }

  void stopSpeaking() async {
    await flutterTts.stop();
  }

  final TextEditingController _controller = TextEditingController();
  String text = "The quick brown fox jumps over the lazy dog.";

  RadioItemData? selectedOption;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90.h,
        backgroundColor: Palette.secondary,
        elevation: 0,
        title: ListTile(
          contentPadding: const EdgeInsets.only(left: 0, right: 0),
          title: Text(
            'Writing & Listening Practice',
            style: TextStyle(
              fontSize: 24.sp,
              color: Palette.primaryText,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            "Daily Conversations",
            style: TextStyle(
              fontSize: 17.sp,
              color: Palette.primaryText,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
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
                    // DictationQuestion(
                    //   controller: _controller,
                    //   text: text,
                    //   flutterTts: flutterTts,
                    // ),
                    RadioGroup(
                      onChanged: (newValue) {
                        print("new value: ${newValue.title}");
                      },
                      options: [
                        RadioItemData(title: "Option 1", value: "1"),
                        RadioItemData(title: "Option 2", value: "2"),
                        RadioItemData(title: "Option 3", value: "3"),
                        RadioItemData(title: "Option 4", value: "4"),
                      ],
                    ),
                    // MultipleChoiceQuestion(
                    //   question: "Select the correct option from below",
                    //   selectedOption: selectedOption,
                    //   options: [
                    //     RadioItemData(title: "Option 1", value: "1"),
                    //     RadioItemData(title: "Option 2", value: "2"),
                    //     RadioItemData(title: "Option 3", value: "3"),
                    //     RadioItemData(title: "Option 4", value: "4"),
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
          EvaluateAnswer()
        ],
      ),
    );
  }
}

class EvaluateAnswer extends StatefulWidget {
  const EvaluateAnswer({super.key});

  @override
  State<EvaluateAnswer> createState() => _EvaluateAnswerState();
}

class _EvaluateAnswerState extends State<EvaluateAnswer> {
  EvaluationState evaulationState = EvaluationState.empty;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: switch (evaulationState) {
        EvaluationState.correct => Palette.primaryFill,
        EvaluationState.incorrect => Palette.errorFill,
        _ => Palette.secondary,
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: Constants.padding8, horizontal: Constants.padding8),
        child: Button(
          onPressed: () {
            setState(() {
              evaulationState = Random().nextBool()
                  ? EvaluationState.correct
                  : EvaluationState.incorrect;
            });
          },
          type: switch (evaulationState) {
            EvaluationState.correct => ButtonType.primary,
            EvaluationState.incorrect => ButtonType.error,
            _ => ButtonType.primaryVariant,
          },
          child: Text(
            "CHECK",
            style: TextStyle(
              color: Palette.secondary,
              fontFamily: 'Inter',
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

enum EvaluationState {
  correct,
  incorrect,
  empty,
}
