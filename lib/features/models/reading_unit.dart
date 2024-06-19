import 'dart:convert';

import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/unit.dart';

class ReadingUnit extends Unit {
  String? passageInEnglish;
  String? passageInArabic;
  String? titleInArabic;
  String? titleInEnglish;
  ReadingUnit(
      {this.passageInArabic,
      this.passageInEnglish,
      this.titleInArabic,
      this.titleInEnglish,
      required super.name,
      required super.questions,
      super.descriptionInArabic,
      super.descriptionInEnglish});

  factory ReadingUnit.fromMap(Map<String, dynamic> map) {
    return ReadingUnit(
      passageInEnglish: map['passageInEnglish'] ?? "No English Passage",
      passageInArabic: map['passageInArabic'] ?? "No Arabic Passage",
      titleInArabic: map['titleInArabic'] ?? "No title in Arabic",
      titleInEnglish: map['titleInEnglish'] ?? "No title in English",
      name: map['name'] ?? '',
      questions: (map['questions'] as List)
          .map((item) => BaseQuestion.fromMap(item))
          .toList(),
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
      "titleInEnglish": titleInEnglish
    };
  }

  factory ReadingUnit.fromJson(String data) {
    return ReadingUnit.fromMap(json.decode(data) as Map<String, dynamic>);
  }
}
