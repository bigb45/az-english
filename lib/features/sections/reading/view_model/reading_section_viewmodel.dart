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
import 'package:ez_english/features/models/level_progress.dart';
import 'package:ez_english/features/models/section_progress.dart';
import 'package:ez_english/features/models/unit.dart';
import 'package:ez_english/features/models/user.dart';
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

  Future<void> updateUserProgress(
      String level, String section, String completedUnit) async {
    User? user = _firebaseAuthService.getUser();
    DocumentReference userDocRef = FirebaseFirestore.instance
        .collection(FirestoreConstants.usersCollections)
        .doc(user?.uid);

    // Fetch the user's progress data
    DocumentSnapshot userDoc = await userDocRef.get();
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

    // Initialize levelsProgress if not present
    if (!userData.containsKey('levelsProgress')) {
      userData['levelsProgress'] = {};
    }

    // Initialize levelProgress if not present
    if (!userData['levelsProgress'].containsKey(level)) {
      userData['levelsProgress'][level] = LevelProgress(
        name: level,
        description: '',
        completedSections: [],
        sectionProgress: {},
        currentDay: 1,
      ).toMap();
    }

    Map<String, dynamic> levelProgressData = userData['levelsProgress'][level];
    LevelProgress levelProgress = LevelProgress.fromMap(levelProgressData);

    // Initialize sectionProgress if not present
    if (!levelProgress.sectionProgress!.containsKey(section)) {
      levelProgress.sectionProgress![section] = SectionProgress(
        sectionName: section,
        progress: '',
        lastStoppedQuestionIndex: 0,
        unitsCompleted: [],
        isAttempted: false,
      );
    }

    SectionProgress sectionProgress = levelProgress.sectionProgress![section]!;

    // Update the completed units
    if (!sectionProgress.unitsCompleted.contains(completedUnit)) {
      sectionProgress.unitsCompleted.add(completedUnit);
    }

    // Check if the current day sections are completed
    bool allSectionsCompleted = true;
    List<String> daySections = getSectionsForDay(levelProgress.currentDay);
    for (String daySection in daySections) {
      if (!levelProgress.sectionProgress!.containsKey(daySection) ||
          !levelProgress.sectionProgress![daySection]!.isCompleted()) {
        allSectionsCompleted = false;
        break;
      }
    }

    // Increment the current day if all sections are completed
    if (allSectionsCompleted) {
      levelProgress.currentDay++;
    }

    // Save the updated progress data back to Firestore
    await userDocRef.update({
      'levelsProgress.$level': levelProgress.toMap(),
    });
  }

  List<String> getSectionsForDay(int day) {
    if (day % 2 == 1) {
      return [
        RouteConstants.readingSectionName,
        RouteConstants.grammarSectionName
      ];
    } else {
      return [RouteConstants.listeningWritingSectionName];
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
