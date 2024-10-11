import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/home/content/data_entry_forms/dictation_question_form.dart';
import 'package:ez_english/features/home/content/data_entry_forms/fill_the_blanks_question_form.dart';
import 'package:ez_english/features/home/content/data_entry_forms/multiple_choice_form.dart';
import 'package:ez_english/features/home/content/data_entry_forms/passage_question_form.dart';
import 'package:ez_english/features/home/content/data_entry_forms/vocabulary_question_form.dart';
import 'package:ez_english/features/home/content/data_entry_forms/worksheet_form.dart';
import 'package:ez_english/features/home/content/data_entry_forms/youtube_question_form.dart';
import 'package:ez_english/features/home/content/viewmodels/add_question_viewmodel.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/unit.dart';
import 'package:ez_english/features/sections/models/word_definition.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class AddQuestion extends StatefulWidget {
  const AddQuestion({super.key});

  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  final _formKey = GlobalKey<FormState>();
  String? selectedLevel;
  String? selectedSection;
  QuestionType? selectedQuestionType;
  bool isQuestionTypeEnabled = false;
  bool isDayMenuEnabled = false;
  Unit? selectedUnit;

  void _updateDayMenuState() {
    setState(() {
      isDayMenuEnabled = selectedLevel != null && selectedSection != null;
    });
  }

  void _updateQuestionTypeState() {
    setState(() {
      isQuestionTypeEnabled = selectedUnit != null &&
          selectedLevel != null &&
          selectedSection != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddQuestionViewModel(),
      child:
          Consumer<AddQuestionViewModel>(builder: (context, viewmodel, child) {
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
              padding: EdgeInsets.all(Constants.padding12),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 16.h),
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
                                selectedLevel = levelSelection;
                              });
                              _updateQuestionTypeState();
                              _updateDayMenuState();
                              if (selectedLevel != null &&
                                  selectedSection != null) {
                                setState(() {
                                  selectedUnit = null;
                                  selectedQuestionType = null;

                                  _updateQuestionTypeState();
                                });
                                viewmodel.fetchDays(
                                    level: selectedLevel!,
                                    section: selectedSection!);
                              }
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
                            isExpanded: true,
                            items: const [
                              DropdownMenuItem(
                                value: "reading",
                                child: Text("Reading"),
                              ),
                              DropdownMenuItem(
                                value: "writing",
                                child: Text("Writing"),
                              ),
                              DropdownMenuItem(
                                value: "listening",
                                child: Text("Listening"),
                              ),
                              DropdownMenuItem(
                                value: "vocabulary",
                                child: Text("Vocabulary"),
                              ),
                              DropdownMenuItem(
                                value: "grammar",
                                child: Text("Grammar"),
                              ),
                              DropdownMenuItem(
                                value: "test",
                                child: Text("Test"),
                              ),
                              DropdownMenuItem(
                                value: "worksheet",
                                child: Text("Worksheet"),
                              )
                            ],
                            onChanged: (sectionSelection) {
                              setState(() {
                                selectedSection = sectionSelection;
                              });
                              _updateQuestionTypeState();
                              _updateDayMenuState();
                              if (selectedLevel != null &&
                                  selectedSection != null) {
                                setState(() {
                                  selectedUnit = null;
                                  selectedQuestionType = null;
                                  _updateQuestionTypeState();
                                });
                                viewmodel.fetchDays(
                                    level: selectedLevel!,
                                    section: selectedSection!);
                              }
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
                    DropdownButtonFormField<Unit>(
                      isExpanded: true,
                      value: selectedUnit,
                      items: viewmodel.units != null
                          ? viewmodel.units!.map((Unit? unit) {
                              return DropdownMenuItem<Unit>(
                                value: unit,
                                child: Text(unit!.name.capitalizeFirst()),
                              );
                            }).toList()
                          : []
                        ..add(
                          DropdownMenuItem<Unit>(
                            value: Unit(
                                name: "+ Add new unit",
                                numberOfQuestionsWithDeletion: 0,
                                questions: {}),
                            child: const Row(
                              children: [Icon(Icons.add), Text("Add new unit")],
                            ),
                          ),
                        ),
                      onChanged: isDayMenuEnabled
                          ? (Unit? newUnit) {
                              if (newUnit != null &&
                                  newUnit.name == "+ Add new unit") {
                                newUnit = viewmodel.addUnit();
                              }
                              setState(() {
                                selectedUnit = newUnit;
                              });

                              if (selectedUnit != null &&
                                  selectedLevel != null &&
                                  selectedSection != null) {
                                _updateQuestionTypeState();
                                setState(() {
                                  selectedQuestionType = null;

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
                    SizedBox(height: 16.h),
                    // don't select question type if admin is uploading a worksheet
                    DropdownButtonFormField(
                      value: selectedQuestionType,
                      isExpanded: true,
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
                        DropdownMenuItem(
                          value: QuestionType.worksheet,
                          child: Text("Worksheet"),
                        ),
                      ],
                      onChanged: isQuestionTypeEnabled
                          ? (QuestionType? questionTypeSelection) {
                              printDebug(
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
                    const Text("Fields marked with * are required"),
                    SizedBox(height: 16.h),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(Constants.padding12),
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
      }),
    );
  }

  Widget _buildQuestionForm() {
    switch (selectedQuestionType!) {
      case QuestionType.multipleChoice:
        return MultipleChoiceForm(
          levelName: selectedLevel!,
          sectionName: selectedSection!,
          dayNumber: selectedUnit!.name.split("t")[1],
        );
      case QuestionType.dictation:
        return DictationQuestionForm(
            level: selectedLevel!,
            section: selectedSection!,
            day: selectedUnit!.name.split("t")[1]);
      case QuestionType.fillTheBlanks:
        return FillTheBlanksForm(
            level: selectedLevel!,
            section: selectedSection!,
            day: selectedUnit!.name.split("t")[1]);
      case QuestionType.youtubeLesson:
        return YoutubeLessonForm(
          level: selectedLevel!,
          section: selectedSection!,
          day: selectedUnit!.name.split("t")[1],
        );

      case QuestionType.passage:
        return PassageForm(
          level: selectedLevel!,
          section: selectedSection!,
          day: selectedUnit!.name.split("t")[1],
        );
      case QuestionType.vocabulary:
      case QuestionType.vocabularyWithListening:
        return VocabularyForm(
          level: selectedLevel!,
          section: selectedSection!,
          day: selectedUnit!.name.split("t")[1],
        );

      case QuestionType.worksheet:
        return WorksheetForm(
          level: selectedLevel!,
          section: selectedSection!,
          day: selectedUnit!.name.split("t")[1],
        );
      default:
        return const Text("Select question type to start");
    }
  }
}
