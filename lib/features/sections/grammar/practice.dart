import 'package:ez_english/features/sections/components/evaluation_section.dart';
import 'package:ez_english/features/sections/grammar/components/sentence_forming_question.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

class GrammarPractice extends StatefulWidget {
  final String fullSentence;
  final String options;
  const GrammarPractice(
      {super.key, required this.fullSentence, required this.options});

  @override
  State<GrammarPractice> createState() => _GrammarPracticeState();
}

class _GrammarPracticeState extends State<GrammarPractice> {
  String userAnswer = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    });
  }

  EvaluationState answerState = EvaluationState.empty;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.white,
        title: ListTile(
          contentPadding: const EdgeInsets.only(left: 0, right: 0),
          title: Text(
            "Grammar Practice",
            style:
                TextStyles.titleTextStyle.copyWith(color: Palette.primaryText),
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
                      onChanged: (value) {
                        setState(() {
                          userAnswer = value;
                        });
                      },
                      fullSentence: widget.fullSentence,
                      words: widget.options,
                      answerState: answerState,
                    ),
                  ],
                ),
              ),
            ),
          ),
          EvaluateAnswer(
              state: answerState,
              onPressed: switch (answerState) {
                EvaluationState.correct => () {
                    print("continuing to next screen");
                  },
                EvaluationState.incorrect => () {
                    evaluateAnswer();
                    print("try again");
                  },
                EvaluationState.empty => () {
                    evaluateAnswer();
                  },
              }),
        ],
      ),
    );
  }

  void evaluateAnswer() {
    setState(() {
      answerState =
          widget.fullSentence.toLowerCase() == userAnswer.toLowerCase()
              ? EvaluationState.correct
              : EvaluationState.incorrect;
    });
  }
}
