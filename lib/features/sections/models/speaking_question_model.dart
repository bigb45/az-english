import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/models/speaking_answer.dart';
import 'package:ez_english/utils/utils.dart';

class SpeakingQuestionModel extends BaseQuestion<int> {
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
    required super.answer,
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
      answer: answer?.copy(),
    );
  }

  factory SpeakingQuestionModel.fromMap(Map<String, dynamic> map) {
    printDebug('fromMap: $map');
    return SpeakingQuestionModel(
      question: map['question'],
      questionTextInEnglish: map['questionTextInEnglish'],
      questionTextInArabic: map['questionTextInArabic'],
      voiceUrl: map['voiceUrl'],
      imageUrl: map['imageUrl'],
      titleInEnglish: map["titleInEnglish"],
      sectionName: SectionNameExtension.fromString(map['sectionName']),
      answer: SpeakingAnswer(answer: map['answer']['answer']),
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
    return answer?.validate(userAnswer) ?? false;
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
