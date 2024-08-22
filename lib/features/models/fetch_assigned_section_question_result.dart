import 'package:ez_english/features/models/base_question.dart';

class SectionFetchResult {
  final Map<int, BaseQuestion<dynamic>> questions;
  final double progress;

  SectionFetchResult({
    required this.questions,
    required this.progress,
  });
}
