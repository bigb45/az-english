import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/firebase/constants.dart';
import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/core/firebase/firebase_authentication_service.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/base_viewmodel.dart';
import 'package:ez_english/features/models/fetch_assigned_section_question_result.dart';
import 'package:ez_english/utils/utils.dart';

class QuestionAssignmentViewmodel extends BaseViewModel {
  late String userId;
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  List<BaseQuestion> _questions = [];
  List<BaseQuestion> _assignedQuestions = [];
  List<BaseQuestion> _filteredQuestions = [];
  List<BaseQuestion> _selectedQuestions = [];

  String? _selectedQuestionType = null;
  String? _selectedSection = null;
  String? _query = null;

  List<BaseQuestion> get questions => _questions;
  List<BaseQuestion> get assignedQuestions => _assignedQuestions;
  List<BaseQuestion> get filteredQuestions => _filteredQuestions;
  List<BaseQuestion> get selectedQuestions => _selectedQuestions;
  String? get selectedQuestionType => _selectedQuestionType;
  String? get selectedSection => _selectedSection;
  String? get query => _query;

  FirestoreService _firestoreService = FirestoreService();

  void setValuesAndInit({required String userId}) async {
    this.userId = userId;
    printDebug("got user id $userId");
    await _fetchQuestions();
    await _fetchAssignedQuestions();
    _filteredQuestions = _questions;
  }

  @override
  FutureOr<void> init() {}
  // TODO: add filter methods

  void _filterQuestions() {
    printDebug("filtering by $_query, $selectedQuestionType, $selectedSection");
    _filteredQuestions = _questions.where((question) {
      return ((question.titleInEnglish
                  ?.toLowerCase()
                  .trim()
                  .contains((_query ?? "").toLowerCase().trim()) ??
              false) ||
          (question.questionTextInEnglish
                  ?.toLowerCase()
                  .trim()
                  .contains((_query ?? "").toLowerCase().trim()) ??
              false) ||
          (question.questionTextInArabic
                  ?.toLowerCase()
                  .trim()
                  .contains((_query ?? "").toLowerCase().trim()) ??
              false));
    }).toList();

    notifyListeners();
  }

  void updateAndFilter({
    String? query,
    String? selectedQuestionType,
    String? selectedSection,
  }) async {
    _query = query ?? _query;
    _selectedQuestionType = selectedQuestionType ?? _selectedQuestionType;
    _selectedSection = selectedSection ?? _selectedSection;
    await _fetchQuestions();
    notifyListeners();
  }

  set query(String? value) => updateAndFilter(query: value);
  set selectedQuestionType(String? value) =>
      updateAndFilter(selectedQuestionType: value);
  set selectedSection(String? value) => updateAndFilter(selectedSection: value);

  Future<void> _fetchQuestions() async {
    isLoading = true;
    try {
      _questions = await _firestoreService.fetchQuestions(
          level: "A1", section: "writing", day: "1");
      error = null;
    } on CustomException catch (e) {
      error = e;
      printDebug(error!.message);
    } catch (e) {
      error = CustomException(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchAssignedQuestions() async {
    isLoading = true;
    try {
      SectionFetchResult fetchResult =
          await _firestoreService.fetchAssignedQuestions(
              userId: userId, sectionName: RouteConstants.speakingSectionName);

      _assignedQuestions =
          fetchResult.questions.values.cast<BaseQuestion>().toList();
      error = null;
    } on CustomException catch (e) {
      error = e;
      printDebug(error!.message);
    } catch (e) {
      error = CustomException(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // TODO: add dispose method
  void reset() {
    _query = null;
    _selectedQuestionType = null;
    _selectedSection = null;
    _filterQuestions();
  }

  Future<void> assignQuestion(BaseQuestion question) async {
    String? questionIndex = await _firestoreService.assignQuestion(
        questionMap: question.toMap(),
        sectionName: RouteConstants.speakingSectionName,
        userId: userId);
    question.path = "${FirestoreConstants.usersCollections}/${userId}/"
        "assignedQuestions/"
        "${RouteConstants.getSectionIds(RouteConstants.speakingSectionName)}/"
        "${FirestoreConstants.questionsField}/$questionIndex";
    _assignedQuestions.add(question);
    notifyListeners();
    printDebug("assigning quesiont ${question.titleInEnglish}");
  }

  Future<void> removeQuestion(BaseQuestion question, int index) async {
    printDebug("removing question ${question.titleInEnglish}");
    List<String> pathSegments = question.path!.split('/');
    String docPath = pathSegments.sublist(0, pathSegments.length - 4).join('/');
    String sectionName = pathSegments[pathSegments.length - 3];
    String questionField = pathSegments[pathSegments.length - 2];
    String fieldIndex = pathSegments[pathSegments.length - 1]; //
    String fieldPath =
        "assignedQuestions.$sectionName.$questionField.$fieldIndex";
    DocumentReference docRef = FirebaseFirestore.instance.doc(docPath);
    await _firestoreService.deleteQuestionUsingFieldPath(
        docRef: docRef, questionFieldPath: fieldPath, deletionRef: true);
    questions.removeAt(index);
    notifyListeners();
  }
}
