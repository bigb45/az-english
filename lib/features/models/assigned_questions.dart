import 'package:ez_english/features/models/base_question.dart';

class AssignedQuestions {
  Map<String, BaseQuestion> questions;
  String sectionName;
  double progress;
  int numberOfQuestionsWithDeletion;
  int numberOfQuestionWithoutDeletion;
  int lastStoppedQuestionIndex;
  List<String?>? assignedLevels;
  AssignedQuestions({
    required this.questions,
    required this.sectionName,
    required this.progress,
    this.assignedLevels,
    this.numberOfQuestionsWithDeletion = 0,
    this.numberOfQuestionWithoutDeletion = 0,
    required this.lastStoppedQuestionIndex,
  });

  factory AssignedQuestions.fromMap(Map<String, dynamic> map) {
    return AssignedQuestions(
      questions: (map['questions'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, BaseQuestion.fromMap(value))),
      sectionName: map['sectionName'],
      progress: map['progress'].toDouble(),
      numberOfQuestionsWithDeletion: map["numberOfQuestionsWithDeletion"],
      numberOfQuestionWithoutDeletion: map["numberOfQuestionWithoutDeletion"],
      lastStoppedQuestionIndex: map['lastStoppedQuestionIndex'],
      assignedLevels: List<String?>.from(map["assignedLevels"] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'questions': questions.map((key, value) => MapEntry(key, value.toMap())),
      'sectionName': sectionName,
      'progress': progress,
      "numberOfQuestionsWithDeletion": numberOfQuestionsWithDeletion,
      "numberOfQuestionWithoutDeletion": numberOfQuestionWithoutDeletion,
      'lastStoppedQuestionIndex': lastStoppedQuestionIndex,
      "assignedLevels": assignedLevels,
    };
  }
}
