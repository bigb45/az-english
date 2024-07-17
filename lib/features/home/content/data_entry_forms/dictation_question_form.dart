import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/home/content/viewmodels/dictation_question_viewmodel.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/components/evaluation_section.dart';
import 'package:ez_english/features/sections/util/build_question.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DictationQuestionForm extends StatefulWidget {
  final String level;
  final String section;
  final String day;
  final Function(BaseQuestion<dynamic>)? onSubmit;

  DictationQuestionForm({
    super.key,
    required this.level,
    required this.section,
    required this.day,
    this.onSubmit,
  });

  @override
  State<DictationQuestionForm> createState() => _DictationQuestionFormState();
}

class _DictationQuestionFormState extends State<DictationQuestionForm> {
  final _formKey = GlobalKey<FormState>();
  bool isFormValid = false;

  void _validateForm() {
    setState(() {
      isFormValid = _formKey.currentState?.validate() ?? false;
    });
  }

  final TextEditingController questionEnglishController =
      TextEditingController();

  final TextEditingController questionArabicController =
      TextEditingController();

  final TextEditingController speakableTextController = TextEditingController();

  final TextEditingController titleInEnglishController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DictationQuestionViewModel(),
      child: Consumer<DictationQuestionViewModel>(
        builder: (context, viewModel, child) {
          return Form(
            onChanged: _validateForm,
            autovalidateMode: AutovalidateMode.always,
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: questionEnglishController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Question text (Egnlish)",
                    hintText: "Ex: \"Write what you hear\"",
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: questionArabicController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Question text (Arabic)",
                    hintText: "Ex: \"اكتب ما تسمع\"",
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: speakableTextController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Dictation text",
                    hintText: "The text to be talked back to the user",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text in English';
                    }
                    return null;
                  },
                ),
                // const SizedBox(height: 10),
                // TextFormField(
                //   controller: titleInEnglishController,
                //   decoration: const InputDecoration(
                //     border: OutlineInputBorder(),
                //     labelText: "Question title",
                //     hintText: "Enter the title in English",
                //   ),
                // ),
                const SizedBox(height: 10),
                Button(
                  onPressed: isFormValid
                      ? () {
                          viewModel
                              .submitForm(
                            questionTextInEnglish:
                                questionEnglishController.text.trim().isEmpty
                                    ? null
                                    : questionEnglishController.text.trim(),
                            questionTextInArabic:
                                questionArabicController.text.trim().isEmpty
                                    ? null
                                    : questionArabicController.text.trim(),
                            speakableText:
                                speakableTextController.text.trim().isEmpty
                                    ? null
                                    : speakableTextController.text.trim(),
                            titleInEnglish:
                                titleInEnglishController.text.trim().isEmpty
                                    ? null
                                    : titleInEnglishController.text.trim(),
                          )
                              .then((question) {
                            showConfirmSubmitModalSheet(
                                context: context,
                                onSubmit: () {
                                  viewModel.uploadQuestion(
                                      level: widget.level,
                                      section: widget.section,
                                      day: widget.day,
                                      // Add question to the onSubmit function
                                      question: question!);
                                  if (widget.onSubmit != null) {
                                    widget.onSubmit!(question);
                                  }
                                },
                                question: question);
                          });
                        }
                      : null,
                  text: "Submit",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

void showConfirmSubmitModalSheet<BaseQuestion>(
    {required context, required onSubmit, question}) {
  showModalBottomSheet(
      enableDrag: true,
      elevation: 10,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: IgnorePointer(
            ignoring: false,
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(Constants.padding20),
                child: Column(
                  children: [
                    Text(
                      "Are you sure you want to submit this question?",
                      style: TextStyles.bodyMedium,
                    ),
                    buildQuestion(
                        question: question,
                        onChanged: (value) {},
                        answerState: EvaluationState.empty),
                    const SizedBox(
                      height: 20,
                    ),
                    Button(
                      onPressed: () {
                        print("submitting question");
                        onSubmit();
                        Navigator.pop(context);
                      },
                      text: "Submit",
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      });
}
