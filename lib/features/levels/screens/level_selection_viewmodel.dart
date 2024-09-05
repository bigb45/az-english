import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/firebase/constants.dart';
import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/core/firebase/firebase_authentication_service.dart';
import 'package:ez_english/features/auth/view_model/auth_view_model.dart';
import 'package:ez_english/features/models/base_viewmodel.dart';
import 'package:ez_english/features/models/level.dart';
import 'package:ez_english/features/models/section.dart';
import 'package:ez_english/features/models/user.dart';
import 'package:ez_english/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LevelSelectionViewmodel extends BaseViewModel {
  int _selectedLevelId = 0;
  late AuthViewModel _authProvider;
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  List<Level> _levels = [];
  bool _isSpeakingAssigned = false;

  int get selectedLevel => _selectedLevelId;
  List<Level> get levels => _levels;
  bool get isSpeakingAssigned => _isSpeakingAssigned;

  void update(AuthViewModel authViewModel) async {
    _authProvider = authViewModel;
    if (_authProvider.isSignedIn) {
      await fetchLevels();
      await fetchUserData(_authProvider.user!.uid);
    }
  }

  Future<void> uploadWorksheetImage({required String imagePath}) async {
    final selectedImage = File(imagePath);
    print("uploading image at path: $imagePath");
  }

  Future<void> fetchUserData(String userId) async {
    UserModel? userModel = await firestoreService.getUser(userId);
    _isSpeakingAssigned = userModel!.isSpeakingAssigned!;
  }

  Future<void> fetchLevels() async {
    isLoading = true;
    notifyListeners();
    try {
      User? user = _firebaseAuthService.getUser();

      if (_authProvider.userData == null) return;
      List<String>? assignedLevels = _authProvider.userData!.assignedLevels;
      error = null;
      _levels = await firestoreService.fetchLevels(user!);
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

  Future<void> fetchSections(Level level) async {
    isLoading = true;
    notifyListeners();
    try {
      error = null;
      _levels[level.id].sections =
          await firestoreService.fetchSection(level.name);
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

  void reset() {
    _selectedLevelId = 0;
    _levels = [];
    notifyListeners();
  }

  Future<void> updateSectionStatus(Section section, String levelName) async {
    isLoading = true;
    notifyListeners();
    try {
      section.isAttempted = true;
      User? user = _firebaseAuthService.getUser();
      DocumentReference userDocRef = FirebaseFirestore.instance
          .collection(FirestoreConstants.usersCollections)
          .doc(user?.uid);

      // Update the section status in the user's document
      String sectionId = RouteConstants.getSectionIds(section.name);
      await userDocRef.update({
        'levelsProgress.$levelName.sectionProgress.$sectionId.isAttempted':
            true,
      });

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      throw e;
    }
  }

  @override
  FutureOr<void> init() {}

  void _handleError(String e) {
    Utils.showErrorSnackBar(e);
    // errorOccurred = true;
    // navigatorKey.currentState!.pop();
  }
}
