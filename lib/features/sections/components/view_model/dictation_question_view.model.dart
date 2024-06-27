import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_english/core/firebase/firebase_service.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/core/network/apis_constants.dart';
import 'package:ez_english/core/network/custom_response.dart';
import 'package:ez_english/core/network/network_helper.dart';
import 'package:ez_english/features/sections/models/dictation_question_model.dart';
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
      // Play existing audio from URL
      return question.voiceUrl!;
    } else {
      // Generate audio using Azure API
      String requestBody =
          '<speak version="1.0" xml:lang="en-US"><voice xml:lang="en-US" xml:gender="Female" name="en-US-JennyNeural">${question.speakableText}</voice></speak>';
      Map<String, String> requestBodyHeaders = {
        'Ocp-Apim-Subscription-Key': apiKey,
        'Content-Type': 'application/ssml+xml',
        'X-Microsoft-OutputFormat': 'audio-24khz-160kbitrate-mono-mp3',
      };

      try {
        CustomResponse response = await NetworkHelper.instance.post(
          url: APIConstants.ttsEndPoint,
          headersForRequest: requestBodyHeaders,
          body: requestBody,
          returnBytesResponse: true,
        );
        if (response.statusCode == 200) {
          final bytes = response.data;
          // Upload audio to Firebase Storage
          String audioUrl = await _firebaseService.uploadAudioToFirebase(
              bytes, question.speakableText);
          // Update Firestore with the new URL

          // Split the path into segments
          List<String> pathSegments = question.path!.split('/');

          // Get the document path and the field path
          String docPath =
              pathSegments.sublist(0, pathSegments.length - 2).join('/');
          String fieldIndex = pathSegments[pathSegments.length - 1];
          String questionField = pathSegments[pathSegments.length - 2];

          // Create the FieldPath for the specific field
          FieldPath questionFiel = FieldPath([questionField]);

          // Get the document reference
          DocumentReference docRef = FirebaseFirestore.instance.doc(docPath);
          question.voiceUrl = audioUrl;
          // Update the specific field
          await _firestoreService.updateQuestion<Map<String, dynamic>>(
              docPath: docRef,
              fieldPath: questionFiel,
              newValue: question.toMap());
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
