import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/firebase/constants.dart';
import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/core/firebase/firebase_service.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/core/network/custom_response.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/base_viewmodel.dart';
import 'package:ez_english/features/models/unit.dart';
import 'package:ez_english/features/sections/models/word_definition.dart';
import 'package:ez_english/utils/utils.dart';

import '../../models/word_model.dart';

class VocabularySectionViewmodel extends BaseViewModel {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseService _firebaseService = FirebaseService();
  late List<WordModel> _words;
  String? levelId;
  List<BaseQuestion?> _questions = [];
  Unit unit = Unit(name: "vocabulary_unit", questions: {});
  List<BaseQuestion?> get questions => _questions;
  get words => _words;
  List<BaseQuestion?> _originalQuestions = [];
  Map<int, int> indexMap = {}; // Map to track filtered to original indices
  List<BaseQuestion?> get originalQuestions => _originalQuestions;

  @override
  FutureOr<void> init() {
    _words = [];
  }

  void setValuesAndInit() async {
    currentIndex = 0;
    levelName = RouteConstants.getLevelName(levelId!);
    sectionName = RouteConstants.vocabularySectionName;
    await fetchQuestions();
    filterQuestions();
  }

  Future<String> getAudioBytes(WordDefinition question) async {
    if (question.voiceUrl != null && question.voiceUrl!.isNotEmpty) {
      return question.voiceUrl!;
    } else {
      try {
        CustomResponse response = await Utils.speakText(question.englishWord);
        if (response.statusCode == 200) {
          final bytes = response.data;
          // Upload audio to Firebase Storage
          String audioUrl = await _firebaseService.uploadAudioToFirebase(
              bytes, question.englishWord);
          // Update Firestore with the new URL

          // Split the path into segments
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
          question.voiceUrl = audioUrl;
          // Update the specific field
          await _firestoreService
              .updateQuestionUsingFieldPath<Map<String, dynamic>>(
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

  Future<void> fetchQuestions() async {
    isLoading = true;
    try {
      unit = await firestoreService.fetchUnit(
        RouteConstants.sectionNameId[RouteConstants.vocabularySectionName]!,
        levelName!,
      );

      _questions = unit.questions.values.toList();
      _originalQuestions = unit.questions.values.toList();
      _questions = List.from(_originalQuestions);

      progress = unit.progress;

      error = null;
    } on CustomException catch (e) {
      error = e;
      notifyListeners();
    } catch (e) {
      error = CustomException("An undefined error occurred $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void filterQuestions() {
    indexMap.clear(); // Clear the map before populating
    List<BaseQuestion?> notNewQuestions = [];
    List<BaseQuestion?> newQuestions = [];

    // Split the questions into 'new' and 'not new'
    for (int i = 0; i < _originalQuestions.length; i++) {
      var question = _originalQuestions[i];
      if ((question as WordDefinition).isNew) {
        newQuestions.add(question);
      } else {
        notNewQuestions.add(question);
      }
    }

    // Combine new questions first, followed by not new questions
    List<BaseQuestion?> combinedQuestions = [
      ...newQuestions,
      ...notNewQuestions
    ];

    // Populate _questions and indexMap with the combined list
    _questions = [];
    for (int i = 0; i < combinedQuestions.length; i++) {
      var question = combinedQuestions[i];
      indexMap[_questions.length] = _originalQuestions
          .indexOf(question); // Map the filtered index to the original index
      _questions.add(question);
    }

    notifyListeners();
  }

  Future<void> updateWordStatus(WordDefinition question) async {
    if (question.isNew) {
      isLoading = true;
      notifyListeners();
      try {
        question.isNew = false;
        incrementIndex();
        error = null;
      } on CustomException catch (e) {
        error = e;
        // _handleError(e.message);
        notifyListeners();
      } catch (e) {
        error = CustomException("An undefined error occurred ${e.toString()}");
        // _handleError("An undefined error occurred ${e.toString()}");
      } finally {
        isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> updateInteractedQuestionsList(int filteredIndex) async {
    int originalIndex = indexMap[filteredIndex]!;
    _firestoreService.updateInteractedQuestionsList(
        originalIndex, levelName!, sectionName!);
  }

  void reset() {
    _words = [];
    levelId = null;
    _questions.clear();
    unit = Unit(name: "vocabulary_unit", questions: {});
    currentIndex = 0;
    levelName = null;
    sectionName = null;
    progress = 0.0;
    isInitialized = false;
    isLoading = false;
    error = null;
    notifyListeners();
  }

  bool areAllWordsNotNew() {
    return questions.every((word) => !(word as WordDefinition).isNew);
  }

  void incrementIndex() {
    if (currentIndex < _questions.length - 1) {
      currentIndex = currentIndex + 1;
      progress = _firestoreService.calculateNewProgress(currentIndex);
    }
    notifyListeners();
  }
}
