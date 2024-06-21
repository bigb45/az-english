// ignore_for_file: avoid_print

import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/components/dictation_question.dart';

class DictationQuestionModel extends BaseQuestion<String> {
  // final String answer;
  final String speakableText;
  final String questionTextInArabic;
  final String questionTextInEnglish;

  DictationQuestionModel({
    required this.questionTextInArabic,
    required this.questionTextInEnglish,
    // required this.answer,
    required super.answer,
    required super.voiceUrl,
    required this.speakableText,
  }) : super(
          questionType: QuestionType.dictation,
          imageUrl: "",
          questionTextInArabic: questionTextInArabic,
          questionTextInEnglish: questionTextInEnglish,
        );

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
