import 'package:ez_english/core/constants.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/microphone_button.dart';
import 'package:ez_english/widgets/text_box.dart';
import 'package:flutter/material.dart';

class SpeakingQuestion extends StatefulWidget {
  const SpeakingQuestion({
    super.key,
  });

  @override
  State<SpeakingQuestion> createState() => _SpeakingQuestionState();
}

class _SpeakingQuestionState extends State<SpeakingQuestion> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Constants.gapH18,
            CustomTextBox(
              // TODO: Dynamic text
              paragraphText:
                  '''Lorem  ipsum  dolor  sit  amet, consectetur  adipiscing  elit,
  sed  do  eiusmod  tempor  incididunt  ut  labore  et  dolore  magna  aliqua.  Ut  enim  ad  minim  veniam,  quis  nostrud  exercitation  ullamco  laboris   ''',
              maxLineNum: 7,
              secondaryTextStyle:
                  TextStyles.readingPracticeTextStyle.copyWith(height: 1.5),
            ),
            Constants.gapH18,
            // TODO: New design
            CustomTextBox(
              paragraphText:
                  '''Lorem  ipsum  dolor  sit  amet, consectetur  adipiscing  elit ''',
              maxLineNum: 2,
              secondaryTextStyle:
                  TextStyles.readingPracticeTextStyle.copyWith(height: 1.5),
            ),
            Constants.gapH8,
            AudioControlButton(
              onPressed: () {},
              type: AudioControlType.microphone,
            ),
            Constants.gapH12,
            Text(
              AppStrings.speakingQuesiton,
              textAlign: TextAlign.center,
              style: TextStyles.readingPracticeSecondaryTextStyle,
            ),
          ],
        ),
      ],
    );
  }
}
