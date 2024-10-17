import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/home/content/data_entry_forms/dictation_question_form.dart';
import 'package:ez_english/features/home/content/viewmodels/speaking_question_viewmodel.dart';
import 'package:ez_english/features/home/content/viewmodels/youtube_question_viewmodel.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/models/speaking_question_model.dart';
import 'package:ez_english/features/sections/models/youtube_lesson_model.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/utils/utils.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SpeakingQuestionForm extends StatefulWidget {
  final String level;
  final String section;
  final String day;
  final Function(BaseQuestion<dynamic>)? onSubmit;
  SpeakingQuestionModel? question;

  SpeakingQuestionForm({
    super.key,
    required this.level,
    required this.section,
    required this.day,
    this.onSubmit,
    this.question,
  });

  @override
  State<SpeakingQuestionForm> createState() => _SpeakingQuestionFormState();
}

class _SpeakingQuestionFormState extends State<SpeakingQuestionForm> {
  final _formKey = GlobalKey<FormState>();
  bool isFormValid = false;
  final TextEditingController paragraphController = TextEditingController();

  String? originalParagraph;

  String? updateMessage;
  @override
  void initState() {
    super.initState();
    if (widget.question != null) {
      paragraphController.text =
          originalParagraph = widget.question!.question ?? "";
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _validateForm();
    });
  }

  void updateQuestion(SpeakingQuestionModel updatedQuestion) {
    if (widget.question != null) {
      if (paragraphController.text != originalParagraph) {
        widget.question!.question = paragraphController.text;
      }
    }
  }

  @override
  void dispose() {
    paragraphController.dispose();
    super.dispose();
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
    return paragraphController.text != originalParagraph;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SpeakingQuestionViewModel(),
      child: Consumer<SpeakingQuestionViewModel>(
        builder: (context, viewmodel, child) {
          return Form(
            onChanged: _validateForm,
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: paragraphController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Paragraph Text",
                    hintText: "Enter the Paragraph text",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid text';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.h),
                _updateButton(viewmodel)
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _updateButton(SpeakingQuestionViewModel viewmodel) {
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
                          sectionName:
                              SectionNameExtension.fromString(widget.section),
                          questionParagraph:
                              paragraphController.text.trim().isEmpty
                                  ? null
                                  : paragraphController.text.trim(),
                        )
                            .then((updatedQuestion) {
                          if (updatedQuestion != null) {
                            if (widget.onSubmit != null) {
                              setState(() {
                                updateQuestion(updatedQuestion);
                              });

                              updatedQuestion.path =
                                  widget.question?.path ?? '';
                              widget.onSubmit!(updatedQuestion);
                              Navigator.of(context).pop();
                              Utils.showSnackbar(
                                  text: "Question updated successfully");
                            } else {
                              showPreviewModalSheet(
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
                                      // _formKey.currentState!.reset();
                                      resetForm();
                                    });
                                    if (widget.onSubmit != null) {
                                      widget.onSubmit!(updatedQuestion);
                                    }
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
              text: widget.question == null ? "submit" : "Update",
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
                              updateMessage = AppStrings.checkAllFields;
                            });
                          },
                  ),
                ),
              ),
          ],
        ),
        if (updateMessage != null)
          Padding(
            padding: EdgeInsets.all(Constants.padding8),
            child: Text(
              updateMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
      ],
    );
  }

  void resetForm() {
    paragraphController.text = "";
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
