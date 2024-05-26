import 'dart:convert';

import 'package:ez_english/features/models/base_question.dart';

class Unit {
  String name;
  List<BaseQuestion> questions;

  Unit({required this.name, required this.questions});
  factory Unit.fromMap(Map<String, dynamic> map) {
    return Unit(
      name: map['name'] ?? '',
      questions: (map['questions'] as List)
          .map((item) => BaseQuestion.fromMap(item))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'questions': questions.map((q) => q.toMap()).toList(),
    };
  }

  factory Unit.fromJson(String data) {
    return Unit.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());
}
