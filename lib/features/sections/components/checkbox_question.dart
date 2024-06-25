import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/sections/models/checkbox_question_model.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/checkbox.dart';
import 'package:ez_english/widgets/expandable_text.dart';
import 'package:flutter/material.dart';

class CheckboxQuestion extends StatefulWidget {
  final CheckboxQuestionModel question;
  const CheckboxQuestion({
    required this.question,
    super.key,
  });

  @override
  State<CheckboxQuestion> createState() => _CheckboxQuestionState();
}

class _CheckboxQuestionState extends State<CheckboxQuestion> {
  bool _isFocused = false;
  late bool _isReadMore;
  late List<CheckboxData> optionList;
  @override
  void initState() {
    super.initState();
    _isReadMore = widget.question.paragraph != null;
    optionList = widget.question.options;
  }

  String readMoreText = AppStrings.mcQuestionReadMoreText;

  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Constants.gapH24,
        _isReadMore
            ? ExpandableTextBox(
                paragraph: widget.question.paragraph!,
                isFocused: _isFocused,
                isReadMore: _isReadMore,
                readMoreText: readMoreText)
            : const SizedBox(),
        Constants.gapH24,
        // TODO: Is it a fixed question or should it be dynamic?
        // Text(
        //   AppStrings.mcQuestionText,
        //   style: TextStyles.questionTextStyle,
        // ),
        Text(
          widget.question.questionText,
          style: TextStyles.questionTextStyle,
        ),
        Constants.gapH24,
        CheckboxGroup(
            onChanged: (selections) {
              widget.question.onChanged(selections);
              setState(() {
                _isFocused = false;
              });
            },
            options: optionList),
      ],
    );
  }
}
