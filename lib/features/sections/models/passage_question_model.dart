import 'dart:convert';

import 'package:ez_english/features/models/base_question.dart';

class PassageQuestionModel extends BaseQuestion {
  String? passageInEnglish;
  String? passageInArabic;
  String? titleInArabic;
  List<BaseQuestion?> questions;
  PassageQuestionModel(
      {this.passageInArabic,
      this.passageInEnglish,
      this.titleInArabic,
      required super.titleInEnglish,
      required this.questions,
      required super.questionTextInEnglish,
      required super.questionTextInArabic,
      required super.imageUrl,
      required super.voiceUrl,
      super.questionType = QuestionType.passage});

  factory PassageQuestionModel.fromMap(Map<String, dynamic> map) {
    return PassageQuestionModel(
      passageInEnglish: map['passageInEnglish'] ?? "No English Passage",
      passageInArabic: map['passageInArabic'] ?? "No Arabic Passage",
      titleInArabic: map['titleInArabic'] ?? "No title in Arabic",
      titleInEnglish: map['titleInEnglish'] ?? "No title in English",
      questions: (map['questions'] as List)
          .map((item) => BaseQuestion.fromMap(item))
          .toList(),
      questionTextInEnglish: map['questionTextInEnglish'],
      questionTextInArabic: map['questionTextInArabic'],
      imageUrl: map['imageUrl'],
      voiceUrl: map['voiceUrl'],
      questionType: QuestionType.passage,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> baseMap = super.toMap();
    return {
      ...baseMap,
      'passageInEnglish': passageInEnglish,
      'passageInArabic': passageInArabic,
      'titleInArabic': titleInArabic,
      "titleInEnglish": titleInEnglish,
      "questions": questions.map((question) => question?.toMap()).toList()
    };
  }

  factory PassageQuestionModel.fromJson(String data) {
    return PassageQuestionModel.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }
}
