import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/sections/models/word_definition.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WordListTile extends StatelessWidget {
  final Function onTap;
  final WordDefinition word;
  const WordListTile({super.key, required this.word, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Palette.secondaryStroke),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Constants.padding20,
              vertical: word.isNew ? Constants.padding12 : Constants.padding20),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  word.isNew
                      ? Text("New", style: TextStyles.indicator)
                      : const SizedBox(),
                  word.isNew ? SizedBox(height: 10.h) : const SizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        word.word,
                        style: TextStyles.practiceCardSecondaryText,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      const Icon(
                        Icons.circle,
                        color: Palette.primaryText,
                        size: 5,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      // TODO: change this to a switch case
                      Text(word.type.toShortString(),
                          style: TextStyles.wordType),
                    ],
                  ),
                ],
              ),
              const Expanded(child: SizedBox()),
              const Icon(Icons.arrow_forward)
            ],
          ),
        ),
      ),
    );
  }
}
