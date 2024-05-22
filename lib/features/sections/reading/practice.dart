import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/components/evaluation_section.dart';
import 'package:ez_english/features/sections/components/leave_alert_dialog.dart';
import 'package:ez_english/features/sections/reading/components/multiple-choice%20question.dart';
import 'package:ez_english/features/sections/reading/components/speaking_question.dart';
import 'package:ez_english/features/sections/reading/model/reading_question.dart';
import 'package:ez_english/features/sections/reading/view_model/reading_section_viewmodel.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/widgets/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ReadingPractice extends StatefulWidget {
  const ReadingPractice({super.key});

  @override
  State<ReadingPractice> createState() => _ReadingPracticeState();
}

class _ReadingPracticeState extends State<ReadingPractice> {
  late ReadingQuestionViewmodel readingQuestionViewmodel;
  late List<BaseQuestion> questions = [];
  int currentQuestionIndex = 0;

  @override
  void initState() {
    readingQuestionViewmodel =
        Provider.of<ReadingQuestionViewmodel>(context, listen: false);
    questions = readingQuestionViewmodel.questions;

    super.initState();
  }

  EvaluationState answerState = EvaluationState.empty;
  @override
  Widget build(BuildContext context) {
    BaseQuestion baseCurrentQuestion = questions[currentQuestionIndex];
    ReadingQuestionModel currentQuestion =
        baseCurrentQuestion as ReadingQuestionModel;

    Widget buildQuestionWidget(ReadingQuestionModel question) {
      switch (question.questionType) {
        case 'speaking':
          return SpeakingQuestion();
        case 'mcq':
          return MultipleChoiceQuestion();
        // Add more cases for other question types if needed
        default:
          return SizedBox(); // Default case
      }
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (canPop) {
        // TODO Is it working ???
        // print("pressed");
        // showLeaveAlertDialog(context);
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
                  onPressed: () async {
                    await readingQuestionViewmodel
                        .updateSectionProgress(currentQuestionIndex);
                  },
                );
              },
            ),
          ],
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Palette.secondary,
          title: ListTile(
            contentPadding: const EdgeInsets.only(left: 0, right: 0),
            title: Text(
              AppStrings.readingSectionPracticeAppbarTitle,
              style: TextStyle(
                fontSize: 24.sp,
                color: Palette.primaryText,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
            // TODO change it to dymaic string from the API
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
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: ProgressBar(value: 20),
                      ),
                      buildQuestionWidget(currentQuestion),
                    ],
                  ),
                ),
              ),
            ),
            EvaluationSection(
              onPressed: () {
                setState(() {
                  currentQuestionIndex++;

                  // evaulationState = Random().nextBool()
                  //     ? EvaluationState.correct
                  //     : EvaluationState.incorrect;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}

// TODO: make sure this is unused & remove it

// class EvaluateAnswer extends StatefulWidget {
//   const EvaluateAnswer({super.key});

//   @override
//   State<EvaluateAnswer> createState() => _EvaluateAnswerState();
// }

// class _EvaluateAnswerState extends State<EvaluateAnswer> {
//   EvaluationState evaulationState = EvaluationState.empty;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       color: switch (evaulationState) {
//         EvaluationState.correct => Palette.primaryFill,
//         EvaluationState.incorrect => Palette.errorFill,
//         _ => Palette.secondary,
//       },
//       child: Padding(
//         padding: EdgeInsets.symmetric(
//             vertical: Constants.padding8, horizontal: Constants.padding8),
//         child: Button(
//             onPressed: () {
//               setState(() {
//                 evaulationState = Random().nextBool()
//                     ? EvaluationState.correct
//                     : EvaluationState.incorrect;
//               });
//             },
//             type: switch (evaulationState) {
//               EvaluationState.correct => ButtonType.primary,
//               EvaluationState.incorrect => ButtonType.error,
//               _ => ButtonType.primaryVariant,
//             },
//             text: "check"),
//       ),
//     );
//   }
// }

// enum EvaluationState {
//   correct,
//   incorrect,
//   empty,
// }
