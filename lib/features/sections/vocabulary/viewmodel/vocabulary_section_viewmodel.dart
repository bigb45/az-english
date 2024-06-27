import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/firebase/constants.dart';
import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/base_viewmodel.dart';
import 'package:ez_english/features/models/unit.dart';
import 'package:ez_english/features/sections/models/word_definition.dart';

import '../../models/word_model.dart';

class VocabularySectionViewmodel extends BaseViewModel {
  final FirestoreService _firestoreService = FirestoreService();

  late List<WordModel> _words;
  String? levelId;
  String? _levelName;
  String? get levelName => _levelName;
  List<BaseQuestion?> _questions = [];
  Unit unit = Unit(name: "vocabulary_unit", questions: {});
  List<BaseQuestion?> get questions => _questions;
  get words => _words;

  @override
  FutureOr<void> init() {
    _words = [];
  }

  void setValuesAndInit() async {
    currentIndex = 0;
    _levelName = RouteConstants.getLevelName(levelId!);
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    isLoading = true;
    try {
      unit = await firestoreService.fetchUnit(
        RouteConstants.vocabularySectionName,
        _levelName!,
        0,
      );

      _questions = unit.questions.values.toList();
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

  Future<void> updateWordStatus(WordDefinition question) async {
    isLoading = true;
    notifyListeners();
    try {
      question.isNew = false;
      List<String> pathSegments = question.path!.split('/');
      // Get the document path and the field path
      String docPath =
          pathSegments.sublist(0, pathSegments.length - 2).join('/');
      String questionIndex = pathSegments.last;
      FieldPath questionFieldPath =
          FieldPath([FirestoreConstants.questionsField, questionIndex]);
      DocumentReference docRef = FirebaseFirestore.instance.doc(docPath);

      // Update the specific field
      await _firestoreService.updateQuestion<Map<String, dynamic>>(
          docPath: docRef,
          fieldPath: questionFieldPath,
          newValue: question.toMap());

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
