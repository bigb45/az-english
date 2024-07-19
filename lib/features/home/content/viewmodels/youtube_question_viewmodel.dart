import 'dart:io';

import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/sections/models/youtube_lesson_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class YoutubeLessonViewModel extends ChangeNotifier {
  File? image;
  FirestoreService _firestoreService = FirestoreService();
  final Uuid uuid = const Uuid();

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
    } finally {}
  }
}
