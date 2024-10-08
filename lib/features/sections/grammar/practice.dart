import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/components/evaluation_section.dart';
import 'package:ez_english/features/sections/components/finished_questions_screen.dart';
import 'package:ez_english/features/sections/components/leave_alert_dialog.dart';
import 'package:ez_english/features/sections/grammar/grammar_section_viewmodel.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/progress_bar.dart';
import 'package:ez_english/widgets/skip_question_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../util/build_question.dart';

class GrammarPractice extends StatefulWidget {
  const GrammarPractice({super.key});

  @override
  State<GrammarPractice> createState() => _GrammarPracticeState();
}

class _GrammarPracticeState extends State<GrammarPractice> {
  List<BaseQuestion> questions = [];
  late GrammarSectionViewmodel grammarSectionViewmodel;

  @override
  void initState() {
    super.initState();
    grammarSectionViewmodel =
        Provider.of<GrammarSectionViewmodel>(context, listen: false);
    questions = grammarSectionViewmodel.questions;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GrammarSectionViewmodel>(builder: (context, viewmodel, _) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (viewmodel.error != null) {
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

      if (viewmodel.currentIndex == questions.length) {
        return FinishedQuestionsScreen(
          onFinished: () async {
            await viewmodel.updateUserProgress().then((value) {
              context.pop();
              context.pop();
              context.pop();
            });
          },
        );
      }
      BaseQuestion currentQuestion = questions[viewmodel.currentIndex];

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
                "Grammar Practice",
                style: TextStyles.titleTextStyle
                    .copyWith(color: Palette.primaryText),
              ),
              subtitle: Text(
                currentQuestion.titleInEnglish ?? "Daily Conversations",
                style: TextStyles.subtitleTextStyle
                    .copyWith(color: Palette.primaryText),
              ),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: Constants.padding8,
                            ),
                            child: ProgressBar(
                              value: viewmodel.progress!,
                            ),
                          ),
                          Center(
                            child: buildQuestion(
                                question: currentQuestion,
                                onChanged: (value) {
                                  viewmodel.updateAnswer(value);
                                },
                                answerState: viewmodel.answerState),
                          ),
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
                            onPressed: viewmodel.incrementIndex,
                            // size: ,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                EvaluationSection(
                  onContinue: () {
                    viewmodel.incrementIndex();
                  },
                  onPressed: viewmodel.evaluateAnswer,
                  state: viewmodel.answerState,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
