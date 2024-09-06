import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_english/features/models/worksheet_student.dart';

class WorkSheet {
  String? title;
  String? imageUrl;
  Map<String, WorksheetStudent>? students;
  Timestamp? timestamp; // Add a timestamp field

  WorkSheet({
    this.title,
    this.imageUrl,
    this.students,
    this.timestamp, // Include timestamp in the constructor
  });

  factory WorkSheet.fromMap(Map<String, dynamic> map) {
    return WorkSheet(
      title: map['title'],
      imageUrl: map['imageUrl'],
      students: (map['students'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(
          key,
          WorksheetStudent.fromMap(value),
        ),
      ),
      timestamp: map['timestamp'] != null
          ? (map['timestamp'] as Timestamp)
          : null, // Handle Firestore timestamp
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'students': students?.map(
        (key, value) => MapEntry(key, value.toMap()),
      ),
      'timestamp': timestamp, // Include the timestamp in the map
    };
  }

  factory WorkSheet.fromJson(String data) {
    return WorkSheet.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());
}
