import 'package:auto_size_text/auto_size_text.dart';
import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/features/levels/screens/level_selection_viewmodel.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:ez_english/widgets/selectable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
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
    LevelSelectionViewmodel viewmodel =
        Provider.of<LevelSelectionViewmodel>(context);

    return Scaffold(
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
          : viewmodel.error != null
              ? ErrorWidget(
                  error: viewmodel.error ??
                      CustomException(
                        "",
                      ))
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
                            _buildCard(
                                headerText: "Practice",
                                isAssigned: true,
                                cardText: "Practice english",
                                onTap: () {
                                  navigateToLevel(
                                    levelId: viewmodel.levels[0].id,
                                  );
                                  viewmodel.fetchSections(
                                    viewmodel.levels[0],
                                  );
                                }),
                            _buildCard(
                                headerText: "Speaking",
                                isAssigned: true,
                                cardText: "Practice Speaking",
                                onTap: () {
                                  context.push('/speaking_practice');
                                })
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
