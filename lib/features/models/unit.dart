import 'package:ez_english/features/models/question_base.dart';

class Unit {
  String name;
  List<BaseQuestion> questions;

  Unit({required this.name, required this.questions});

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      name: json['name'],
      questions: (json['questions'] as List)
          .map((item) => BaseQuestion.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }
}
