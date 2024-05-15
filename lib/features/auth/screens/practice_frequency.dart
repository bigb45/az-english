import 'package:ez_english/core/constants.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:ez_english/widgets/menu.dart';
import 'package:flutter/material.dart';

class PracticeFrequencyScreen extends StatefulWidget {
  const PracticeFrequencyScreen({super.key});

  @override
  State<PracticeFrequencyScreen> createState() =>
      _PracticeFrequencyScreenState();
}

class _PracticeFrequencyScreenState extends State<PracticeFrequencyScreen> {
  final usedGap = Constants.gapH16;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(Constants.padding12),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Constants.gapAppBarH,
              Constants.gapAppBarH,
              Constants.gapAppBarH,
              Text(
                AppStrings.practiceFrequencyScreenTitle,
                textAlign: TextAlign.center,
                style:
                    TextStyles.cardHeader.copyWith(color: Palette.primaryText),
              ),
              Constants.gapH36,
              // TODO change logo

              usedGap,
              Menu(
                onItemSelected: (index) {
                  print(index);
                },
                items: [
                  MenuItemData(
                    mainText: AppStrings.practiceFrequencyPlanOne,
                    description: AppStrings.practiceFrequencyPlanOneDescription,
                  ),
                  MenuItemData(
                    mainText: AppStrings.practiceFrequencyPlanTwo,
                    description: AppStrings.practiceFrequencyPlanTwoDescription,
                  ),
                ],
              ),
              Constants.gapAppBarH,
              Constants.gapAppBarH,

              Button(
                text: AppStrings.continueButton,
                onPressed: () {},
                type: ButtonType.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
