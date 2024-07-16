import 'package:cached_network_image/cached_network_image.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/models/multiple_choice_question_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ez_english/features/home/content/data_entry_forms/radio_group_form.dart';
import 'package:ez_english/features/home/content/viewmodels/multiple_choice_viewmodel.dart';

class MultipleChoiceForm extends StatelessWidget {
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

  final _formKey = GlobalKey<FormState>();
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

  @override
  Widget build(BuildContext context) {
    if (question != null) {
      // Pre-fill the form fields with existing question data
      questionEnglishController.text = question!.questionTextInEnglish ?? '';
      questionArabicController.text = question!.questionTextInArabic ?? '';
      questionSentenceEnglishController.text =
          question!.questionSentenceInEnglish ?? '';
      questionSentenceArabicController.text =
          question!.questionSentenceInArabic ?? '';
      titleInEnglishController.text = question!.titleInEnglish ?? '';
    }

    return ChangeNotifierProvider(
      create: (_) => MultipleChoiceViewModel(),
      child: Consumer<MultipleChoiceViewModel>(
        builder: (context, viewModel, child) {
          if (question != null && viewModel.answers.isEmpty) {
            // Pre-fill the answers and selected answer
            viewModel.updateAnswerInEditMode(
                question!.options, question!.answer!.answer!);
          }

          return Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: questionEnglishController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Question in English",
                    hintText: "Enter the question in English",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the question in English';
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
                    labelText: "Question in Arabic",
                    hintText: "Enter the question in Arabic",
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: questionSentenceEnglishController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Question Sentence in English",
                    hintText: "Enter the question sentence in English",
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: questionSentenceArabicController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Question Sentence in Arabic",
                    hintText: "Enter the question sentence in Arabic",
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: titleInEnglishController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Title in English",
                    hintText: "Enter the title in English",
                  ),
                ),
                const SizedBox(height: 10),
                question != null &&
                        viewModel.image == null &&
                        question!.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: question!.imageUrl!,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                      )
                    : viewModel.image == null
                        ? const Text("No image selected.")
                        : Image.file(viewModel.image!, height: 100, width: 100),
                ElevatedButton(
                  onPressed: viewModel.pickImage,
                  child: const Text("Upload Image from Gallery"),
                ),
                const SizedBox(height: 10),
                RadioGroupForm(
                  onChanged: (newSelection) {
                    viewModel.selectedAnswer = newSelection;
                  },
                  onAnswerUpdated: viewModel.updateAnswer,
                  onDeleteItem: viewModel.deleteAnswer,
                  options: viewModel.answers,
                  selectedOption: viewModel.selectedAnswer,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (viewModel.answerCount < viewModel.maxAnswers) {
                      viewModel.addAnswer();
                    }
                  },
                  child: const Text("Add answer"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final updatedQuestion = await viewModel.submitForm(
                          questionTextInEnglish:
                              questionEnglishController.text.trim().isEmpty
                                  ? null
                                  : questionEnglishController.text.trim(),
                          questionTextInArabic:
                              questionArabicController.text.trim().isEmpty
                                  ? null
                                  : questionArabicController.text.trim(),
                          questionSentenceInEnglish:
                              questionSentenceEnglishController.text
                                      .trim()
                                      .isEmpty
                                  ? null
                                  : questionSentenceEnglishController.text
                                      .trim(),
                          questionSentenceInArabic:
                              questionSentenceArabicController.text
                                      .trim()
                                      .isEmpty
                                  ? null
                                  : questionSentenceArabicController.text
                                      .trim(),
                          titleInEnglish:
                              titleInEnglishController.text.trim().isEmpty
                                  ? null
                                  : titleInEnglishController.text.trim(),
                          imageUrlInEditMode: question?.imageUrl);
                      if (updatedQuestion != null) {
                        if (onSubmit != null) {
                          updatedQuestion.path = question?.path ?? '';
                          onSubmit!(updatedQuestion);
                        } else {
                          await viewModel.uploadQuestion(
                            level: levelName,
                            section: sectionName,
                            day: dayNumber,
                            question: updatedQuestion!,
                          );
                        }
                        print("Question added to Firebase");
                      }
                    } else {
                      print("Form validation failed.");
                    }
                  },
                  child: Text(question == null ? "Submit" : "Update"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
