import 'package:ez_english/features/home/content/data_entry_forms/dictation_question_form.dart';
import 'package:ez_english/features/home/content/viewmodels/vocabulary_question_viewmodel.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/models/word_definition.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VocabularyForm extends StatefulWidget {
  final String level;
  final String section;
  final String day;
  final Function(BaseQuestion<dynamic>)? onSubmit;

  VocabularyForm({
    super.key,
    required this.level,
    required this.section,
    required this.day,
    this.onSubmit,
  });

  @override
  State<VocabularyForm> createState() => _VocabularyFormState();
}

class _VocabularyFormState extends State<VocabularyForm> {
  final _formKey = GlobalKey<FormState>();
  bool isFormValid = false;
  void _validateForm() {
    setState(() {
      isFormValid = _formKey.currentState?.validate() ?? false;
    });
  }

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
            onChanged: _validateForm,
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
                Button(
                  onPressed: isFormValid
                      ? () async {
                          if (_formKey.currentState!.validate()) {
                            final question = await viewModel.submitForm(
                              englishWord: englishWordController.text.trim(),
                              arabicWord:
                                  arabicWordController.text.trim().isEmpty
                                      ? null
                                      : arabicWordController.text.trim(),
                              type: viewModel.selectedWordType!,
                              exampleUsageInEnglish:
                                  exampleUsageInEnglishController
                                          .text
                                          .trim()
                                          .isEmpty
                                      ? null
                                      : [
                                          exampleUsageInEnglishController.text
                                              .trim()
                                        ],
                              exampleUsageInArabic:
                                  exampleUsageInArabicController.text
                                          .trim()
                                          .isEmpty
                                      ? null
                                      : [
                                          exampleUsageInArabicController.text
                                              .trim()
                                        ],
                            );
                            if (question != null) {
                              if (widget.onSubmit != null) {
                                widget.onSubmit!(question);
                              } else {
                                showConfirmSubmitModalSheet(
                                  context: context,
                                  onSubmit: () {
                                    viewModel.uploadQuestion(
                                      level: widget.level,
                                      section: widget.section,
                                      day: widget.day,
                                      question: question,
                                    );
                                  },
                                  question: question,
                                );
                              }
                            } else {
                              print("Form validation failed.");
                            }
                          } else {
                            print("Please fill all the required fields");
                          }
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
