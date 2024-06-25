import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/components/evaluation_section.dart';
import 'package:ez_english/features/sections/components/leave_alert_dialog.dart';
import 'package:ez_english/features/sections/models/passage_question_model.dart';
import 'package:ez_english/features/sections/reading/view_model/reading_section_viewmodel.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/expandable_text.dart';
import 'package:ez_english/widgets/progress_bar.dart';
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
  late ReadingSectionViewmodel readingSectionViewmodel;
  late List<BaseQuestion?> questions = [];
  late BaseQuestion? currentQuestion;
  bool _isFocused = false;
  PassageQuestionModel? passageQuestion;
  @override
  void initState() {
    readingSectionViewmodel =
        Provider.of<ReadingSectionViewmodel>(context, listen: false);
    questions = readingSectionViewmodel.questions;
    passageQuestion = readingSectionViewmodel.passageQuestion;
    currentQuestion = questions[readingSectionViewmodel.currentIndex];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // handle empty questions
    if (questions.isEmpty) {
      return Scaffold(
          body: Center(
        child: Text(
          "No questions found, try again later.",
          style: TextStyles.bodyLarge,
        ),
      ));
    }

    return Consumer<ReadingSectionViewmodel>(
      builder: (context, readingSectionViewmodel, child) {
        currentQuestion = questions[readingSectionViewmodel.currentIndex];
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
                  passageQuestion?.titleInEnglish ?? "Passage",
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
                    padding:
                        EdgeInsets.symmetric(horizontal: Constants.padding8),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Constants.padding8),
                            child: const ProgressBar(value: 20),
                          ),
                          passageQuestion != null
                              ? ExpandableTextBox(
                                  paragraph: passageQuestion!.passageInEnglish!,
                                  isFocused: _isFocused,
                                  readMoreText:
                                      AppStrings.mcQuestionReadMoreText)
                              : const SizedBox(),
                          questions.isNotEmpty
                              ? buildQuestion(
                                  question: currentQuestion!,
                                  onChanged: (value) {
                                    // handle the case for different question types
                                    readingSectionViewmodel.updateAnswer(value);
                                  },
                                  answerState:
                                      readingSectionViewmodel.answerState,
                                )
                              // TODO: Verify if the 'questions' array can ever be empty and handle this case appropriately.
                              : const Text("No questions provided"),
                        ],
                      ),
                    ),
                  ),
                ),
                EvaluationSection(
                  state: readingSectionViewmodel.answerState,
                  onContinue: readingSectionViewmodel.incrementIndex,
                  onPressed: readingSectionViewmodel.evaluateAnswer,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
