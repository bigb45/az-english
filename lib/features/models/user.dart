import 'dart:convert';

import 'package:ez_english/features/models/level_progress.dart';

class UserModel {
  String? id;
  String studentName;
  String parentPhoneNumber;
  String emailAddress;
  String password;
  List<String>? assignedLevels;
  List<LevelProgress>? levelsProgress;

  UserModel({
    this.id,
    required this.studentName,
    required this.parentPhoneNumber,
    required this.emailAddress,
    required this.password,
    this.assignedLevels,
    this.levelsProgress,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
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
      "id": id,
      'studentName': studentName,
      'parentPhoneNumber': parentPhoneNumber,
      'emailAddress': emailAddress,
      'password': password,
      'assignedLevels': assignedLevels,
      'levelsProgress': levelsProgress?.map((lp) => lp.toMap()).toList(),
    };
  }

  factory UserModel.fromJson(String data) {
    return UserModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());
}
