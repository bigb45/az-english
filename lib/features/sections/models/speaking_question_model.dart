import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/models/string_answer.dart';
import 'package:flutter/foundation.dart';

class SpeakingQuestionModel extends BaseQuestion<String> {
  String question;
  SpeakingQuestionModel({
    required this.question,
    super.titleInEnglish,
    super.questionTextInEnglish,
    super.questionTextInArabic,
    super.questionType = QuestionType.speaking,
    super.imageUrl,
    super.voiceUrl,
    super.sectionName,
  });

  @override
  SpeakingQuestionModel copy() {
    return SpeakingQuestionModel(
      question: question,
      questionTextInArabic: questionTextInArabic,
      questionTextInEnglish: questionTextInEnglish,
      imageUrl: imageUrl,
      voiceUrl: voiceUrl,
      questionType: questionType,
      titleInEnglish: titleInEnglish,
      sectionName: sectionName,
    );
  }

  factory SpeakingQuestionModel.fromMap(Map<String, dynamic> map) {
    return SpeakingQuestionModel(
      question: map['question'],
      questionTextInEnglish: map['questionTextInEnglish'],
      questionTextInArabic: map['questionTextInArabic'],
      voiceUrl: map['voiceUrl'],
      imageUrl: map['imageUrl'],
      titleInEnglish: map["titleInEnglish"],
      sectionName: SectionNameExtension.fromString(map['sectionName']),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> baseMap = super.toMap();
    return {
      ...baseMap,
      'question': question,
    };
  }

  @override
  bool evaluateAnswer() {
    return true;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SpeakingQuestionModel) return false;

    return other.runtimeType == runtimeType &&
        other.question == question &&
        other.questionTextInEnglish == questionTextInEnglish &&
        other.questionTextInArabic == questionTextInArabic &&
        other.imageUrl == imageUrl &&
        other.voiceUrl == voiceUrl &&
        other.titleInEnglish == titleInEnglish;
  }

  @override
  int get hashCode => Object.hash(runtimeType, question,
      super.hashCode // Including all properties from the BaseQuestion
      );
}
