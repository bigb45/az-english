// ignore_for_file: avoid_print

import 'package:ez_english/features/models/generic_question_model.dart';

class DictationQuestionModel extends GenericQuestionModel<String> {
  DictationQuestionModel({
    required String question,
    required String answer,
    List<String>? options,
    String? hint,
    String? imageUrl,
  }) : super(
          questionType: QuestionType.dictation,
          question: question,
          answer: answer,
          options: options,
          hint: hint,
          imageUrl: imageUrl,
        );
  @override
  bool validateQuestion({String? correctAnswer, required String userAnswer}) {
    correctAnswer = correctAnswer ?? answer;

    correctAnswer = correctAnswer.normalize();
    userAnswer = userAnswer.normalize();

    if (enableDebugging) {
      if (userAnswer == correctAnswer) {
        print("correct");
      } else {
        print(
            "incorrect, user answered: $userAnswer, correct answer: $correctAnswer");
      }
    }
    return userAnswer == correctAnswer;
  }
}

extension StringExtension on String {
  String normalize() {
    return replaceAll(RegExp(r'[^\w\s]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .toLowerCase();
  }
}
