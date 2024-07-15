import 'package:ez_english/features/home/content/data_entry_forms/dictation_question_form.dart';
import 'package:ez_english/features/home/content/data_entry_forms/fill_the_blanks_question_form.dart';
import 'package:ez_english/features/home/content/data_entry_forms/multiple_choice_form.dart';
import 'package:ez_english/features/home/content/data_entry_forms/passage_question_form.dart';
import 'package:ez_english/features/home/content/data_entry_forms/vocabulary_question_form.dart';
import 'package:ez_english/features/home/content/data_entry_forms/youtube_question_form.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddQuestion extends StatefulWidget {
  const AddQuestion({super.key});

  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dayController = TextEditingController();
  String? selectedLevel;
  String? selectedSection;
  QuestionType? selectedQuestionType;
  bool isQuestionTypeEnabled = false;

  void _updateQuestionTypeState() {
    setState(() {
      isQuestionTypeEnabled = _dayController.text.isNotEmpty &&
          selectedLevel != null &&
          selectedSection != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: const EdgeInsets.only(left: 0, right: 0),
          title: Text(
            "Add Question",
            style: TextStyles.titleTextStyle,
          ),
          subtitle: Text(
            "Add new questions",
            style: TextStyles.subtitleTextStyle,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _dayController,
                  decoration: const InputDecoration(
                    labelText: "Day",
                    hintText: "Enter the day",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the day';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _updateQuestionTypeState();
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField(
                        items: const [
                          DropdownMenuItem(
                            value: "A1",
                            child: Text("A1"),
                          ),
                          DropdownMenuItem(
                            value: "A2",
                            child: Text("A2"),
                          ),
                          DropdownMenuItem(
                            value: "B1",
                            child: Text("B1"),
                          ),
                          DropdownMenuItem(
                            value: "B2",
                            child: Text("B2"),
                          ),
                          DropdownMenuItem(
                            value: "C1",
                            child: Text("C1"),
                          ),
                          DropdownMenuItem(
                            value: "C2",
                            child: Text("C2"),
                          ),
                        ],
                        onChanged: (levelSelection) {
                          setState(() {
                            selectedLevel = levelSelection as String?;
                          });
                          _updateQuestionTypeState();
                          print("Level selected: $levelSelection");
                        },
                        decoration: const InputDecoration(
                          labelText: "Select level",
                          hintText: "Select level",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a level';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: DropdownButtonFormField(
                        items: const [
                          DropdownMenuItem(
                            value: "reading",
                            child: Text("Reading"),
                          ),
                          DropdownMenuItem(
                            value: "listeningWriting",
                            child: Text("Writing & Listening"),
                          ),
                          DropdownMenuItem(
                            value: "vocabulary",
                            child: Text("Vocabulary"),
                          ),
                          DropdownMenuItem(
                            value: "grammar",
                            child: Text("Grammar"),
                          ),
                        ],
                        onChanged: (sectionSelection) {
                          setState(() {
                            selectedSection = sectionSelection as String?;
                          });
                          _updateQuestionTypeState();
                          print("Section selected: $sectionSelection");
                        },
                        decoration: const InputDecoration(
                          labelText: "Section",
                          hintText: "Select section",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a section';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
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
                      value: QuestionType.passage,
                      child: Text("Passage"),
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
                  onChanged: isQuestionTypeEnabled
                      ? (QuestionType? questionTypeSelection) {
                          print(
                              "Question type selected: ${questionTypeSelection!.toShortString()}");
                          setState(() {
                            selectedQuestionType = questionTypeSelection;
                          });
                        }
                      : null,
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
                  disabledHint: const Text(
                      "Please fill all fields above to select question type"),
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
                        : _buildQuestionForm(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionForm() {
    switch (selectedQuestionType!) {
      case QuestionType.multipleChoice:
        return MultipleChoiceForm(
          levelName: selectedLevel!,
          sectionName: selectedSection!,
          dayNumber: _dayController.text,
        );
      case QuestionType.dictation:
        return DictationQuestionForm(
            level: selectedLevel!,
            section: selectedSection!,
            day: _dayController.text);
      case QuestionType.fillTheBlanks:
        return FillTheBlanksForm(
            level: selectedLevel!,
            section: selectedSection!,
            day: _dayController.text);
      case QuestionType.youtubeLesson:
        return YoutubeLessonForm(
          level: selectedLevel!,
          section: selectedSection!,
          day: _dayController.text,
        );

      case QuestionType.passage:
        return PassageForm(
          level: selectedLevel!,
          section: selectedSection!,
          day: _dayController.text,
        );
      case QuestionType.vocabulary:
      case QuestionType.vocabularyWithListening:
        return VocabularyForm(
          level: selectedLevel!,
          section: selectedSection!,
          day: _dayController.text,
        );
      default:
        return const Text("Select question type to start");
    }
  }
}
