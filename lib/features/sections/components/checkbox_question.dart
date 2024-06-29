import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/sections/models/checkbox_answer.dart';
import 'package:ez_english/features/sections/models/checkbox_question_model.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/checkbox.dart';
import 'package:flutter/material.dart';

class CheckboxQuestion extends StatefulWidget {
  final CheckboxQuestionModel question;
  final Function(CheckboxAnswer) onChanged;

  const CheckboxQuestion({
    required this.question,
    required this.onChanged,
    super.key,
  });

  @override
  State<CheckboxQuestion> createState() => _CheckboxQuestionState();
}

class _CheckboxQuestionState extends State<CheckboxQuestion> {
  late List<CheckboxData> optionList;
  @override
  void initState() {
    super.initState();
    optionList = widget.question.options;
  }

  String readMoreText = AppStrings.mcQuestionReadMoreText;

  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Constants.gapH24,
        Text(
          widget.question.questionText,
          style: TextStyles.questionTextStyle,
        ),
        Constants.gapH24,
        CheckboxGroup(
          onChanged: (selections) {
            widget.onChanged(CheckboxAnswer(answer: selections));
          },
          options: optionList,
        ),
      ],
    );
  }
}
