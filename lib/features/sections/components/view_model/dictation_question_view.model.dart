import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_english/core/firebase/firebase_service.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/core/network/custom_response.dart';
import 'package:ez_english/features/sections/models/dictation_question_model.dart';
import 'package:ez_english/utils/utils.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';

class DictationQuestionViewModel extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  final FirestoreService _firestoreService = FirestoreService();
  final String apiKey = dotenv.env['AZURE_API_KEY_1'] ?? '';
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<String> getAudioBytes(DictationQuestionModel question) async {
    if (question.voiceUrl != null && question.voiceUrl!.isNotEmpty) {
      return question.voiceUrl!;
    } else {
      try {
        CustomResponse response = await Utils.speakText(question.speakableText);
        if (response.statusCode == 200) {
          final bytes = response.data;
          // Upload audio to Firebase Storage
          String audioUrl = await _firebaseService.uploadAudioToFirebase(
              bytes, question.speakableText);
          question.voiceUrl = audioUrl;
          // Update Firestore with the new URL

          // Split the path into segments
          if (question.path != null && question.path!.isNotEmpty) {
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
            // Update the specific field
            await _firestoreService
                .updateQuestionUsingFieldPath<Map<String, dynamic>>(
                    docPath: docRef,
                    fieldPath: questionFiel,
                    newValue: question.toMap());
          }
          return audioUrl;
        } else {
          throw Exception(
              "Error while generating audio: ${response.statusCode}, ${response.errorMessage}");
        }
      } catch (e) {
        print("Error while playing audio: $e");
      }
    }
    throw Exception("No audio URL found.");
  }
}
