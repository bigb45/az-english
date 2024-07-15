import 'package:ez_english/features/home/content/viewmodels/dictation_question_viewmodel.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DictationQuestionForm extends StatelessWidget {
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

  final _formKey = GlobalKey<FormState>();
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
                  controller: speakableTextController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Speakable Text",
                    hintText: "Enter the speakable text",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the speakable text';
                    }
                    return null;
                  },
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
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final question = await viewModel.submitForm(
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
                      );
                      if (question != null) {
                        if (onSubmit != null) {
                          onSubmit!(question);
                        } else {
                          await viewModel.uploadQuestion(
                            level: level,
                            section: section,
                            day: day,
                            question: question,
                          );
                        }
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
