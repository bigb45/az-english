import 'package:ez_english/features/sections/components/evaluation_section.dart';
import 'package:ez_english/features/sections/components/leave_alert_dialog.dart';
import 'package:ez_english/features/sections/grammar/components/sentence_forming_question.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GrammarPractice extends StatefulWidget {
  // final String fullSentence;
  // final String options;
  const GrammarPractice({super.key});

  @override
  State<GrammarPractice> createState() => _GrammarPracticeState();
}

class _GrammarPracticeState extends State<GrammarPractice> {
  String userAnswer = "";
  final String fullSentence = "A cat is sleeping";
  final String options = "cat is sleeping are am the a";

  EvaluationState answerState = EvaluationState.empty;
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
                showLeaveAlertDialog(
                  context,
                  onPressed: () {},
                );
              },
            ),
          ],
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.white,
          title: ListTile(
            contentPadding: const EdgeInsets.only(left: 0, right: 0),
            title: Text(
              "Grammar Practice",
              style: TextStyles.titleTextStyle
                  .copyWith(color: Palette.primaryText),
            ),
            subtitle: Text(
              "Daily Conversations",
              style: TextStyles.subtitleTextStyle
                  .copyWith(color: Palette.primaryText),
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
                      const ProgressBar(value: 20),
                      SentenceFormingQuestion(
                        partialSentence: ["A"],
                        fullSentence: fullSentence,
                        words: options,
                        answerState: answerState,
                        onChanged: (value) {
                          setState(() {
                            userAnswer = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            EvaluationSection(
                onContinue: () {},
                state: answerState,
                onPressed: switch (answerState) {
                  EvaluationState.correct => () {
                      // TODO: move on to next question or screen
                    },
                  EvaluationState.incorrect => () {
                      evaluateAnswer();
                    },
                  EvaluationState.empty => () {
                      evaluateAnswer();
                    },
                }),
          ],
        ),
      ),
    );
  }

  void evaluateAnswer() {
    setState(() {
      answerState = fullSentence.toLowerCase() == userAnswer.toLowerCase()
          ? EvaluationState.correct
          : EvaluationState.incorrect;
    });
  }
}
