import 'dart:convert';

import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/models/word_definition.dart';

class ListeningQuestionModel extends BaseQuestion {
  final String word;
  ListeningQuestionModel(
      {required this.word,
      required super.questionTextInEnglish,
      required super.questionTextInArabic,
      super.imageUrl,
      super.voiceUrl,
      super.questionType = QuestionType.listening});
  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> baseMap = super.toMap();
    return {
      ...baseMap,
      'word': word,
    };
  }

  @override
  factory ListeningQuestionModel.fromMap(Map<String, dynamic> map) {
    return ListeningQuestionModel(
      word: map['word'],
      questionTextInEnglish: map['questionTextInEnglish'],
      questionTextInArabic: 'questionTextInArabic',
      imageUrl: map['imageUrl'],
      voiceUrl: map['voiceUrl'],
    );
  }

  factory ListeningQuestionModel.fromJson(String data) {
    return ListeningQuestionModel.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }
  String toJson() => json.encode(toMap());
}
