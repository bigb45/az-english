import 'package:ez_english/features/home/content/viewmodels/youtube_question_viewmodel.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class YoutubeLessonForm extends StatelessWidget {
  final String level;
  final String section;
  final String day;
  final Function(BaseQuestion<dynamic>)? onSubmit;

  YoutubeLessonForm({
    super.key,
    required this.level,
    required this.section,
    required this.day,
    this.onSubmit,
  });

  final _formKey = GlobalKey<FormState>();
  final TextEditingController youtubeUrlController = TextEditingController();
  final TextEditingController titleInEnglishController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => YoutubeLessonViewModel(),
      child: Consumer<YoutubeLessonViewModel>(
        builder: (context, viewModel, child) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: youtubeUrlController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "YouTube URL",
                    hintText: "Enter the YouTube URL",
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !RegExp(
                          r'^(https?\:\/\/)?(www\.)?(youtube\.com\/watch\?v=|youtu\.be\/)[a-zA-Z0-9_-]{11}$',
                        ).hasMatch(value)) {
                      return 'Please enter a valid YouTube video URL';
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
                        youtubeUrl: youtubeUrlController.text.trim().isEmpty
                            ? null
                            : youtubeUrlController.text.trim(),
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
