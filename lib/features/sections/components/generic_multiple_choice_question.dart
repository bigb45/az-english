import 'package:ez_english/core/constants.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/expandable_text.dart';
import 'package:ez_english/widgets/radio_button.dart';
import 'package:flutter/material.dart';

import '../models/multiple_choice_question_model.dart';

class GenericMultipleChoiceQuestion<T> extends StatefulWidget {
  final MultipleChoiceQuestionModel question;
  final String? image;
  final Function(RadioItemData) onChanged;
  const GenericMultipleChoiceQuestion(
      {super.key,
      required this.question,
      // required this.options,
      required this.onChanged,
      this.image});

  @override
  State<GenericMultipleChoiceQuestion> createState() =>
      _GenericMultipleChoiceQuestionState();
}

class _GenericMultipleChoiceQuestionState
    extends State<GenericMultipleChoiceQuestion> {
  bool _isFocused = false;
  late bool _isReadMore;
  RadioItemData? selectedOption;

  @override
  void initState() {
    super.initState();
    _isReadMore = widget.question.paragraph != null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Constants.gapH24,
            _isReadMore
                ? ExpandableTextBox(
                    questionText: widget.question.paragraph!,
                    isFocused: _isFocused,
                    isReadMore: _isReadMore,
                    readMoreText: AppStrings.mcQuestionReadMoreText)
                : const SizedBox(),
            Constants.gapH24,
            if (widget.image == null)
              const SizedBox() // placeholder
            else
              Image.network(widget.image!),
            SizedBox(height: Constants.padding20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.question.questionTextInEnglish,
                    style: TextStyles.practiceCardSecondaryText
                        .copyWith(height: 2),
                    maxLines: 5,
                  ),
                ),
              ],
            ),
            RadioGroup(
              onChanged: (newSelection) {
                setState(() {
                  _isFocused = false;
                  selectedOption = newSelection;
                  widget.onChanged(newSelection);
                });
              },
              options: widget.question.options,
              selectedOption: null,
            ),
            SizedBox(height: Constants.padding20),
          ],
        ),
      ],
    );
  }
}
