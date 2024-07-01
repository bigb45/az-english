class TestResult {
  final String examId;
  final String examName;
  final String examDate;
  final String examScore;
  final ExamStatus examStatus;

  TestResult({
    required this.examId,
    required this.examName,
    required this.examDate,
    required this.examScore,
    required this.examStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'examId': examId,
      'examName': examName,
      'examDate': examDate,
      'examScore': examScore,
      'examStatus': examStatus.toString().split('.').last,
    };
  }

  factory TestResult.fromMap(Map<String, dynamic> map) {
    return TestResult(
      examId: map['examId'],
      examName: map['examName'],
      examDate: map['examDate'],
      examScore: map['examScore'],
      examStatus: ExamStatus.values
          .firstWhere((e) => e.toString() == 'ExamStatus.${map['examStatus']}'),
    );
  }
}

enum ExamStatus { passed, failed, notAttempted }
