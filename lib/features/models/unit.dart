import 'dart:convert';

import 'package:ez_english/features/models/base_question.dart';

class Unit {
  String name;
  String? descriptionInEnglish;
  String? descriptionInArabic;

  Map<int, BaseQuestion?> questions;

  Unit(
      {required this.name,
      this.descriptionInEnglish,
      this.descriptionInArabic,
      required this.questions});
  factory Unit.fromMap(Map<String, dynamic> map) {
    return Unit(
      name: map['name'] ?? '',
      descriptionInEnglish:
          map['descriptionInEnglish'] ?? 'No English description',
      descriptionInArabic:
          map['descriptionInArabic'] ?? "No Arabic Description",
      questions: (map['questions'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(int.parse(key), BaseQuestion.fromMap(value)),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'descriptionInEnglish': descriptionInEnglish,
      'descriptionInArabic': descriptionInArabic,
      'questions': questions
          .map((key, value) => MapEntry(key.toString(), value?.toMap())),
    };
  }

  factory Unit.fromJson(String data) {
    return Unit.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());
}
