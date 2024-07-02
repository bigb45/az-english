import 'package:ez_english/core/constants.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:flutter/material.dart';

class ExpandableTextBox extends StatefulWidget {
  final bool? isReadMore;
  final String readMoreText;
  bool? isFocused;
  final String paragraph;

  ExpandableTextBox({
    super.key,
    this.isReadMore,
    required this.readMoreText,
    this.isFocused,
    required this.paragraph,
  });

  @override
  State<ExpandableTextBox> createState() => _ExpandableTextBoxState();
}

class _ExpandableTextBoxState extends State<ExpandableTextBox> {
  late bool isReadMore;
  late String readMoreText;
  late bool isFocused;
  late String formattedParagraph;

  @override
  void initState() {
    isFocused = false;
    isReadMore = false;
    readMoreText = widget.readMoreText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.isFocused = true;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: widget.isFocused! ? Colors.blue : Colors.grey,
            width: 2.0,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text(
                widget.paragraph,
                maxLines: isReadMore ? 100 : 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.readingPracticeTextStyle,
              ),
              Constants.gapH12,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Add onPressed action here
                      setState(() {
                        isReadMore = !isReadMore;
                        readMoreText == AppStrings.mcQuestionReadMoreText
                            ? readMoreText = AppStrings.mcQuestionShowLessText
                            : readMoreText = AppStrings.mcQuestionReadMoreText;
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          readMoreText,
                          style: TextStyles.showMoreTextStyle,
                        ),
                        Icon(
                          isReadMore
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Palette.primaryVariantShadow,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
