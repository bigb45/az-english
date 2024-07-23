import 'package:ez_english/features/home/content/data_entry_forms/dictation_question_form.dart';
import 'package:ez_english/features/home/content/data_entry_forms/fill_the_blanks_question_form.dart';
import 'package:ez_english/features/home/content/data_entry_forms/multiple_choice_form.dart';
import 'package:ez_english/features/home/content/data_entry_forms/vocabulary_question_form.dart';
import 'package:ez_english/features/home/content/data_entry_forms/youtube_question_form.dart';
import 'package:ez_english/features/home/content/edit_question.dart';
import 'package:ez_english/features/home/content/viewmodels/passage_question_viewmodel.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/models/passage_question_model.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/utils/utils.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:ez_english/widgets/vertical_list_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class PassageForm extends StatefulWidget {
  final String level;
  final String section;
  final String day;
  final Function(BaseQuestion<dynamic>)? onSubmit;
  final PassageQuestionModel? question;

  PassageForm({
    super.key,
    required this.level,
    required this.section,
    required this.day,
    this.onSubmit,
    this.question,
  });

  @override
  State<PassageForm> createState() => _PassageFormState();
}

class _PassageFormState extends State<PassageForm> {
  final _formKey = GlobalKey<FormState>();
  bool isFormValid = false;

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
  Map<int, BaseQuestion<dynamic>?> questions = {};
  String? updateMessage;

  String? originalPassageInEnglish;
  String? originalPassageInArabic;
  String? originalTitleInEnglish;
  String? originalTitleInArabic;
  String? originalQuestionTextInEnglish;
  String? originalQuestionTextInArabic;
  Map<int, BaseQuestion<dynamic>?> originalQuestions = {};

  @override
  void initState() {
    super.initState();

    if (widget.question != null) {
      passageInEnglishController.text =
          originalPassageInEnglish = widget.question!.passageInEnglish ?? "";
      passageInArabicController.text =
          originalPassageInArabic = widget.question!.passageInArabic ?? "";
      titleInEnglishController.text =
          originalTitleInEnglish = widget.question!.titleInEnglish ?? "";
      titleInArabicController.text =
          originalTitleInArabic = widget.question!.titleInArabic ?? "";
      questionTextInEnglishController.text = originalQuestionTextInEnglish =
          widget.question!.questionTextInEnglish ?? "";
      questionTextInArabicController.text = originalQuestionTextInArabic =
          widget.question!.questionTextInArabic ?? "";
      originalQuestions = widget.question!.questions
          .map((key, value) => MapEntry(key, value?.copy()));
      questions = widget.question!.questions
          .map((key, value) => MapEntry(key, value?.copy()));
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _validateForm();
    });
  }

  void _validateForm() {
    bool formValid = _formKey.currentState?.validate() ?? false;
    bool changesMade = _checkForChanges();
    setState(() {
      isFormValid = formValid && (widget.question == null || changesMade);
      if (changesMade) {
        updateMessage = null;
      }
    });
  }

  bool _checkForChanges() {
    bool basicInfoChanged = passageInEnglishController.text !=
            originalPassageInEnglish ||
        passageInArabicController.text != originalPassageInArabic ||
        titleInEnglishController.text != originalTitleInEnglish ||
        titleInEnglishController.text != originalTitleInEnglish ||
        titleInArabicController.text != originalTitleInArabic ||
        questionTextInEnglishController.text != originalQuestionTextInEnglish ||
        questionTextInArabicController.text != originalQuestionTextInArabic;
    // Check if the number of questions has changed
    bool questionCountChanged = questions.length != originalQuestions.length;

    bool questionsChanged = false;
    var allKeys = {...questions.keys, ...originalQuestions.keys};
    for (var key in allKeys) {
      if (!questions.containsKey(key) ||
          !originalQuestions.containsKey(key) ||
          !questions[key]!.equals(originalQuestions[key]!)) {
        questionsChanged = true;
        break;
      }
    }

    return basicInfoChanged || questionCountChanged || questionsChanged;
  }

  @override
  void dispose() {
    passageInEnglishController.dispose();
    passageInArabicController.dispose();
    titleInEnglishController.dispose();
    titleInArabicController.dispose();
    questionTextInEnglishController.dispose();
    questionTextInArabicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PassageViewModel(),
      child: Consumer<PassageViewModel>(
        builder: (context, viewmodel, child) {
          return Form(
            onChanged: _validateForm,
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
                      if (_formKey.currentState!.validate())
                        _showAddQuestionDialog(context, viewmodel);
                    },
                    text: "Add paragraph question",
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 300.h,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: questions.keys.length,
                      itemBuilder: (context, index) {
                        var key = questions.keys.elementAt(index);
                        var question = questions[key];

                        if (widget.question != null) {
                          question!.path =
                              "${widget.question!.path}/questions/$key";
                        }

                        return VerticalListItemCard(
                          mainText:
                              "${index + 1}. ${question?.questionTextInEnglish.toString() ?? "No question text"}",
                          info: Text(question!.titleInEnglish ?? ""),
                          subText: question.questionType.toShortString(),
                          actionIcon: Icons.arrow_forward_ios,
                          onTap: () => showEditQuestionDialog(context, question,
                              widget.level, widget.section, widget.day,
                              updateQuestionCallback: viewmodel.updateQuestion,
                              onChangesCallBack: _checkForChanges),
                          isEditMode: true,
                          onDeletionPressed: () {
                            viewmodel.deleteQuestion(question);
                            setState(() {
                              questions.remove(key);
                            });
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  _updateButton(viewmodel),
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
                setState(() {
                  questions[questions.length] = question;
                });
                _validateForm();
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

  Widget _updateButton(PassageViewModel viewmodel) {
    bool isEnabled = isFormValid;

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Button(
              onPressed: isEnabled
                  ? () {
                      if (_formKey.currentState!.validate()) {
                        final updatedQuestion = viewmodel.submitForm(
                          questions: questions,
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
                        if (widget.onSubmit != null) {
                          updatedQuestion.path = widget.question?.path ?? '';
                          widget.onSubmit!(updatedQuestion);
                          Navigator.of(context).pop();
                          Utils.showSnackbar(
                              text: "Question updated successfully");
                        } else {
                          viewmodel
                              .uploadQuestion(
                                  level: widget.level,
                                  section: widget.section,
                                  day: widget.day,
                                  question: updatedQuestion)
                              .then((_) {
                            Utils.showSnackbar(
                                text: "Question uploaded successfully");
                            resetForm(viewmodel.reset);
                          });
                          // showConfirmSubmitModalSheet(
                          //     question: updatedQuestion,
                          //     context: context,
                          //     onSubmit: () {
                          //       viewmodel
                          //           .uploadQuestion(
                          //               level: widget.level,
                          //               section: widget.section,
                          //               day: widget.day,
                          //               question: updatedQuestion)
                          //           .then((_) {
                          //         Utils.showSnackbar(
                          //             text: "Question uploaded successfully");
                          //         resetForm(viewmodel.reset);
                          //       });
                          //     });
                        }
                      } else {
                        Utils.showErrorSnackBar(
                          "Please select an answer as the correct answer.",
                        );
                      }
                    }
                  : null,
              text: "Update",
            ),
            if (!isEnabled)
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: isEnabled
                        ? null
                        : () {
                            setState(() {
                              updateMessage =
                                  "Please make changes to update the question.";
                            });
                          },
                  ),
                ),
              ),
          ],
        ),
        if (updateMessage != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              updateMessage!,
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
      ],
    );
  }

  void resetForm(VoidCallback resetCallback) {
    resetCallback();
    passageInEnglishController.clear();
    passageInArabicController.clear();
    titleInEnglishController.clear();
    titleInArabicController.clear();
    questionTextInEnglishController.clear();
    questionTextInArabicController.clear();
    questions.clear();
    setState(() {
      isFormValid = false;
    });
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
