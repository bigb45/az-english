import 'dart:io';

import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/sections/models/fill_the_blanks_question_model.dart';
import 'package:ez_english/features/sections/models/string_answer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class FillTheBlanksViewModel extends ChangeNotifier {
  File? image;
  final FirestoreService _firestoreService = FirestoreService();
  final Uuid uuid = Uuid();

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future<FillTheBlanksQuestionModel?> submitForm({
    required String? incompleteSentenceInEnglish,
    required String? incompleteSentenceInArabic,
    required String answer,
    String? questionTextInEnglish,
    String? questionTextInArabic,
  }) async {
    if (incompleteSentenceInEnglish == null || answer.isEmpty) {
      return null;
    }

    return FillTheBlanksQuestionModel(
      incompleteSentenceInEnglish: incompleteSentenceInEnglish,
      incompleteSentenceInArabic: incompleteSentenceInArabic,
      answer: StringAnswer(answer: answer),
      questionTextInEnglish: questionTextInEnglish,
      questionTextInArabic: questionTextInArabic,
    );
  }

  Future<void> uploadQuestion({
    required String level,
    required String section,
    required String day,
    required FillTheBlanksQuestionModel question,
  }) async {
    try {
      await _firestoreService.uploadQuestionToFirestore(
          day: day,
          level: level,
          section: section,
          questionMap: question.toMap());
    } catch (e) {
      print('Error adding question: $e');
    }
  }
}
