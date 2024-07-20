import 'package:ez_english/features/home/content/data_entry_forms/dictation_question_form.dart';
import 'package:ez_english/features/home/content/data_entry_forms/fill_the_blanks_question_form.dart';
import 'package:ez_english/features/home/content/data_entry_forms/multiple_choice_form.dart';
import 'package:ez_english/features/home/content/data_entry_forms/vocabulary_question_form.dart';
import 'package:ez_english/features/home/content/data_entry_forms/youtube_question_form.dart';
import 'package:ez_english/features/home/content/viewmodels/edit_question_viewmodel.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/models/dictation_question_model.dart';
import 'package:ez_english/features/sections/models/fill_the_blanks_question_model.dart';
import 'package:ez_english/features/sections/models/multiple_choice_question_model.dart';
import 'package:ez_english/features/sections/models/word_definition.dart';
import 'package:ez_english/features/sections/models/youtube_lesson_model.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/list_item_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditQuestion extends StatefulWidget {
  const EditQuestion({super.key});

  @override
  State<EditQuestion> createState() => _EditQuestionState();
}

class _EditQuestionState extends State<EditQuestion> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dayController = TextEditingController();
  String? selectedLevel;
  String? selectedSection;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditQuestionViewModel(),
      child: Consumer<EditQuestionViewModel>(
        builder: (context, viewmodel, child) {
          return Scaffold(
            appBar: AppBar(
              title: ListTile(
                contentPadding: const EdgeInsets.only(left: 0, right: 0),
                title: Text(
                  "Edit Question",
                  style: TextStyles.titleTextStyle,
                ),
                subtitle: Text(
                  "Edit existing questions",
                  style: TextStyles.subtitleTextStyle,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.number,
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
                        if (_dayController.text.isNotEmpty &&
                            selectedLevel != null &&
                            selectedSection != null) {
                          viewmodel.fetchQuestions(
                            level: selectedLevel!,
                            section: selectedSection!,
                            day: value,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: levelsDropDown(
                            onChanged: (levelSelection) {
                              setState(() {
                                selectedLevel = levelSelection;
                              });
                              if (_dayController.text.isNotEmpty &&
                                  selectedLevel != null &&
                                  selectedSection != null) {
                                viewmodel.fetchQuestions(
                                  level: selectedLevel!,
                                  section: selectedSection!,
                                  day: _dayController.text,
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: sectionDropDown(
                            onChanged: (sectionSelection) {
                              setState(() {
                                selectedSection = sectionSelection as String?;
                              });
                              if (_dayController.text.isNotEmpty &&
                                  selectedLevel != null &&
                                  selectedSection != null) {
                                viewmodel.fetchQuestions(
                                  level: selectedLevel!,
                                  section: selectedSection!,
                                  day: _dayController.text,
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (viewmodel.questions.isNotEmpty)
                      Expanded(
                        // height: 300,
                        child: ListView.builder(
                          itemCount: viewmodel.questions.length,
                          itemBuilder: (context, index) {
                            return ListItemCard(
                              mainText:
                                  "${viewmodel.questions[index].questionType.toShortString()}",
                              // info: ,
                              actionIcon: Icons.arrow_forward_ios,
                              onTap: () {
                                _showEditQuestionDialog(
                                  context,
                                  viewmodel.questions[index],
                                );
                                // Navigator.pushNamed(
                                //   context,
                                //   Routes.editQuestion,
                                //   arguments: viewmodel.questions[index],
                                //
                              },
                              // result:
                            );
                          },
                        ),
                      )

                    // Container(
                    //   color: Colors.red,
                    //   height: MediaQuery.of(context).size.height * 0.5,
                    //   child: PageView.builder(
                    //     itemCount: viewmodel.questions.length,
                    //     itemBuilder: (context, index) {
                    //       final question = viewmodel.questions[index];
                    //       return ListTile(
                    //         title:
                    //             Text(question.questionType.toShortString()),
                    //         onTap: () {
                    //           _showEditQuestionDialog(context, question);
                    //         },
                    //       );
                    //     },
                    //   ),
                    // )
                    else if (selectedLevel != null &&
                        selectedSection != null &&
                        _dayController.text.isNotEmpty)
                      const Text("No questions found for the selected day."),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showEditQuestionDialog(
      BuildContext context, BaseQuestion<dynamic> question) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Question"),
          insetPadding: EdgeInsets.all(8),
          content: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.75,
              child: _buildQuestionForm(question),
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

  Widget _buildQuestionForm(BaseQuestion<dynamic> question) {
    return ChangeNotifierProvider(
      create: (_) => EditQuestionViewModel(),
      child: Consumer<EditQuestionViewModel>(
        builder: (context, viewModel, child) {
          switch (question.questionType) {
            case QuestionType.multipleChoice:
              return MultipleChoiceForm(
                levelName: selectedLevel!,
                sectionName: selectedSection!,
                dayNumber: _dayController.text,
                onSubmit: (updatedQuestion) {
                  viewModel.updateQuestion(updatedQuestion);
                  Navigator.of(context).pop();
                },
                question: question as MultipleChoiceQuestionModel,
              );
            case QuestionType.dictation:
              return DictationQuestionForm(
                level: selectedLevel!,
                section: selectedSection!,
                day: _dayController.text,
                onSubmit: (updatedQuestion) {
                  viewModel.updateQuestion(updatedQuestion);
                  Navigator.of(context).pop();
                },
                question: question as DictationQuestionModel,
              );
            case QuestionType.youtubeLesson:
              return YoutubeLessonForm(
                level: selectedLevel!,
                section: selectedSection!,
                day: _dayController.text,
                onSubmit: (updatedQuestion) {
                  viewModel.updateQuestion(updatedQuestion);
                  Navigator.of(context).pop();
                },
                question: question as YoutubeLessonModel,
              );

            case QuestionType.vocabulary:
              return VocabularyForm(
                level: selectedLevel!,
                section: selectedSection!,
                day: _dayController.text,
                onSubmit: (updatedQuestion) {
                  viewModel.updateQuestion(updatedQuestion);
                  Navigator.of(context).pop();
                },
                question: question as WordDefinition,
              );

            case QuestionType.fillTheBlanks:
              return FillTheBlanksForm(
                level: selectedLevel!,
                section: selectedSection!,
                day: _dayController.text,
                onSubmit: (updatedQuestion) {
                  viewModel.updateQuestion(updatedQuestion);
                  Navigator.of(context).pop();
                },
                question: question as FillTheBlanksQuestionModel,
              );
            default:
              return const Text("Question type not supported.");
          }
        },
      ),
    );
  }
}

Widget sectionDropDown({required onChanged}) {
  return DropdownButtonFormField(
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
      onChanged(sectionSelection);
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
  );
}

Widget levelsDropDown({required onChanged}) {
  return DropdownButtonFormField(
    decoration: const InputDecoration(
      labelText: "Level",
      hintText: "Select level",
      border: OutlineInputBorder(),
    ),
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
      onChanged(levelSelection);
    },
  );
}
