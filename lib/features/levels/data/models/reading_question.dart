import 'dart:convert';

import 'package:ez_english/features/models/base_question.dart';

class ReadingQuestion extends BaseQuestion {
  String? passageInEnglish;
  String? passageInArabic;

  String? titleInArabic;
  List<String>? words;
  List<String?> answers;

  ReadingQuestion({
    required super.questionTextInEnglish,
    required super.questionTextInArabic,
    required super.imageUrl,
    required super.voiceUrl,
    required super.questionType,
    required super.titleInEnglish,
    required this.answers,
    this.titleInArabic,
    this.passageInEnglish,
    this.passageInArabic,
    this.words,
  });
  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> baseMap = super.toMap();
    return <String, dynamic>{
      ...baseMap,
      'passageInEnglish': passageInEnglish,
      'passageInArabic': passageInArabic,
      'titleInEnglish': titleInEnglish,
      'titleInArabic': titleInArabic,
      'words': words,
      'answers': answers,
    };
  }

  factory ReadingQuestion.fromMap(Map<String, dynamic> map) {
    return ReadingQuestion(
      passageInEnglish: map['passageInEnglish'] != null
          ? map['passageInEnglish'] as String
          : null,
      passageInArabic: map['passageInArabic'] != null
          ? map['passageInArabic'] as String
          : null,
      titleInEnglish: map['titleInEnglish'] != null
          ? map['titleInEnglish'] as String
          : null,
      titleInArabic:
          map['titleInArabic'] != null ? map['titleInArabic'] as String : null,
      words: map['words'] != null ? map['words'] as List<String> : null,
      answers: map['answers'] as List<String?>,
      questionTextInEnglish: map['questionTextInEnglish'],
      imageUrl: map['imageUrl'],
      voiceUrl: map['voiceUrl'],
      questionType: map['questionType'],
      questionTextInArabic: map['questionTextInArabic'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ReadingQuestion.fromJson(String source) =>
      ReadingQuestion.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  BaseQuestion copy() {
    // TODO: implement copy
    throw UnimplementedError();
  }
}
