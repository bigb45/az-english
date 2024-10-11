import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/firebase/constants.dart';
import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/base_viewmodel.dart';
import 'package:ez_english/features/models/fetch_assigned_section_question_result.dart';
import 'package:ez_english/features/models/unit.dart';
import 'package:ez_english/features/sections/models/passage_question_model.dart';
import 'package:ez_english/utils/utils.dart';

class QuestionAssignmentViewmodel extends BaseViewModel {
  late String userId;
  bool _isQuestionLoading = false;
  bool get isQuestionLoading => _isQuestionLoading;
  final List<int> _loadingIndices = [];
  List<String> _levels = [];
  List<int> get loadingIndices => _loadingIndices;

  final List<BaseQuestion> _questions = [];
  List<BaseQuestion> _assignedQuestions = [];
  List<BaseQuestion> _filteredQuestions = [];
  final List<BaseQuestion> _selectedQuestions = [];
  QuestionType? _selectedQuestionType;
  SectionName? _selectedSection;
  String? _query;

  List<BaseQuestion> get questions => _questions;
  List<BaseQuestion> get assignedQuestions => _assignedQuestions;
  List<BaseQuestion> get filteredQuestions => _filteredQuestions;
  List<BaseQuestion> get selectedQuestions => _selectedQuestions;
  QuestionType? get selectedQuestionType => _selectedQuestionType;
  SectionName? get selectedSection => _selectedSection;
  String? get query => _query;

  final FirestoreService _firestoreService = FirestoreService();

  void setValuesAndInit({required String userId}) async {
    isLoading = true;
    this.userId = userId;
    await _fetchLevelNames();
    await _fetchQuestions();
    await _fetchAssignedQuestions();
    _filteredQuestions = _questions;
    notifyListeners();
  }

  @override
  FutureOr<void> init() {}

  void _filterQuestions() {
    printDebug(
        "filtering by $_query, $_selectedQuestionType, $selectedSection");

    _filteredQuestions = _questions.where((question) {
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
          (question.questionType ==
              (_selectedQuestionType ?? question.questionType)) &&
          (question.sectionName == (_selectedSection ?? question.sectionName)));
    }).toList();

    notifyListeners();
  }

  void clearFilters() {
    _query = null;
    _selectedQuestionType = null;
    _selectedSection = null;
    updateAndFilter(); // Trigger filtering with cleared filters
  }

  void updateAndFilter({
    String? query,
    QuestionType? selectedQuestionType,
    SectionName? selectedSection,
    LevelName? selectedLevel,
  }) async {
    _query = query ?? _query;
    _selectedQuestionType = selectedQuestionType ?? _selectedQuestionType;
    _selectedSection = selectedSection ?? _selectedSection;
    _filterQuestions();
    notifyListeners();
  }

  Future<List<Unit?>?> fetchDays(
      {required String level, required String section, d}) async {
    try {
      return await _firestoreService.getDays(
        level,
        section,
      );
    } catch (e) {
      printDebug('Error fetching questions: $e');
      notifyListeners();
    }
    return null;
  }

  Future<void> _fetchQuestions() async {
    isLoading = true;
    try {
      List<BaseQuestion> embeddedPassageQuestions = [];

      for (var section in SectionName.values) {
        String sectionName = section.toShortString();
        if (sectionName == "other") {
          continue;
        }
        for (var level in _levels) {
          List<Unit?>? units =
              await fetchDays(level: level, section: sectionName);
          for (var unit in units!) {
            var sectionQuestions = await _firestoreService.fetchQuestions(
                level: level,
                section: sectionName,
                day: unit!.name.substring(unit.name.length - 1));
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
                      sectionName:
                          SectionNameExtension.fromString(sectionName));
                  embeddedQuestion.path =
                      "$parentQuestionPath/embeddedQuestions/${embeddedEntry.key}";
                  embeddedPassageQuestions.add(embeddedQuestion);
                }
                sectionQuestions = embeddedPassageQuestions;
              }
            }

            _questions.addAll(sectionQuestions);
            sectionQuestions = [];
            embeddedPassageQuestions = [];
          }
        }
      }

      error = null;
    } on CustomException catch (e) {
      error = e;
      printDebug(error!.message);
    } catch (e) {
      error = CustomException(e.toString());
    } finally {
      isLoading = false;
      printDebug("questions: ${_questions.length}");
      notifyListeners();
    }
  }

  Future<void> _fetchLevelNames() async {
    _levels = (await firestoreService.getLevels())
        .map((level) => level?.name ?? "")
        .toList();
    notifyListeners();
    printDebug("levels: $_levels");
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

  void reset() {
    _query = null;
    _selectedQuestionType = null;
    _selectedSection = null;
    _questions.clear();
    _assignedQuestions.clear();
    _filteredQuestions.clear();
    _selectedQuestions.clear();
    _loadingIndices.clear();
    _isQuestionLoading = false;
    _filterQuestions();
  }

  Future<void> assignQuestion(BaseQuestion question, int index) async {
    _loadingIndices.add(index);
    _isQuestionLoading = true;
    notifyListeners();
    String? questionIndex = await _firestoreService.assignQuestion(
        questionMap: question.toMap(),
        sectionName: RouteConstants.speakingSectionName,
        userId: userId);
    question.path = "${FirestoreConstants.usersCollections}/$userId/"
        "assignedQuestions/"
        "${RouteConstants.getSectionIds(RouteConstants.speakingSectionName)}/"
        "${FirestoreConstants.questionsField}/$questionIndex";
    _assignedQuestions.add(question);
    _isQuestionLoading = false;
    _loadingIndices.remove(index);

    notifyListeners();
  }

  Future<void> removeQuestion(BaseQuestion question, int index) async {
    _isQuestionLoading = true;
    _loadingIndices.add(index);
// ⚠️ زنا ⚠️
    notifyListeners();
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
    _assignedQuestions.remove(question);
    _isQuestionLoading = false;
    _loadingIndices.remove(index);
    notifyListeners();
  }
}
