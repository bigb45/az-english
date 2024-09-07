// ignore_for_file: avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:auto_size_text/auto_size_text.dart';
import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/home/admin/users/users_settings_viewmodel.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/selectable_card.dart';
import 'package:ez_english/widgets/text_field.dart';
import 'package:ez_english/widgets/upload_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatelessWidget {
  AdminScreen({super.key});
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Palette.primaryText),
        title: const Text(
          'Administrator',
          style: TextStyle(color: Palette.primaryText),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.all(Constants.padding12),
        child: Column(
          children: [
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 10.w,
                runSpacing: 10.w,
                children: [
                  SelectableCard(
                    onPressed: () {
                      context.push(
                        "/all_users", // navigate user settings
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SvgPicture.asset(
                          "assets/images/users.svg",
                          height: 80.h,
                          width: 80.w,
                        ),
                        Text(
                          "Users",
                          style: TextStyles.bodyLarge,
                        )
                      ],
                    ),
                  ),
                  SelectableCard(
                    onPressed: () {
                      context.push(
                        "/all_questions",
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SvgPicture.asset(
                          "assets/images/question-mark.svg",
                          height: 80.h,
                          width: 80.w,
                        ),
                        Text(
                          "Questions",
                          style: TextStyles.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                  Consumer<UsersSettingsViewmodel>(
                    builder: (context, viewmodel, _) => UploadCard(
                      onPressed: viewmodel.isLoading
                          ? () {}
                          : () async {
                              final pickedImage = await ImagePicker().pickImage(
                                source: ImageSource.gallery,
                              );
                              if (pickedImage != null && context.mounted) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                          "Add a title",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              viewmodel.uploadWorksheetSolution(
                                                  imagePath: pickedImage.path,
                                                  worksheetTitle:
                                                      _controller.text.isEmpty
                                                          ? "Untitled worksheet"
                                                          : _controller.text);
                                              _controller.clear();
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Add"),
                                          ),
                                        ],
                                        content: Form(
                                          child: CustomTextField(
                                            controller: _controller,
                                            hintText: "Enter a title",
                                          ),
                                        ),
                                      );
                                    });
                              }
                            },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AutoSizeText(
                            'Add Worksheet',
                            style:
                                TextStyles.cardHeader.copyWith(fontSize: 18.sp),
                            textAlign: TextAlign.center,
                            maxLines: 3,
                          ),
                          Expanded(
                            child: viewmodel.isLoading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: Palette.primaryText,
                                    ),
                                  )
                                : FittedBox(
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
                      ),
                    ),
                  ),
                  SelectableCard(
                    onPressed: () {
                      context.push(
                        "/all_worksheets",
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SvgPicture.asset(
                          "assets/images/worksheets.svg",
                          height: 80.h,
                          width: 80.w,
                        ),
                        Text(
                          "Worksheets",
                          style: TextStyles.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
