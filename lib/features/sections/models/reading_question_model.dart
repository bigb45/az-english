import 'dart:convert';

import 'package:ez_english/features/models/base_question.dart';

// TODO: refactor reading question model to be more specific
// TODO will change this class after finishing the input class
class ReadingQuestionModel extends BaseQuestion {
  ReadingQuestionModel({
    required String question,
    required super.questionType,
    required super.answer,
  }) : super(
          questionTextInEnglish: question,
          questionTextInArabic: "",
          imageUrl: "",
          voiceUrl: "",
        );

  // bool validateQuestion({String? correctAnswer, required String userAnswer}) {
  //   correctAnswer = correctAnswer ?? answer;

  //   correctAnswer = correctAnswer?.normalize();
  //   userAnswer = userAnswer.normalize();

  //   if (userAnswer == correctAnswer) {
  //     print("correct");
  //   } else {
  //     print(
  //         "incorrect, user answered: $userAnswer, correct answer: $correctAnswer");
  //   }

  //   return userAnswer == correctAnswer;
  // }

  @override
  Map<String, dynamic> toMap() {
    return {
      'questionType': questionType,
      'question': questionTextInEnglish,
      'answer': answer,
    };
  }

  @override
  factory ReadingQuestionModel.fromMap(Map<String, dynamic> map) {
    return ReadingQuestionModel(
      questionType: switch (map['questionType']) {
        'multipleChoice' => QuestionType.multipleChoice,
        'mcq' => QuestionType.multipleChoice,
        Object()? => QuestionType.multipleChoice,
        null => QuestionType.multipleChoice,
      },
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
