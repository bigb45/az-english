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
  final String? paragraphTranslation;
  ExpandableTextBox({
    super.key,
    this.isReadMore,
    this.isFocused,
    this.paragraphTranslation,
    required this.readMoreText,
    required this.paragraph,
  });

  @override
  State<ExpandableTextBox> createState() => _ExpandableTextBoxState();
}

class _ExpandableTextBoxState extends State<ExpandableTextBox> {
  bool isReadMore = false;
  bool isFocused = false;
  bool translate = false;
  late String readMoreText;
  late String formattedParagraph;

  @override
  void initState() {
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
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              widget.paragraphTranslation == null
                  ? const SizedBox()
                  : Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Palette.primary,
                            boxShadow: const [
                              BoxShadow(
                                color: Palette.primaryShadow,
                                blurRadius: 0.0,
                                offset: Offset(0, 3),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          child: IconButton(
                            color: Palette.secondary,
                            onPressed: () {
                              setState(() {
                                translate = !translate;
                              });
                            },
                            icon: const Icon(
                              Icons.translate,
                            ),
                          ),
                        ),
                      ],
                    ),
              Text(
                translate ? widget.paragraphTranslation! : widget.paragraph,
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
