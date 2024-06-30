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

  RadioItemData? selectedOption;
  @override
  Widget build(BuildContext context) {
    return Consumer<WritingSectionViewmodel>(builder: (context, viewmodel, _) {
      currentQuestion = viewmodel.questions[viewmodel.currentIndex];

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
