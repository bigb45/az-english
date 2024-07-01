// ignore_for_file: avoid_print

import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/models/string_answer.dart';

class DictationQuestionModel extends BaseQuestion<String> {
  // final String answer;
  final String speakableText;

  DictationQuestionModel({
    // required this.answer,
    required super.answer,
    required super.voiceUrl,
    required this.speakableText,
    required super.questionTextInArabic,
    required super.questionTextInEnglish,
    required super.imageUrl,
    required super.titleInEnglish,
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
      speakableText: json['speakableText'],
      answer: StringAnswer(answer: json['answer']['answer']),
      questionTextInEnglish: json['questionTextInEnglish'],
      questionTextInArabic: json['questionTextInArabic'],
      imageUrl: json['imageUrl'],
      voiceUrl: json['voiceUrl'],
      titleInEnglish: json["titleInEnglish"],
    );
  }

  @override
  bool evaluateAnswer() {
    return answer?.validate(userAnswer) ?? false;
  }
}
