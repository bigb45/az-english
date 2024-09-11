import 'dart:convert';

import 'package:ez_english/features/models/base_question.dart';

class ReadingQuestionModel extends BaseQuestion {
  ReadingQuestionModel({
    required String question,
    required super.questionType,
    required super.answer,
  }) : super(
          questionTextInEnglish: question,
          questionTextInArabic: "",
          imageUrl: "",
          voiceUrl: "",
          titleInEnglish: "",
        );

  @override
  Map<String, dynamic> toMap() {
    return {
      'questionType': questionType,
      'question': questionTextInEnglish,
      'answer': answer,
    };
  }

  @override
  factory ReadingQuestionModel.fromMap(Map<String, dynamic> map) {
    return ReadingQuestionModel(
      questionType: switch (map['questionType']) {
        'multipleChoice' => QuestionType.multipleChoice,
        'mcq' => QuestionType.multipleChoice,
        Object()? => QuestionType.multipleChoice,
        null => QuestionType.multipleChoice,
      },
      question: map['questionText'],
      answer: map['answer'],
    );
  }

  factory ReadingQuestionModel.fromJson(String data) {
    return ReadingQuestionModel.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }
  String toJson() => json.encode(toMap());

  @override
  BaseQuestion copy() {
    // TODO: implement copy
    throw UnimplementedError();
  }
}
