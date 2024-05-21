import 'dart:convert';
import 'package:ez_english/features/models/level_progress.dart';

class UserModel {
  String? id;
  String? studentName;
  String? parentPhoneNumber;
  String emailAddress;
  String password;
  List<String>? assignedLevels;
  Map<String, LevelProgress>? levelsProgress;

  UserModel({
    this.id,
    this.studentName,
    this.parentPhoneNumber,
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
      emailAddress:
          map['emailAddress'] ?? '', // Provide a default value if needed
      password: map['password'] ?? '', // Provide a default value if needed
      assignedLevels: List<String>.from(map['assignedLevels'] ?? []),
      levelsProgress: (map['levelsProgress'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry<String, LevelProgress>(
          key,
          LevelProgress.fromMap(value),
        ),
      ),
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
      'levelsProgress':
          levelsProgress?.map((key, value) => MapEntry(key, value.toMap())),
    };
  }

  factory UserModel.fromJson(String data) {
    return UserModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());
}
