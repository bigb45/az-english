import 'dart:convert';

class SectionProgress {
  String sectionName;
  String progress;
  int lastStoppedQuestionIndex;

  SectionProgress({
    required this.sectionName,
    required this.progress,
    required this.lastStoppedQuestionIndex,
  });

  factory SectionProgress.fromMap(Map<String, dynamic> map) {
    return SectionProgress(
      sectionName: map['sectionName'],
      progress: map['progress'],
      lastStoppedQuestionIndex: map['lastStoppedQuestionIndex'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sectionName': sectionName,
      'progress': progress,
      'lastStoppedQuestionIndex': lastStoppedQuestionIndex,
    };
  }

  factory SectionProgress.fromJson(String data) {
    return SectionProgress.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());
}
