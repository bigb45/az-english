import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/levels/screens/school/school_section_viewmodel.dart';
import 'package:ez_english/features/models/worksheet.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/upload_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SchoolSectionStudentWorksheetView extends StatefulWidget {
  final Worksheet worksheet;

  const SchoolSectionStudentWorksheetView({super.key, required this.worksheet});

  @override
  State<SchoolSectionStudentWorksheetView> createState() =>
      _SchoolSectionStudentWorksheetViewState();
}

class _SchoolSectionStudentWorksheetViewState
    extends State<SchoolSectionStudentWorksheetView> {
  late Worksheet worksheet;
  bool isSubmitted = false;
  @override
  void initState() {
    super.initState();
    final viewmodel = context.read<SchoolSectionViewmodel>();
    worksheet = widget.worksheet;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isSubmitted = viewmodel.getCurrentUserSubmission(widget.worksheet);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SchoolSectionViewmodel>(
      builder: (context, viewmodel, _) => Padding(
        padding: EdgeInsets.all(Constants.padding12),
        child: Center(
            child: viewmodel.isLoading
                ? const CircularProgressIndicator()
                : !isSubmitted
                    ? Column(
                        children: [
                          Text(
                            "Worksheet Title: ${worksheet.title}",
                            style: TextStyles.bodyLarge,
                          ),
                          Constants.gapH20,
                          UploadCard(
                            onPressed: () async {
                              final pickedImage = await ImagePicker().pickImage(
                                source: ImageSource.gallery,
                              );
                              if (pickedImage != null) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: const Text(
                                          "Are you sure you want to upload the selected image?"),
                                      title: const Text('Confirm Upload'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            await viewmodel
                                                .uploadStudentSubmission(
                                                    imagePath: pickedImage.path,
                                                    worksheet: worksheet);
                                          },
                                          child: const Text('Upload'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AutoSizeText(
                                  'Add Submission',
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
                            ),
                          ),
                        ],
                      )
                    : SingleChildScrollView(
                        // scrollDirection: Axis.horizontal,
                        child: Column(
                          children: [
                            Text("Your submission",
                                style: TextStyles.bodyLarge),
                            Container(
                              decoration: const BoxDecoration(),
                              child: InteractiveViewer(
                                child: CachedNetworkImage(
                                  imageUrl:
                                      viewmodel.uploadedWorksheet?.imagePath ??
                                          '',
                                  progressIndicatorBuilder:
                                      (context, url, progress) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: progress.progress,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Constants.padding12,
                            ),
                            Text("Answer key", style: TextStyles.bodyLarge),
                            Container(
                              child: InteractiveViewer(
                                child: CachedNetworkImage(
                                  imageUrl: worksheet.imageUrl ?? '',
                                  progressIndicatorBuilder:
                                      (context, url, progress) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: progress.progress,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
      ),
    );
  }
}
