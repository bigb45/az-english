import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/models/speaking_answer.dart';
import 'package:ez_english/features/sections/models/speaking_question_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class SpeakingQuestionViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final Uuid uuid = const Uuid();

  Future<SpeakingQuestionModel?> submitForm({
    required String? questionParagraph,
    required SectionName sectionName,
  }) async {
    if (questionParagraph == null) {
      return null;
    }

    return SpeakingQuestionModel(
        question: questionParagraph,
        sectionName: sectionName,
        // add a minimum accuracy score of 60% to consider question as correct
        answer: SpeakingAnswer(answer: 60));
  }

  Future<void> uploadQuestion({
    required String level,
    required String section,
    required String day,
    required SpeakingQuestionModel question,
  }) async {
    try {
      _firestoreService.uploadQuestionToFirestore(
          day: day,
          level: level,
          section: section,
          questionMap: question.toMap());
    } catch (e) {
      print('Error adding question: $e');
    } finally {}
  }
}
