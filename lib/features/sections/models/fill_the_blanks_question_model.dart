// ignore_for_file: avoid_print

import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/models/string_answer.dart';

class FillTheBlanksQuestionModel extends BaseQuestion<String> {
  String? incompleteSentenceInEnglish;
  String? incompleteSentenceInArabic;
  FillTheBlanksQuestionModel({
    this.incompleteSentenceInEnglish,
    this.incompleteSentenceInArabic,
    required super.answer,
    super.questionTextInEnglish,
    super.questionTextInArabic,
    super.questionType = QuestionType.fillTheBlanks,
    super.imageUrl,
    super.voiceUrl,
    super.titleInEnglish,
    super.sectionName,
  });

  @override
  FillTheBlanksQuestionModel copy() {
    return FillTheBlanksQuestionModel(
      incompleteSentenceInEnglish: incompleteSentenceInEnglish,
      incompleteSentenceInArabic: incompleteSentenceInArabic,
      answer: answer?.copy(),
      questionTextInEnglish: questionTextInEnglish,
      questionTextInArabic: questionTextInArabic,
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
      "incompleteSentenceInEnglish": incompleteSentenceInEnglish,
      "incompleteSentenceInArabic": incompleteSentenceInArabic
    };
  }

  factory FillTheBlanksQuestionModel.fromMap(Map<String, dynamic> map) {
    return FillTheBlanksQuestionModel(
      answer: StringAnswer(answer: map['answer']['answer']),
      questionTextInEnglish: map['questionTextInEnglish'],
      questionTextInArabic: map['questionTextInArabic'],
      imageUrl: map['imageUrl'],
      voiceUrl: map['voiceUrl'],
      incompleteSentenceInEnglish: map['incompleteSentenceInEnglish'],
      incompleteSentenceInArabic: map['incompleteSentenceInArabic'],
      questionType: QuestionType.fillTheBlanks,
      titleInEnglish: map["titleInEnglish"],
      sectionName: SectionNameExtension.fromString(map['sectionName']),
    );
  }

  @override
  bool evaluateAnswer() {
    userAnswer = userAnswer ?? StringAnswer(answer: "");
    return answer?.validate(userAnswer) ?? false;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FillTheBlanksQuestionModel &&
        other.questionTextInEnglish == questionTextInEnglish &&
        other.questionTextInArabic == questionTextInArabic &&
        other.imageUrl == imageUrl &&
        other.voiceUrl == voiceUrl &&
        other.titleInEnglish == titleInEnglish &&
        other.incompleteSentenceInEnglish == incompleteSentenceInEnglish &&
        other.incompleteSentenceInArabic == incompleteSentenceInArabic;
  }

  @override
  int get hashCode => Object.hash(
      questionTextInEnglish,
      questionTextInArabic,
      imageUrl,
      voiceUrl,
      titleInEnglish,
      incompleteSentenceInEnglish,
      incompleteSentenceInArabic);
}
