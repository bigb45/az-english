// ignore_for_file: avoid_print

import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/widgets/radio_button.dart';

class MultipleChoiceQuestionModel<T> extends BaseQuestion<RadioItemData> {
  final List<RadioItemData> options;
  final String? questionSentence;
  final String? paragraph;
  @override
  final RadioItemData answer;

  MultipleChoiceQuestionModel(
      {required this.options,
      this.questionSentence,
      this.paragraph,
      required this.answer,
      required super.questionTextInArabic,
      required super.questionTextInEnglish,
      required super.imageUrl,
      super.voiceUrl = "",
      super.questionType = QuestionType.multipleChoice})
      : super(answer: answer);

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> baseMap = super.toMap();
    return {
      ...baseMap,
      'options': options.map((option) => option.toMap()).toList(),
      'answer': answer.toMap(),
      'questionSentence': questionSentence
    };
  }

  factory MultipleChoiceQuestionModel.fromMap(Map<String, dynamic> map) {
    return MultipleChoiceQuestionModel(
      options: (map['options'] as List<Map<String, dynamic>>)
          .map((option) => RadioItemData.fromMap(option))
          .toList(),
      answer: RadioItemData.fromMap(map['answer']),
      questionTextInEnglish: map['questionTextInEnglish'],
      questionTextInArabic: map['questionTextInArabic'],
      imageUrl: map['imageUrl'],
      voiceUrl: map['voiceUrl'],
      questionSentence: map['questionSentence'],
    );
  }
  bool validateQuestion(
      {required RadioItemData correctAnswer,
      required RadioItemData? userAnswer}) {
    return userAnswer?.value == correctAnswer.value;
  }
}
