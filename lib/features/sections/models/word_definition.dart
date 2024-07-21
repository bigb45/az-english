import 'dart:convert';

import 'package:ez_english/features/models/base_question.dart';
import 'package:flutter/foundation.dart';

class WordDefinition extends BaseQuestion {
  String englishWord;
  String? arabicWord;
  WordType type;
  String? definition;
  List<String>? exampleUsageInEnglish;
  List<String>? exampleUsageInArabic;

  final String? tenses;
  bool isNew;
  WordDefinition(
      {required this.englishWord,
      super.titleInEnglish,
      required this.arabicWord,
      required this.type,
      this.isNew = true,
      this.definition,
      this.exampleUsageInEnglish,
      this.exampleUsageInArabic,
      this.tenses,
      super.questionTextInEnglish,
      super.questionTextInArabic,
      required super.questionType,
      super.imageUrl,
      super.voiceUrl});
  @override
  WordDefinition copy() {
    return WordDefinition(
      englishWord: englishWord,
      arabicWord: arabicWord,
      type: type,
      definition: definition,
      exampleUsageInEnglish: exampleUsageInEnglish != null
          ? List<String>.from(exampleUsageInEnglish!)
          : null,
      exampleUsageInArabic: exampleUsageInArabic != null
          ? List<String>.from(exampleUsageInArabic!)
          : null,
      tenses: tenses,
      isNew: isNew,
      titleInEnglish: titleInEnglish,
      questionTextInEnglish: questionTextInEnglish,
      questionTextInArabic: questionTextInArabic,
      questionType: questionType,
      imageUrl: imageUrl,
      voiceUrl: voiceUrl,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> baseMap = super.toMap();
    return {
      ...baseMap,
      'englishWord': englishWord,
      'arabicWord': arabicWord,
      'type': type.toShortString(),
      'definition': definition,
      'exampleUsageInEnglish': exampleUsageInEnglish,
      'exampleUsageInArabic': exampleUsageInArabic,
      'isNew': isNew,
      // TODO implement exampleUsage and tenses attributes if needed
    };
  }

  @override
  factory WordDefinition.fromMap(Map<String, dynamic> map) {
    return WordDefinition(
        titleInEnglish: map["titleInEnglish"],
        englishWord: map['englishWord'],
        arabicWord: map['arabicWord'],
        isNew: map['isNew'],
        type: switch (map['type']) {
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
        exampleUsageInEnglish: map['exampleUsageInEnglish'] != null
            ? List<String>.from(map['exampleUsageInEnglish'])
            : null,
        exampleUsageInArabic: map['exampleUsageInArabic'] != null
            ? List<String>.from(map['exampleUsageInArabic'])
            : null,
        questionType: QuestionTypeExtension.fromString(map['questionType']));
  }

  factory WordDefinition.fromJson(String data) {
    return WordDefinition.fromMap(json.decode(data) as Map<String, dynamic>);
  }
  String toJson() => json.encode(toMap());

  @override
  bool evaluateAnswer() {
    return true;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WordDefinition &&
        other.englishWord == englishWord &&
        other.arabicWord == arabicWord &&
        other.type == type &&
        other.definition == definition &&
        listEquals(other.exampleUsageInEnglish, exampleUsageInEnglish) &&
        listEquals(other.exampleUsageInArabic, exampleUsageInArabic) &&
        other.tenses == tenses &&
        other.isNew == isNew &&
        super == other;
  }

  @override
  int get hashCode => Object.hash(
      englishWord,
      arabicWord,
      type,
      definition,
      Object.hashAll(exampleUsageInEnglish ?? []),
      Object.hashAll(exampleUsageInArabic ?? []),
      tenses,
      isNew,
      super.hashCode);
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

extension StringExtension on String {
  String capitalizeFirst() {
    if (isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + substring(1);
  }
}
