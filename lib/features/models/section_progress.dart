import 'dart:convert';

class SectionProgress {
  String sectionName;
  String progress;
  int lastStoppedQuestionIndex;
  List<String> unitsCompleted; // List to track completed units
  bool isAttempted;
  bool isAssigned;
  bool isCompleted;

  SectionProgress({
    required this.sectionName,
    this.isAttempted = false,
    this.isAssigned = false,
    this.isCompleted = false,
    required this.progress,
    required this.lastStoppedQuestionIndex,
    this.unitsCompleted = const [],
  });

  factory SectionProgress.fromMap(Map<String, dynamic> map) {
    return SectionProgress(
        sectionName: map['sectionName'] ?? '',
        progress: map['progress'] ?? '',
        lastStoppedQuestionIndex: map['lastStoppedQuestionIndex'] ?? 0,
        unitsCompleted: List<String>.from(map['unitsCompleted'] ?? []),
        isAssigned: map['isAssigned'],
        isCompleted: map['isCompleted'],
        isAttempted: map['isAttempted']);
  }

  Map<String, dynamic> toMap() {
    return {
      'sectionName': sectionName,
      'progress': progress,
      'lastStoppedQuestionIndex': lastStoppedQuestionIndex,
      'unitsCompleted': unitsCompleted,
      'isAssigned': isAssigned,
      'isCompleted': isCompleted,
      'isAttempted': isAttempted,
    };
  }

  factory SectionProgress.fromJson(String data) {
    return SectionProgress.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());

  bool isSectionCompleted(String requiredUnit) {
    if (!unitsCompleted.contains(requiredUnit)) {
      return false;
    }
    return true;
  }
}
