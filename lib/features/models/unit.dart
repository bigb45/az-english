import 'dart:convert';

import 'package:ez_english/features/models/base_question.dart';

class Unit {
  String name;
  String? descriptionInEnglish;
  String? descriptionInArabic;
  int numberOfQuestionsWithDeletion;
  int numberOfQuestionWithoutDeletion;
  Map<int, BaseQuestion?> questions;
  double progress;

  Unit({
    required this.name,
    this.descriptionInEnglish,
    this.descriptionInArabic,
    this.numberOfQuestionsWithDeletion = 0,
    this.numberOfQuestionWithoutDeletion = 0,
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
      numberOfQuestionsWithDeletion: map['numberOfQuestionsWithDeletion'],
      numberOfQuestionWithoutDeletion: map['numberOfQuestionWithoutDeletion'],
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
      "numberOfQuestionsWithDeletion": numberOfQuestionsWithDeletion,
      "numberOfQuestionWithoutDeletion": numberOfQuestionWithoutDeletion,
      'questions': questions
          .map((key, value) => MapEntry(key.toString(), value?.toMap())),
    };
  }

  factory Unit.fromJson(String data) {
    return Unit.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Unit &&
        other.name == name &&
        other.descriptionInEnglish == descriptionInEnglish &&
        other.descriptionInArabic == descriptionInArabic &&
        other.numberOfQuestionsWithDeletion == numberOfQuestionsWithDeletion &&
        other.numberOfQuestionWithoutDeletion ==
            numberOfQuestionWithoutDeletion &&
        other.progress == progress;
  }
}
