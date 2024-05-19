import 'dart:async';

import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/features/models/base_viewmodel.dart';
import 'package:ez_english/features/auth/view_model/auth_view_model.dart';
import 'package:ez_english/features/models/level.dart';
import 'package:ez_english/router.dart';
import 'package:ez_english/utils/utils.dart';

class LevelSelectionViewmodel extends BaseViewModel {
  int _selectedLevelId = 0;
  late AuthViewModel _authProvider;

  List<Level> _levels = [];

  int get selectedLevel => _selectedLevelId;
  List<Level> get levels => _levels;

  void update(AuthViewModel authViewModel) {
    _authProvider = authViewModel;
    if (_authProvider.isSignedIn) {
      // TODO ask about getting the levels only when the auth state changes
      fetchLevels();
    }
  }

  Future<void> fetchLevels() async {
    isLoading = true;
    List<String>? assignedLevels = _authProvider.userDate!.assignedLevels;
    notifyListeners();
    try {
      error = null;
      _levels = await firestoreService.fetchLevels();
      for (var level in _levels) {
        level.isAssigned = assignedLevels!.contains(level.name);
      }
    } on CustomException catch (e) {
      // error = e as CustomException;
      _handleError(e.message);
      notifyListeners();
    } catch (e) {
      _handleError("An undefined error occurred");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedLevel(int level) {
    _selectedLevelId = level;
    notifyListeners();
  }

  @override
  FutureOr<void> init() {
    // TODO: implement init
    throw UnimplementedError();
  }

  void _handleError(String e) {
    Utils.showSnackBar(e);
    // errorOccurred = true;
    // navigatorKey.currentState!.pop();
  }
}
