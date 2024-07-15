import 'package:ez_english/features/home/content/viewmodels/vocabulary_question_viewmodel.dart';
import 'package:ez_english/features/sections/models/word_definition.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VocabularyForm extends StatelessWidget {
  final String level;
  final String section;
  final String day;

  VocabularyForm({
    super.key,
    required this.level,
    required this.section,
    required this.day,
  });

  final _formKey = GlobalKey<FormState>();
  final TextEditingController englishWordController = TextEditingController();
  final TextEditingController arabicWordController = TextEditingController();
  final TextEditingController exampleUsageInEnglishController =
      TextEditingController();
  final TextEditingController exampleUsageInArabicController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VocabularyViewModel(),
      child: Consumer<VocabularyViewModel>(
        builder: (context, viewModel, child) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: englishWordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "English Word",
                    hintText: "Enter the English word",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the English word';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: arabicWordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Arabic Word",
                    hintText: "Enter the Arabic word",
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<WordType>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Word Type",
                    hintText: "Select the word type",
                  ),
                  value: viewModel.selectedWordType,
                  items: WordType.values.map((WordType type) {
                    return DropdownMenuItem<WordType>(
                      value: type,
                      child: Text(type.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (WordType? newValue) {
                    viewModel.setSelectedWordType(newValue);
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select the word type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                if (viewModel.selectedWordType == WordType.verb ||
                    viewModel.selectedWordType == WordType.word) ...[
                  TextFormField(
                    controller: exampleUsageInEnglishController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Example Usage in English",
                      hintText: "Enter example usage in English",
                    ),
                    validator: (value) {
                      if (viewModel.selectedWordType != WordType.sentence &&
                          (value == null || value.isEmpty)) {
                        return 'Please enter example usage in English';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: exampleUsageInArabicController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Example Usage in Arabic",
                      hintText: "Enter example usage in Arabic",
                    ),
                    validator: (value) {
                      if (viewModel.selectedWordType != WordType.sentence &&
                          (value == null || value.isEmpty)) {
                        return 'Please enter example usage in Arabic';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final question = await viewModel.submitForm(
                        englishWord: englishWordController.text.trim(),
                        arabicWord: arabicWordController.text.trim().isEmpty
                            ? null
                            : arabicWordController.text.trim(),
                        type: viewModel.selectedWordType!,
                        exampleUsageInEnglish:
                            exampleUsageInEnglishController.text.trim().isEmpty
                                ? null
                                : [exampleUsageInEnglishController.text.trim()],
                        exampleUsageInArabic:
                            exampleUsageInArabicController.text.trim().isEmpty
                                ? null
                                : [exampleUsageInArabicController.text.trim()],
                      );
                      if (question != null) {
                        await viewModel.uploadQuestion(
                          level: level,
                          section: section,
                          day: day,
                          question: question,
                        );
                        print("Question added to Firebase");
                      } else {
                        print("Form validation failed.");
                      }
                    } else {
                      print("Please fill all the required fields");
                    }
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
