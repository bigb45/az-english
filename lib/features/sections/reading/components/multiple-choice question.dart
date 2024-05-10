import 'package:ez_english/core/constants.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:ez_english/widgets/expandable_text.dart';
import 'package:ez_english/widgets/microphone_button.dart';
import 'package:ez_english/widgets/progress_bar.dart';
import 'package:ez_english/widgets/radio_button.dart';
import 'package:ez_english/widgets/text_box.dart';
import 'package:ez_english/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';

class MultipleChoiceQuestion extends StatefulWidget {
  const MultipleChoiceQuestion({
    super.key,
  });

  @override
  State<MultipleChoiceQuestion> createState() => _MultipleChoiceQuestionState();
}

class _MultipleChoiceQuestionState extends State<MultipleChoiceQuestion> {
  bool _isFocused = false;
  bool _isReadMore = false;
  RadioItemData? selectedOption;
  String readMoreText = AppStrings.mcQuestionReadMoreText;
// TODO dynamic list
  var optList = [
    RadioItemData(
      value: "1",
      title: "A Bag",
    ),
    RadioItemData(
      value: "2",
      title: "A Backpack",
    ),
    RadioItemData(
      value: "3",
      title: "A Suitcase",
    ),
    RadioItemData(
      value: "4",
      title: "A Duffle Bag",
    )
  ];
  @override
  void initState() {
    super.initState();
    selectedOption = optList.isNotEmpty ? optList[0] : null;
  }

  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Constants.gapH24,
        ExpandableTextBox(
            // TODO dynamic text
            questionText:
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit,sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris",
            isFocused: _isFocused,
            isReadMore: _isReadMore,
            readMoreText: readMoreText),
        Constants.gapH24,
        Text(
          AppStrings.mcQuestionText,
          style: TextStyles.questionTextStyle,
        ),
        Constants.gapH24,
        RadioGroup(
          onChanged: (_selectedOption) {
            setState(() {
              _isFocused = false;
              selectedOption = _selectedOption;
            });
          },
          options: optList,
          selectedOption: selectedOption,
        ),
      ],
    );
  }
}
