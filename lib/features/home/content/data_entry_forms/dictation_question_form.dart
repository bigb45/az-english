import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/home/content/viewmodels/dictation_question_viewmodel.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/components/evaluation_section.dart';
import 'package:ez_english/features/sections/models/dictation_question_model.dart';
import 'package:ez_english/features/sections/models/passage_question_model.dart';
import 'package:ez_english/features/sections/util/build_question.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/utils/utils.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:ez_english/widgets/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DictationQuestionForm extends StatefulWidget {
  final String level;
  final String section;
  final String day;
  final Function(BaseQuestion<dynamic>)? onSubmit;
  final DictationQuestionModel? question;

  const DictationQuestionForm({
    super.key,
    required this.level,
    required this.section,
    required this.day,
    this.onSubmit,
    this.question,
  });

  @override
  State<DictationQuestionForm> createState() => _DictationQuestionFormState();
}

class _DictationQuestionFormState extends State<DictationQuestionForm> {
  final _formKey = GlobalKey<FormState>();
  bool isFormValid = false;
  String? originalQuestionTextInEnglish;
  String? originalQuestionTextInArabic;
  String? originalSpeakableText;
  String? originalTitleInEnglish;
  String? originalAnswer;
  String? updateMessage;
  final TextEditingController questionEnglishController =
      TextEditingController();

  final TextEditingController questionArabicController =
      TextEditingController();

  final TextEditingController speakableTextController = TextEditingController();
  final TextEditingController answerTextController = TextEditingController();

  final TextEditingController titleInEnglishController =
      TextEditingController();
  void updateQuestion(DictationQuestionModel updatedQuestion) {
    if (widget.question != null) {
      if (questionEnglishController.text != originalQuestionTextInEnglish) {
        widget.question!.questionTextInEnglish = questionEnglishController.text;
      }
      if (questionArabicController.text != originalQuestionTextInArabic) {
        widget.question!.questionTextInArabic = questionArabicController.text;
      }
      if (speakableTextController.text != originalSpeakableText) {
        widget.question!.speakableText = speakableTextController.text;
      }
      if (titleInEnglishController.text != originalTitleInEnglish) {
        widget.question!.titleInEnglish = titleInEnglishController.text;
      }
      if (answerTextController.text != originalAnswer) {
        widget.question!.answer!.answer = answerTextController.text;
      }
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.question != null) {
      questionEnglishController.text = originalQuestionTextInEnglish =
          widget.question!.questionTextInEnglish ?? "";
      questionArabicController.text = originalQuestionTextInArabic =
          widget.question!.questionTextInArabic ?? "";
      speakableTextController.text =
          originalSpeakableText = widget.question!.speakableText;
      titleInEnglishController.text =
          originalTitleInEnglish = widget.question!.titleInEnglish ?? "";
      answerTextController.text =
          originalAnswer = widget.question!.answer!.answer ?? "";
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _validateForm();
    });
  }

  @override
  void dispose() {
    questionEnglishController.dispose();
    questionArabicController.dispose();
    speakableTextController.dispose();
    titleInEnglishController.dispose();
    answerTextController.dispose();
    super.dispose();
  }

  void _validateForm() {
    bool formValid = _formKey.currentState?.validate() ?? false;
    bool changesMade = _checkForChanges();
    setState(() {
      isFormValid = formValid && (widget.question == null || changesMade);
      if (changesMade) {
        updateMessage = null;
      }
    });
  }

  bool _checkForChanges() {
    return questionEnglishController.text != originalQuestionTextInEnglish ||
        questionArabicController.text != originalQuestionTextInArabic ||
        speakableTextController.text != originalSpeakableText ||
        titleInEnglishController.text != originalTitleInEnglish ||
        answerTextController.text != originalAnswer;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DictationQuestionViewModel(),
      child: Consumer<DictationQuestionViewModel>(
        builder: (context, viewmodel, child) {
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
                SizedBox(height: 10.h),
                TextFormField(
                  controller: questionArabicController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Question text (Arabic)",
                    hintText: "Ex: \"اكتب ما تسمع\"",
                  ),
                ),
                SizedBox(height: 10.h),
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
                SizedBox(height: 10.h),
                TextFormField(
                  controller: answerTextController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Answer",
                    hintText: "The student answer",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please fill some text in English';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.h),
                TextFormField(
                  controller: titleInEnglishController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Question title",
                    hintText: "Enter the title in English",
                  ),
                ),
                SizedBox(height: 10.h),
                _updateButton(viewmodel),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _updateButton(DictationQuestionViewModel viewmodel) {
    bool isEnabled = isFormValid;

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Button(
              onPressed: isEnabled
                  ? () {
                      if (_formKey.currentState!.validate()) {
                        viewmodel
                            .submitForm(
                          answer: answerTextController.text.trim(),
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
                          sectionName:
                              SectionNameExtension.fromString(widget.section),
                        )
                            .then((updatedQuestion) {
                          if (updatedQuestion != null) {
                            setState(() {
                              updateQuestion(updatedQuestion);
                            });
                            if (widget.onSubmit != null) {
                              updatedQuestion.path =
                                  widget.question?.path ?? '';
                              widget.onSubmit!(updatedQuestion);
                              Navigator.of(context).pop();
                              Utils.showSnackbar(
                                  text: "Question updated successfully");
                            } else {
                              showPreviewModalSheet(
                                  context: context,
                                  onSubmit: () {
                                    viewmodel
                                        .uploadQuestion(
                                            level: widget.level,
                                            section: widget.section,
                                            day: widget.day,
                                            // Add question to the onSubmit function
                                            question: updatedQuestion)
                                        .then((_) {
                                      Utils.showSnackbar(
                                          text:
                                              "Question uploaded successfully");
                                      resetForm(viewmodel.reset);
                                    });
                                    if (widget.onSubmit != null) {
                                      widget.onSubmit!(updatedQuestion);
                                    }
                                  },
                                  question: updatedQuestion);
                            }
                          }
                        });
                      } else {
                        Utils.showErrorSnackBar(
                          "Please select an answer as the correct answer.",
                        );
                      }
                    }
                  : null,
              text: widget.question == null ? "submit" : "Update",
            ),
            if (!isEnabled)
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: isEnabled
                        ? null
                        : () {
                            setState(() {
                              updateMessage = AppStrings.checkAllFields;
                            });
                          },
                  ),
                ),
              ),
          ],
        ),
        if (updateMessage != null)
          Padding(
            padding: EdgeInsets.all(Constants.padding8),
            child: Text(
              updateMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
      ],
    );
  }

  void resetForm(Function resetViewmodel) {
    resetViewmodel();
    questionEnglishController.text = "";
    questionArabicController.text = "";
    speakableTextController.text = "";
    titleInEnglishController.text = "";
    answerTextController.text = "";
    setState(() {
      isFormValid = false;
      updateMessage = null;
    });
  }
}

void showPreviewModalSheet<BaseQuestion>({
  required context,
  required onSubmit,
  String? title,
  bool showSubmitButton = true,
  question,
}) {
  PassageQuestionModel? passageQuestion;
  if (question.questionType == QuestionType.passage) {
    passageQuestion = question as PassageQuestionModel;

    if (passageQuestion.questions.isNotEmpty &&
        passageQuestion.questions.containsKey(1)) {
      question = passageQuestion.questions[1]!;
    } else {
      throw Exception(
          "No embedded questions found or first question is missing.");
    }
  }
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
                      title ?? "Are you sure you want to submit this question?",
                      style: TextStyles.bodyMedium,
                    ),
                    if (passageQuestion != null)
                      Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10.0,
                          ),
                          child: ExpandableTextBox(
                              paragraph: passageQuestion.passageInEnglish!,
                              paragraphTranslation:
                                  passageQuestion.passageInArabic,
                              isFocused: false,
                              readMoreText: AppStrings.mcQuestionReadMoreText)),
                    buildQuestion(
                        question: question,
                        onChanged: (value) {},
                        answerState: EvaluationState.empty),
                    if (showSubmitButton) ...[
                      SizedBox(
                        height: 20.h,
                      ),
                      Button(
                        onPressed: () {
                          onSubmit();
                          printDebug("submitting question");
                          Navigator.pop(context);
                        },
                        text: "Submit",
                      )
                    ]
                  ],
                ),
              ),
            ),
          ),
        );
      });
}
