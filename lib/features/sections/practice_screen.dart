import 'package:ez_english/core/constants.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/exercise_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:go_router/go_router.dart';

class PracticeScreen extends StatefulWidget {
  // TODO: use levelId to fetch title and exercises for the level via viewmodel
  final String levelId;
  final String levelName;
  const PracticeScreen({
    Key? key,
    required this.levelId,
    required this.levelName,
  }) : super(key: key);

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  late List<String> hintTexts = [];
  late List<String?> imageAssets = [];
  late List<Color> backgroundColors = [];
  late List<String> sectionNames = [];
  late List<String> sectionIds = [];

  @override
  void initState() {
    hintTexts = [
      AppStrings.readingSectionCardTitle,
      AppStrings.listeningAndWritingSectionCardTitle,
      AppStrings.vocabSectionCardTitle,
      AppStrings.grammarSectionCardTitle,
      AppStrings.skillTestSectionCardTitle
    ];
    imageAssets = [
      "assets/images/reading_section_card.svg",
      "assets/images/listening_section_card.svg",
      "assets/images/vocabulary_section_card.svg",
      "assets/images/grammar_section_card.svg",
      null
    ];
    backgroundColors = [
      const Color(0xFFFFA500),
      const Color(0xFF3498DB),
      Color.fromARGB(255, 143, 143, 143),
      const Color(0xFF663399),
      const Color(0xFF34495E)
    ];
    sectionNames = [
      "reading",
      "listening",
      "vocabulary",
      "grammar",
      "skill_test"
    ];
    sectionIds = ["0", "1", "2", "3", "4"];
    // setStatusBar to make the top side of the navbar with a different color since this is not supported for IOS in the default implementation of AppBar

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterStatusbarcolor.setStatusBarColor(Palette.primary);
    });

    super.initState();
  }

  void navigateToSection(
      {required String sectionName, required String sectionId}) {
    context.push(
        '/${widget.levelName}/${widget.levelId}/section/$sectionName/$sectionId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: const EdgeInsets.only(left: 0, right: 0),
          title: Text(
            AppStrings.practiceScreenTitle,
            style: TextStyle(
              fontSize: 24.sp,
              color: Palette.secondary,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            AppStrings.practiceScreenText,
            style: TextStyle(
              fontSize: 17.sp,
              color: Palette.secondary,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      body: SizedBox(
        child: SingleChildScrollView(
          child: SizedBox(
            child: Padding(
              padding: EdgeInsets.all(Constants.padding20),
              child: Center(
                child: Column(
                  children: [
                    Constants.gapH20,
                    Wrap(
                      alignment: WrapAlignment.center,
                      runSpacing: 15,
                      spacing: 10,
                      children: [
                        ...hintTexts.asMap().entries.map((entry) {
                          int index = entry.key;
                          String hintText = entry.value;
                          return _buildCard(
                            headerText: hintText,
                            cardText:
                                "Learn common everyday expressions and simple phrases",
                            // TODO: change this to completionState from viewmodel
                            onTap: sectionIds[index] == sectionIds.last
                                ? null
                                : () {
                                    navigateToSection(
                                        sectionId: sectionIds[index]);
                                  },
                            imagePath: imageAssets[index],
                            backgroundColor: backgroundColors[index],
                            sectionName: sectionNames[index],
                            sectionId: sectionIds[index],
                          );
                        }).toList(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String headerText,
    required String cardText,
    required Color backgroundColor,
    required String sectionName,
    required String sectionId,
    required VoidCallback? onTap,
    String? imagePath,
    bool secondaryText = false,
    Color? cardShadowColor,
  }) {
    return ExerciseCard(
      attempted: false,
      onPressed: onTap != null
          ? () {
              onTap();
            }
          : null,
      cardBackgroundColor: backgroundColor,
      image: imagePath,
      cardShadowColor: cardShadowColor,
      child: Text(
        headerText,
        style: secondaryText
            ? TextStyles.practiceCardSecondaryText
            : TextStyles.practiceCardMainText,
        textAlign: TextAlign.center,
      ),
    );
  }
}
