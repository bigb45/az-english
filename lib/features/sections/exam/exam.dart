import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/components/leave_alert_dialog.dart';
import 'package:ez_english/features/sections/exam/viewmodel/viewmodel.dart';
import 'package:ez_english/features/sections/util/build_question.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ExamSection extends StatefulWidget {
  final String levelId;

  const ExamSection({super.key, required this.levelId});

  @override
  State<ExamSection> createState() => _ExamSectionState();
}

class _ExamSectionState extends State<ExamSection> {
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
          showLeaveAlertDialog(context);
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
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (viewmodel.passageTexts.containsKey(index))
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0),
                                      child: ExpandableTextBox(
                                          paragraph:
                                              viewmodel.passageTexts[index]!,
                                          isFocused: false,
                                          readMoreText: AppStrings
                                              .mcQuestionReadMoreText)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: buildQuestion(
                                    answerState: viewmodel.answerState,
                                    onChanged: (answer) {
                                      // viewmodel.updateAnswer(question, answer);
                                    },
                                    question: question,
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // viewmodel.submitExam();
                        },
                        child: Text("Submit Exam"),
                      ),
                    ),
                  ],
                )),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      );
    });
  }
}
