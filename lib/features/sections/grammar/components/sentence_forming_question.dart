import 'package:ez_english/core/Constants.dart';
import 'package:ez_english/features/sections/components/evaluation_section.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/word_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SentenceFormingQuestion extends StatefulWidget {
  final String fullSentence;
  // TODO: figure out how to make the same question incorporate partial sentences
  final List<String>? partialSentence;
  final String words;
  final EvaluationState answerState;
  final Function(String) onChanged;

  const SentenceFormingQuestion({
    super.key,
    this.partialSentence,
    required this.fullSentence,
    required this.words,
    required this.answerState,
    required this.onChanged,
  });

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
                    child: const Divider(
                      thickness: 2,
                      color: Palette.secondaryStroke,
                    ),
                  ),
                  Positioned(
                    top: 100.w,
                    left: 0,
                    right: 0,
                    child: const Divider(
                      thickness: 2,
                      color: Palette.secondaryStroke,
                    ),
                  ),
                  Positioned(
                    top: 160.w,
                    left: 0,
                    right: 0,
                    child: const Divider(
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
                            children: [
                              Text(widget.partialSentence?[0] ?? "",
                                  style: TextStyles.bodyLarge),
                              ...orderedWords.map(
                                (word) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Constants.padding4),
                                    child: WordChip(
                                      onPressed: widget.answerState ==
                                              EvaluationState.correct
                                          ? null
                                          : () {
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
                                    ),
                                  );
                                },
                              ),
                            ]),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
        WordOptions(
          answerState: widget.answerState,
          onWordSelected: (value) {
            setState(() {
              orderedWords.add(value);
              value.isSelected = true;
              widget.onChanged(
                orderedWords.map((e) => e.text).join(" "),
              );
            });
            // print(
            //   orderedWords.map((e) => e.text).join(
            //         " ",
            //       ),
            // );
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
  final EvaluationState answerState;
  const WordOptions(
      {super.key,
      required this.words,
      required this.onWordSelected,
      required this.selectedWords,
      required this.answerState});

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
                onPressed: word.isSelected ||
                        widget.answerState == EvaluationState.correct
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
