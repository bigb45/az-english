import 'dart:convert';

import 'package:ez_english/features/models/base_question.dart';

class WhiteboardModel extends BaseQuestion {
  final String title;

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
  BaseQuestion copy() {
    throw UnimplementedError();
  }
}
