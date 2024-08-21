import 'package:ez_english/features/models/base_question.dart';

class AssignedQuestions {
  Map<String, BaseQuestion> questions;
  String sectionName;
  double progress;
  int lastStoppedQuestionIndex;

  AssignedQuestions({
    required this.questions,
    required this.sectionName,
    required this.progress,
    required this.lastStoppedQuestionIndex,
  });

  factory AssignedQuestions.fromMap(Map<String, dynamic> map) {
    return AssignedQuestions(
      questions: (map['questions'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, BaseQuestion.fromMap(value))),
      sectionName: map['sectionName'],
      progress: map['progress'].toDouble(),
      lastStoppedQuestionIndex: map['lastStoppedQuestionIndex'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'questions': questions.map((key, value) => MapEntry(key, value.toMap())),
      'sectionName': sectionName,
      'progress': progress,
      'lastStoppedQuestionIndex': lastStoppedQuestionIndex,
    };
  }
}
