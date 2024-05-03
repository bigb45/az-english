// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:ez_english/core/Constants.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/word_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SentenceFormingQuestion extends StatefulWidget {
  // TODO: fix divider and wrap alignment
  // TODO: make the words draggable, maybe not
  final String fullSentence;
  final String words;
  final Function(String) onChanged;
  const SentenceFormingQuestion(
      {super.key,
      required this.fullSentence,
      required this.words,
      required this.onChanged});

  @override
  State<SentenceFormingQuestion> createState() =>
      _SentenceFormingQuestionState();
}

class _SentenceFormingQuestionState extends State<SentenceFormingQuestion> {
  late List<WordChipString> words;
  @override
  void initState() {
    super.initState();
    words =
        widget.words.split(" ").map((word) => WordChipString(word)).toList();
    words.shuffle();
  }

  List<WordChipString> orderedWords = [];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          constraints: BoxConstraints(minHeight: 40.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Place the words in their correct order",
                  style: TextStyles.bodyLarge),
              Stack(
                children: [
                  Positioned(
                    top: 40.w,
                    left: 0,
                    right: 0,
                    child: Divider(
                      thickness: 2,
                      color: Palette.secondaryStroke,
                    ),
                  ),
                  Positioned(
                    top: 100.w,
                    left: 0,
                    right: 0,
                    child: Divider(
                      thickness: 2,
                      color: Palette.secondaryStroke,
                    ),
                  ),
                  Positioned(
                    top: 160.w,
                    left: 0,
                    right: 0,
                    child: Divider(
                      thickness: 2,
                      color: Palette.secondaryStroke,
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        height: 200.w,
                        width: double.infinity,
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          runSpacing: Constants.padding20,
                          children: orderedWords.map((word) {
                            return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Constants.padding4),
                                child: WordChip(
                                  onPressed: () {
                                    setState(() {
                                      orderedWords.remove(word);
                                      word.isSelected = false;
                                      widget.onChanged(
                                        orderedWords
                                            .map((e) => e.text)
                                            .join(" "),
                                      );
                                    });
                                  },
                                  text: word.text,
                                ));
                          }).toList(),
                        ),
                      ),
                      // Divider(
                      //   thickness: 2,
                      //   color: Palette.secondaryStroke,
                      // ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
        WordOptions(
          onWordSelected: (value) {
            setState(() {
              orderedWords.add(value);
              value.isSelected = true;
              widget.onChanged(
                orderedWords.map((e) => e.text).join(" "),
              );
            });
            print(
              orderedWords.map((e) => e.text).join(
                    " ",
                  ),
            );
          },
          selectedWords: orderedWords,
          words: words,
        ),
      ],
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
