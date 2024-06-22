import 'dart:convert';

import 'package:ez_english/features/models/base_question.dart';

class WordDefinition extends BaseQuestion {
  final String word;
  final WordType type;
  final String? definition;
  final List<String>? exampleUsage;
  final String? tenses;
  WordDefinition(
      {required this.word,
      required this.type,
      this.definition,
      this.exampleUsage,
      this.tenses,
      required super.questionTextInEnglish,
      required super.questionTextInArabic,
      required super.questionType,
      required super.imageUrl,
      required super.voiceUrl});
  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> baseMap = super.toMap();
    return {
      ...baseMap,
      'word': word,
      'type': type.toShortString(),
      'definition': definition,
      // TODO implement exampleUsage and tenses attributes if needed
    };
  }

  @override
  factory WordDefinition.fromMap(Map<String, dynamic> map) {
    return WordDefinition(
        word: map['word'],
        type: switch (map['questionType']) {
          'verb' => WordType.verb,
          'word' => WordType.word,
          'sentence' => WordType.sentence,
          null => WordType.sentence,
          Object() => throw UnimplementedError(),
        },
        definition: map['definition'],
        questionTextInEnglish: map['questionTextInEnglish'],
        questionTextInArabic: map['questionTextInArabic'],
        imageUrl: map['imageUrl'],
        voiceUrl: map['voiceUrl'],
        questionType: QuestionTypeExtension.fromString(map['questionType']));
  }

  factory WordDefinition.fromJson(String data) {
    return WordDefinition.fromMap(json.decode(data) as Map<String, dynamic>);
  }
  String toJson() => json.encode(toMap());
}

enum WordType {
  verb,
  word,
  sentence,
}

extension WordTypeExtension on WordType {
  String toShortString() {
    return toString().split('.').last;
  }

  static WordType fromString(String str) {
    return WordType.values.firstWhere(
      (e) => e.toString().split('.').last == str,
      orElse: () => WordType.word, // Default to dictation if not found
    );
  }
}
