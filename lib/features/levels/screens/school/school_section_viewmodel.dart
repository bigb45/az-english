import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/core/firebase/firebase_authentication_service.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/models/assigned_questions.dart';
import 'package:ez_english/features/models/base_answer.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/base_viewmodel.dart';
import 'package:ez_english/features/models/level.dart';
import 'package:ez_english/features/models/user.dart';
import 'package:ez_english/features/models/worksheet.dart';
import 'package:ez_english/features/models/worksheet_student.dart';
import 'package:ez_english/features/sections/components/evaluation_section.dart';
import 'package:ez_english/features/sections/models/passage_question_model.dart';
import 'package:ez_english/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SchoolSectionViewmodel extends BaseViewModel {
  String? levelId;
  List<BaseQuestion> _questions = [];
  get questions => _questions;

  List<Level> _levels = [];
  int _userCurrentDay = 0;
  String? _tempUnitNumber;
  List<Level> get levels => _levels;
  int get userCurrentDay => _userCurrentDay;
  WorksheetStudent? _uploadedWorksheet;
  WorksheetStudent? get uploadedWorksheet => _uploadedWorksheet;
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  final String _currentUserId = FirebaseAuth.instance.currentUser!.uid;
  @override
  FutureOr<void> init() {}

  Future<void> setValuesAndInit() async {
    currentIndex = 0;
    levelName = RouteConstants.getLevelName(levelId!);
    sectionName = RouteConstants.speakingSectionName;
    await fetchQuestions();
    await fetchQuestionsFromLevel();
    if (_questions.isNotEmpty &&
        _questions[currentIndex].questionType == QuestionType.youtubeLesson) {
      answerState = EvaluationState.noState;
    }
  }

  Future<void> fetchQuestions() async {
    isLoading = true;
    notifyListeners();
    try {
      User? user = _firebaseAuthService.getUser();
      var questions = await _firestoreService.fetchAssignedQuestions(
          user: user!, sectionName: RouteConstants.speakingSectionName);
      _questions = questions.questions.values.cast<BaseQuestion>().toList();
      progress = questions.progress;
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

  Future<int> fetchSections() async {
    isLoading = true;
    notifyListeners();
    try {
      error = null;
      User? user = _firebaseAuthService.getUser();
      UserModel? userModel = await _firestoreService.getUser(user!.uid);
      AssignedQuestions assignedQuestions = userModel!.assignedQuestions![
          RouteConstants.sectionNameId[RouteConstants.speakingSectionName]]!;
      int currentDay = assignedQuestions.currentDay;
      return currentDay;
    } on CustomException catch (e) {
      // error = e as CustomException;
      _handleError(e.message);
      notifyListeners();
      return 0;
    } catch (e) {
      _handleError("An undefined error occurred ${e.toString()}");
      return 0;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _handleError(String e) {
    Utils.showErrorSnackBar(e);
  }

  Future<void> fetchQuestionsFromLevel({int? desiredDay}) async {
    isLoading = true;
    notifyListeners();
    try {
      _questions = [];
      List<BaseQuestion> embeddedPassageQuestions = [];
      User? user = _firebaseAuthService.getUser();
      UserModel? userModel = await _firestoreService.getUser(user!.uid);
      AssignedQuestions assignedQuestions = userModel!.assignedQuestions![
          RouteConstants.sectionNameId[RouteConstants.speakingSectionName]]!;
      if (desiredDay != null) {
        assignedQuestions.lastStoppedQuestionIndex = 0;
        assignedQuestions.progress = 0;
        assignedQuestions.currentDay = desiredDay;
      }
      progress = assignedQuestions.progress;
      int currentDay = assignedQuestions.currentDay;
      List<String> daySections = _firestoreService.getSectionsForDay();
      int tempAllQuestionsLength = 0;
      int tempFilterQuestionsLength = 0;

      for (var section in daySections) {
        String tempUnitNumber = "$currentDay";
        _tempUnitNumber = "unit$currentDay";
        if (assignedQuestions.assignedLevels!.isNotEmpty) {
          for (var level in assignedQuestions.assignedLevels!) {
            var sectionQuestions = await _firestoreService.fetchQuestions(
                level: level!, section: section, day: tempUnitNumber);
            tempAllQuestionsLength = sectionQuestions.length;
            List<BaseQuestion<dynamic>> finalSectionQuestions = [];

            for (var entry in sectionQuestions) {
              if (entry.questionType == QuestionType.passage) {
                PassageQuestionModel? passageQuestion =
                    entry as PassageQuestionModel;
                var embeddedQuestionsData = passageQuestion.questions;
                var parentQuestionPath = entry.path;
                for (var embeddedEntry in embeddedQuestionsData.entries) {
                  var embeddedQuestionMap = embeddedEntry.value as BaseQuestion;
                  PassageQuestionModel embeddedQuestion = PassageQuestionModel(
                      passageInEnglish: entry.passageInEnglish,
                      passageInArabic: entry.passageInArabic,
                      titleInArabic: entry.titleInArabic,
                      titleInEnglish: entry.titleInEnglish,
                      questions: {1: embeddedQuestionMap},
                      questionTextInEnglish: entry.questionTextInEnglish,
                      questionTextInArabic: entry.questionTextInArabic,
                      imageUrl: entry.imageUrl,
                      voiceUrl: entry.voiceUrl,
                      questionType: QuestionType.passage,
                      sectionName: SectionNameExtension.fromString(section));
                  embeddedQuestion.path =
                      "$parentQuestionPath/embeddedQuestions/${embeddedEntry.key}";
                  embeddedPassageQuestions.add(embeddedQuestion);
                  // finalSectionQuestions.add(embeddedQuestion);
                }
                finalSectionQuestions.addAll(embeddedPassageQuestions);
                sectionQuestions = (embeddedPassageQuestions);
              } else {
                finalSectionQuestions.add(entry);
              }
            }

            _questions.addAll(finalSectionQuestions);
            sectionQuestions = [];
            embeddedPassageQuestions = [];
          }
        }
      }
      tempAllQuestionsLength = _questions.length;
      _questions =
          _questions.skip(assignedQuestions.lastStoppedQuestionIndex).toList();
      tempFilterQuestionsLength = _questions.length;

      _firestoreService.updateQuestionsLength(
          tempAllQuestionsLength, tempFilterQuestionsLength);
      error = null;
    } on CustomException catch (e) {
      error = e;
    } catch (e) {
      error = CustomException(e.toString());
    } finally {
      isLoading = false;
      print("questions: ${_questions.length}");
      notifyListeners();
    }
  }

  void updateAnswer(BaseAnswer answer) {
    BaseQuestion question = _questions[currentIndex];
    if (question.questionType == QuestionType.passage) {
      PassageQuestionModel passageQuestion = question as PassageQuestionModel;
      question = passageQuestion.questions.entries.first.value!;
    }
    question.userAnswer = answer;
    notifyListeners();
  }

  void evaluateAnswer() {
    BaseQuestion question = _questions[currentIndex];
    if (question.questionType == QuestionType.passage) {
      PassageQuestionModel passageQuestion = question as PassageQuestionModel;
      question = passageQuestion.questions.entries.first.value!;
    }
    if (question.evaluateAnswer()) {
      answerState = EvaluationState.correct;
    } else {
      wrongAnswerCount += 1;
      answerState = EvaluationState.incorrect;
    }
  }

  void incrementIndex() {
    if (currentIndex < _questions.length) {
      currentIndex = currentIndex + 1;
      progress = _firestoreService.calculateNewProgress(currentIndex);
      if (currentIndex < _questions.length &&
          shouldSkipValidation(_questions[currentIndex])) {
        answerState = EvaluationState.noState;
      } else {
        answerState = EvaluationState.empty;
      }
    }
  }

  @override
  Future<void> updateSectionProgress() async {
    isLoading = true;
    notifyListeners();
    try {
      if (!tempUnit) {
        await _firestoreService
            .updateCurrentSectionQuestionIndexForAssignedQuestions(
                currentIndex, sectionName!);
      }
      ;
    } catch (e) {
      error = CustomException("An undefined error ocurred ${e.toString()}");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  Future<void> updateUserProgress() async {
    isLoading = true;
    notifyListeners();
    try {
      if (!tempUnit) {
        User? user = _firebaseAuthService.getUser();
        UserModel? userModel = await _firestoreService.getUser(user!.uid);
        AssignedQuestions assignedQuestions = userModel!.assignedQuestions![
            RouteConstants.sectionNameId[RouteConstants.speakingSectionName]]!;
        int currentDay = assignedQuestions.currentDay;
        currentDay = currentDay + 1;
        DocumentReference userDocRef =
            FirebaseFirestore.instance.collection("users").doc(userModel.id);
        await _firestoreService.updateQuestionUsingFieldPath(
            docPath: userDocRef,
            fieldPath: FieldPath([
              'assignedQuestions',
              RouteConstants.sectionNameId[RouteConstants.speakingSectionName]!,
              "currentDay"
            ]),
            newValue: currentDay);
        await _firestoreService.updateQuestionUsingFieldPath(
            docPath: userDocRef,
            fieldPath: FieldPath([
              'assignedQuestions',
              RouteConstants.sectionNameId[RouteConstants.speakingSectionName]!,
              "lastStoppedQuestionIndex"
            ]),
            newValue: 0);
        await _firestoreService.updateQuestionUsingFieldPath(
            docPath: userDocRef,
            fieldPath: FieldPath([
              'assignedQuestions',
              RouteConstants.sectionNameId[RouteConstants.speakingSectionName]!,
              "progress"
            ]),
            newValue: 0);
      }
      ;
    } catch (e) {
      // this causes speaking section error
      error = CustomException("An undefined error ocurred ${e.toString()}");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool getCurrentUserSubmission(Worksheet worksheet) {
    final userSubmission = worksheet.students?.entries.firstWhere(
        (studentEntry) => studentEntry.key == _currentUserId,
        orElse: () => MapEntry('null', WorksheetStudent()));

    if (userSubmission != null && userSubmission.key != "null") {
      _uploadedWorksheet = userSubmission.value;
      return true;
    } else {
      return false;
    }
  }

  Future<Worksheet> uploadStudentSubmission(
      {required String imagePath, required Worksheet worksheet}) async {
    isLoading = true;
    notifyListeners();
    try {
      String studentImagePath = await uploadImageAndGetUrl(
        imagePath,
        'worksheet_solution_${DateTime.now().millisecondsSinceEpoch}',
      );
      // Split the path by '/' to get its components
      List<String> pathSegments = worksheet.path!.split('/');

      // Check for 'questions' keyword and extract the next segment as worksheet ID
      String? worksheetID;
      int questionIndex = pathSegments.indexOf('questions');

      if (questionIndex != -1 && questionIndex + 1 < pathSegments.length) {
        worksheetID = pathSegments[questionIndex + 1]; // This would get '1'
      }

      WorksheetStudent studentSubmission =
          await firestoreService.addStudentSubmission(
              level: levelName!,
              section: RouteConstants.worksheetSectionName,
              studentImagePath: studentImagePath,
              workSheetID: worksheetID!,
              tempUnitNumber: _tempUnitNumber);

      worksheet.students ??= {};
      worksheet.students![_currentUserId] = studentSubmission;
      print("Student data associated with the last worksheet successfully.");
    } catch (e) {
      print("Error uploading worksheet solution: $e");
    } finally {
      isLoading = false;
      notifyListeners();
      return worksheet;
    }
  }

  Future<String> uploadImageAndGetUrl(
      String imagePath, String imageName) async {
    try {
      File imageFile = File(imagePath);
      Uint8List imageData = await imageFile.readAsBytes();

      UploadTask uploadTask = FirebaseStorage.instance
          .ref('worksheets/school_student_solutions/$imageName')
          .putData(imageData);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
    } finally {}
    return '';
  }

  void reset() {
    _questions.clear();
    currentIndex = 0;
    levelName = null;
    sectionName = null;
    progress = 0.0;
    isInitialized = false;
    isLoading = false;
    error = null;
    notifyListeners();
  }
}
