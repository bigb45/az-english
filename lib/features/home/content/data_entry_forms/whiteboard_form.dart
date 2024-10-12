import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/home/content/data_entry_forms/dictation_question_form.dart';
import 'package:ez_english/features/home/content/viewmodels/whiteboard_viewmodel.dart';
import 'package:ez_english/features/home/whiteboard/whiteboard_model.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/utils/utils.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:ez_english/widgets/upload_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class WhiteboardForm extends StatefulWidget {
  final String level;
  final String section;
  final String day;
  final Function(BaseQuestion<dynamic>)? onSubmit;
  final WhiteboardModel? question;

  const WhiteboardForm({
    super.key,
    required this.level,
    required this.section,
    required this.day,
    this.onSubmit,
    this.question,
  });

  @override
  State<WhiteboardForm> createState() => _WhiteboardFormState();
}

class _WhiteboardFormState extends State<WhiteboardForm> {
  final _titleController = TextEditingController();
  String? originalTitle;
  bool isFormValid = false;
  String? updateMessage;
  String? imageUrl;
  File? currentImage;

  String? originalImagePath;
  String? newImagePath;

  void updateQuestion(WhiteboardModel updatedQuestion) {
    if (widget.question != null) {
      if (_titleController.text != originalTitle) {
        widget.question!.title = _titleController.text;
      }
      if (newImagePath != originalImagePath) {
        widget.question!.imageUrl = newImagePath;
      }
    }
  }

  @override
  void initState() {
    if (widget.question != null) {
      _titleController.text = widget.question!.title;
      originalTitle = widget.question!.title;
      originalImagePath = widget.question!.imageUrl;
      newImagePath = originalImagePath;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _validateForm();
    });
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  void _validateForm() {
    bool formValid =
        newImagePath != null && (_formKey.currentState?.validate() ?? false);
    bool changesMade = _checkForChanges();

    setState(() {
      isFormValid = formValid && (widget.question == null || changesMade);
      if (changesMade) {
        updateMessage = null;
      }
    });
  }

  bool _checkForChanges() {
    return _titleController.text != originalTitle ||
        newImagePath != originalImagePath;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WhiteboardViewmodel>(
      builder: (context, viewmodel, _) => Form(
        key: _formKey,
        onChanged: _validateForm,
        autovalidateMode: AutovalidateMode.always,
        child: viewmodel.isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.fieldRequired;
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Whiteboard Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Stack(
                    children: [
                      if (currentImage != null)
                        Center(child: Image.file(currentImage!))
                      else if (newImagePath != null)
                        Center(
                            child: CachedNetworkImage(
                                progressIndicatorBuilder:
                                    (context, url, progress) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: progress.progress,
                                    ),
                                  );
                                },
                                imageUrl: newImagePath!))
                      else
                        UploadCard(
                            onPressed: () async {
                              await viewmodel.pickImage();
                              setState(() {
                                currentImage = viewmodel.image;
                                newImagePath = viewmodel.image?.path;
                                _validateForm();
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AutoSizeText(
                                  'Add Whiteboard',
                                  style: TextStyles.cardHeader
                                      .copyWith(fontSize: 18.sp),
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                ),
                                Expanded(
                                  child: viewmodel.isLoading
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                            color: Palette.primaryText,
                                          ),
                                        )
                                      : const FittedBox(
                                          child: Icon(
                                            Icons.add_rounded,
                                            color: Palette.secondaryText,
                                          ),
                                        ),
                                ),
                              ],
                            )),
                      if (currentImage != null || (newImagePath != null))
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                viewmodel.removeImage();
                                currentImage = null;
                                newImagePath = null;
                                _validateForm();
                              });
                            },
                          ),
                        ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  _updateButton(viewmodel)
                ],
              ),
      ),
    );
  }

  Widget _updateButton(WhiteboardViewmodel viewmodel) {
    bool isEnabled = isFormValid;
    void resetForm() {
      _titleController.clear();
      currentImage = null;
      viewmodel.removeImage();
      updateMessage = null;
      setState(() {
        isFormValid = false;
      });
    }

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Button(
              onPressed: isEnabled
                  ? () {
                      if (_formKey.currentState!.validate()) {
                        WhiteboardModel question = WhiteboardModel(
                            title: _titleController.text.trim(),
                            imageUrl: currentImage?.path ??
                                widget.question!.imageUrl);
                        viewmodel
                            .submitQuestion(
                          question: question,
                          levelID: widget.level,
                          unitNumber: widget.day,
                          section: widget.section,
                        )
                            .then((updatedQuestion) {
                          if (updatedQuestion != null) {
                            setState(() {
                              newImagePath = updatedQuestion.imageUrl;
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
              text: "submit",
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
}
