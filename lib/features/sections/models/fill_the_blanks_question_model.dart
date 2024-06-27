// ignore_for_file: avoid_print

import 'package:ez_english/features/models/base_question.dart';

class FillTheBlanksQuestionModel extends BaseQuestion<String> {
  final String? incompleteSentenceInEnglish;
  final String? incompleteSentenceInArabic;
  FillTheBlanksQuestionModel({
    this.incompleteSentenceInEnglish,
    this.incompleteSentenceInArabic,
    required super.answer,
    required super.questionTextInEnglish,
    required super.questionTextInArabic,
    super.questionType = QuestionType.fillTheBlanks,
    required super.imageUrl,
    required super.voiceUrl,
  });

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> baseMap = super.toMap();

    return {
      ...baseMap,
      "questionInEnglish": incompleteSentenceInEnglish,
      "questionInArabic": incompleteSentenceInArabic
    };
  }

  factory FillTheBlanksQuestionModel.fromMap(Map<String, dynamic> json) {
    return FillTheBlanksQuestionModel(
      answer: json['answer'],
      questionTextInEnglish: json['questionTextInEnglish'],
      questionTextInArabic: json['questionTextInArabic'],
      imageUrl: json['imageUrl'],
      voiceUrl: json['voiceUrl'],
      incompleteSentenceInEnglish: json['questionInEnglish'],
      incompleteSentenceInArabic: json['questionInArabic'],
      questionType: QuestionType.fillTheBlanks,
    );
  }

  @override
  bool evaluateAnswer() {
    return answer?.validate(userAnswer) ?? false;
  }
}
