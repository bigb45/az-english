import 'package:ez_english/features/home/whiteboard/whiteboard_model.dart';
import 'package:ez_english/features/models/base_answer.dart';
import 'package:ez_english/features/models/worksheet.dart';
import 'package:ez_english/features/sections/models/fill_the_blanks_question_model.dart';
import 'package:ez_english/features/sections/models/multiple_choice_question_model.dart';
import 'package:ez_english/features/sections/models/passage_question_model.dart';
import 'package:ez_english/features/sections/models/speaking_question_model.dart';
import 'package:ez_english/features/sections/models/word_definition.dart';
import 'package:ez_english/features/sections/models/youtube_lesson_model.dart';

import '../sections/models/dictation_question_model.dart';

abstract class BaseQuestion<T> {
  String? questionTextInEnglish;
  String? questionTextInArabic;
  String? imageUrl;
  String? voiceUrl;
  String? path; // Firestore document path
  String? titleInEnglish;
  SectionName? sectionName;
  // correct answer
  BaseAnswer<T>? answer;
  BaseAnswer<T>? userAnswer;
  QuestionType questionType;
  BaseQuestion({
    required this.questionTextInEnglish,
    required this.questionTextInArabic,
    required this.imageUrl,
    required this.voiceUrl,
    required this.questionType,
    required this.titleInEnglish,
    this.sectionName,
    this.path,
    this.answer,
  });
  BaseQuestion<T> copy();

  bool evaluateAnswer() {
    return answer?.validate(userAnswer) ?? false;
  }

  Map<String, dynamic> toMap() {
    return {
      'questionTextInEnglish': questionTextInEnglish,
      'questionTextInArabic': questionTextInArabic,
      'imageUrl': imageUrl,
      'voiceUrl': voiceUrl,
      'description': null,
      'answer': answer?.toMap(),
      "titleInEnglish": titleInEnglish,
      "questionType": questionType.toShortString(),
      'sectionName': sectionName?.toString().split('.').last,
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
      case QuestionType.fillTheBlanks:
        return FillTheBlanksQuestionModel.fromMap(json);

      case QuestionType.worksheet:
        return Worksheet.fromMap(json);

      case QuestionType.whiteboard:
        return WhiteboardModel.fromMap(json);
      case QuestionType.speaking:
        return SpeakingQuestionModel.fromMap(json);
      default:
        throw Exception('Unknown question type: $questionType');
    }
  }

  bool equals(BaseQuestion other) {
    return questionTextInEnglish == other.questionTextInEnglish &&
        questionTextInArabic == other.questionTextInArabic &&
        imageUrl == other.imageUrl &&
        voiceUrl == other.voiceUrl &&
        titleInEnglish == other.titleInEnglish &&
        questionType == other.questionType;
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
  worksheet,
  whiteboard,
  //other
  other,
}

enum SectionName {
  reading,
  writing,
  speaking,
  grammar,
  vocabulary,
  listening,
  test,
  other
}

enum LevelName { A1, A2, B1, B2, C1, C2, other }

extension LevelNameExtension on LevelName {
  String toShortString() {
    return toString().split('.').last;
  }

  static LevelName fromString(String str) {
    return LevelName.values.firstWhere(
      (e) => e.toString().split('.').last == str,
      orElse: () => LevelName.other,
    );
  }
}

extension SectionNameExtension on SectionName {
  String toShortString() {
    return toString().split('.').last;
  }

  static SectionName fromString(String str) {
    return SectionName.values.firstWhere(
      (e) => e.toString().split('.').last == str,
      orElse: () => SectionName.other,
    );
  }
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
