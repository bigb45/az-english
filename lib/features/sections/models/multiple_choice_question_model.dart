// ignore_for_file: avoid_print

import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/models/multiple_choice_answer.dart';
import 'package:ez_english/widgets/radio_button.dart';

class MultipleChoiceQuestionModel extends BaseQuestion<RadioItemData> {
  final List<RadioItemData> options;
  final String? paragraph;
  final String? questionSentenceInEnglish;
  final String? questionSentenceInArabic;
  @override
  MultipleChoiceQuestionModel(
      {required this.options,
      this.questionSentenceInEnglish,
      required this.questionSentenceInArabic,
      this.paragraph,
      required super.answer,
      required super.questionTextInArabic,
      required super.questionTextInEnglish,
      required super.imageUrl,
      super.voiceUrl,
      super.questionType = QuestionType.multipleChoice});

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> baseMap = super.toMap();
    return {
      ...baseMap,
      'options': options.map((option) => option.toMap()).toList(),
      'questionSentenceInEnglish': questionSentenceInEnglish,
      'questionSentenceInArabic': questionSentenceInArabic
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
      voiceUrl: map['voiceUrl'],
      imageUrl: map['imageUrl'],
      questionSentenceInEnglish: map['questionSentenceInEnglish'],
      questionSentenceInArabic: map['questionSentenceInArabic'],
    );
  }

  @override
  bool evaluateAnswer() {
    return answer?.validate(userAnswer) ?? false;
  }
}
