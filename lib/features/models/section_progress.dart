class SectionProgress {
  String sectionName;
  String progress;
  int lastStoppedQuestionIndex;

  SectionProgress(
      {required this.sectionName,
      required this.progress,
      required this.lastStoppedQuestionIndex});

  factory SectionProgress.fromJson(Map<String, dynamic> json) {
    return SectionProgress(
      sectionName: json['sectionName'],
      progress: json['progress'],
      lastStoppedQuestionIndex: json['lastStoppedQuestionIndex'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sectionName': sectionName,
      'progress': progress,
      'lastStoppedQuestionIndex': lastStoppedQuestionIndex,
    };
  }
}
