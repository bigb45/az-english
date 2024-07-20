import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/sections/models/passage_question_model.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';

class PassageViewModel extends ChangeNotifier {
  File? image;
  final FirestoreService _firestoreService = FirestoreService();
  final Uuid uuid = Uuid();
  List<BaseQuestion<dynamic>> questions = [];

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      notifyListeners();
    }
  }

  void addQuestion(BaseQuestion<dynamic> question) {
    questions.add(question);
    notifyListeners();
  }

  PassageQuestionModel submitForm({
    required String passageInEnglish,
    required String passageInArabic,
    required String titleInEnglish,
    required String titleInArabic,
    required String questionTextInEnglish,
    required String questionTextInArabic,
  }) {
    return PassageQuestionModel(
      questions: questions,
      passageInEnglish: passageInEnglish,
      passageInArabic: passageInArabic,
      titleInEnglish: titleInEnglish,
      titleInArabic: titleInArabic,
      questionTextInEnglish: questionTextInEnglish,
      questionTextInArabic: questionTextInArabic,
      imageUrl: '', // Handle image URL if necessary
      voiceUrl: '', // Handle voice URL if necessary
    );
  }

  Future<void> uploadQuestion({
    required String level,
    required String section,
    required String day,
    required PassageQuestionModel question,
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
