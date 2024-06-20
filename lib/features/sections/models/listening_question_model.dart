import 'dart:convert';

import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/models/word_definition.dart';

class ListeningQuestionModel extends BaseQuestion {
  final List<String?> words;
  ListeningQuestionModel(
      {required this.words,
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
      'words': words,
    };
  }

  @override
  factory ListeningQuestionModel.fromMap(Map<String, dynamic> map) {
    return ListeningQuestionModel(
      words: map['word'],
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
