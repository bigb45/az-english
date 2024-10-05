import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/worksheet_student.dart';
import 'package:ez_english/utils/utils.dart';

class WorkSheet extends BaseQuestion {
  String? title;
  String? description;
  Map<String, WorksheetStudent>? students;
  Timestamp? timestamp; // Add a timestamp field
// TODO: add description
  WorkSheet({
    this.title,
    this.students,
    this.timestamp, // Include timestamp in the constructor
    super.imageUrl,
    super.answer,
    super.questionTextInEnglish = '',
    super.questionTextInArabic = '',
    super.voiceUrl = '',
    super.questionType = QuestionType.worksheet,
    super.titleInEnglish = '',
  });

  factory WorkSheet.fromMap(Map<String, dynamic> map) {
    printDebug("getting worksheet from, $map");
    return WorkSheet(
      answer: null,
      questionTextInEnglish: null,
      imageUrl: map['imageUrl'],
      voiceUrl: null,
      questionType: QuestionType.worksheet,
      questionTextInArabic: null,
      title: map['title'],
      students: (map['students'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(
          key,
          WorksheetStudent.fromMap(value),
        ),
      ),
      timestamp:
          map['timestamp'] != null ? (map['timestamp'] as Timestamp) : null,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> baseMap = super.toMap();

    return {
      ...baseMap,
      'title': title,
      'imageUrl': imageUrl,
      'students': students?.map(
        (key, value) => MapEntry(key, value.toMap()),
      ),
      'timestamp': timestamp,
    };
  }

  factory WorkSheet.fromJson(String data) {
    return WorkSheet.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());

  @override
  BaseQuestion copy() {
    // TODO: implement copy
    throw UnimplementedError();
  }
}
