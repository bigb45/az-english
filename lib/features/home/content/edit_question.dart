import 'package:ez_english/features/home/content/data_entry_forms/dictation_question_form.dart';
import 'package:ez_english/features/home/content/data_entry_forms/fill_the_blanks_question_form.dart';
import 'package:ez_english/features/home/content/data_entry_forms/multiple_choice_form.dart';
import 'package:ez_english/features/home/content/data_entry_forms/passage_question_form.dart';
import 'package:ez_english/features/home/content/data_entry_forms/vocabulary_question_form.dart';
import 'package:ez_english/features/home/content/data_entry_forms/youtube_question_form.dart';
import 'package:ez_english/features/home/content/viewmodels/edit_question_viewmodel.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/level.dart';
import 'package:ez_english/features/models/unit.dart';
import 'package:ez_english/features/sections/models/dictation_question_model.dart';
import 'package:ez_english/features/sections/models/fill_the_blanks_question_model.dart';
import 'package:ez_english/features/sections/models/multiple_choice_question_model.dart';
import 'package:ez_english/features/sections/models/passage_question_model.dart';
import 'package:ez_english/features/sections/models/word_definition.dart';
import 'package:ez_english/features/sections/models/youtube_lesson_model.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/vertical_list_item_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditQuestion extends StatefulWidget {
  const EditQuestion({super.key});

  @override
  State<EditQuestion> createState() => _EditQuestionState();
}

class _EditQuestionState extends State<EditQuestion> {
  final _formKey = GlobalKey<FormState>();
  String? selectedLevel;
  String? selectedSection;
  Unit? selectedUnit;
  bool isDayMenuEnabled = false;

  void _updateDayMenuState() {
    setState(() {
      isDayMenuEnabled = selectedLevel != null && selectedSection != null;
    });
  }

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
                    Row(
                      children: [
                        Expanded(
                          child: levelsDropDown(
                            onChanged: (levelSelection) {
                              setState(() {
                                selectedLevel = levelSelection;
                              });
                              _updateDayMenuState();
                              if (selectedLevel != null &&
                                  selectedSection != null) {
                                setState(() {
                                  selectedUnit = null;
                                  viewmodel.questions.clear();
                                });
                                viewmodel.fetchDays(
                                    level: selectedLevel!,
                                    section: selectedSection!);
                              }
                              if (selectedUnit != null &&
                                  selectedLevel != null &&
                                  selectedSection != null) {
                                viewmodel.fetchQuestions(
                                  level: selectedLevel!,
                                  section: selectedSection!,
                                  day: selectedUnit!.name.split("t")[1],
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
                              _updateDayMenuState();
                              if (selectedLevel != null &&
                                  selectedSection != null) {
                                setState(() {
                                  selectedUnit = null;
                                  viewmodel.questions.clear();
                                });
                                viewmodel.fetchDays(
                                    level: selectedLevel!,
                                    section: selectedSection!);
                              }
                              if (selectedUnit != null &&
                                  selectedLevel != null &&
                                  selectedSection != null) {
                                viewmodel.fetchQuestions(
                                  level: selectedLevel!,
                                  section: selectedSection!,
                                  day: selectedUnit!.name.split("t")[1],
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<Unit>(
                      value: selectedUnit,
                      items: viewmodel.units != null
                          ? viewmodel.units!.map((Unit? unit) {
                              return DropdownMenuItem<Unit>(
                                value: unit,
                                child: Text(unit!.name.capitalizeFirst()),
                              );
                            }).toList()
                          : [],
                      onChanged: isDayMenuEnabled
                          ? (Unit? newUnit) {
                              setState(() {
                                selectedUnit = newUnit;
                              });
                              if (selectedUnit != null &&
                                  selectedLevel != null &&
                                  selectedSection != null) {
                                viewmodel.fetchQuestions(
                                  level: selectedLevel!,
                                  section: selectedSection!,
                                  day: selectedUnit!.name.split("t")[1],
                                );
                                setState(() {
                                  selectedUnit = newUnit;
                                });
                              }
                            }
                          : null,
                      decoration: const InputDecoration(
                        labelText: "Please select a unit",
                        hintText: "Select a unit",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a unit';
                        }
                        return null;
                      },
                      disabledHint: viewmodel.units == null
                          ? const Text(
                              "Please fill all fields above to select a unit")
                          : const Text("Please add the level first"),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                        child: viewmodel.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : viewmodel.questions.isNotEmpty
                                ? ListView.builder(
                                    itemCount: viewmodel.questions.length,
                                    itemBuilder: (context, index) {
                                      return VerticalListItemCard(
                                        mainText:
                                            "${index + 1}. ${viewmodel.questions[index].questionTextInEnglish ?? "No question text"}",
                                        info: Text(viewmodel.questions[index]
                                                .titleInEnglish ??
                                            ""),
                                        subText: viewmodel
                                            .questions[index].questionType
                                            .toShortString(),
                                        actionIcon: Icons.arrow_forward_ios,
                                        onTap: () {
                                          showEditQuestionDialog(
                                            context,
                                            viewmodel.questions[index],
                                            selectedLevel,
                                            selectedSection,
                                            updateQuestionCallback:
                                                (updatedQuestion) {
                                              viewmodel.updateQuestion(
                                                  updatedQuestion);
                                            },
                                            selectedUnit!.name.split("t")[1],
                                          );
                                        },
                                      );
                                    },
                                  )
                                : const Text(
                                    "No questions found for the selected day."))
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

void showEditQuestionDialog(
    BuildContext context,
    BaseQuestion<dynamic> question,
    String? selectedLevel,
    String? selectedSection,
    String? dayController,
    {Function(BaseQuestion<dynamic>)? updateQuestionCallback,
    bool Function()? onChangesCallBack}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Edit Question"),
        insetPadding: const EdgeInsets.all(8),
        content: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            child: buildQuestionForm(
                question, selectedLevel, selectedSection, dayController,
                updateQuestionCallback: updateQuestionCallback),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (onChangesCallBack != null) {
                onChangesCallBack();
              }

              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
        ],
      );
    },
  );
}

Widget buildQuestionForm(BaseQuestion<dynamic> question, String? selectedLevel,
    String? selectedSection, String? dayController,
    {Function(BaseQuestion<dynamic>)? updateQuestionCallback}) {
  return ChangeNotifierProvider(
    create: (_) => EditQuestionViewModel(),
    child: Consumer<EditQuestionViewModel>(
      builder: (context, viewModel, child) {
        switch (question.questionType) {
          case QuestionType.multipleChoice:
            return MultipleChoiceForm(
              levelName: selectedLevel!,
              sectionName: selectedSection!,
              dayNumber: dayController!,
              onSubmit: updateQuestionCallback ??
                  (updatedQuestion) {
                    viewModel.updateQuestion(updatedQuestion);
                    Navigator.of(context).pop();
                  },
              question: question as MultipleChoiceQuestionModel,
            );
          case QuestionType.dictation:
            return DictationQuestionForm(
              level: selectedLevel!,
              section: selectedSection!,
              day: dayController!,
              onSubmit: updateQuestionCallback ??
                  (updatedQuestion) {
                    viewModel.updateQuestion(updatedQuestion);
                  },
              question: question as DictationQuestionModel,
            );
          case QuestionType.youtubeLesson:
            return YoutubeLessonForm(
              level: selectedLevel!,
              section: selectedSection!,
              day: dayController!,
              onSubmit: updateQuestionCallback ??
                  (updatedQuestion) {
                    viewModel.updateQuestion(updatedQuestion);
                    Navigator.of(context).pop();
                  },
              question: question as YoutubeLessonModel,
            );

          case QuestionType.vocabulary:
            return VocabularyForm(
              level: selectedLevel!,
              section: selectedSection!,
              day: dayController!,
              onSubmit: updateQuestionCallback ??
                  (updatedQuestion) {
                    viewModel.updateQuestion(updatedQuestion);
                    Navigator.of(context).pop();
                  },
              question: question as WordDefinition,
            );

          case QuestionType.fillTheBlanks:
            return FillTheBlanksForm(
              level: selectedLevel!,
              section: selectedSection!,
              day: dayController!,
              onSubmit: updateQuestionCallback ??
                  (updatedQuestion) {
                    viewModel.updateQuestion(updatedQuestion);
                    Navigator.of(context).pop();
                  },
              question: question as FillTheBlanksQuestionModel,
            );
          case QuestionType.passage:
            return PassageForm(
              level: selectedLevel!,
              section: selectedSection!,
              day: dayController!,
              onSubmit: updateQuestionCallback ??
                  (updatedQuestion) {
                    viewModel.updateQuestion(updatedQuestion);
                    Navigator.of(context).pop();
                  },
              question: question as PassageQuestionModel,
            );

          default:
            return const Text("Question type not supported.");
        }
      },
    ),
  );
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
