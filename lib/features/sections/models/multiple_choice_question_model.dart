// ignore_for_file: avoid_print

import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/models/multiple_choice_answer.dart';
import 'package:ez_english/widgets/radio_button.dart';

class MultipleChoiceQuestionModel<T> extends BaseQuestion<RadioItemData> {
  final List<RadioItemData> options;
  final String? paragraph;
  @override
  MultipleChoiceQuestionModel({
    required this.options,
    this.paragraph,
    required super.answer,
    required super.questionTextInArabic,
    required super.questionTextInEnglish,
    required super.imageUrl,
  }) : super(
          voiceUrl: "",
          questionType: QuestionType.multipleChoice,
        );

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> baseMap = super.toMap();
    return {
      ...baseMap,
      'options': options.map((option) => option.toMap()).toList(),
    };
  }

  factory MultipleChoiceQuestionModel.fromMap(Map<String, dynamic> map) {
    return MultipleChoiceQuestionModel(
      options: (map['options'] as List<dynamic>)
          .map((option) => RadioItemData.fromMap(option))
          .toList(),
      answer: MultipleChoiceAnswer(
          answer: RadioItemData.fromMap(map['answer']['answer'])),
      questionTextInEnglish: map['questionTextInEnglish'],
      questionTextInArabic: map['questionTextInArabic'],
      imageUrl: map['imageUrl'],
      // voiceUrl: map['voiceUrl'],
    );
  }
  bool validateQuestion(
      {required RadioItemData correctAnswer,
      required RadioItemData? userAnswer}) {
    return userAnswer?.value == correctAnswer.value;
  }
}
