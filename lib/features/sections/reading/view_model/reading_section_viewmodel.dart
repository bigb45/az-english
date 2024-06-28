import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/firebase/constants.dart';
import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/core/firebase/firebase_authentication_service.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/models/base_answer.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/base_viewmodel.dart';
import 'package:ez_english/features/models/unit.dart';
import 'package:ez_english/features/sections/components/evaluation_section.dart';
import 'package:ez_english/features/sections/models/passage_question_model.dart';
import 'package:ez_english/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReadingSectionViewmodel extends BaseViewModel {
  String? levelId;
  String? _levelName;
  String? get levelName => _levelName;
  PassageQuestionModel? _passageQuestion;
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  List<BaseQuestion?> _questions = [];

  List<BaseQuestion?> get questions => _questions;
  PassageQuestionModel? get passageQuestion => _passageQuestion;

  @override
  FutureOr<void> init() {}

  void setValuesAndInit() async {
    currentIndex = 0;
    _levelName = RouteConstants.getLevelName(levelId!);

    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    isLoading = true;
    try {
      Unit unit = await _firestoreService.fetchUnit(
        RouteConstants.sectionNameId[RouteConstants.readingSectionName]!,
        _levelName!,
        0,
      );

      if (unit.questions.isNotEmpty &&
          unit.questions.values.first is PassageQuestionModel) {
        _passageQuestion = unit.questions.values.first as PassageQuestionModel;
        _questions = _passageQuestion!.questions;
      } else {
        _questions = unit.questions.values.cast<BaseQuestion>().toList();
      }

      error = null;
    } on CustomException catch (e) {
      error = e;
    } catch (e) {
      error = CustomException("An undefined error occurred $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateSectionProgress(
      int newQuestionIndex, String unitName) async {
    User? currentUser = _firebaseAuthService.getUser();
    isLoading = true;
    notifyListeners();
    try {
      DocumentReference userDocRef = FirebaseFirestore.instance
          .collection(FirestoreConstants.usersCollections)
          .doc(currentUser!.uid);

      FieldPath lastStoppedQuestionIndexPath = FieldPath([
        'levelsProgress',
        levelName!,
        'sectionProgress',
        RouteConstants.sectionNameId[RouteConstants.readingSectionName]!,
        unitName,
        "lastStoppedQuestionIndex"
      ]);
      FieldPath sectionProgressIndex = FieldPath([
        'levelsProgress',
        levelName!,
        'sectionProgress',
        RouteConstants.sectionNameId[RouteConstants.readingSectionName]!,
        unitName,
        "progress"
      ]);
      int lastStoppedQuestionIndex = (_firestoreService.allQuestionsLength -
              _firestoreService.filteredQuestionsLength) +
          newQuestionIndex;
      String sectionProgress = (((lastStoppedQuestionIndex + 1) /
                  _firestoreService.allQuestionsLength) *
              100)
          .toString();
      await _firestoreService.updateQuestionUsingFieldPath<int>(
          docPath: userDocRef,
          fieldPath: lastStoppedQuestionIndexPath,
          newValue: lastStoppedQuestionIndex);
      await _firestoreService.updateQuestionUsingFieldPath<String>(
          docPath: userDocRef,
          fieldPath: sectionProgressIndex,
          newValue: sectionProgress);
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

  // Future<void> getUserData(String userId) async {
  //   _userData = await _firestoreService.getUser(userId);
  // }

  @Deprecated(
      "Assign error value to error property instead of calling this method")
  void _handleError(String e) {
    Utils.showSnackBar(e);
  }

  void incrementIndex() {
    if (currentIndex < questions.length - 1) {
      currentIndex = currentIndex + 1;
      answerState = EvaluationState.empty;
    }
  }

  void updateAnswer(BaseAnswer newAnswer) {
    _questions[currentIndex]?.userAnswer = newAnswer;
    notifyListeners();
  }

  void evaluateAnswer() {
    if (_questions[currentIndex] != null &&
        _questions[currentIndex]!.evaluateAnswer()) {
      answerState = EvaluationState.correct;
    } else {
      answerState = EvaluationState.incorrect;
    }
  }
}
