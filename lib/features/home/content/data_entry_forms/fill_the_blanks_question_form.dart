import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/home/content/data_entry_forms/dictation_question_form.dart';
import 'package:ez_english/features/home/content/viewmodels/fill_the_blanks_question_viewmodel.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/models/fill_the_blanks_question_model.dart';
import 'package:ez_english/features/sections/models/string_answer.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/utils/utils.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:ez_english/widgets/rich_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class FillTheBlanksForm extends StatefulWidget {
  final String level;
  final String section;
  final String day;
  final Function(BaseQuestion<dynamic>)? onSubmit;
  final FillTheBlanksQuestionModel? question;
  FillTheBlanksForm({
    super.key,
    required this.level,
    required this.section,
    required this.day,
    this.onSubmit,
    this.question,
  });

  @override
  State<FillTheBlanksForm> createState() => _FillTheBlanksFormState();
}

class _FillTheBlanksFormState extends State<FillTheBlanksForm> {
  int englishBlankStart = 0;
  int englishBlankEnd = 0;
  int arabicBlankStart = 0;
  int arabicBlankEnd = 0;

  final _formKey = GlobalKey<FormState>();
  bool isFormValid = false;

  final TextEditingController incompleteSentenceInEnglishController =
      TextEditingController();

  final TextEditingController incompleteSentenceInArabicController =
      TextEditingController();

  final TextEditingController questionEnglishController =
      TextEditingController();

  final TextEditingController questionArabicController =
      TextEditingController();

  String? originalIncompleteSentenceInEnglish;
  String? originalIncompleteSentenceInArabic;
  String? originalQuestionEnglish;
  String? originalQuestionArabic;

  int originalEnglishBlankStart = 0;
  int originalEnglishBlankEnd = 0;
  int originalArabicBlankStart = 0;
  int originalArabicBlankEnd = 0;

  String? updateMessage;
  String answer = "";
  String formattedTextInEnglish = "";
  String formattedTextInArabic = "";

  void updateQuestion(FillTheBlanksQuestionModel updatedQuestion) {
    if (widget.question != null) {
      if (incompleteSentenceInEnglishController.text !=
          originalIncompleteSentenceInEnglish) {
        widget.question!.incompleteSentenceInEnglish =
            incompleteSentenceInEnglishController.text;
      }
      if (incompleteSentenceInArabicController.text !=
          originalIncompleteSentenceInArabic) {
        widget.question!.incompleteSentenceInArabic =
            incompleteSentenceInArabicController.text;
      }
      if (questionEnglishController.text != originalQuestionEnglish) {
        widget.question!.questionTextInEnglish = questionEnglishController.text;
      }
      if (questionArabicController.text != originalQuestionArabic) {
        widget.question!.questionTextInArabic = questionArabicController.text;
      }
      if (englishBlankStart != originalEnglishBlankStart ||
          englishBlankEnd != originalEnglishBlankEnd) {
        widget.question!.answer = StringAnswer(
            answer: incompleteSentenceInEnglishController.text
                .substring(englishBlankStart, englishBlankEnd)
                .trim());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.question != null) {
      originalIncompleteSentenceInEnglish =
          widget.question!.incompleteSentenceInEnglish ?? "";
      originalIncompleteSentenceInArabic =
          widget.question!.incompleteSentenceInArabic ?? "";
      originalQuestionEnglish = widget.question!.questionTextInEnglish ?? "";
      originalQuestionArabic = widget.question!.questionTextInArabic ?? "";
      answer = widget.question!.answer!.answer!;
      incompleteSentenceInEnglishController.text =
          originalIncompleteSentenceInEnglish!;
      incompleteSentenceInArabicController.text =
          originalIncompleteSentenceInArabic!;
      questionEnglishController.text = originalQuestionEnglish!;
      questionArabicController.text = originalQuestionArabic!;
      formattedTextInEnglish = originalIncompleteSentenceInEnglish!;
      formattedTextInArabic = originalIncompleteSentenceInArabic!;
      parseInitialFormattedText(originalIncompleteSentenceInEnglish!,
          isEnglish: true);
      parseInitialFormattedText(originalIncompleteSentenceInArabic!,
          isEnglish: false);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _validateForm();
    });
  }

  void parseInitialFormattedText(String text, {bool isEnglish = true}) {
    RegExp blankRegex = RegExp(
        r'\{\{blank\|(.*?)\}\}'); // Adjust regex based on your actual format
    Iterable<RegExpMatch> matches = blankRegex.allMatches(text);

    for (var match in matches) {
      int start = match.start;
      int end = match.end;
      String answer = match.group(1) ?? "";

      if (isEnglish) {
        englishBlankStart = start;
        englishBlankEnd = end;
      } else {
        arabicBlankStart = start;
        arabicBlankEnd = end;
      }

      // Assuming you have a method in RichTextfield to set initial state
      if (isEnglish) {
        // Set initial state for English RichTextfield
      } else {
        // Set initial state for Arabic RichTextfield
      }
    }
  }

  void _validateForm() {
    bool formValid =
        (_formKey.currentState?.validate() ?? false) && answer.isNotEmpty;
    bool changesMade = _checkForChanges();
    setState(() {
      isFormValid = formValid && (widget.question == null || changesMade);
      if (changesMade) {
        updateMessage = null;
      }
    });
  }

  bool _checkForChanges() {
    return questionEnglishController.text != originalQuestionEnglish ||
        questionArabicController.text != originalQuestionArabic ||
        incompleteSentenceInEnglishController.text !=
            originalIncompleteSentenceInEnglish ||
        incompleteSentenceInArabicController.text !=
            originalIncompleteSentenceInArabic ||
        englishBlankStart != originalEnglishBlankStart ||
        englishBlankEnd != originalEnglishBlankEnd ||
        formattedTextInEnglish != originalIncompleteSentenceInEnglish ||
        formattedTextInArabic != originalIncompleteSentenceInArabic;
  }

  @override
  void dispose() {
    questionEnglishController.dispose();
    questionArabicController.dispose();
    incompleteSentenceInEnglishController.dispose();
    incompleteSentenceInArabicController.dispose();
    super.dispose();
  }

  void insertBlank(TextEditingController controller,
      {bool isEnglishField = true}) {
    if (controller.selection ==
        TextSelection(baseOffset: -1, extentOffset: -1)) {
      return;
    }
    final selection = controller.selection;
    if (isEnglishField) {
      englishBlankStart = selection.start;
      englishBlankEnd = selection.end;
      answer = controller.text.substring(englishBlankStart, englishBlankEnd);
    } else {
      arabicBlankStart = selection.start;
      arabicBlankEnd = selection.end;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FillTheBlanksViewModel(),
      child: Consumer<FillTheBlanksViewModel>(
        builder: (context, viewmodel, child) {
          return Form(
            onChanged: _validateForm,
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                      "Select part of the sentence and press the 'insert blank' button to insert a blank.",
                      style: TextStyles.bodyMedium),
                  SizedBox(
                    height: 10.h,
                  ),
                  RichTextfield(
                    initialAnswer: answer,
                    isRequired: true,
                    type: QuestionTextFormFieldType.both,
                    onChanged: (answer, formattedText) {
                      this.answer = answer;
                      formattedTextInEnglish = formattedText;
                      print("Answer: $answer, formattedText: $formattedText");
                      _validateForm();
                    },
                    controller: incompleteSentenceInEnglishController,
                  ),
                  SizedBox(height: 10.h),
                  RichTextfield(
                    isRequired: true,
                    isArabicText: true,
                    type: QuestionTextFormFieldType.both,
                    controller: incompleteSentenceInArabicController,
                    onChanged: (answer, formattedText) {
                      formattedTextInArabic = formattedText;
                      print("Answer: $answer, formattedText: $formattedText");
                      _validateForm();
                    },
                  ),
                  SizedBox(height: 10.h),
                  TextFormField(
                    controller: questionEnglishController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Question in English",
                      hintText: "Enter the question in English",
                    ),
                  ),
                  SizedBox(height: 10.h),
                  TextFormField(
                    controller: questionArabicController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Question in Arabic",
                      hintText: "Enter the question in Arabic",
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _updateButton(viewmodel),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _updateButton(FillTheBlanksViewModel viewmodel) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Button(
              onPressed: isFormValid
                  ? () {
                      if (_formKey.currentState!.validate()) {
                        final newEnglishText = formattedTextInEnglish;
                        final arabicText = formattedTextInArabic;

                        viewmodel
                            .submitForm(
                          incompleteSentenceInEnglish: newEnglishText,
                          incompleteSentenceInArabic:
                              arabicText.isEmpty ? null : arabicText,
                          answer: answer.trim(),
                          questionTextInEnglish:
                              questionEnglishController.text.trim(),
                          questionTextInArabic:
                              questionArabicController.text.trim().isEmpty
                                  ? null
                                  : questionArabicController.text.trim(),
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
                              showConfirmSubmitModalSheet(
                                  context: context,
                                  onSubmit: () {
                                    viewmodel
                                        .uploadQuestion(
                                      level: widget.level,
                                      section: widget.section,
                                      day: widget.day,
                                      question: updatedQuestion,
                                    )
                                        .then((_) {
                                      Utils.showSnackbar(
                                          text:
                                              "Question uploaded successfully");
                                    });
                                    if (widget.onSubmit != null) {
                                      widget.onSubmit!(updatedQuestion);
                                    }
                                  },
                                  question: updatedQuestion);
                            }
                          } else {
                            print("not working");
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
            if (!isFormValid)
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: isFormValid
                        ? null
                        : () {
                            setState(() {
                              updateMessage =
                                  "Please make changes to update the question.";
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
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
      ],
    );
  }
}
