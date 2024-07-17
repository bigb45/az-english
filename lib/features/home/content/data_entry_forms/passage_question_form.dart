import 'package:ez_english/features/home/content/data_entry_forms/dictation_question_form.dart';
import 'package:ez_english/features/home/content/data_entry_forms/fill_the_blanks_question_form.dart';
import 'package:ez_english/features/home/content/data_entry_forms/multiple_choice_form.dart';
import 'package:ez_english/features/home/content/data_entry_forms/vocabulary_question_form.dart';
import 'package:ez_english/features/home/content/data_entry_forms/youtube_question_form.dart';
import 'package:ez_english/features/home/content/viewmodels/passage_question_viewmodel.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class PassageForm extends StatefulWidget {
  final String level;
  final String section;
  final String day;

  PassageForm({
    super.key,
    required this.level,
    required this.section,
    required this.day,
  });

  @override
  State<PassageForm> createState() => _PassageFormState();
}

class _PassageFormState extends State<PassageForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController passageInEnglishController =
      TextEditingController();
  final TextEditingController passageInArabicController =
      TextEditingController();
  final TextEditingController titleInEnglishController =
      TextEditingController();
  final TextEditingController titleInArabicController = TextEditingController();
  final TextEditingController questionTextInEnglishController =
      TextEditingController();
  final TextEditingController questionTextInArabicController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PassageViewModel(),
      child: Consumer<PassageViewModel>(
        builder: (context, viewModel, child) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: passageInEnglishController,
                    // unlimited lines with multi-line textfield
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Passage (English)",
                      hintText: "Enter the passage in English",
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
                    controller: passageInArabicController,
                    // unlimited lines with multi-line textfield
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Passage (Arabic)",
                      hintText: "Enter the passage in Arabic",
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.requiredField;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: titleInArabicController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Title in Arabic",
                      hintText: "Enter the title in Arabic",
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: questionTextInEnglishController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Question Text (English)",
                      hintText: "\"Read the follwing passage\"",
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: questionTextInArabicController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Question Text (Arabic)",
                      hintText: "\"إقرأ النص في الأسفل\"",
                    ),
                  ),
                  const SizedBox(height: 10),

                  Button(
                    type: ButtonType.secondary,
                    onPressed: () {
                      _showAddQuestionDialog(context, viewModel);
                    },
                    text: "Add paragraph question",
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: viewModel.questions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(viewModel.questions[index].toString()),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Button(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final passage = viewModel.submitForm(
                          passageInEnglish:
                              passageInEnglishController.text.trim(),
                          passageInArabic:
                              passageInArabicController.text.trim(),
                          titleInEnglish: titleInEnglishController.text.trim(),
                          titleInArabic: titleInArabicController.text.trim(),
                          questionTextInEnglish:
                              questionTextInEnglishController.text.trim(),
                          questionTextInArabic:
                              questionTextInArabicController.text.trim(),
                        );
                        if (passage != null) {
                          await viewModel.uploadQuestion(
                            level: widget.level,
                            section: widget.section,
                            day: widget.day,
                            question: passage,
                          );
                          print("Passage added to Firebase");
                        } else {
                          print("Form validation failed.");
                        }
                      } else {
                        print("Please fill all the required fields");
                      }
                    },
                    text: "Submit",
                  ),
                  const SizedBox(height: 10),
                  // Adding embedded questions
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddQuestionDialog(
      BuildContext context, PassageViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.all(5),
          title: const Text("Add Embedded Question"),
          content: SizedBox(
            child: AddEmbeddedQuestionForm(
              onAddQuestion: (BaseQuestion<dynamic> question) {
                viewModel.addQuestion(question);
                Navigator.of(context).pop();
              },
              level: widget.level,
              section: widget.section,
              day: widget.day,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}

class AddEmbeddedQuestionForm extends StatefulWidget {
  final String level;
  final String section;
  final String day;

  final Function(BaseQuestion<dynamic>) onAddQuestion;

  const AddEmbeddedQuestionForm(
      {Key? key,
      required this.onAddQuestion,
      required this.level,
      required this.section,
      required this.day})
      : super(key: key);

  @override
  _AddEmbeddedQuestionFormState createState() =>
      _AddEmbeddedQuestionFormState();
}

class _AddEmbeddedQuestionFormState extends State<AddEmbeddedQuestionForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  QuestionType? selectedQuestionType;
  bool isQuestionTypeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 16),
              DropdownButtonFormField(
                items: const [
                  DropdownMenuItem(
                    value: QuestionType.multipleChoice,
                    child: Text("Multiple Choice"),
                  ),
                  DropdownMenuItem(
                    value: QuestionType.dictation,
                    child: Text("Dictation"),
                  ),
                  DropdownMenuItem(
                    value: QuestionType.youtubeLesson,
                    child: Text("Youtube video"),
                  ),
                  DropdownMenuItem(
                    value: QuestionType.vocabulary,
                    child: Text("Vocabulary"),
                  ),
                  DropdownMenuItem(
                    value: QuestionType.fillTheBlanks,
                    child: Text("Fill in the blank"),
                  ),
                ],
                onChanged: (QuestionType? questionTypeSelection) {
                  setState(() {
                    selectedQuestionType = questionTypeSelection;
                  });
                },
                decoration: const InputDecoration(
                  labelText: "Question Type",
                  hintText: "Select question type",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a question type';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: selectedQuestionType == null
                      ? const Text("Select question type to start")
                      : _buildQuestionForm(selectedQuestionType!, context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionForm(
      QuestionType selectedQuestionType, BuildContext context) {
    switch (selectedQuestionType) {
      case QuestionType.multipleChoice:
        return MultipleChoiceForm(
          levelName: widget.level,
          sectionName: widget.section,
          dayNumber: widget.day,
          onSubmit: widget.onAddQuestion,
        );
      case QuestionType.dictation:
        return DictationQuestionForm(
          level: widget.level,
          section: widget.section,
          day: widget.day,
          onSubmit: widget.onAddQuestion,
        );
      case QuestionType.fillTheBlanks:
        return FillTheBlanksForm(
          level: widget.level,
          section: widget.section,
          day: widget.day,
          onSubmit: widget.onAddQuestion,
        );
      case QuestionType.youtubeLesson:
        return YoutubeLessonForm(
          level: widget.level,
          section: widget.section,
          day: widget.day,
          onSubmit: widget.onAddQuestion,
        );
      case QuestionType.vocabulary:
      case QuestionType.vocabularyWithListening:
        return VocabularyForm(
          level: widget.level,
          section: widget.section,
          day: widget.day,
          onSubmit: widget.onAddQuestion,
        );
      default:
        return const Text("Select question type to start");
    }
  }
}
