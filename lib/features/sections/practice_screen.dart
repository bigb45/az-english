import 'package:ez_english/core/constants.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/exercise_card.dart';
import 'package:ez_english/widgets/progress_bar.dart';
import 'package:ez_english/widgets/selectable_card.dart';
import 'package:flutter/material.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({Key? key}) : super(key: key);

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  @override
  void initState() {
    // setStatusBar to make the top side of the navbar with a different color since this is not supported for IOS in the default implementation of AppBar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterStatusbarcolor.setStatusBarColor(Palette.primary);
    });

    super.initState();
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
          child: Column(
            children: [
              // First row
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: ProgressBar(value: 20),
              ),
              Constants.gapH36,
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    _buildCard(
                        headerText: AppStrings.readingSectionCardTitle,
                        cardText:
                            "learn common everyday expressions and simple phrases",
                        imagePath: "assets/images/reading_section_card.svg",
                        backgroundColor: const Color(0xFFFFA500),
                        cardShadowColor: const Color(0xFFFFA500)),
                    Constants.gapW10,
                    _buildCard(
                        headerText:
                            AppStrings.listeningAndWritingSectionCardTitle,
                        cardText:
                            "learn common everyday expressions and simple phrases",
                        imagePath: "assets/images/listening_section_card.svg",
                        backgroundColor: const Color(0xFF3498DB),
                        cardShadowColor: const Color(0xFF3498DB)),
                  ],
                ),
              ),
              // Second row
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    _buildCard(
                        headerText: AppStrings.vocabSectionCardTitle,
                        cardText:
                            "learn common everyday expressions and simple phrases",
                        imagePath: "assets/images/vocabulary_section_card.svg",
                        backgroundColor: const Color(0xFFECECEC),
                        cardShadowColor: const Color(0xFFECECEC),
                        secondaryText: true),
                    Constants.gapW10,
                    _buildCard(
                        headerText: AppStrings.grammarSectionCardTitle,
                        cardText:
                            "learn common everyday expressions and simple phrases",
                        imagePath: "assets/images/grammar_section_card.svg",
                        backgroundColor: const Color(0xFF663399),
                        cardShadowColor: const Color(0xFF663399)),
                  ],
                ),
              ),
              // Third row
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCard(
                      headerText: AppStrings.skillTestSectionCardTitle,
                      cardText:
                          "learn common everyday expressions and simple phrases",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// TODO ask about shadow colors for the cards
  Widget _buildCard({
    required String headerText,
    required String cardText,
    String? imagePath,
    Color? backgroundColor,
    bool secondaryText = false,
    Color? cardShadowColor,
  }) {
    return ExerciseCard(
      attempted: false,
      onPressed: () {},
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
