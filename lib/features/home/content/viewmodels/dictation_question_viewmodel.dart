import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/sections/models/dictation_question_model.dart';
import 'package:ez_english/features/sections/models/string_answer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DictationQuestionViewModel extends ChangeNotifier {
  File? image;
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
  }) async {
    if (speakableText == null) {
      return null;
    }

    return DictationQuestionModel(
      questionTextInEnglish: questionTextInEnglish,
      questionTextInArabic: questionTextInArabic ?? '',
      imageUrl: null,
      voiceUrl: '', // Add logic to handle voiceUrl if necessary
      speakableText: speakableText,
      answer: StringAnswer(answer: speakableText),
      titleInEnglish: titleInEnglish,
    );
  }

  Future<void> uploadQuestion({
    required String level,
    required String section,
    required String day,
    required DictationQuestionModel question,
  }) async {
    _firestoreService.uploadQuestionToFirestore(
        day: day,
        level: level,
        section: section,
        questionMap: question.toMap());
  }
}
