import 'dart:convert';

import 'package:ez_english/features/models/base_question.dart';

class ReadingQuestionModel extends BaseQuestion {
  final String? questionType;
  final String? answer;

  ReadingQuestionModel({
    required this.questionType,
    required String question,
    required this.answer,
  }) : super(
          questionText: question,
          imageUrl: "",
          voiceUrl: "",
        );

  bool validateQuestion({String? correctAnswer, required String userAnswer}) {
    correctAnswer = correctAnswer ?? answer;

    correctAnswer = correctAnswer?.normalize();
    userAnswer = userAnswer.normalize();

    if (userAnswer == correctAnswer) {
      print("correct");
    } else {
      print(
          "incorrect, user answered: $userAnswer, correct answer: $correctAnswer");
    }

    return userAnswer == correctAnswer;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'questionType': questionType,
      'question': questionText,
      'answer': answer,
    };
  }

  @override
  factory ReadingQuestionModel.fromMap(Map<String, dynamic> map) {
    return ReadingQuestionModel(
      questionType: map['questionType'],
      question: map['questionText'],
      answer: map['answer'],
    );
  }

  factory ReadingQuestionModel.fromJson(String data) {
    return ReadingQuestionModel.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }
  String toJson() => json.encode(toMap());
}

extension StringExtension on String {
  String normalize() {
    return replaceAll(RegExp(r'[^\w\s]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .toLowerCase();
  }
}
