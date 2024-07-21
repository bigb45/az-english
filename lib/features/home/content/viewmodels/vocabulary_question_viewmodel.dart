import 'dart:io';

import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/models/word_definition.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class VocabularyViewModel extends ChangeNotifier {
  File? image;
  final FirestoreService _firestoreService = FirestoreService();
  final Uuid uuid = Uuid();
  bool _isLoading = false;

  get isLoading => _isLoading;
  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future<WordDefinition?> submitForm({
    required String? englishWord,
    required String? arabicWord,
    required WordType type,
    required List<String>? exampleUsageInEnglish,
    required List<String>? exampleUsageInArabic,
    required String? questionTextInEnglish,
  }) async {
    return WordDefinition(
      englishWord: englishWord!,
      arabicWord: arabicWord,
      type: type,
      exampleUsageInEnglish: exampleUsageInEnglish,
      exampleUsageInArabic: exampleUsageInArabic,
      questionType: QuestionType.vocabulary,
      questionTextInEnglish: questionTextInEnglish,
    );
  }

  Future<void> uploadQuestion({
    required String level,
    required String section,
    required String day,
    required WordDefinition question,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _firestoreService.uploadQuestionToFirestore(
          day: day,
          level: level,
          section: section,
          questionMap: question.toMap());
    } catch (e) {
      print('Error adding question: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
