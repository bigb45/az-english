// ignore_for_file: avoid_print

import 'package:ez_english/features/models/base_question.dart';

class FillTheBlanksQuestionModel extends BaseQuestion<String> {
  final String? questionInEnglish;
  final String? questionInArabic;
  FillTheBlanksQuestionModel({
    this.questionInEnglish,
    this.questionInArabic,
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
      "questionInEnglish": questionInEnglish,
      "questionInArabic": questionInArabic
    };
  }

  factory FillTheBlanksQuestionModel.fromMap(Map<String, dynamic> json) {
    return FillTheBlanksQuestionModel(
      answer: json['answer'],
      questionTextInEnglish: json['questionTextInEnglish'],
      questionTextInArabic: json['questionTextInArabic'],
      imageUrl: json['imageUrl'],
      voiceUrl: json['voiceUrl'],
      questionInEnglish: json['questionInEnglish'],
      questionInArabic: json['questionInArabic'],
      questionType: QuestionType.fillTheBlanks,
    );
  }
}
