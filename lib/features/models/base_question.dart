import 'package:ez_english/features/models/base_answer.dart';

import '../sections/models/dictation_question_model.dart';

abstract class BaseQuestion<T> {
  String? questionTextInEnglish;
  String? questionTextInArabic;
  String? imageUrl;
  String? voiceUrl;
  BaseAnswer<T>? answer;
  QuestionType questionType;
  BaseQuestion({
    required this.questionTextInEnglish,
    required this.questionTextInArabic,
    required this.imageUrl,
    required this.voiceUrl,
    this.answer,
    required this.questionType,
  });

  Map<String, dynamic> toMap() {
    return {
      'questionTextInEnglish': questionTextInEnglish,
      'questionTextInArabic': questionTextInArabic,
      'imageUrl': imageUrl,
      'voiceUrl': voiceUrl,
      'description': voiceUrl,
      'answer': answer, //TODO Is there a need for any type conversion here ?
      "questionType": questionType.toShortString(),
    };
  }

  static BaseQuestion fromMap(Map<String, dynamic> json) {
    QuestionType questionType =
        QuestionTypeExtension.fromString(json['questionType']);

    switch (questionType) {
      case QuestionType.dictation:
        return DictationQuestionModel.fromMap(json);
      // case QuestionType.multipleChoice:
      //   return MultipleChoiceQuestionModel.fromMap(json);
      // Add cases for other question types
      default:
        throw Exception('Unknown question type: $questionType');
    }
  }
}

enum QuestionType {
  // reading question types
  multipleChoice,
  dictation,
  speaking,
  fillTheBlanks,

  // writing question types
  findWordsFromPassage,
  answerQuestionsFromPassage,

  // grammar question types
  sentenceForming,
  youtubeLesson,

  //passage with multiple questions
  passage,

  //vocabulary
  vocabulary,
  vocabularyWithListening,
  //listening
  listening,

  //other
  other,
}

extension QuestionTypeExtension on QuestionType {
  String toShortString() {
    return toString().split('.').last;
  }

  static QuestionType fromString(String str) {
    return QuestionType.values.firstWhere(
      (e) => e.toString().split('.').last == str,
      orElse: () => QuestionType.other, // Default to dictation if not found
    );
  }
}
