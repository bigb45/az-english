import 'dart:async';

import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/base_viewmodel.dart';
import 'package:ez_english/features/models/fetch_assigned_section_question_result.dart';
import 'package:ez_english/utils/utils.dart';

class QuestionAssignmentViewmodel extends BaseViewModel {
  late String userId;

  List<BaseQuestion> _questions = [];
  final List<BaseQuestion> _assignedQuestions = [];
  List<BaseQuestion> _filteredQuestions = [];
  final List<BaseQuestion> _selectedQuestions = [];
  QuestionType? _selectedQuestionType;
  String? _selectedSection;
  String? _query;

  List<BaseQuestion> get questions => _questions;
  List<BaseQuestion> get assignedQuestions => _assignedQuestions;
  List<BaseQuestion> get filteredQuestions => _filteredQuestions;
  List<BaseQuestion> get selectedQuestions => _selectedQuestions;
  QuestionType? get selectedQuestionType => _selectedQuestionType;
  String? get selectedSection => _selectedSection;
  String? get query => _query;

  final FirestoreService _firestoreService = FirestoreService();

  void setValuesAndInit({required String userId}) {
    this.userId = userId;
    _fetchQuestions();
    _fetchAssignedQuestions();
    _filteredQuestions = _questions;
  }

  @override
  FutureOr<void> init() {}

  void _filterQuestions() {
    printDebug(
        "filtering by $_query, $_selectedQuestionType, $selectedSection");

    _filteredQuestions = _questions.where((question) {
      print("section: $selectedSection");
      return (((question.titleInEnglish
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
                  false)) &&
          (question.questionType == selectedQuestionType) &&
          (selectedSection == "writing"));
    }).toList();

    notifyListeners();
  }

  void updateAndFilter({
    String? query,
    QuestionType? selectedQuestionType,
    String? selectedSection,
  }) {
    _query = query ?? _query;
    _selectedQuestionType = selectedQuestionType ?? _selectedQuestionType;
    _selectedSection = selectedSection ?? _selectedSection;
    // _fetchQuestions();
    _filterQuestions();
    notifyListeners();
  }

  set query(String? value) => updateAndFilter(query: value);

  set selectedQuestionType(QuestionType? value) =>
      updateAndFilter(selectedQuestionType: value);

  set selectedSection(String? value) => updateAndFilter(selectedSection: value);

  Future<void> _fetchQuestions() async {
    isLoading = true;
    try {
      // TODO: change section to speaking
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
    // _assignedQuestions = _questions.sublist(0, 20);
    isLoading = true;
    try {
      SectionFetchResult fetchResult =
          await _firestoreService.fetchAssignedQuestions(
              userId: userId, sectionName: RouteConstants.speakingSectionName);

      _questions = fetchResult.questions.values.cast<BaseQuestion>().toList();
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
    // TODO: implement method to assign questions and update them
    printDebug("assigning quesiont ${question.titleInEnglish}");
  }

  Future<void> removeQuestion(BaseQuestion question) async {
    // TODO: implement method to remove assigned questions
    printDebug("removing question ${question.titleInEnglish}");
  }
}
