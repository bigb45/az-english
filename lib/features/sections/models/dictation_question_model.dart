// ignore_for_file: avoid_print

import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/writing/components/dictation_question.dart';

class DictationQuestionModel extends BaseQuestion {
  final String answer;

  DictationQuestionModel({
    required this.answer,
    required super.questionTextInEnglish,
    required super.questionTextInArabic,
    super.questionType = QuestionType.dictation,
    required super.imageUrl,
    required super.voiceUrl,
  });

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> baseMap = super.toMap();
    baseMap['answer'] = answer;
    return baseMap;
  }

  factory DictationQuestionModel.fromMap(Map<String, dynamic> json) {
    return DictationQuestionModel(
      answer: json['answer'],
      questionTextInEnglish: json['questionTextInEnglish'],
      questionTextInArabic: json['questionTextInArabic'],
      imageUrl: json['imageUrl'],
      voiceUrl: json['voiceUrl'],
    );
  }

  bool validateQuestion({String? correctAnswer, required String userAnswer}) {
    correctAnswer = correctAnswer ?? answer;

    correctAnswer = correctAnswer.normalize();
    userAnswer = userAnswer.normalize();

    if (userAnswer == correctAnswer) {
      print("correct");
    } else {
      print(
          "incorrect, user answered: $userAnswer, correct answer: $correctAnswer");
    }
    return userAnswer == correctAnswer;
  }
}
