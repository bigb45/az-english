import 'package:ez_english/features/models/base_answer.dart';
import 'package:ez_english/features/sections/models/multiple_choice_question_model.dart';
import 'package:ez_english/features/sections/models/passage_question_model.dart';
import 'package:ez_english/features/sections/models/word_definition.dart';
import 'package:ez_english/features/sections/models/youtube_lesson_model.dart';

import '../sections/models/dictation_question_model.dart';

abstract class BaseQuestion<T> {
  String? questionTextInEnglish;
  String? questionTextInArabic;
  String? imageUrl;
  String? voiceUrl;
  String? path; // Firestore document path

  // correct answer
  BaseAnswer<T>? answer;
  BaseAnswer<T>? userAnswer;
  QuestionType questionType;
  BaseQuestion({
    required this.questionTextInEnglish,
    required this.questionTextInArabic,
    required this.imageUrl,
    required this.voiceUrl,
    this.answer,
    this.path,
    required this.questionType,
  });

  bool evaluateAnswer() {
    return answer?.validate(userAnswer) ?? false;
  }

  Map<String, dynamic> toMap() {
    return {
      'questionTextInEnglish': questionTextInEnglish,
      'questionTextInArabic': questionTextInArabic,
      'imageUrl': imageUrl,
      'voiceUrl': voiceUrl,
      // TODO: Description???
      'description': voiceUrl,
      'answer': answer?.toMap(),
      "questionType": questionType.toShortString(),
    };
  }

  static BaseQuestion fromMap(Map<String, dynamic> json) {
    QuestionType questionType =
        QuestionTypeExtension.fromString(json['questionType']);

    switch (questionType) {
      case QuestionType.passage:
        return PassageQuestionModel.fromMap(json);

      case QuestionType.dictation:
        return DictationQuestionModel.fromMap(json);

      case QuestionType.multipleChoice:
        return MultipleChoiceQuestionModel.fromMap(json);

      case QuestionType.vocabulary:
      case QuestionType.vocabularyWithListening:
        return WordDefinition.fromMap(json);

      case QuestionType.youtubeLesson:
        return YoutubeLessonModel.fromMap(json);

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

  checkbox,
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
