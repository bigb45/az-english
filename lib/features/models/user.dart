import 'dart:convert';

import 'package:ez_english/features/models/level_progress.dart';

class User {
  String studentName;
  String parentPhoneNumber;
  String emailAddress;
  String password;
  List<String> assignedLevels;
  List<LevelProgress>? levelsProgress;

  User({
    required this.studentName,
    required this.parentPhoneNumber,
    required this.emailAddress,
    required this.password,
    required this.assignedLevels,
    required this.levelsProgress,
  });

  // Factory constructor to create a User instance from a map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      studentName: map['studentName'],
      parentPhoneNumber: map['parentPhoneNumber'],
      emailAddress: map['emailAddress'],
      password: map['password'],
      assignedLevels: List<String>.from(map['assignedLevels']),
      levelsProgress: (map['levelsProgress'] as List?)
          ?.map((item) => LevelProgress.fromMap(item))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentName': studentName,
      'parentPhoneNumber': parentPhoneNumber,
      'emailAddress': emailAddress,
      'password': password,
      'assignedLevels': assignedLevels,
      'levelsProgress': levelsProgress?.map((lp) => lp.toMap()).toList(),
    };
  }

  factory User.fromJson(String data) {
    return User.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());
}
