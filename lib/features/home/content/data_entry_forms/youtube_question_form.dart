import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/home/content/data_entry_forms/dictation_question_form.dart';
import 'package:ez_english/features/home/content/viewmodels/youtube_question_viewmodel.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/models/youtube_lesson_model.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/utils/utils.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class YoutubeLessonForm extends StatefulWidget {
  final String level;
  final String section;
  final String day;
  final Function(BaseQuestion<dynamic>)? onSubmit;
  YoutubeLessonModel? question;

  YoutubeLessonForm({
    super.key,
    required this.level,
    required this.section,
    required this.day,
    this.onSubmit,
    this.question,
  });

  @override
  State<YoutubeLessonForm> createState() => _YoutubeLessonFormState();
}

class _YoutubeLessonFormState extends State<YoutubeLessonForm> {
  final _formKey = GlobalKey<FormState>();
  bool isFormValid = false;
  final TextEditingController youtubeUrlController = TextEditingController();
  final TextEditingController titleInEnglishController =
      TextEditingController();
  String? originalYoutubeUrl;
  String? originalTitleInEnglish;

  String? updateMessage;
  @override
  void initState() {
    super.initState();
    if (widget.question != null) {
      youtubeUrlController.text =
          originalYoutubeUrl = widget.question!.youtubeUrl ?? "";
      titleInEnglishController.text =
          originalTitleInEnglish = widget.question?.titleInEnglish ?? "";
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _validateForm();
    });
  }

  void updateQuestion(YoutubeLessonModel updatedQuestion) {
    if (widget.question != null) {
      if (youtubeUrlController.text != originalYoutubeUrl) {
        widget.question!.youtubeUrl = youtubeUrlController.text;
      }
      if (titleInEnglishController.text != originalTitleInEnglish) {
        widget.question!.titleInEnglish = titleInEnglishController.text;
      }
    }
  }

  @override
  void dispose() {
    youtubeUrlController.dispose();
    titleInEnglishController.dispose();
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
    return youtubeUrlController.text != originalYoutubeUrl ||
        titleInEnglishController.text != originalTitleInEnglish;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => YoutubeLessonViewModel(),
      child: Consumer<YoutubeLessonViewModel>(
        builder: (context, viewmodel, child) {
          return Form(
            onChanged: _validateForm,
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
                SizedBox(height: 10.h),
                TextFormField(
                  controller: titleInEnglishController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Title in English",
                    hintText: "Enter the title in English",
                  ),
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

  Widget _updateButton(YoutubeLessonViewModel viewmodel) {
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
                          youtubeUrl: youtubeUrlController.text.trim().isEmpty
                              ? null
                              : youtubeUrlController.text.trim(),
                          titleInEnglish:
                              titleInEnglishController.text.trim().isEmpty
                                  ? null
                                  : titleInEnglishController.text.trim(),
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
    youtubeUrlController.text = "";
    titleInEnglishController.text = "";
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
