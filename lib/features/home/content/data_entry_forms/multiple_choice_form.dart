import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:ez_english/features/home/content/data_entry_forms/dictation_question_form.dart';
import 'package:ez_english/features/home/content/data_entry_forms/radio_group_form.dart';
import 'package:ez_english/features/home/content/viewmodels/multiple_choice_viewmodel.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/models/multiple_choice_question_model.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/utils/utils.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:ez_english/widgets/radio_button.dart';
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
  void _validateForm() {
    setState(() {
      isFormValid = _formKey.currentState?.validate() ?? false;
    });
  }

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
  late List<RadioItemData>? options;
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
      options = widget.question!.options;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MultipleChoiceViewModel(),
      child: Consumer<MultipleChoiceViewModel>(
        builder: (context, viewmodel, child) {
          if (widget.question != null && viewmodel.shouldSetOptions) {
            // Pre-fill the answers and selected answer
            print("${options?.map((option) => option.title)}");
            viewmodel.updateAnswerInEditMode(
                widget.question!.options, widget.question!.answer!.answer!);
          }

          return Form(
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
                    labelText: "Question text (Egnlish)",
                    hintText: "Ex: \"Answer the following sentence\"",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.requiredField;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: questionArabicController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Question text (Arabic)",
                    hintText: "\"أجب على الجملة التالية\"",
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: questionSentenceEnglishController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Question sentence (English)",
                    hintText: "\"What did Ali eat for breakfast?\"",
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: questionSentenceArabicController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Question Sentence (Arabic)",
                    hintText: "\"ماذا تناول علي على الإفطار؟\"",
                  ),
                ),

                // TODO: remove this field
                // const SizedBox(height: 10),
                // TextFormField(
                //   controller: titleInEnglishController,
                //   decoration: const InputDecoration(
                //     border: OutlineInputBorder(),
                //     labelText: "Question title",
                //     hintText: "Enter the question title",
                //   ),
                // ),
                const SizedBox(height: 10),
                // question != null &&
                //         viewModel.image == null &&
                //         question!.imageUrl != null
                //     ? CachedNetworkImage(
                //         imageUrl: question!.imageUrl!,
                //         placeholder: (context, url) =>
                //             const CircularProgressIndicator(),
                //       )
                //     : viewModel.image == null
                //         ? const Text("No image selected.")
                //         : Image.file(viewModel.image!),
                const SizedBox(height: 10),
                // GestureDetector(
                //   onTap: viewModel.pickImage,
                //   child: DottedBorder(
                //     color: Palette.primaryVariant,
                //     strokeWidth: 1,
                //     padding: const EdgeInsets.all(0),
                //     child: Container(
                //       height: 200.h,
                //       decoration: const BoxDecoration(
                //         color: Color.fromARGB(255, 216, 243, 255),
                //       ),
                //       child: Center(
                //           child: Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           const Icon(
                //             Icons.add,
                //             size: 32,
                //           ),
                //           SizedBox(
                //             width: 10.w,
                //           ),
                //           Text(
                //             "Tap here to pick image",
                //             style: TextStyles.bodyLarge,
                //           ),
                //         ],
                //       )),
                //     ),
                //   ),
                // ),
                GestureDetector(
                  onTap: viewmodel.pickImage,
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
                                : (widget.question != null &&
                                        widget.question!.imageUrl != null
                                    ? CachedNetworkImage(
                                        imageUrl: widget.question!.imageUrl!,
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
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            viewmodel.removeImage();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                RadioGroupForm(
                  onFormChanged: (isNewFormValid) {
                    isSubformValid = isNewFormValid;
                  },
                  onSelectionChanged: (newSelection) {
                    viewmodel.setSelectedAnswer(newSelection);
                  },
                  onAnswerUpdated: viewmodel.updateAnswer,
                  onDeleteItem: viewmodel.deleteAnswer,
                  options: viewmodel.answers,
                  selectedOption: viewmodel.selectedAnswer,
                ),
                viewmodel.answerCount < viewmodel.maxAnswers
                    ? GestureDetector(
                        onTap: () {
                          viewmodel.addAnswer();
                          isSubformValid = false;
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
                const SizedBox(height: 10),
                Button(
                  onPressed: isFormValid && isSubformValid
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
                                    questionTextInArabic: questionArabicController
                                            .text
                                            .trim()
                                            .isEmpty
                                        ? null
                                        : questionArabicController.text.trim(),
                                    questionSentenceInEnglish:
                                        questionSentenceEnglishController.text
                                                .trim()
                                                .isEmpty
                                            ? null
                                            : questionSentenceEnglishController
                                                .text
                                                .trim(),
                                    questionSentenceInArabic:
                                        questionSentenceArabicController.text
                                                .trim()
                                                .isEmpty
                                            ? null
                                            : questionSentenceArabicController.text
                                                .trim(),
                                    titleInEnglish: titleInEnglishController
                                            .text
                                            .trim()
                                            .isEmpty
                                        ? null
                                        : titleInEnglishController.text.trim(),
                                    imageUrlInEditMode:
                                        widget.question?.imageUrl)
                                .then((updatedQuestion) {
                              if (updatedQuestion != null) {
                                if (widget.onSubmit != null) {
                                  updatedQuestion.path =
                                      widget.question?.path ?? '';
                                  widget.onSubmit!(updatedQuestion);
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
                                        });
                                      },
                                      question: updatedQuestion);
                                  // TODO: reflect changes in the UI using snackbar
                                }
                              }
                            });
                          } else {
                            Utils.showErrorSnackBar(
                              "Please select an answer as the correct answer.",
                            );
                            print("Form validation failed.");
                          }
                        }
                      : null,
                  text: widget.question == null ? "Submit" : "Update",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
