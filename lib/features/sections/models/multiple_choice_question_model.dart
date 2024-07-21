// ignore_for_file: avoid_print

import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/models/multiple_choice_answer.dart';
import 'package:ez_english/widgets/radio_button.dart';

class MultipleChoiceQuestionModel extends BaseQuestion<RadioItemData> {
  List<RadioItemData> options;
  String? paragraph;
  // final String? paragraphTranslation;
  String? questionSentenceInEnglish;
  String? questionSentenceInArabic;
  @override
  MultipleChoiceQuestionModel(
      {required this.options,
      // this.paragraphTranslation,
      this.questionSentenceInEnglish,
      required this.questionSentenceInArabic,
      this.paragraph,
      required super.answer,
      required super.questionTextInArabic,
      required super.questionTextInEnglish,
      required super.imageUrl,
      super.voiceUrl,
      super.questionType = QuestionType.multipleChoice,
      required super.titleInEnglish});
  @override
  MultipleChoiceQuestionModel copy() {
    return MultipleChoiceQuestionModel(
      options: options
          .map((option) => RadioItemData.copy(option))
          .toList(), // Ensuring a deep copy of options
      paragraph: paragraph,
      questionSentenceInEnglish: questionSentenceInEnglish,
      questionSentenceInArabic: questionSentenceInArabic,
      answer: answer?.copy(),
      questionTextInArabic: questionTextInArabic,
      questionTextInEnglish: questionTextInEnglish,
      imageUrl: imageUrl,
      voiceUrl: voiceUrl,
      questionType: questionType,
      titleInEnglish: titleInEnglish,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> baseMap = super.toMap();
    return {
      ...baseMap,
      'options': options.map((option) => option.toMap()).toList(),
      'questionSentenceInEnglish': questionSentenceInEnglish,
      'questionSentenceInArabic': questionSentenceInArabic
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MultipleChoiceQuestionModel) return false;

    return other.runtimeType == runtimeType &&
        other.options == options &&
        other.paragraph == paragraph &&
        other.questionSentenceInEnglish == questionSentenceInEnglish &&
        other.questionSentenceInArabic == questionSentenceInArabic &&
        other.questionTextInEnglish == questionTextInEnglish &&
        other.questionTextInArabic == questionTextInArabic &&
        other.imageUrl == imageUrl &&
        other.voiceUrl == voiceUrl &&
        other.titleInEnglish == titleInEnglish &&
        other.answer ==
            answer; // Ensure that BaseAnswer also correctly implements equality
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      Object.hashAll(
          options), // Assuming RadioItemData has a proper hashCode implementation
      paragraph,
      questionSentenceInEnglish,
      questionSentenceInArabic,
      // Combine hash codes of inherited properties
      questionTextInEnglish,
      questionTextInArabic,
      imageUrl,
      voiceUrl,
      titleInEnglish,
      answer // Assuming BaseAnswer has a proper hashCode implementation
      );
  factory MultipleChoiceQuestionModel.fromMap(Map<String, dynamic> map) {
    return MultipleChoiceQuestionModel(
      options: (map['options'] as List<dynamic>)
          .map((option) => RadioItemData.fromMap(option))
          .toList(),
      answer: MultipleChoiceAnswer(
          answer: RadioItemData.fromMap(map['answer']['answer'])),
      questionTextInEnglish: map['questionTextInEnglish'],
      questionTextInArabic: map['questionTextInArabic'],
      voiceUrl: map['voiceUrl'],
      imageUrl: map['imageUrl'],
      questionSentenceInEnglish: map['questionSentenceInEnglish'],
      questionSentenceInArabic: map['questionSentenceInArabic'],
      titleInEnglish: map["titleInEnglish"],
    );
  }

  @override
  bool evaluateAnswer() {
    return answer?.validate(userAnswer) ?? false;
  }
}
