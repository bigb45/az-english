class ExamResult {
  final String examName;
  final String examDate;
  final String examScore;
  final ExamStatus examStatus;
  final String examId;
  ExamResult({
    required this.examId,
    required this.examName,
    required this.examDate,
    required this.examScore,
    required this.examStatus,
  });
}

enum ExamStatus { passed, failed, notAttempted }
