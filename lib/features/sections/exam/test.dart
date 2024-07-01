import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/components/leave_alert_dialog.dart';
import 'package:ez_english/features/sections/exam/viewmodel/test_section_viewmodel.dart';
import 'package:ez_english/features/sections/util/build_question.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:ez_english/widgets/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TestSection extends StatefulWidget {
  final String levelId;

  const TestSection({super.key, required this.levelId});

  @override
  State<TestSection> createState() => _TestSectionState();
}

class _TestSectionState extends State<TestSection> {
  late TestSectionViewmodel viewmodel;

  @override
  void initState() {
    super.initState();
    viewmodel = Provider.of<TestSectionViewmodel>(context, listen: false);
    viewmodel.levelId = widget.levelId;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      viewmodel.myInit();
    });
  }

  @override
  Widget build(BuildContext context) {
    viewmodel = Provider.of<TestSectionViewmodel>(context);

    return Consumer<TestSectionViewmodel>(builder: (context, viewmodel, _) {
      return PopScope(
        canPop: false,
        onPopInvoked: (canPop) {
          showAlertDialog(
            title: "Leave Exam?",
            body:
                "Are you sure you want to leave the exam? Your progress will not be saved.",
            context,
            onConfirm: () async {
              await viewmodel.updateSectionProgress();
            },
          );
        },
        child: viewmodel.isInitialized
            ? Scaffold(
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
                          title: "Leave Exam?",
                          body:
                              "Are you sure you want to leave the exam? Your progress will not be saved.",
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
                      'Writing & Listening Exam',
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
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: viewmodel.questions
                              .asMap()
                              .entries
                              .map<Widget>((entry) {
                            int index = entry.key;
                            BaseQuestion question = entry.value;
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: Constants.padding8,
                                  horizontal: Constants.padding4),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: viewmodel.answers.isNotEmpty &&
                                          viewmodel.answers[index] != null
                                      ? viewmodel.answers[index]!
                                          ? Palette.primaryFill
                                          : Palette.errorFill
                                      : null,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (viewmodel.passageTexts
                                        .containsKey(index))
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 10.0,
                                          ),
                                          child: ExpandableTextBox(
                                              paragraph: viewmodel
                                                  .passageTexts[index]!,
                                              isFocused: false,
                                              readMoreText: AppStrings
                                                  .mcQuestionReadMoreText)),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0),
                                      child: IgnorePointer(
                                        ignoring: viewmodel.isSubmitted,
                                        child: buildQuestion(
                                          answerState: viewmodel.answerState,
                                          onChanged: (answer) {
                                            viewmodel.updateAnswer(
                                                index, answer);
                                          },
                                          question: question,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Button(
                        onPressed: viewmodel.isReadyToSubmit
                            ? () {
                                viewmodel.submitExam();
                                // viewmodel.addOrUpdateExamResult();
                                // showAlertDialog(
                                //   context,
                                //   title: "Submit Exam",
                                //   body: "Are you sure you want to submit the exam?",
                                //   onConfirm: () async {
                                //     viewmodel.submitExam();
                                //   },
                                // );
                              }
                            : null,
                        text: "Submit Exam",
                      ),
                    ),
                  ],
                )),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      );
    });
  }
}
