import 'package:ez_english/features/home/content/viewmodels/fill_the_blanks_question_viewmodel.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FillTheBlanksForm extends StatelessWidget {
  final String level;
  final String section;
  final String day;
  final Function(BaseQuestion<dynamic>)? onSubmit;

  FillTheBlanksForm({
    super.key,
    required this.level,
    required this.section,
    required this.day,
    this.onSubmit,
  });

  final _formKey = GlobalKey<FormState>();
  final TextEditingController incompleteSentenceInEnglishController =
      TextEditingController();
  final TextEditingController incompleteSentenceInArabicController =
      TextEditingController();
  final TextEditingController answerController = TextEditingController();
  final TextEditingController questionEnglishController =
      TextEditingController();
  final TextEditingController questionArabicController =
      TextEditingController();
  void insertBlank(TextEditingController controller) {
    final text = controller.text;
    final selection = controller.selection;
    final newText = text.replaceRange(selection.start, selection.end, '_____');
    controller.text = newText;
    controller.selection =
        TextSelection.fromPosition(TextPosition(offset: selection.start + 5));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FillTheBlanksViewModel(),
      child: Consumer<FillTheBlanksViewModel>(
        builder: (context, viewModel, child) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: incompleteSentenceInEnglishController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Incomplete Sentence in English",
                      hintText: "Enter the incomplete sentence in English",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () =>
                            insertBlank(incompleteSentenceInEnglishController),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the incomplete sentence in English';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: incompleteSentenceInArabicController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Incomplete Sentence in Arabic",
                      hintText: "Enter the incomplete sentence in Arabic",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () =>
                            insertBlank(incompleteSentenceInArabicController),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: answerController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Answer",
                      hintText: "Enter the answer",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the answer';
                      }
                      return null;
                    },
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
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final question = await viewModel.submitForm(
                          incompleteSentenceInEnglish:
                              incompleteSentenceInEnglishController.text.trim(),
                          incompleteSentenceInArabic:
                              incompleteSentenceInArabicController.text
                                      .trim()
                                      .isEmpty
                                  ? null
                                  : incompleteSentenceInArabicController.text
                                      .trim(),
                          answer: answerController.text.trim(),
                          questionTextInEnglish:
                              questionEnglishController.text.trim(),
                          questionTextInArabic:
                              questionArabicController.text.trim().isEmpty
                                  ? null
                                  : questionArabicController.text.trim(),
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
            ),
          );
        },
      ),
    );
  }
}
