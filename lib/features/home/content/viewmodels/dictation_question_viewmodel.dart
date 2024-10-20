import 'dart:io';

import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/models/dictation_question_model.dart';
import 'package:ez_english/features/sections/models/string_answer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DictationQuestionViewModel extends ChangeNotifier {
  File? image;
  bool _isLoading = false;

  get isLoading => _isLoading;
  final FirestoreService _firestoreService = FirestoreService();
  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future<DictationQuestionModel?> submitForm({
    required String? questionTextInEnglish,
    required String? questionTextInArabic,
    required String? speakableText,
    required String? titleInEnglish,
    required SectionName sectionName,
    required String? answer,
  }) async {
    if (speakableText == null) {
      return null;
    }

    return DictationQuestionModel(
      questionTextInEnglish: questionTextInEnglish,
      questionTextInArabic: questionTextInArabic ?? '',
      imageUrl: null,
      speakableText: speakableText,
      answer: StringAnswer(answer: answer),
      titleInEnglish: titleInEnglish,
      sectionName: sectionName,
    );
  }

  Future<void> uploadQuestion({
    required String level,
    required String section,
    required String day,
    required DictationQuestionModel question,
  }) async {
    _isLoading = true;
    notifyListeners();
    await _firestoreService.uploadQuestionToFirestore(
        day: day,
        level: level,
        section: section,
        questionMap: question.toMap());
    _isLoading = false;
    notifyListeners();
  }

  void reset() {
    image = null;
    notifyListeners();
  }
}
