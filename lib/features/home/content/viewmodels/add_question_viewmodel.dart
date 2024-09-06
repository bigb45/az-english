import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/models/unit.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:flutter/material.dart';

class AddQuestionViewModel extends ChangeNotifier {
  List<BaseQuestion<dynamic>> questions = [];
  final FirestoreService _firestoreService = FirestoreService();
  List<Unit?>? units;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchQuestions({
    required String level,
    required String section,
    required String day,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      questions = await _firestoreService.fetchQuestions(
        level: level,
        section: section,
        day: day,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error fetching questions: $e');
      questions = [];
      notifyListeners();
    }
  }

  Unit addUnit() {
    int unitNumber = 0;
    if (units != null) {
      unitNumber = units!.length;
    }
    String unitName = "unit${unitNumber + 1}";

    Unit unit = Unit(name: unitName, questions: {});
    units?.add(unit);
    notifyListeners();
    return unit;
  }

  Future<void> fetchDays(
      {required String level, required String section, d}) async {
    try {
      units = await _firestoreService.getDays(
        level,
        section,
      );
      notifyListeners();
    } catch (e) {
      print('Error fetching questions: $e');
      questions = [];
      notifyListeners();
    }
  }

  Future<void> updateQuestion(BaseQuestion<dynamic> question) async {
    try {
      List<String> pathSegments = question.path!.split('/');

      // Get the document path and the field path
      String docPath =
          pathSegments.sublist(0, pathSegments.length - 2).join('/');
      String fieldIndex = pathSegments[pathSegments.length - 1];
      String questionField = pathSegments[pathSegments.length - 2];

      // Create the FieldPath for the specific field
      FieldPath questionFiel = FieldPath([questionField, fieldIndex]);

      // Get the document reference
      DocumentReference docRef = FirebaseFirestore.instance.doc(docPath);
      await _firestoreService
          .updateQuestionUsingFieldPath<Map<String, dynamic>>(
              docPath: docRef,
              fieldPath: questionFiel,
              newValue: question.toMap());
      questions = questions.map((q) {
        if (q.path == question.path) {
          return question;
        }
        return q;
      }).toList();
      notifyListeners();
    } catch (e) {
      print('Error updating question: $e');
    }
  }

  // Add other methods for updating and deleting questions if needed
}
