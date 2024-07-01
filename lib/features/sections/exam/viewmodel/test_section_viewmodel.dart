import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/firebase/constants.dart';
import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/core/firebase/firebase_authentication_service.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/models/base_answer.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/base_viewmodel.dart';
import 'package:ez_english/features/models/exam_result.dart';
import 'package:ez_english/features/models/unit.dart';
import 'package:ez_english/features/sections/components/evaluation_section.dart';
import 'package:ez_english/features/sections/models/passage_question_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TestSectionViewmodel extends BaseViewModel {
  final sectionId = "4";
  Map<int, String> passageTexts = {};
  bool _isReadyToSubmit = false;
  bool _isSubmitted = false;
  String? levelId;
  List<BaseQuestion> _questions = [];
  List<bool?> _answers = [];

  bool get isReadyToSubmit => _isReadyToSubmit;
  bool get isSubmitted => _isSubmitted;
  get answers => _answers;
  get questions => _questions;
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuthService _firebaseAuth = FirebaseAuthService();

  @override
  FutureOr<void> init() {}

  Future<void> myInit() async {
    _answers = [];
    currentIndex = 0;
    levelName = RouteConstants.getLevelName(levelId!);
    sectionName = RouteConstants.testSectionName;
    await fetchQuestions();
    if (_questions[currentIndex].questionType == QuestionType.youtubeLesson) {
      answerState = EvaluationState.noState;
    }
    isInitialized = true;
  }

  Future<void> fetchQuestions() async {
    isLoading = true;
    // UserModel userData = (await _firestoreService.getUser(_firebaseAuthService.getUser()!.uid))!;
    // int lastQuestionIndex = userData.levelsProgress![_levelName]!
    //     .sectionProgress![_sectionName]!.lastStoppedQuestionIndex;
    try {
      Unit unit = await _firestoreService.fetchUnit(
        RouteConstants.sectionNameId[RouteConstants.testSectionName]!,
        levelName!,
      );
      _questions = unit.questions.values.cast<BaseQuestion>().toList();

      for (int i = 0; i < _questions.length; i++) {
        if (_questions[i] is PassageQuestionModel) {
          PassageQuestionModel passageQuestion =
              _questions[i] as PassageQuestionModel;
          passageTexts[i] = passageQuestion.passageInEnglish!;
          _questions.removeAt(i);
          _questions.insertAll(
              i,
              passageQuestion.questions
                  .where((q) => q != null)
                  .cast<BaseQuestion>());
        }
        _answers = [..._answers, null];
      }

      progress = unit.progress;

      error = null;
    } on CustomException catch (e) {
      error = e;
    } catch (e) {
      error = CustomException(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void updateAnswer(int questionIndex, BaseAnswer answer) {
    questions[questionIndex].userAnswer = answer;
    _isReadyToSubmit = true;
    // answers[questionIndex] = questions[questionIndex].evaluateAnswer();
    notifyListeners();
  }

  Future<void> submitExam() async {
    _isSubmitted = true;
    _isReadyToSubmit = false;
    for (int i = 0; i < questions.length; i++) {
      _answers[i] = questions[i].evaluateAnswer();
    }
    notifyListeners();
    // print(
    //   "submiting exam => ${questions.map(
    //     (q) {
    //       return q.evaluateAnswer();
    //     },
    //   )}",
    // );
  }

  void reset() {
    passageTexts.clear();
    levelId = null;
    _questions.clear();
    currentIndex = 0;
    levelName = null;
    sectionName = null;
    progress = 0.0;
    isInitialized = false;
    isLoading = false;
    error = null;
    answerState = EvaluationState.empty;
    notifyListeners();
  }

  Future<void> addOrUpdateExamResult() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);

    ExamResult examResult = ExamResult(
      examId: "$levelName$sectionName${_firestoreService.unitNumber}",
      examName: "",
      examDate: formattedDate,
      examScore: "",
      examStatus: ExamStatus.passed,
    );
    User user = _firebaseAuth.getUser()!;
    DocumentReference userDocRef = FirebaseFirestore.instance
        .collection(FirestoreConstants.usersCollections)
        .doc(user.uid);
    _firestoreService.updateDocuments(
      docPath: userDocRef,
      newValues: {
        'examResults': {
          examResult.examId: examResult.toMap(),
        }
      },
    );
  }
}
