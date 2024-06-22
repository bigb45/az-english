import 'dart:async';

import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/core/firebase/firebase_authentication_service.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/base_viewmodel.dart';
import 'package:ez_english/features/models/user.dart';
import 'package:ez_english/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReadingQuestionViewmodel extends BaseViewModel {
  String? levelId;
  String? _sectionName = "Reading";
  String? _levelName;
  UserModel? _userData;
  String? get sectionName => _sectionName;
  String? get levelName => _levelName;
  dynamic userAnswer = "";
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  List<BaseQuestion> _questions = [];

  List<BaseQuestion> get questions => _questions;

  @override
  FutureOr<void> init() {}

  void setValuesAndInit() async {
    _levelName = RouteConstants.getLevelName(levelId!);
    await getUserData(_firebaseAuthService.getUser()!.uid);
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    isLoading = true;
    int lastQuestionIndex = _userData!.levelsProgress![levelName]!
        .sectionProgress!["reading"]!.lastStoppedQuestionIndex;
    try {
      _questions = await _firestoreService.fetchQuestions(
        _sectionName!,
        _levelName!,
        lastQuestionIndex,
      );
      error = null;
    } on CustomException catch (e) {
      // error = e as CustomException;
      _handleError(e.message);
      notifyListeners();
    } catch (e) {
      // TODO: assign error to 'error' variable here and handle state in UI
      // error = CustomException(e.toString());
      _handleError("An undefined error occurred ${e.toString()}");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateSectionProgress(int newQuestionIndex) async {
    User? currentUser = _firebaseAuthService.getUser();
    isLoading = true;

    // TODO: change this to be dynamic from the API
    newQuestionIndex = (3 - questions.length) + newQuestionIndex;
    notifyListeners();
    try {
      await _firestoreService.updateQuestionProgress(
          userId: currentUser!.uid,
          levelName: levelName!,
          sectionName: sectionName!,
          newQuestionIndex: newQuestionIndex);
      error = null;
    } on CustomException catch (e) {
      // error = e as CustomException;
      _handleError(e.message);
      notifyListeners();
    } catch (e) {
      _handleError("An undefined error occurred ${e.toString()}");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getUserData(String userId) async {
    _userData = await _firestoreService.getUser(userId);
  }

  void _handleError(String e) {
    // TODO: separate UI logic from business logic
    Utils.showSnackBar(e);
  }

  void incrementIndex() {
    if (currentIndex < questions.length - 1) {
      currentIndex++;
    }
  }

  void updateAnswer<T>(T newAnswer) {
    userAnswer = newAnswer;
    notifyListeners();
  }

  void evaluateAnswer() {
    // answerState = switch (_questions[currentIndex].questionType) {
    //   // TODO: fix this
    //   QuestionType.multipleChoice =>
    //     ((_questions[currentIndex]).imageUrl == null)
    //         ? EvaluationState.correct
    //         : EvaluationState.incorrect,
    //   _ => EvaluationState.correct,
    // };
  }
}
