// ignore_for_file: avoid_print

import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/components/evaluation_section.dart';
import 'package:ez_english/features/sections/components/finished_questions_screen.dart';
import 'package:ez_english/features/sections/components/leave_alert_dialog.dart';
import 'package:ez_english/features/sections/listening/viewmodel/listening_section_viewmodel.dart';
import 'package:ez_english/features/sections/util/build_question.dart';
import 'package:ez_english/features/sections/writing/viewmodel/writing_section_viewmodel.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/progress_bar.dart';
import 'package:ez_english/widgets/radio_button.dart';
import 'package:ez_english/widgets/skip_question_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ListeningPractice extends StatefulWidget {
  const ListeningPractice({super.key});

  @override
  State<ListeningPractice> createState() => _ListeningPracticeState();
}

class _ListeningPracticeState extends State<ListeningPractice> {
  late ListeningSectionViewmodel viewmodel;
  late BaseQuestion currentQuestion;
  @override
  void initState() {
    super.initState();
    viewmodel = Provider.of<ListeningSectionViewmodel>(context, listen: false);
  }

  RadioItemData? selectedOption;
  @override
  Widget build(BuildContext context) {
    return Consumer<ListeningSectionViewmodel>(
        builder: (context, viewmodel, _) {
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
      if (viewmodel.currentIndex == viewmodel.questions.length) {
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

      currentQuestion = viewmodel.questions[viewmodel.currentIndex];

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
                currentQuestion.titleInEnglish ?? "Daily Conversations",
                style: TextStyles.subtitleTextStyle.copyWith(
                  color: Palette.primaryText,
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ProgressBar(value: viewmodel.progress!),
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
                  state: viewmodel.answerState,
                  onContinue: viewmodel.incrementIndex,
                  onPressed: viewmodel.evaluateAnswer,
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
