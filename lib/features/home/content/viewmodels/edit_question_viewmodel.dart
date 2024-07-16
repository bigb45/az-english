import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_english/features/models/base_question.dart';

class EditQuestionViewModel extends ChangeNotifier {
  List<BaseQuestion<dynamic>> questions = [];
  FirestoreService _firestoreService = FirestoreService();

  Future<void> fetchQuestions({
    required String level,
    required String section,
    required String day,
  }) async {
    try {
      questions = await _firestoreService.fetchQuestions(
        level: level,
        section: section,
        day: day,
      );
      notifyListeners();
    } catch (e) {
      print('Error fetching questions: $e');
      questions = [];
      notifyListeners();
    }
  }

  // Add other methods for updating and deleting questions if needed
}
