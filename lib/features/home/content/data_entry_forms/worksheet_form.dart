import 'package:auto_size_text/auto_size_text.dart';
import 'package:ez_english/features/home/admin/users/users_settings_viewmodel.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/text_field.dart';
import 'package:ez_english/widgets/upload_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class WorksheetForm extends StatelessWidget {
  const WorksheetForm({super.key});

  @override
  Widget build(BuildContext context) {
    final _controller = TextEditingController();

    return Consumer<UsersSettingsViewmodel>(
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
                              onPressed: () async {
                                // TODO:change this to dynamic after implementing the form
                                await viewmodel.uploadWorksheetAnswerKey(
                                    imagePath: pickedImage.path,
                                    worksheetTitle: _controller.text.isEmpty
                                        ? "Untitled worksheet"
                                        : _controller.text,
                                    levelID: 'A1',
                                    unitNumber: '1');
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
              style: TextStyles.cardHeader.copyWith(fontSize: 18.sp),
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
        ),
      ),
    );
  }
}
