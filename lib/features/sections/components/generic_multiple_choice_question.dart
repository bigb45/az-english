import 'package:cached_network_image/cached_network_image.dart';
import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/sections/models/multiple_choice_answer.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/utils/utils.dart';
import 'package:ez_english/widgets/expandable_text.dart';
import 'package:ez_english/widgets/radio_button.dart';
import 'package:flutter/material.dart';

import '../models/multiple_choice_question_model.dart';

class GenericMultipleChoiceQuestion<T> extends StatefulWidget {
  final MultipleChoiceQuestionModel question;
  final String? image;
  final Function(MultipleChoiceAnswer) onChanged;
  const GenericMultipleChoiceQuestion(
      {super.key, required this.question, required this.onChanged, this.image});

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
                    paragraph: widget.question.paragraph!,
                    paragraphTranslation: widget.question.paragraphTranslation!,
                    isFocused: _isFocused,
                    isReadMore: _isReadMore,
                    readMoreText: AppStrings.mcQuestionReadMoreText)
                : const SizedBox(),
            Constants.gapH24,
            if (widget.question.imageUrl == null)
              const SizedBox() // placeholder
            else
              CachedNetworkImage(
                imageUrl: widget.question.imageUrl!,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
              ),
            SizedBox(height: Constants.padding20),
            Text(
              widget.question.questionTextInEnglish ??
                  "Please Choose one of the choices",
              style: TextStyles.questionTextStyle.copyWith(height: 2),
              maxLines: 5,
            ),
            if (widget.question.questionSentenceInEnglish != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: RichText(
                  text: TextSpan(
                      children: stringToRichText(
                    widget.question.questionSentenceInEnglish!,
                  )),
                  // style: TextStyles.questionTextStyle.copyWith(height: 1.5),
                  maxLines: 5,
                ),
              ),
            if (widget.question.questionSentenceInArabic != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: RichText(
                  textDirection: TextDirection.rtl,
                  text: TextSpan(
                      children: stringToRichText(
                    widget.question.questionSentenceInArabic!,
                  )),
                  // style: TextStyles.questionTextStyle.copyWith(height: 1.5),
                  maxLines: 5,
                ),
              ),
            Constants.gapH24,
            RadioGroup(
              onChanged: (newSelection) {
                setState(() {
                  _isFocused = false;
                  selectedOption = newSelection;
                  widget.onChanged(MultipleChoiceAnswer(answer: newSelection));
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
