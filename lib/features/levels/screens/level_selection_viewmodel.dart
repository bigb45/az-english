import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/firebase/constants.dart';
import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/auth/view_model/auth_view_model.dart';
import 'package:ez_english/features/models/base_viewmodel.dart';
import 'package:ez_english/features/models/level.dart';
import 'package:ez_english/features/models/section.dart';
import 'package:ez_english/utils/utils.dart';

class LevelSelectionViewmodel extends BaseViewModel {
  int _selectedLevelId = 0;
  late AuthViewModel _authProvider;
  final FirestoreService _firestoreService = FirestoreService();
  List<Level> _levels = [];

  int get selectedLevel => _selectedLevelId;
  List<Level> get levels => _levels;

  void update(AuthViewModel authViewModel) {
    _authProvider = authViewModel;
    if (_authProvider.isSignedIn) {
      fetchLevels();
    }
  }

  Future<void> fetchLevels() async {
    isLoading = true;
    notifyListeners();
    try {
      if (_authProvider.userData == null) return;
      List<String>? assignedLevels = _authProvider.userData!.assignedLevels;
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
      _handleError("An undefined error occurred ${e.toString()}");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedLevel(int level) {
    _selectedLevelId = level;
    notifyListeners();
  }

  Future<void> updateSectionStatus(Section section, String levelName) async {
    isLoading = true;
    notifyListeners();
    try {
      section.attempted = true;
      DocumentReference sectionDocRef = FirebaseFirestore.instance
          .collection(FirestoreConstants.levelsCollection)
          .doc(levelName)
          .collection(FirestoreConstants.sectionsCollection)
          .doc(RouteConstants.getSectionIds(section.name));
      await _firestoreService.updateDocuments(
          docPath: sectionDocRef, newValues: {"attempted": section.attempted});

      // Update the specific field

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

  @override
  FutureOr<void> init() {}

  void _handleError(String e) {
    Utils.showSnackBar(e);
    // errorOccurred = true;
    // navigatorKey.currentState!.pop();
  }
}
