import 'dart:convert';

class SectionProgress {
  String sectionName;
  String progress;
  int lastStoppedQuestionIndex;
  List<String> unitsCompleted; // List to track completed units
  bool isAttempted; // Flag to track if the section has been attempted

  SectionProgress({
    required this.sectionName,
    required this.progress,
    required this.lastStoppedQuestionIndex,
    this.unitsCompleted = const [],
    this.isAttempted = false,
  });

  factory SectionProgress.fromMap(Map<String, dynamic> map) {
    return SectionProgress(
      sectionName: map['sectionName'] ?? '',
      progress: map['progress'] ?? '',
      lastStoppedQuestionIndex: map['lastStoppedQuestionIndex'] ?? 0,
      unitsCompleted: List<String>.from(map['unitsCompleted'] ?? []),
      isAttempted: map['isAttempted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sectionName': sectionName,
      'progress': progress,
      'lastStoppedQuestionIndex': lastStoppedQuestionIndex,
      'unitsCompleted': unitsCompleted,
      'isAttempted': isAttempted,
    };
  }

  factory SectionProgress.fromJson(String data) {
    return SectionProgress.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());

  bool isCompleted() {
    // Add logic to check if the section is completed
    // For example, you can check if all units are completed
    return unitsCompleted.isNotEmpty; // Adjust based on your criteria
  }
}
