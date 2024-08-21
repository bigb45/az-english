import 'dart:convert';

import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/level_progress.dart';
import 'package:ez_english/features/models/test_result.dart';

class UserModel {
  String? id;
  String? studentName;
  String? parentPhoneNumber;
  String emailAddress;
  String password;
  List<String>? assignedLevels;
  Map<String, LevelProgress>? levelsProgress;
  Map<String, BaseQuestion>? assignedQuestions;
  final Map<String, TestResult>? examResults;
  UserType userType;

  UserModel(
      {this.id,
      this.studentName,
      this.parentPhoneNumber,
      required this.emailAddress,
      required this.password,
      this.assignedLevels,
      this.levelsProgress,
      this.examResults,
      assignedQuestions,
      this.userType = UserType.student});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      userType: UserTypeExtension.fromString(map['userType']),
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
      assignedQuestions:
          (map['assignedQuestions'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry<String, BaseQuestion>(
          key,
          BaseQuestion.fromMap(value),
        ),
      ),

      examResults: (map['examResults'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, TestResult.fromMap(value)),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userType": userType?.toShortString(),
      'studentName': studentName,
      'parentPhoneNumber': parentPhoneNumber,
      'emailAddress': emailAddress,
      'password': password,
      'assignedLevels': assignedLevels,
      'assignedQuestions': assignedQuestions,
      'levelsProgress':
          levelsProgress?.map((key, value) => MapEntry(key, value.toMap())),
      'examResults':
          examResults?.map((key, value) => MapEntry(key, value.toMap())),
    };
  }

  factory UserModel.fromJson(String data) {
    return UserModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());
}

enum UserType {
  developer,
  admin,
  student,
}

extension UserTypeExtension on UserType {
  String toShortString() {
    return toString().split('.').last;
  }

  static UserType fromString(String str) {
    return UserType.values.firstWhere(
      (e) => e.toString().split('.').last == str,
      orElse: () => UserType.student,
    );
  }
}
