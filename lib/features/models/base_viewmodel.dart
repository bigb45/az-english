import 'dart:async';

import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/sections/components/evaluation_section.dart';
import 'package:flutter/material.dart';

abstract class BaseViewModel extends ChangeNotifier {
  bool _isSkipVisible = false;
  int _wrongAnswerCount = 0;
  bool _isLoading = false;
  CustomException? _error;
  bool _isDisposed = false;
  String? _levelName;
  String? _sectionName;
  double? _progress;
  final FirestoreService _firestoreService = FirestoreService();

  String? get sectionName => _sectionName;

  set sectionName(String? value) {
    _sectionName = value;
    notifyListeners();
  }

  String? get levelName => _levelName;

  set levelName(String? value) {
    _levelName = value;
    notifyListeners();
  }

  double? get progress => _progress;

  set progress(double? value) {
    _progress = value;
    notifyListeners();
  }

  bool _isInitializeDone = false;
  int _currentIndex = 0;
  EvaluationState _answerState = EvaluationState.empty;

  final FirestoreService firestoreService = FirestoreService();

  FutureOr<void> _initState;

  BaseViewModel() {
    _init();
  }

  FutureOr<void> init();

  void _init() async {
    isLoading = true;
    _initState = init();
    await _initState;
    _isInitializeDone = true;
    isLoading = false;
  }

  void changeStatus() => isLoading = !isLoading;

  void reloadState() {
    if (!isLoading) notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  FutureOr<void> get initState => _initState;

  bool get isLoading => _isLoading;
  bool get isDisposed => _isDisposed;
  bool get isInitialized => _isInitializeDone;
  bool get isSkipVisible => _isSkipVisible;
  int get wrongAnswerCount => _wrongAnswerCount;
  CustomException? get error => _error;
  int get currentIndex => _currentIndex;
  EvaluationState get answerState => _answerState;
  set isInitialized(bool value) {
    _isInitializeDone = value;
    notifyListeners();
  }

  @protected
  set isSkipVisible(bool value) {
    _isSkipVisible = value;
    notifyListeners();
  }

  @protected
  set wrongAnswerCount(int value) {
    _wrongAnswerCount = value;
    if (_wrongAnswerCount >= Constants.wrongAnswerSkipLimit) {
      isSkipVisible = true;
    }
    notifyListeners();
  }

  @protected
  set currentIndex(int newValue) {
    _currentIndex = newValue;
    // Reset the wrong answer count and skip button visibility
    wrongAnswerCount = 0;
    isSkipVisible = false;
    notifyListeners();
  }

  @protected
  set isLoading(bool value) {
    _isLoading = value;
    scheduleMicrotask(() {
      if (!_isDisposed) notifyListeners();
    });
  }

  Future<void> updateUserProgress() async {
    isLoading = true;
    notifyListeners();
    try {
      await _firestoreService.updateUserProgress(levelName!, sectionName!);
    } catch (e) {
      error = CustomException("An undefined error ocurred ${e.toString()}");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateSectionProgress() async {
    _firestoreService.updateCurrentSectionQuestionIndex(
        currentIndex, levelName!, sectionName!);
  }

  @protected
  set error(CustomException? value) {
    _error = value;
    scheduleMicrotask(() {
      if (!_isDisposed) notifyListeners();
    });
  }

  void resetError() {
    _error = null;
    notifyListeners();
  }

  @protected
  set answerState(EvaluationState value) {
    _answerState = value;
    notifyListeners();
  }
}
