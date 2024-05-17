import 'package:ez_english/features/models/level_progress.dart';

class User {
  String studentName;
  String parentPhoneNumber;
  String emailAddress;
  String password;
  List<String> assignedLevels;
  List<LevelProgress> levelsProgress;

  User({
    required this.studentName,
    required this.parentPhoneNumber,
    required this.emailAddress,
    required this.password,
    required this.assignedLevels,
    required this.levelsProgress,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      studentName: json['studentName'],
      parentPhoneNumber: json['parentPhoneNumber'],
      emailAddress: json['emailAddress'],
      password: json['password'],
      assignedLevels: List<String>.from(json['assignedLevels']),
      levelsProgress: (json['levelsProgress'] as List)
          .map((item) => LevelProgress.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentName': studentName,
      'parentPhoneNumber': parentPhoneNumber,
      'emailAddress': emailAddress,
      'password': password,
      'assignedLevels': assignedLevels,
      'levelsProgress': levelsProgress.map((lp) => lp.toJson()).toList(),
    };
  }
}
