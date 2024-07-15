import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/sections/models/youtube_lesson_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class YoutubeLessonViewModel extends ChangeNotifier {
  File? image;
  FirestoreService _firestoreService = FirestoreService();
  final Uuid uuid = Uuid();

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future<YoutubeLessonModel?> submitForm({
    required String? youtubeUrl,
    required String? titleInEnglish,
  }) async {
    if (youtubeUrl == null) {
      return null;
    }

    return YoutubeLessonModel(
      youtubeUrl: youtubeUrl,
      titleInEnglish: titleInEnglish,
    );
  }

  Future<void> uploadQuestion({
    required String level,
    required String section,
    required String day,
    required YoutubeLessonModel question,
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

  Future<bool> _documentExists(DocumentReference docRef) async {
    try {
      var docSnapshot = await docRef.get();
      return docSnapshot.exists;
    } catch (e) {
      print('Error checking document existence: $e');
      return false;
    }
  }
}
