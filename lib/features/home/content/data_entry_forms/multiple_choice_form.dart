import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:ez_english/features/home/content/data_entry_forms/dictation_question_form.dart';
import 'package:ez_english/features/home/content/data_entry_forms/radio_group_form.dart';
import 'package:ez_english/features/home/content/viewmodels/multiple_choice_viewmodel.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/models/multiple_choice_answer.dart';
import 'package:ez_english/features/sections/models/multiple_choice_question_model.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/utils/utils.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:ez_english/widgets/radio_button.dart';
import 'package:ez_english/widgets/rich_textfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MultipleChoiceForm extends StatefulWidget {
  final String levelName;
  final String sectionName;
  final String dayNumber;
  final Function(BaseQuestion<dynamic>)? onSubmit;
  final MultipleChoiceQuestionModel? question;

  MultipleChoiceForm({
    Key? key,
    required this.levelName,
    required this.sectionName,
    required this.dayNumber,
    this.onSubmit,
    this.question,
  }) : super(key: key);

  @override
  State<MultipleChoiceForm> createState() => _MultipleChoiceFormState();
}

class _MultipleChoiceFormState extends State<MultipleChoiceForm> {
  final _formKey = GlobalKey<FormState>();

  bool isSubformValid = false;
  bool isFormValid = false;

  String? originalQuestionTextInEnglish;
  String? originalQuestionTextInArabic;
  String? originalQuestionSentenceInEnglish;
  String? originalQuestionSentenceInArabic;
  String? originalTitleInEnglish;
  List<RadioItemData>? originalOptions;
  RadioItemData? originalAnswer;

  File? currentImage;
  File? originalImage;

  String? currentImageURL;
  String? originalImageURL;

  String? updateMessage;

  String formattedTextInEnglish = "";
  String formattedTextInArabic = "";

  final TextEditingController questionEnglishController =
      TextEditingController();
  final TextEditingController questionArabicController =
      TextEditingController();
  final TextEditingController questionSentenceEnglishController =
      TextEditingController();
  final TextEditingController questionSentenceArabicController =
      TextEditingController();
  final TextEditingController titleInEnglishController =
      TextEditingController();
  List<RadioItemData>? options;
  RadioItemData? answer;
  @override
  void initState() {
    super.initState();

    if (widget.question != null) {
      // Pre-fill the form fields with existing question data
      questionEnglishController.text =
          widget.question!.questionTextInEnglish ?? '';
      questionArabicController.text =
          widget.question!.questionTextInArabic ?? '';
      questionSentenceEnglishController.text =
          widget.question!.questionSentenceInEnglish ?? '';
      questionSentenceArabicController.text =
          widget.question!.questionSentenceInArabic ?? '';
      titleInEnglishController.text = widget.question!.titleInEnglish ?? '';
      originalQuestionTextInEnglish =
          widget.question!.questionTextInEnglish ?? '';
      originalQuestionTextInArabic =
          widget.question!.questionTextInArabic ?? '';
      originalQuestionSentenceInEnglish =
          widget.question!.questionSentenceInEnglish ?? '';
      originalQuestionSentenceInArabic =
          widget.question!.questionSentenceInArabic ?? '';
      originalTitleInEnglish = widget.question!.titleInEnglish ?? '';
      originalOptions = widget.question?.options
              .map((option) => RadioItemData.copy(option))
              .toList() ??
          [];
      options = widget.question?.options
              .map((option) => RadioItemData.copy(option))
              .toList() ??
          [];
      originalAnswer = RadioItemData.copy(widget.question!.answer!.answer!);
      answer = RadioItemData.copy(widget.question!.answer!.answer!);
      originalImageURL = widget.question!.imageUrl;
      currentImageURL = widget.question!.imageUrl;
    } else {
      options = [];
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _validateForm();
    });
  }

  @override
  void dispose() {
    questionEnglishController.dispose();
    questionArabicController.dispose();
    questionSentenceEnglishController.dispose();
    questionSentenceArabicController.dispose();
    titleInEnglishController.dispose();
    super.dispose();
  }

  void updateQuestion(MultipleChoiceQuestionModel updatedQuestion) {
    if (widget.question != null) {
      if (questionEnglishController.text != originalQuestionTextInEnglish) {
        widget.question!.questionTextInEnglish = questionEnglishController.text;
      }
      if (questionArabicController.text != originalQuestionTextInArabic) {
        widget.question!.questionTextInArabic = questionArabicController.text;
      }
      if (questionSentenceEnglishController.text !=
          originalQuestionSentenceInEnglish) {
        widget.question!.questionSentenceInEnglish =
            questionSentenceEnglishController.text;
      }
      if (questionSentenceArabicController.text !=
          originalQuestionSentenceInArabic) {
        widget.question!.questionSentenceInArabic =
            questionSentenceArabicController.text;
      }
      if (titleInEnglishController.text != originalTitleInEnglish) {
        widget.question!.titleInEnglish = titleInEnglishController.text;
      }
      if (options != originalOptions) {
        widget.question!.options = options!;
      }
      if (answer != originalAnswer) {
        widget.question!.answer = MultipleChoiceAnswer(answer: answer!);
      }
      if (currentImageURL != originalImageURL) {
        widget.question!.imageUrl = currentImageURL;
      }
    }
  }

  void _validateForm() {
    bool formValid = _formKey.currentState?.validate() ?? false;
    bool changesMade = _checkForChanges();

    setState(() {
      isFormValid = formValid && (widget.question == null || changesMade);
      isSubformValid = widget.question != null
          ? widget.question!.options.isNotEmpty
          : isSubformValid;
      if (changesMade) {
        updateMessage = null;
      }
    });
  }

  bool _checkForChanges() {
    print(
        "${formattedTextInEnglish?.trim()} == $originalQuestionSentenceInEnglish");
    return questionEnglishController.text != originalQuestionTextInEnglish ||
        questionArabicController.text != originalQuestionTextInArabic ||
        questionSentenceEnglishController.text !=
            originalQuestionSentenceInEnglish ||
        questionSentenceArabicController.text !=
            originalQuestionSentenceInArabic ||
        titleInEnglishController.text != originalTitleInEnglish ||
        !listEquals(options, originalOptions) ||
        answer != originalAnswer ||
        currentImage != originalImage ||
        currentImageURL != originalImageURL;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MultipleChoiceViewModel(),
      child: Consumer<MultipleChoiceViewModel>(
        builder: (context, viewmodel, child) {
          if (widget.question != null && viewmodel.shouldSetOptions) {
            viewmodel.updateAnswerInEditMode(
                widget.question!.options
                    .map((option) => RadioItemData.copy(option))
                    .toList(),
                RadioItemData.copy(widget.question!.answer!.answer!));
          }

          return viewmodel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Form(
                  onChanged: _validateForm,
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: questionEnglishController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Question text (English)",
                          hintText: "Ex: \"Answer the following sentence\"",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppStrings.requiredField;
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _validateForm();
                        },
                      ),
                      SizedBox(height: 10.h),
                      TextFormField(
                        controller: questionArabicController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Question text (Arabic)",
                          hintText: "\"أجب على الجملة التالية\"",
                        ),
                        onChanged: (value) {
                          _validateForm();
                        },
                      ),
                      SizedBox(height: 10.h),
                      RichTextfield(
                        isRequired: false,
                        type: QuestionTextFormFieldType.underline,
                        controller: questionSentenceEnglishController,
                        onChanged: (answer, formattedText) {
                          formattedTextInEnglish = formattedText;
                          print(
                              "formattedTextInEnglish: $formattedTextInEnglish");
                          _validateForm();
                        },
                      ),
                      SizedBox(height: 10.h),
                      RichTextfield(
                        isRequired: false,
                        isArabicText: true,
                        type: QuestionTextFormFieldType.underline,
                        controller: questionSentenceArabicController,
                        onChanged: (answer, formattedText) {
                          formattedTextInArabic = formattedText;
                          _validateForm();
                        },
                      ),
                      SizedBox(height: 10.h),
                      GestureDetector(
                        onTap: () async {
                          await viewmodel.pickImage();
                          setState(() {
                            currentImage = viewmodel.image;
                            _validateForm();
                          });
                        },
                        child: Stack(
                          children: [
                            DottedBorder(
                              color: Palette.primaryVariant,
                              strokeWidth: 1,
                              padding: const EdgeInsets.all(0),
                              child: Container(
                                height: 200.h,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 216, 243, 255),
                                ),
                                child: Center(
                                  child: viewmodel.image != null
                                      ? Image.file(viewmodel.image!)
                                      : (viewmodel.showCachedImage &&
                                              widget.question != null &&
                                              widget.question!.imageUrl != null
                                          ? CachedNetworkImage(
                                              imageUrl:
                                                  widget.question!.imageUrl!,
                                              placeholder: (context, url) =>
                                                  const CircularProgressIndicator(),
                                            )
                                          : Text(
                                              "Tap here to pick image",
                                              style: TextStyles.bodyLarge,
                                            )),
                                ),
                              ),
                            ),
                            if (viewmodel.image != null ||
                                viewmodel.showCachedImage)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      viewmodel.removeImage();
                                      currentImage = null;
                                      currentImageURL = null;
                                      _validateForm();
                                    });
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      RadioGroupForm(
                        onFormChanged: (isNewFormValid) {
                          setState(() {
                            isSubformValid = isNewFormValid;
                            _validateForm();
                          });
                        },
                        onSelectionChanged: (newSelection) {
                          viewmodel.setSelectedAnswer(newSelection);
                          setState(() {
                            answer = newSelection;
                          });

                          _validateForm();
                        },
                        onAnswerUpdated: (newAnswer, option) {
                          viewmodel.updateAnswer(newAnswer, option);
                          setState(() {
                            answer?.title = newAnswer;
                          });
                          _validateForm();
                        },
                        onDeleteItem: (option) {
                          viewmodel.deleteAnswer(option);
                          setState(() {
                            if (options!.length > 1) {
                              options!.remove(option);
                            }
                          });
                          _validateForm();
                        },
                        options: viewmodel.answers,
                        selectedOption: viewmodel.selectedAnswer,
                      ),
                      viewmodel.answerCount < viewmodel.maxAnswers
                          ? GestureDetector(
                              onTap: () {
                                viewmodel.addAnswer();
                                setState(() {
                                  isSubformValid = false;
                                  _validateForm();
                                });
                              },
                              child: DottedBorder(
                                color: Palette.primaryVariant,
                                strokeWidth: 1,
                                padding: const EdgeInsets.all(0),
                                child: Container(
                                  height: 50.h,
                                  decoration: const BoxDecoration(
                                    color: Palette.textFieldFill,
                                  ),
                                  child: Center(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.add,
                                        size: 32,
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Text(
                                        "Add an answer",
                                        style: TextStyles.bodyLarge,
                                      ),
                                    ],
                                  )),
                                ),
                              ),
                            )
                          : const SizedBox(),
                      SizedBox(height: 10.h),
                      _updateButton(viewmodel),
                      SizedBox(
                        height: 10.h,
                      )
                    ],
                  ),
                );
        },
      ),
    );
  }

  Widget _updateButton(MultipleChoiceViewModel viewmodel) {
    bool isEnabled = isFormValid && isSubformValid;

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
                                questionTextInEnglish: questionEnglishController
                                        .text
                                        .trim()
                                        .isEmpty
                                    ? null
                                    : questionEnglishController.text.trim(),
                                questionTextInArabic:
                                    questionArabicController.text.trim().isEmpty
                                        ? null
                                        : questionArabicController.text.trim(),
                                questionSentenceInEnglish:
                                    formattedTextInEnglish.trim().isEmpty
                                        ? null
                                        : formattedTextInEnglish.trim(),
                                questionSentenceInArabic:
                                    formattedTextInArabic.trim().isEmpty
                                        ? null
                                        : formattedTextInArabic.trim(),
                                titleInEnglish:
                                    titleInEnglishController.text.trim().isEmpty
                                        ? null
                                        : titleInEnglishController.text.trim(),
                                imageUrlInEditMode: widget.question?.imageUrl)
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
                                      level: widget.levelName,
                                      section: widget.sectionName,
                                      day: widget.dayNumber,
                                      question: updatedQuestion,
                                    )
                                        .then((_) {
                                      Utils.showSnackbar(
                                        text: "Question added successfully",
                                      );
                                      _formKey.currentState!.reset();
                                      resetForm(viewmodel.reset);
                                    });
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
        if (updateMessage != null) // Display the message if it's not null
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              updateMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
      ],
    );
  }

  void resetForm(VoidCallback resetViewmodel) {
    setState(() {
      questionEnglishController.clear();
      questionArabicController.clear();
      questionSentenceEnglishController.clear();
      questionSentenceArabicController.clear();
      titleInEnglishController.clear();
      options = [];
      resetViewmodel();
      answer = null;
      currentImage = null;
      currentImageURL = null;
      isFormValid = false;
      isSubformValid = false;
      updateMessage = null;
    });
  }
}
