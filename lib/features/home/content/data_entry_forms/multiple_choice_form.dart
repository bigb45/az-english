// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ez_english/features/home/content/data_entry_forms/radio_group_form.dart';
import 'package:ez_english/features/home/content/viewmodels/multiple_choice_viewmodel.dart';

class MultipleChoiceForm extends StatelessWidget {
  String levelName;
  String sectionName;
  String dayNumber;
  MultipleChoiceForm({
    Key? key,
    required this.levelName,
    required this.sectionName,
    required this.dayNumber,
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
    return ChangeNotifierProvider(
      create: (_) => MultipleChoiceViewModel(),
      child: Consumer<MultipleChoiceViewModel>(
        builder: (context, viewModel, child) {
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
                viewModel.image == null
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
                    await viewModel.submitForm(
                      questionTextInEnglish:
                          questionEnglishController.text.trim().isEmpty
                              ? null
                              : questionEnglishController.text.trim(),
                      questionTextInArabic:
                          questionArabicController.text.trim().isEmpty
                              ? null
                              : questionArabicController.text.trim(),
                      questionSentenceInEnglish:
                          questionSentenceEnglishController.text.trim().isEmpty
                              ? null
                              : questionSentenceEnglishController.text.trim(),
                      questionSentenceInArabic:
                          questionSentenceArabicController.text.trim().isEmpty
                              ? null
                              : questionSentenceArabicController.text.trim(),
                      titleInEnglish:
                          titleInEnglishController.text.trim().isEmpty
                              ? null
                              : titleInEnglishController.text.trim(),
                      level: levelName,
                      section: sectionName,
                      day: dayNumber,
                    );
                  },
                  child: const Text("Submit"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
