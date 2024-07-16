import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/models/word_definition.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class VocabularyViewModel extends ChangeNotifier {
  File? image;
  final FirestoreService _firestoreService = FirestoreService();
  final Uuid uuid = Uuid();
  WordType? selectedWordType;

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      notifyListeners();
    }
  }

  void setSelectedWordType(WordType? type) {
    selectedWordType = type;
    notifyListeners();
  }

  Future<WordDefinition?> submitForm({
    required String? englishWord,
    required String? arabicWord,
    required WordType type,
    required List<String>? exampleUsageInEnglish,
    required List<String>? exampleUsageInArabic,
  }) async {
    if (englishWord == null) {
      return null;
    }

    return WordDefinition(
      englishWord: englishWord,
      arabicWord: arabicWord,
      type: type,
      exampleUsageInEnglish: exampleUsageInEnglish,
      exampleUsageInArabic: exampleUsageInArabic,
      questionType: QuestionType.vocabulary,
    );
  }

  Future<void> uploadQuestion({
    required String level,
    required String section,
    required String day,
    required WordDefinition question,
  }) async {
    try {
      _firestoreService.uploadQuestionToFirestore(
          day: day,
          level: level,
          section: section,
          questionMap: question.toMap());
    } catch (e) {
      print('Error adding question: $e');
    }
  }
}