import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/home/admin/users/users_settings_viewmodel.dart';
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

class WorksheetForm extends StatefulWidget {
  final String level;
  final String section;
  final String day;
  final Function(BaseQuestion<dynamic>)? onSubmit;

  const WorksheetForm({
    super.key,
    required this.level,
    required this.section,
    required this.day,
    this.onSubmit,
  });

  @override
  State<WorksheetForm> createState() => _WorksheetFormState();
}

class _WorksheetFormState extends State<WorksheetForm> {
  final _titleController = TextEditingController();
  // final _descriptionController = TextEditingController();

  bool isFormValid = false;
  String? updateMessage;
  String? imageUrl;
  File? currentImage;

  final _formKey = GlobalKey<FormState>();
  void _validateForm() {
    bool formValid =
        currentImage != null && (_formKey.currentState?.validate() ?? false);

    // bool changesMade = _checkForChanges();
    setState(() {
      isFormValid = formValid;
      printDebug("is valid: $isFormValid");
      // if (changesMade) {
      //   updateMessage = null;
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UsersSettingsViewmodel>(
      builder: (context, viewmodel, _) => Form(
        key: _formKey,
        onChanged: _validateForm,
        autovalidateMode: AutovalidateMode.always,
        child: viewmodel.isLoading
            ? CircularProgressIndicator()
            : Column(
                children: [
                  // TextFormField for worksheet title
                  TextFormField(
                    controller: _titleController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.fieldRequired;
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Worksheet Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Stack(
                    children: [
                      viewmodel.image != null
                          ? Center(child: Image.file(viewmodel.image!))
                          : UploadCard(
                              onPressed: () async {
                                await viewmodel.pickImage();
                                setState(() {
                                  currentImage = viewmodel.image;
                                  _validateForm();
                                });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AutoSizeText(
                                    'Add Worksheet',
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
                                  AutoSizeText(
                                    "Add worksheet solution",
                                    style: TextStyles.cardText,
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                  ),
                                ],
                              )),
                      if (viewmodel.image != null)
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

  Widget _updateButton(UsersSettingsViewmodel viewmodel) {
    bool isEnabled = isFormValid;
    void resetForm() {
      _titleController.clear();
      currentImage = null;
      viewmodel.removeImage();
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
                        printDebug(
                            "uploading image: ${currentImage!.path}, title: ${_titleController.text.trim()}, level: ${widget.level}, unit: ${widget.day}");
                        viewmodel
                            .uploadWorksheetAnswerKey(
                          imagePath: currentImage!.path,
                          worksheetTitle: _titleController.text.trim(),
                          levelID: widget.level,
                          unitNumber: widget.day,
                        )
                            .then((updatedQuestion) {
                          if (updatedQuestion != null) {
                            {
                              resetForm();
                              Utils.showSnackbar(
                                  text: "Question uploaded successfully");
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
