import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/auth/view_model/auth_view_model.dart';
import 'package:ez_english/features/models/level.dart';
import 'package:flutter/material.dart';

class LevelSelectionViewmodel extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  late AuthViewModel _authProvider;

  List<Level> _levels = [];

  bool _isLoading = false;

  int _selectedLevelId = 0;

  int get selectedLevel => _selectedLevelId;
  List<Level> get levels => _levels;
  bool get isLoding => _isLoading;

  void update(AuthViewModel authViewModel) {
    _authProvider = authViewModel;
    if (_authProvider.isSignedIn) {
      fetchLevels();
    }
  }

  Future<void> fetchLevels() async {
    print("stop");
    List<String>? assignedLevels = _authProvider.userDate!.assignedLevels;
    _isLoading = true;
    notifyListeners();
    try {
      _levels = await _firestoreService.fetchLevels();
      for (var level in _levels) {
        level.isAssigned = assignedLevels!.contains(level.name);
      }
    } catch (e) {
      print(e);
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
