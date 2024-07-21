// ignore_for_file: avoid_print

import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/models/string_answer.dart';

class DictationQuestionModel extends BaseQuestion<String> {
  // final String answer;
  String speakableText;

  DictationQuestionModel({
    // required this.answer,
    required super.answer,
    super.voiceUrl,
    required this.speakableText,
    required super.questionTextInArabic,
    required super.questionTextInEnglish,
    required super.imageUrl,
    required super.titleInEnglish,
    super.questionType = QuestionType.dictation,
  });
  @override
  DictationQuestionModel copy() {
    return DictationQuestionModel(
      speakableText: speakableText,
      answer: StringAnswer(answer: answer?.answer),
      questionTextInArabic: questionTextInArabic,
      questionTextInEnglish: questionTextInEnglish,
      imageUrl: imageUrl,
      voiceUrl: voiceUrl,
      titleInEnglish: titleInEnglish,
      questionType: questionType,
    );
  }

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
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DictationQuestionModel &&
        other.speakableText == speakableText &&
        other.answer == answer &&
        other.questionTextInEnglish == questionTextInEnglish &&
        other.questionTextInArabic == questionTextInArabic &&
        other.imageUrl == imageUrl &&
        other.voiceUrl == voiceUrl &&
        other.titleInEnglish == titleInEnglish;
  }

  @override
  int get hashCode => Object.hash(speakableText, answer, questionTextInEnglish,
      questionTextInArabic, imageUrl, voiceUrl, titleInEnglish);
  @override
  bool evaluateAnswer() {
    userAnswer = userAnswer ?? StringAnswer(answer: "");
    return answer?.validate(userAnswer) ?? false;
  }
}
