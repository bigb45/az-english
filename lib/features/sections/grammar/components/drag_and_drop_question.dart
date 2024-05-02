// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

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
  String selectedWord = "";
  List<String> words = [
    "Jumps",
    "over",
    "The",
    "does",
    "is",
    "are",
    "do",
  ];
  List<String> orderedWords = [];
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
                                });
                              },
                              text: word,
                            )
                            // Container(
                            //   width: 100.w,
                            //   height: 40.w,
                            //   decoration: BoxDecoration(
                            //     color: Palette.secondaryStroke,
                            //     borderRadius: BorderRadius.circular(16.r),
                            //   ),
                            // ),
                            );
                      }).toList(),
                      // [
                      //   // Text("The dog", style: TextStyles.wordChipTextStyle),
                      //   // Padding(
                      //   //   padding: EdgeInsets.symmetric(
                      //   //       horizontal: Constants.padding4),
                      //   //   child: Container(
                      //   //     width: 100.w,
                      //   //     height: 40.w,
                      //   //     decoration: BoxDecoration(
                      //   //       color: Palette.secondaryStroke,
                      //   //       borderRadius: BorderRadius.circular(16.r),
                      //   //     ),
                      //   //   ),
                      //   // ),
                      //   // Text("over the fox", style: TextStyles.wordChipTextStyle),
                      // ],
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
                    print(value);
                    setState(() {
                      orderedWords.add(value);
                    });
                  },
                  words: words)
            ],
          )
        ],
      ),
    );
  }
}

class WordOptions extends StatefulWidget {
  final List<String> words;
  final Function(String) onWordSelected;
  const WordOptions(
      {super.key, required this.words, required this.onWordSelected});

  @override
  State<WordOptions> createState() => _WordOptionsState();
}

class _WordOptionsState extends State<WordOptions> {
  @override
  Widget build(BuildContext context) {
    // widget.words.shuffle();
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: Constants.padding8,
      children: widget.words
          .map(
            (word) => Padding(
              padding: EdgeInsets.symmetric(vertical: Constants.padding4),
              child: WordChip(
                onPressed: () {
                  widget.onWordSelected(word);
                },
                text: word,
              ),
            ),
          )
          .toList(),
    );
  }
}
