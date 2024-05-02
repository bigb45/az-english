// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:ez_english/core/Constants.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/word_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DragAndDropQuestion extends StatefulWidget {
  const DragAndDropQuestion({super.key});

  @override
  State<DragAndDropQuestion> createState() => _DragAndDropQuestionState();
}

class _DragAndDropQuestionState extends State<DragAndDropQuestion> {
  List<WordChipString> words = [
    WordChipString("Jumps"),
    WordChipString("over"),
    WordChipString("dog"),
    WordChipString("it"),
    WordChipString("The"),
    WordChipString("does"),
    WordChipString("is"),
    WordChipString("are"),
    WordChipString("do"),
  ];
  List<WordChipString> orderedWords = [];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Place the words in their correct order",
              style: TextStyles.bodyLarge),
          Column(
            children: [
              Column(
                children: [
                  Container(
                    height: 40.w,
                    child: Row(
                      children: orderedWords.map((word) {
                        return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Constants.padding4),
                            child: WordChip(
                              onPressed: () {
                                setState(() {
                                  orderedWords.remove(word);
                                  word.isSelected = false;
                                });
                              },
                              text: word.text,
                            ));
                      }).toList(),
                    ),
                  ),
                  Divider(
                    thickness: 2,
                    color: Palette.secondaryStroke,
                  ),
                ],
              ),
              WordOptions(
                onWordSelected: (value) {
                  setState(() {
                    orderedWords.add(value);
                    value.isSelected = true;
                  });
                },
                selectedWords: orderedWords,
                words: words,
              )
            ],
          )
        ],
      ),
    );
  }
}

class WordOptions extends StatefulWidget {
  final List<WordChipString> words;
  final List<WordChipString> selectedWords;
  final Function(WordChipString) onWordSelected;
  const WordOptions({
    super.key,
    required this.words,
    required this.onWordSelected,
    required this.selectedWords,
  });

  @override
  State<WordOptions> createState() => _WordOptionsState();
}

class _WordOptionsState extends State<WordOptions> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: Constants.padding8,
      children: widget.words
          .map(
            (word) => Padding(
              padding: EdgeInsets.symmetric(vertical: Constants.padding4),
              child: WordChip(
                isSelected: word.isSelected,
                onPressed: word.isSelected
                    ? null
                    : () {
                        widget.onWordSelected(word);
                      },
                text: word.text,
              ),
            ),
          )
          .toList(),
    );
  }
}

class WordChipString {
  final String text;
  bool isSelected;
  WordChipString(this.text, {this.isSelected = false});
}
