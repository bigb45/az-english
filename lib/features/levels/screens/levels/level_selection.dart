import 'package:auto_size_text/auto_size_text.dart';
import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/features/levels/screens/levels/level_selection_viewmodel.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:ez_english/widgets/selectable_card.dart';
import 'package:ez_english/widgets/upload_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class LevelSelection extends StatefulWidget {
  const LevelSelection({Key? key}) : super(key: key);

  @override
  State<LevelSelection> createState() => _LevelSelectionState();
}

class _LevelSelectionState extends State<LevelSelection> {
  void navigateToLevel({required int levelId}) {
    context.push('/level/$levelId');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LevelSelectionViewmodel>(
      builder: (context, viewmodel, _) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          title: const Text(
            'Assigned Levels',
            style: TextStyle(color: Palette.primaryText),
          ),
          centerTitle: true,
        ),
        body: viewmodel.isLoading
            ? const Center(child: CircularProgressIndicator())
            : !viewmodel.isSpeakingAssigned &&
                    (viewmodel.levels.isNotEmpty &&
                        !viewmodel.levels[0].isAssigned)
                ? Center(
                    child: Text(
                      'No Assigned Sections yet.',
                      style: TextStyles.bodyLarge,
                    ),
                  )
                : SingleChildScrollView(
                    child: SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            runSpacing: 10.w,
                            spacing: 10.w,
                            children: [
                              if (viewmodel.levels.isNotEmpty)
                                viewmodel.levels[0].isAssigned
                                    ? _buildCard(
                                        headerText: "Speaking",
                                        isAssigned: true,
                                        cardText: "Practice Speaking",
                                        onTap: () {
                                          navigateToLevel(
                                            levelId: viewmodel.levels[0].id,
                                          );
                                          viewmodel.fetchSections(
                                            viewmodel.levels[0],
                                          );
                                        })
                                    : const SizedBox(),
                              viewmodel.isSpeakingAssigned
                                  ? _buildCard(
                                      headerText: "Practice",
                                      isAssigned: true,
                                      cardText: "Practice English",
                                      onTap: () {
                                        context.push('/speaking_practice');
                                      })
                                  : const SizedBox(),
                              viewmodel.isWorksheetUploaded
                                  ? _buildCard(
                                      headerText: "Worksheet",
                                      isAssigned: true,
                                      cardText: "View Worksheet answers",
                                      onTap: () {
                                        context.push('/student_worksheet_view');
                                      })
                                  : UploadCard(
                                      onPressed: () async {
                                        // TODO: Implement image upload in viewmodel
                                        final pickedImage =
                                            await ImagePicker().pickImage(
                                          source: ImageSource.gallery,
                                        );
                                        if (pickedImage != null) {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                content: const Text(
                                                    "Are you sure you want to upload the selected image?"),
                                                title: const Text(
                                                    'Confirm Upload'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);

                                                      viewmodel
                                                          .uploadWorksheetImage(
                                                              imagePath:
                                                                  pickedImage
                                                                      .path);
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          AutoSizeText(
                                            'Add Worksheet',
                                            style: TextStyles.cardHeader
                                                .copyWith(fontSize: 18.sp),
                                            textAlign: TextAlign.center,
                                            maxLines: 3,
                                          ),
                                          const Expanded(
                                            child: FittedBox(
                                              child: Icon(
                                                Icons.add_rounded,
                                                color: Palette.secondaryText,
                                              ),
                                            ),
                                          ),
                                          AutoSizeText(
                                            "Submit your worksheet",
                                            style: TextStyles.cardText,
                                            textAlign: TextAlign.center,
                                            maxLines: 3,
                                          ),
                                        ],
                                      ),
                                    )
                              // ...viewmodel.levels.map(
                              //   (level) {
                              //     return _buildCard(
                              //       headerText: level.name,
                              //       isAssigned: level.isAssigned,
                              //       cardText: level.description,
                              //       onTap: () {
                              //         navigateToLevel(levelId: level.id);
                              //         viewmodel.fetchSections(level);
                              //       },
                              //     );
                              //   },
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}

Widget _buildCard(
    {required String headerText,
    required String cardText,
    required Function() onTap,
    bool isAssigned = false}) {
  return SelectableCard(
    selected: isAssigned,
    onPressed: isAssigned
        ? () {
            onTap();
          }
        : null,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AutoSizeText(
          headerText,
          style: TextStyles.cardHeader.copyWith(fontSize: 18.sp),
          textAlign: TextAlign.center,
          maxLines: 3,
        ),
        Constants.gapH18,
        AutoSizeText(
          cardText,
          style: TextStyles.cardText,
          textAlign: TextAlign.center,
          maxLines: 3,
        ),
      ],
    ),
  );
}

class ErrorWidget extends StatelessWidget {
  final CustomException error;
  const ErrorWidget({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error,
            size: 100.h,
          ),
          Text(error.message),
          SizedBox(
            height: 30.h,
          ),
          Button(
              onPressed: () {
                context.read<LevelSelectionViewmodel>().fetchLevels();
              },
              text: 'Retry')
        ],
      ),
    );
  }
}
