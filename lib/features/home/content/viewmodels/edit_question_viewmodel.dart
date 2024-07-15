import 'package:ez_english/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_english/features/models/base_question.dart';

class EditQuestionViewModel extends ChangeNotifier {
  List<BaseQuestion<dynamic>> questions = [];

  Future<void> fetchQuestions({
    required String level,
    required String section,
    required String day,
  }) async {
    try {
      DocumentReference unitRef = FirebaseFirestore.instance
          .collection('levels')
          .doc(level)
          .collection('sections')
          .doc(RouteConstants.getSectionIds(section))
          .collection('units')
          .doc('unit$day');

      DocumentSnapshot unitSnapshot = await unitRef.get();

      if (unitSnapshot.exists) {
        Map<String, dynamic> data = unitSnapshot.data() as Map<String, dynamic>;
        if (data['questions'] != null) {
          final questionEntries =
              (data['questions'] as Map<String, dynamic>).entries.toList();

          // Sort the entries by their keys
          questionEntries.sort((a, b) => a.key.compareTo(b.key));

          questions = questionEntries
              .map((questionData) => BaseQuestion.fromMap(questionData.value))
              .toList();
        } else {
          questions = [];
        }
      } else {
        questions = [];
      }

      notifyListeners();
    } catch (e) {
      print('Error fetching questions: $e');
      questions = [];
      notifyListeners();
    }
  }

  // Add other methods for updating and deleting questions if needed
}
