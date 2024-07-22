import 'package:ez_english/features/home/content/data_entry_forms/dictation_question_form.dart';
import 'package:ez_english/features/home/content/viewmodels/vocabulary_question_viewmodel.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/models/word_definition.dart';
import 'package:ez_english/utils/utils.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VocabularyForm extends StatefulWidget {
  final String level;
  final String section;
  final String day;
  final Function(BaseQuestion<dynamic>)? onSubmit;
  final WordDefinition? question;

  VocabularyForm({
    super.key,
    required this.level,
    required this.section,
    required this.day,
    this.onSubmit,
    this.question,
  });

  @override
  State<VocabularyForm> createState() => _VocabularyFormState();
}

class _VocabularyFormState extends State<VocabularyForm> {
  final _formKey = GlobalKey<FormState>();
  bool isFormValid = false;

  final TextEditingController englishWordController = TextEditingController();

  final TextEditingController arabicWordController = TextEditingController();

  final TextEditingController exampleUsageInEnglishController =
      TextEditingController();

  final TextEditingController exampleUsageInArabicController =
      TextEditingController();
  final TextEditingController questionTitleController = TextEditingController();
  WordType? currentWordType;

  String? originalEnglishWord;
  String? originalArabicWord;
  String? originalExampleUsageInEnglish;
  String? originalExampleUsageInArabic;
  String? originalQuestionTitle;
  WordType? originalWordType;
  String? updateMessage;
  @override
  void initState() {
    super.initState();

    if (widget.question != null) {
      englishWordController.text =
          originalEnglishWord = widget.question!.englishWord;
      arabicWordController.text =
          originalArabicWord = widget.question!.arabicWord ?? "";
      exampleUsageInEnglishController.text = originalExampleUsageInEnglish =
          widget.question!.exampleUsageInEnglish?[0] ?? "";
      exampleUsageInArabicController.text = originalExampleUsageInArabic =
          widget.question!.exampleUsageInArabic?[0] ?? "";
      questionTitleController.text =
          originalQuestionTitle = widget.question!.titleInEnglish ?? "";
      currentWordType = originalWordType = widget.question!.type;
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
    return englishWordController.text != originalEnglishWord ||
        arabicWordController.text != originalArabicWord ||
        exampleUsageInEnglishController.text != originalExampleUsageInEnglish ||
        exampleUsageInArabicController.text != originalExampleUsageInArabic ||
        questionTitleController.text != originalQuestionTitle ||
        currentWordType != originalWordType;
  }

  @override
  void dispose() {
    englishWordController.dispose();
    arabicWordController.dispose();
    exampleUsageInEnglishController.dispose();
    exampleUsageInArabicController.dispose();
    questionTitleController.dispose();
    super.dispose();
  }

  void updateQuestion(WordDefinition updatedQuestion) {
    if (widget.question != null) {
      if (englishWordController.text != originalEnglishWord) {
        widget.question!.englishWord = englishWordController.text;
      }
      if (arabicWordController.text != originalArabicWord) {
        widget.question!.arabicWord = arabicWordController.text;
      }
      if (exampleUsageInEnglishController.text !=
          originalExampleUsageInEnglish) {
        widget.question!.exampleUsageInEnglish = [
          exampleUsageInEnglishController.text
        ];
      }
      if (exampleUsageInArabicController.text != originalExampleUsageInArabic) {
        widget.question!.exampleUsageInArabic = [
          exampleUsageInArabicController.text
        ];
      }
      if (questionTitleController.text != originalQuestionTitle) {
        widget.question!.titleInEnglish = questionTitleController.text;
      }
      if (currentWordType != originalWordType) {
        widget.question!.type = currentWordType!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VocabularyViewModel(),
      child: Consumer<VocabularyViewModel>(
        builder: (context, viewmodel, child) {
          return viewmodel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Form(
                  onChanged: _validateForm,
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: questionTitleController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Word title",
                          hintText: "Ex: \"Everyday Greetings\"",
                        ),
                      ),
                      const SizedBox(height: 10),
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
                        value: currentWordType,
                        items: WordType.values.map((WordType type) {
                          return DropdownMenuItem<WordType>(
                            value: type,
                            child: Text(type.toString().split('.').last),
                          );
                        }).toList(),
                        onChanged: (WordType? newValue) {
                          setState(() {
                            currentWordType = newValue;
                            if (newValue == WordType.sentence) {
                              exampleUsageInArabicController.clear();
                              exampleUsageInEnglishController.clear();
                            }
                            _validateForm();
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select the word type';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      if (currentWordType == WordType.verb ||
                          currentWordType == WordType.word) ...[
                        TextFormField(
                          controller: exampleUsageInEnglishController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Example Usage in English",
                            hintText: "Enter example usage in English",
                          ),
                          validator: (value) {
                            if (currentWordType != WordType.sentence &&
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
                            if (currentWordType != WordType.sentence &&
                                (value == null || value.isEmpty)) {
                              return 'Please enter example usage in Arabic';
                            }
                            return null;
                          },
                        ),
                      ],
                      const SizedBox(height: 10),
                      _updateButton(viewmodel),
                    ],
                  ),
                );
        },
      ),
    );
  }

  Widget _updateButton(VocabularyViewModel viewmodel) {
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
                        viewmodel
                            .submitForm(
                          englishWord: englishWordController.text.trim(),
                          arabicWord: arabicWordController.text.trim().isEmpty
                              ? null
                              : arabicWordController.text.trim(),
                          type: currentWordType!,
                          exampleUsageInEnglish: exampleUsageInEnglishController
                                  .text
                                  .trim()
                                  .isEmpty
                              ? null
                              : [exampleUsageInEnglishController.text.trim()],
                          exampleUsageInArabic:
                              exampleUsageInArabicController.text.trim().isEmpty
                                  ? null
                                  : [
                                      exampleUsageInArabicController.text.trim()
                                    ],
                          questionTextInEnglish:
                              questionTitleController.text.trim().isEmpty
                                  ? null
                                  : questionTitleController.text.trim(),
                        )
                            .then((updatedQuestion) {
                          if (updatedQuestion != null) {
                            setState(() {
                              updateQuestion(updatedQuestion);
                            });
                            if (widget.onSubmit != null) {
                              updatedQuestion.path =
                                  widget.question?.path ?? '';
                              widget.onSubmit!(updatedQuestion);
                              Navigator.of(context).pop();
                              Utils.showSnackbar(
                                  text: "Question updated successfully");
                            } else {
                              showConfirmSubmitModalSheet(
                                  context: context,
                                  onSubmit: () {
                                    viewmodel
                                        .uploadQuestion(
                                            level: widget.level,
                                            section: widget.section,
                                            day: widget.day,
                                            question: updatedQuestion)
                                        .then((_) {
                                      Utils.showSnackbar(
                                          text:
                                              "Question uploaded successfully");
                                      resetForm();
                                    });
                                  },
                                  question: updatedQuestion);
                            }
                          }
                        });
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
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
      ],
    );
  }

  void resetForm() {
    englishWordController.clear();
    arabicWordController.clear();
    exampleUsageInEnglishController.clear();
    exampleUsageInArabicController.clear();
    questionTitleController.clear();
    currentWordType = null;
    updateMessage = null;
    _validateForm();
  }
}
