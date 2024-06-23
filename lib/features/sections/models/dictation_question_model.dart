// ignore_for_file: avoid_print

import 'package:ez_english/features/models/base_question.dart';

class DictationQuestionModel extends BaseQuestion<String> {
  // final String answer;
  final String speakableText;

  DictationQuestionModel({
    // required this.answer,
    required super.answer,
    required super.voiceUrl,
    required this.speakableText,
    super.questionTextInArabic,
    super.questionTextInEnglish,
    super.imageUrl,
    super.questionType = QuestionType.dictation,
  });

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> baseMap = super.toMap();
    return {
      ...baseMap,
      "speakableText": speakableText,
    };
  }

  factory DictationQuestionModel.fromMap(Map<String, dynamic> json) {
    return DictationQuestionModel(
      answer: json['answer'],
      questionTextInEnglish: json['questionTextInEnglish'],
      questionTextInArabic: json['questionTextInArabic'],
      // imageUrl: json['imageUrl'],
      speakableText: json['answer'],
      voiceUrl: json['voiceUrl'],
    );
  }

  // bool validateQuestion({String? correctAnswer, required String userAnswer}) {
  //   correctAnswer = correctAnswer ?? answer;

  //   correctAnswer = correctAnswer.normalize();
  //   userAnswer = userAnswer.normalize();

  //   if (userAnswer == correctAnswer) {
  //     print("correct");
  //   } else {
  //     print(
  //         "incorrect, user answered: $userAnswer, correct answer: $correctAnswer");
  //   }
  //   return userAnswer == correctAnswer;
  // }
}
