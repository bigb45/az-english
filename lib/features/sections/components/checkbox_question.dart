import 'package:ez_english/core/constants.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/checkbox.dart';
import 'package:ez_english/widgets/expandable_text.dart';
import 'package:flutter/material.dart';

class CheckboxQuestion extends StatefulWidget {
  const CheckboxQuestion({
    super.key,
  });

  @override
  State<CheckboxQuestion> createState() => _CheckboxQuestionState();
}

class _CheckboxQuestionState extends State<CheckboxQuestion> {
  bool _isFocused = false;
  bool _isReadMore = false;
  String readMoreText = AppStrings.mcQuestionReadMoreText;
// TODO dynamic list
  var optList = [
    CheckboxData(
      title: "Option 1",
    ),
    CheckboxData(
      title: "Option 2",
    ),
    CheckboxData(
      title: "Option 3",
    ),
    CheckboxData(
      title: "Option 4",
    ),
  ];
  @override
  void initState() {
    super.initState();
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
        // TODO: Is it a fixed question or should it be dynamic?
        Text(
          AppStrings.mcQuestionText,
          style: TextStyles.questionTextStyle,
        ),
        Constants.gapH24,
        CheckboxGroup(
            onChanged: (selections) {
              List<bool?> options = selections.map((e) => e.value).toList();
              print("new selections: $options");
              setState(() {
                _isFocused = false;
              });
            },
            options: optList),
      ],
    );
  }
}
