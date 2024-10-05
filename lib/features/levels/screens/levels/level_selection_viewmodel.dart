import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/firebase/constants.dart';
import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/core/firebase/firebase_authentication_service.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/auth/view_model/auth_view_model.dart';
import 'package:ez_english/features/models/level.dart';
import 'package:ez_english/features/models/section.dart';
import 'package:ez_english/features/models/user.dart';
import 'package:ez_english/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LevelSelectionViewmodel extends ChangeNotifier {
  int _selectedLevelId = 0;
  late AuthViewModel _authProvider;
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  List<Level> _levels = [];
  final FirestoreService firestoreService = FirestoreService();
  bool _isSpeakingAssigned = false;
  int _userCurrentDay = 1;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  int get selectedLevel => _selectedLevelId;
  List<Level> get levels => _levels;
  bool get isSpeakingAssigned => _isSpeakingAssigned;
  int get userCurrentDay => _userCurrentDay;
  CustomException? _error;
  CustomException? get error => _error;

  void update(AuthViewModel authViewModel) async {
    _authProvider = authViewModel;
    if (_authProvider.isSignedIn) {
      _isLoading = true;
      notifyListeners();
      await fetchLevels();
      await fetchUserData(_authProvider.user!.uid);
      _isLoading = false;
      notifyListeners();
    }
  }

  // Future<String> uploadImageAndGetUrl(
  //     String imagePath, String imageName) async {
  //   try {
  //     File imageFile = File(imagePath);
  //     Uint8List imageData = await imageFile.readAsBytes();

  //     UploadTask uploadTask = FirebaseStorage.instance
  //         .ref('worksheets/student_solutions/$imageName')
  //         .putData(imageData);
  //     TaskSnapshot snapshot = await uploadTask;
  //     String downloadUrl = await snapshot.ref.getDownloadURL();
  //     return downloadUrl;
  //   } catch (e) {
  //     print("Error uploading image: $e");
  //   } finally {}
  //   return '';
  // }

  Future<void> fetchUserData(String userId) async {
    UserModel? userModel = await firestoreService.getUser(userId);
    _isSpeakingAssigned = userModel!.isSpeakingAssigned!;
  }

  Future<void> fetchLevels() async {
    if (_levels.isNotEmpty) {
      return;
    }
    try {
      User? user = _firebaseAuthService.getUser();

      if (_authProvider.userData == null) return;
      List<String>? assignedLevels = _authProvider.userData!.assignedLevels;
      _error = null;
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
    }
  }

  Future<void> fetchSections(Level level, {int? desiredDay}) async {
    _isLoading = true;
    notifyListeners();
    try {
      _error = null;
      _levels[level.id].sections = await firestoreService
          .fetchSection(level.name, desiredDay: desiredDay);
      _userCurrentDay = int.tryParse(firestoreService.currentDayString!)!;
    } on CustomException catch (e) {
      // error = e as CustomException;
      _handleError(e.message);
      notifyListeners();
    } catch (e) {
      _handleError("An undefined error occurred ${e.toString()}");
    } finally {
      _isLoading = false;
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
    _isLoading = true;
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
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _handleError(String e) {
    Utils.showErrorSnackBar(e);
    // errorOccurred = true;
    // navigatorKey.currentState!.pop();
  }
}
