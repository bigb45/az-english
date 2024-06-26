import 'dart:async';

import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/sections/components/evaluation_section.dart';
import 'package:flutter/material.dart';

abstract class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  CustomException? _error;
  bool _isDisposed = false;
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
  CustomException? get error => _error;
  int get currentIndex => _currentIndex;
  EvaluationState get answerState => _answerState;

  @protected
  set currentIndex(int newValue) {
    _currentIndex = newValue;
    notifyListeners();
  }

  @protected
  set isLoading(bool value) {
    _isLoading = value;
    scheduleMicrotask(() {
      if (!_isDisposed) notifyListeners();
    });
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
