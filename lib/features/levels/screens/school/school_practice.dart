import 'package:easy_localization/easy_localization.dart';
import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/levels/screens/school/school_section_viewmodel.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/components/evaluation_section.dart';
import 'package:ez_english/features/sections/components/finished_questions_screen.dart';
import 'package:ez_english/features/sections/components/leave_alert_dialog.dart';
import 'package:ez_english/features/sections/models/passage_question_model.dart';
import 'package:ez_english/features/sections/util/build_question.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/expandable_text.dart';
import 'package:ez_english/widgets/progress_bar.dart';
import 'package:ez_english/widgets/skip_question_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SchoolPractice extends StatefulWidget {
  const SchoolPractice({super.key});

  @override
  State<SchoolPractice> createState() => _SchoolPracticeState();
}

class _SchoolPracticeState extends State<SchoolPractice> {
  BaseQuestion? currentQuestion;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    PassageQuestionModel? passageQuestion;
    return Consumer<SchoolSectionViewmodel>(builder: (context, viewmodel, _) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (viewmodel.error != null) {
          print("showing error");
          ScaffoldMessenger.of(context)
              .showSnackBar(
                SnackBar(
                  content: Text(
                    viewmodel.error?.message ?? "An error occurred",
                  ),
                ),
              )
              .closed
              .then((reason) => viewmodel.resetError());
        }
      });
      if (viewmodel.currentIndex == viewmodel.questions.length) {
        return _isLoading == true
            ? Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  systemOverlayStyle: SystemUiOverlayStyle.dark,
                  title: ListTile(
                    title: Text(
                      "Finished all questions",
                      style: TextStyles.titleTextStyle,
                    ),
                    contentPadding: const EdgeInsets.only(left: 0, right: 0),
                  ),
                ),
                body: const Center(child: CircularProgressIndicator()))
            : FinishedQuestionsScreen(
                onFinished: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  await viewmodel.updateUserProgress().then((value) {
                    setState(() {
                      _isLoading = false;
                    });
                    context.pop();
                    context.pop();
                  });
                },
              );
      }
      if (viewmodel.isLoading == false) {
        currentQuestion = viewmodel.questions[viewmodel.currentIndex];

        if (currentQuestion?.questionType == QuestionType.passage) {
          passageQuestion = currentQuestion as PassageQuestionModel;

          if (passageQuestion!.questions.isNotEmpty &&
              passageQuestion!.questions.containsKey(1)) {
            currentQuestion = passageQuestion!.questions[1]!;
          } else {
            throw Exception(
                "No embedded questions found or first question is missing.");
          }
        }
      }
      return PopScope(
        canPop: false,
        onPopInvoked: (canPop) {
          showAlertDialog(
            context,
            onConfirm: () async {
              await viewmodel.updateSectionProgress();
            },
          );
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
                  showAlertDialog(
                    context,
                    onConfirm: () async {
                      await viewmodel.updateSectionProgress();
                    },
                  );
                },
              ),
            ],
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.white,
            title: ListTile(
              contentPadding: const EdgeInsets.only(left: 0, right: 0),
              title: Text(
                'Listening Practice',
                style: TextStyles.titleTextStyle.copyWith(
                  color: Palette.primaryText,
                ),
              ),
              subtitle: Text(
                currentQuestion?.titleInEnglish ?? "Daily Conversations",
                style: TextStyles.subtitleTextStyle.copyWith(
                  color: Palette.primaryText,
                ),
              ),
            ),
          ),
          body: viewmodel.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                if (passageQuestion != null)
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 10.0,
                                      ),
                                      child: ExpandableTextBox(
                                          paragraph: passageQuestion!
                                              .passageInEnglish!,
                                          paragraphTranslation:
                                              passageQuestion!.passageInArabic,
                                          isFocused: false,
                                          readMoreText: AppStrings
                                              .mcQuestionReadMoreText)),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child:
                                      ProgressBar(value: viewmodel.progress!),
                                ),
                                buildQuestion(
                                  answerState: viewmodel.answerState,
                                  onChanged: viewmodel.updateAnswer,
                                  question: currentQuestion!,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: viewmodel.isSkipVisible ? 1 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Visibility(
                          visible: viewmodel.isSkipVisible,
                          child: Padding(
                            padding: EdgeInsets.all(Constants.padding8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SkipQuestionButton(
                                  onPressed: () {
                                    passageQuestion = null;
                                    viewmodel.incrementIndex();
                                  },
                                  // size: ,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      EvaluationSection(
                        state: viewmodel.answerState,
                        onContinue: () {
                          passageQuestion = null;
                          viewmodel.incrementIndex();
                        },
                        onPressed: () {
                          passageQuestion = null;
                          viewmodel.evaluateAnswer();
                        },
                      )
                    ],
                  ),
                ),
        ),
      );
    });
  }
}
