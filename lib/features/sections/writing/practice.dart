// ignore_for_file: avoid_print

import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/components/evaluation_section.dart';
import 'package:ez_english/features/sections/components/leave_alert_dialog.dart';
import 'package:ez_english/features/sections/util/build_question.dart';
import 'package:ez_english/features/sections/writing/viewmodel/writing_section_viewmodel.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/progress_bar.dart';
import 'package:ez_english/widgets/radio_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/dictation_question_model.dart';

class WritingPractice extends StatefulWidget {
  const WritingPractice({super.key});

  @override
  State<WritingPractice> createState() => _WritingPracticeState();
}

class _WritingPracticeState extends State<WritingPractice> {
  late WritingSectionViewmodel viewmodel;
  late BaseQuestion currentQuestion;
  @override
  void initState() {
    super.initState();
    viewmodel = Provider.of<WritingSectionViewmodel>(context, listen: false);
  }

  // final TextEditingController _controller = TextEditingController();

  RadioItemData? selectedOption;
  @override
  Widget build(BuildContext context) {
    viewmodel = Provider.of<WritingSectionViewmodel>(context, listen: false);
    // currentQuestion = viewmodel.questions[viewmodel.currentQuestionIndex];
    currentQuestion = DictationQuestionModel(
        answer: "test",
        questionTextInEnglish: "test",
        imageUrl: "",
        voiceUrl: "",
        questionTextInArabic: '');

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
                showLeaveAlertDialog(context, onPressed: () {});
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
                      buildQuestion(
                        answerState: viewmodel.answerState,
                        onChanged: viewmodel.updateAnswer,
                        question: currentQuestion,
                      )
                    ],
                  ),
                ),
              ),
            ),
            EvaluationSection(
              state: viewmodel.answerState,
              onContinue: () {
                // TODO: update this to new standard
                viewmodel.incrementIndex();
              },
              onPressed: viewmodel.evaluateAnswer,
            )
          ],
        ),
      ),
    );
  }

  // Widget buildQuestionWidget<T extends BaseQuestion>(question) {
  //   switch (question.questionType) {
  //     case QuestionType.dictation:
  //       return DictationQuestion(
  //         onAnswerChanged: (value) {
  //           viewmodel.updateAnswer(value);
  //         },
  //         question: question,
  //       );
  //     case QuestionType.multipleChoice:
  //       return WritingMultipleChoiceQuestion(
  //         question: question,
  //         // options: question.options!,
  //         onChanged: (value) {
  //           selectedOption = value;
  //         },
  //       );
  //     // Add more cases for other question types if needed
  //     default:
  //       return const SizedBox(
  //         child: Text("Check buildQuestionWidget"),
  //       );
  //   }
  // }

// TODO: move answer validation to viewmodel
  // void checkQuestion() {
  //   final condition = switch (currentQuestion.questionType) {
  //     QuestionType.multipleChoice =>
  //       (currentQuestion as MultipleChoiceQuestionModel).validateQuestion(
  //           correctAnswer:
  //               (currentQuestion as MultipleChoiceQuestionModel).answer,
  //           userAnswer: selectedOption),
  //     QuestionType.dictation => (currentQuestion as DictationQuestionModel)
  //         .validateQuestion(
  //             correctAnswer: (currentQuestion as DictationQuestionModel).answer,
  //             userAnswer: _controller.text),
  //     _ => false,
  //   };

  //   setState(() {
  //     switch (condition) {
  //       case true:
  //         evaluationState = EvaluationState.correct;
  //       case false:
  //         evaluationState = EvaluationState.incorrect;
  //     }
  //   });
  // }
}
