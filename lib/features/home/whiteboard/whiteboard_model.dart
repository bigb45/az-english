import 'dart:convert';

import 'package:ez_english/features/models/base_question.dart';

class WhiteboardModel extends BaseQuestion {
  String title;

  WhiteboardModel({
    required this.title,
    required super.imageUrl,
    super.questionType = QuestionType.whiteboard,
    super.questionTextInEnglish,
    super.questionTextInArabic,
    super.voiceUrl,
    super.titleInEnglish,
  });

  factory WhiteboardModel.fromMap(Map<String, dynamic> map) {
    return WhiteboardModel(
      questionTextInEnglish: null,
      imageUrl: map['imageUrl'],
      voiceUrl: null,
      questionType: QuestionType.whiteboard,
      questionTextInArabic: null,
      title: map['title'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> baseMap = super.toMap();

    return {
      ...baseMap,
      'title': title,
      'imageUrl': imageUrl,
    };
  }

  factory WhiteboardModel.fromJson(String data) {
    return WhiteboardModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());

  @override
  WhiteboardModel copy() {
    return WhiteboardModel(
      title: title,
      questionTextInArabic: questionTextInArabic,
      questionTextInEnglish: questionTextInEnglish,
      imageUrl: imageUrl,
      voiceUrl: voiceUrl,
      questionType: questionType,
      titleInEnglish: titleInEnglish,
    );
  }

  @override
  int get hashCode => Object.hash(runtimeType, title, questionTextInEnglish,
      questionTextInArabic, imageUrl, voiceUrl, titleInEnglish, answer);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! WhiteboardModel) return false;
    return other.runtimeType == runtimeType &&
        other.title == title &&
        other.questionTextInEnglish == questionTextInEnglish &&
        other.questionTextInArabic == questionTextInArabic &&
        other.imageUrl == imageUrl &&
        other.voiceUrl == voiceUrl &&
        other.titleInEnglish == titleInEnglish &&
        other.answer == answer;
  }
}
