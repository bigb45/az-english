import 'dart:convert';

import 'package:ez_english/features/models/base_question.dart';

class PassageQuestionModel extends BaseQuestion {
  String? passageInEnglish;
  String? passageInArabic;
  String? titleInArabic;
  Map<int, BaseQuestion?> questions;
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
      super.sectionName,
      super.questionType = QuestionType.passage});

  @override
  PassageQuestionModel copy() {
    return PassageQuestionModel(
      passageInArabic: passageInArabic,
      passageInEnglish: passageInEnglish,
      titleInArabic: titleInArabic,
      titleInEnglish: titleInEnglish,
      questionTextInEnglish: questionTextInEnglish,
      questionTextInArabic: questionTextInArabic,
      imageUrl: imageUrl,
      voiceUrl: voiceUrl,
      questionType: questionType,
      questions: questions.map(
        (key, value) => MapEntry(key, value?.copy()),
      ),
    );
  }

  factory PassageQuestionModel.fromMap(Map<String, dynamic> map) {
    return PassageQuestionModel(
      passageInEnglish: map['passageInEnglish'] ?? "No English Passage",
      passageInArabic: map['passageInArabic'] ?? "No Arabic Passage",
      titleInArabic: map['titleInArabic'] ?? "No title in Arabic",
      titleInEnglish: map['titleInEnglish'] ?? "No title in English",
      questions: (map['questions'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(int.parse(key), BaseQuestion.fromMap(value)),
      ),
      questionTextInEnglish: map['questionTextInEnglish'],
      questionTextInArabic: map['questionTextInArabic'],
      imageUrl: map['imageUrl'],
      voiceUrl: map['voiceUrl'],
      questionType: QuestionType.passage,
      sectionName: SectionNameExtension.fromString(map['sectionName']),
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
      'questions': questions
          .map((key, value) => MapEntry(key.toString(), value?.toMap())),
    };
  }

  factory PassageQuestionModel.fromJson(String data) {
    return PassageQuestionModel.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }
}
