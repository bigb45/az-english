import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/components/evaluation_section.dart';
import 'package:ez_english/features/sections/components/leave_alert_dialog.dart';
import 'package:ez_english/features/sections/components/multiple_choice_question.dart';
import 'package:ez_english/features/sections/components/sentence_forming_question.dart';
import 'package:ez_english/features/sections/models/dictation_question_model.dart';
import 'package:ez_english/features/sections/models/reading_question_model.dart';
import 'package:ez_english/features/sections/models/sentence_forming_question_model.dart';
import 'package:ez_english/features/sections/models/speaking_question_model.dart';
import 'package:ez_english/features/sections/models/youtube_lesson_model.dart';
import 'package:ez_english/features/sections/components/speaking_question.dart';
import 'package:ez_english/features/sections/reading/view_model/reading_section_viewmodel.dart';
import 'package:ez_english/features/sections/components/dictation_question.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/widgets/progress_bar.dart';
import 'package:ez_english/features/sections/components/youtube_lesson.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../util/build_question.dart';

class ReadingPractice extends StatefulWidget {
  const ReadingPractice({super.key});

  @override
  State<ReadingPractice> createState() => _ReadingPracticeState();
}

class _ReadingPracticeState extends State<ReadingPractice> {
  late ReadingQuestionViewmodel readingSectionViewmodel;
  late List<BaseQuestion> questions = [];

  @override
  void initState() {
    readingSectionViewmodel =
        Provider.of<ReadingQuestionViewmodel>(context, listen: false);
    questions = readingSectionViewmodel.questions;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ReadingQuestionModel currentQuestion =
        questions[readingSectionViewmodel.currentIndex] as ReadingQuestionModel;

    return PopScope(
      canPop: false,
      onPopInvoked: (canPop) {
        showLeaveAlertDialog(context, onConfirm: () async {
          await readingSectionViewmodel
              .updateSectionProgress(readingSectionViewmodel.currentIndex);
        });
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
                  onConfirm: () async {
                    await readingSectionViewmodel.updateSectionProgress(
                        readingSectionViewmodel.currentIndex);
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
            // TODO change subtitle to dymaic string from the API
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
                padding: EdgeInsets.symmetric(horizontal: Constants.padding8),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: Constants.padding8),
                        child: const ProgressBar(value: 20),
                      ),
                      buildQuestion(
                        question: currentQuestion,
                        onChanged: (value) {
                          readingSectionViewmodel.updateAnswer(value);
                        },
                        answerState: readingSectionViewmodel.answerState,
                      )
                    ],
                  ),
                ),
              ),
            ),
            EvaluationSection(
              onContinue: () {
                readingSectionViewmodel.incrementIndex();
              },
              onPressed: () {
                setState(() {
                  readingSectionViewmodel.evaluateAnswer();
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
