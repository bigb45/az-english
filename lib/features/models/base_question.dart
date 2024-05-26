import 'package:ez_english/features/sections/writing/practice.dart';

abstract class BaseQuestion<T> {
  String questionText;
  String imageUrl;
  String voiceUrl;
  QuestionType? questionType;
  BaseQuestion({
    required this.questionText,
    required this.imageUrl,
    required this.voiceUrl,
    this.questionType,
  });

  Map<String, dynamic> toMap() {
    return {
      'questionText': questionText,
      'imageUrl': imageUrl,
      'description': voiceUrl,
      "questionType": questionType!.toShortString(),
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
  multipleChoice,
  dictation,
  speaking,
}

extension QuestionTypeExtension on QuestionType {
  String toShortString() {
    return toString().split('.').last;
  }

  static QuestionType fromString(String str) {
    return QuestionType.values.firstWhere(
      (e) => e.toString().split('.').last == str,
      orElse: () => QuestionType.dictation, // Default to dictation if not found
    );
  }
}
