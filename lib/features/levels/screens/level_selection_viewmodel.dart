import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/models/level.dart';
import 'package:flutter/material.dart';

class LevelSelectionViewmodel extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<Level> _levels = [];
  bool _isLoading = false;
  int _selectedLevelId = 0;
  CustomException? _error;

  int get selectedLevel => _selectedLevelId;
  List<Level> get levels => _levels;
  bool get isLoding => _isLoading;
  CustomException? get error => _error;

  LevelSelectionViewmodel() {
    init();
  }

  void init() {
    fetchLevels();
    notifyListeners();
  }

  Future<void> fetchLevels() async {
    print("fetching levels");
    _isLoading = true;
    notifyListeners();
    try {
      _error = null;
      _levels = await _firestoreService.fetchLevels();
    } catch (e) {
      _error = e as CustomException;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedLevel(int level) {
    _selectedLevelId = level;
    notifyListeners();
  }
}
