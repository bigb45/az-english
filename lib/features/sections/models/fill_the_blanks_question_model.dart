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
  });

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> baseMap = super.toMap();

    return {
      ...baseMap,
      "incompleteSentenceInEnglish": incompleteSentenceInEnglish,
      "incompleteSentenceInArabic": incompleteSentenceInArabic
    };
  }

  factory FillTheBlanksQuestionModel.fromMap(Map<String, dynamic> json) {
    return FillTheBlanksQuestionModel(
      answer: StringAnswer(answer: json['answer']['answer']),
      questionTextInEnglish: json['questionTextInEnglish'],
      questionTextInArabic: json['questionTextInArabic'],
      imageUrl: json['imageUrl'],
      voiceUrl: json['voiceUrl'],
      incompleteSentenceInEnglish: json['incompleteSentenceInEnglish'],
      incompleteSentenceInArabic: json['incompleteSentenceInArabic'],
      questionType: QuestionType.fillTheBlanks,
      titleInEnglish: json["titleInEnglish"],
    );
  }

  @override
  bool evaluateAnswer() {
    userAnswer = userAnswer ?? StringAnswer(answer: "");
    return answer?.validate(userAnswer) ?? false;
  }

  // @override
  // bool operator ==(Object other) {
  //   if (identical(this, other)) return true;
  //   return other is FillTheBlanksQuestionModel &&
  //       super == other && // Comparing all properties in the superclass
  //       other.incompleteSentenceInEnglish == incompleteSentenceInEnglish &&
  //       other.incompleteSentenceInArabic == incompleteSentenceInArabic;
  // }

  // @override
  // int get hashCode => Object.hash(
  //       super.hashCode, // Include the hashCode of the superclass
  //       incompleteSentenceInEnglish,
  //       incompleteSentenceInArabic,
  //     );
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
