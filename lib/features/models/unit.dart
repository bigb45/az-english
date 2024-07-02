import 'dart:convert';

import 'package:ez_english/features/models/base_question.dart';

class Unit {
  String name;
  String? descriptionInEnglish;
  String? descriptionInArabic;
  int numberOfQuestions;
  Map<int, BaseQuestion?> questions;
  double progress;

  Unit({
    required this.name,
    this.descriptionInEnglish,
    this.descriptionInArabic,
    this.numberOfQuestions = 0,
    required this.questions,
    this.progress = 0,
  });
  factory Unit.fromMap(Map<String, dynamic> map) {
    return Unit(
      name: map['name'] ?? '',
      descriptionInEnglish:
          map['descriptionInEnglish'] ?? 'No English description',
      descriptionInArabic:
          map['descriptionInArabic'] ?? "No Arabic Description",
      numberOfQuestions: map['numberOfQuestions'],
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
      "numberOfQuestions": numberOfQuestions,
      'questions': questions
          .map((key, value) => MapEntry(key.toString(), value?.toMap())),
    };
  }

  factory Unit.fromJson(String data) {
    return Unit.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());
}
