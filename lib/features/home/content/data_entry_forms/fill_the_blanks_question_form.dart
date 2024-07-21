// ignore_for_file: prefer_const_constructors

import 'package:ez_english/features/home/content/data_entry_forms/dictation_question_form.dart';
import 'package:ez_english/features/home/content/viewmodels/fill_the_blanks_question_viewmodel.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/models/fill_the_blanks_question_model.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/utils/utils.dart';
import 'package:ez_english/widgets/button.dart';
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

  @override
  void initState() {
    super.initState();

    if (widget.question != null) {
      int? startIndexOfEnglishWord =
          widget.question!.incompleteSentenceInEnglish?.indexOf("_____");
      if (startIndexOfEnglishWord != -1) {
        englishBlankStart = originalEnglishBlankStart =
            startIndexOfEnglishWord ?? englishBlankStart;
        englishBlankEnd =
            (startIndexOfEnglishWord ?? englishBlankEnd) + "_____".length;
      }

      final newText = widget.question!.incompleteSentenceInEnglish
          ?.replaceRange(englishBlankStart, englishBlankEnd,
              widget.question!.answer!.answer!);

      englishBlankEnd = originalEnglishBlankEnd =
          startIndexOfEnglishWord! + widget.question!.answer!.answer!.length;

      // TODO: add the Arabic word with blank to the API
      //       var startIndexOfArabicWord = widget.question!.incompleteSentenceInArabic
      //     ?.indexOf(widget.question!.answer!.answer!);
      // if (startIndexOfEnglishWord != -1) {
      //   englishBlankStart = startIndexOfEnglishWord ?? englishBlankStart;
      //   englishBlankEnd = (startIndexOfEnglishWord ?? englishBlankEnd) +
      //       widget.question!.answer!.answer!.length;
      // }

      incompleteSentenceInEnglishController.text =
          originalIncompleteSentenceInEnglish = newText ?? "";
      incompleteSentenceInArabicController.text =
          originalIncompleteSentenceInArabic =
              widget.question!.incompleteSentenceInArabic ?? "";
      questionEnglishController.text = originalQuestionEnglish =
          widget.question!.questionTextInEnglish ?? "";
      questionArabicController.text =
          originalQuestionArabic = widget.question!.questionTextInArabic ?? "";
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _validateForm();
    });
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
    return questionEnglishController.text != originalQuestionEnglish ||
        questionArabicController.text != originalQuestionArabic ||
        incompleteSentenceInEnglishController.text !=
            originalIncompleteSentenceInEnglish ||
        incompleteSentenceInArabicController.text !=
            originalIncompleteSentenceInArabic ||
        englishBlankStart != originalEnglishBlankStart ||
        englishBlankEnd != originalEnglishBlankEnd;
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
                  TextFormField(
                    controller: incompleteSentenceInEnglishController,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: "Full sentence (English)",
                        hintText: "Ex: \"The boy kicks the ball.\"",
                        suffixIcon: TextButton(
                          onPressed: () {
                            insertBlank(incompleteSentenceInEnglishController);
                            _validateForm();
                          },
                          child: const Text("Insert blank"),
                        )),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the incomplete sentence in English';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    width: double.infinity,
                    height: 70.h,
                    child: Column(
                      children: [
                        Text.rich(
                          style: TextStyles.bodyLarge,
                          TextSpan(
                            children: [
                              TextSpan(
                                text: incompleteSentenceInEnglishController.text
                                    .substring(0, englishBlankStart),
                                style: const TextStyle(color: Colors.black),
                              ),
                              TextSpan(
                                text: '_____',
                                style:
                                    const TextStyle(color: Palette.primaryText),
                              ),
                              TextSpan(
                                text: incompleteSentenceInEnglishController.text
                                    .substring(englishBlankEnd),
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        Text(
                            "Answer: ${incompleteSentenceInEnglishController.text.substring(englishBlankStart, englishBlankEnd)}",
                            style: TextStyles.bodyLarge)
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: incompleteSentenceInArabicController,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: "Full sentence (Arabic)",
                        hintText: "Enter the incomplete sentence in Arabic",
                        suffixIcon: TextButton(
                          onPressed: () {
                            insertBlank(incompleteSentenceInArabicController,
                                isEnglishField: false);
                          },
                          child: const Text("Insert blank"),
                        )),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    width: double.infinity,
                    height: 70.h,
                    child: Column(
                      children: [
                        Text.rich(
                          style: TextStyles.bodyLarge,
                          TextSpan(
                            children: [
                              TextSpan(
                                text: incompleteSentenceInArabicController.text
                                    .substring(0, arabicBlankStart),
                                style: const TextStyle(color: Colors.black),
                              ),
                              TextSpan(
                                text: '_____',
                                style:
                                    const TextStyle(color: Palette.primaryText),
                              ),
                              TextSpan(
                                text: incompleteSentenceInArabicController.text
                                    .substring(arabicBlankEnd),
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        Text(
                            "Answer: ${incompleteSentenceInArabicController.text.substring(arabicBlankStart, arabicBlankEnd)}",
                            style: TextStyles.bodyLarge)
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: questionEnglishController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Question in English",
                      hintText: "Enter the question in English",
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: questionArabicController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Question in Arabic",
                      hintText: "Enter the question in Arabic",
                    ),
                  ),
                  const SizedBox(height: 10),
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
                        final text =
                            incompleteSentenceInEnglishController.text.trim();

                        final newText = text.replaceRange(
                            englishBlankStart, englishBlankEnd, '_____');
                        viewmodel
                            .submitForm(
                          incompleteSentenceInEnglish: newText,
                          incompleteSentenceInArabic:
                              incompleteSentenceInArabicController.text
                                      .trim()
                                      .isEmpty
                                  ? null
                                  : incompleteSentenceInArabicController.text
                                      .trim(),
                          answer: incompleteSentenceInEnglishController.text
                              .substring(englishBlankStart, englishBlankEnd)
                              .trim(),
                          questionTextInEnglish:
                              questionEnglishController.text.trim(),
                          questionTextInArabic:
                              questionArabicController.text.trim().isEmpty
                                  ? null
                                  : questionArabicController.text.trim(),
                        )
                            .then((updatedQuestion) {
                          if (updatedQuestion != null) {
                            if (widget.onSubmit != null) {
                              updatedQuestion.path =
                                  widget.question?.path ?? '';
                              widget.onSubmit!(updatedQuestion);
                            } else {
                              showConfirmSubmitModalSheet(
                                  context: context,
                                  onSubmit: () async {
                                    await viewmodel
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
                          }
                        });
                      } else {
                        Utils.showErrorSnackBar(
                          "Please select an answer as the correct answer.",
                        );
                      }
                    }
                  : null,
              text: "Update",
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
            padding: const EdgeInsets.all(8.0),
            child: Text(
              updateMessage!,
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
      ],
    );
  }
}
