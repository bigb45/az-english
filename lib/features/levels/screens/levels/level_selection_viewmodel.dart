import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

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
import 'package:firebase_storage/firebase_storage.dart';

class LevelSelectionViewmodel extends BaseViewModel {
  int _selectedLevelId = 0;
  late AuthViewModel _authProvider;
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  List<Level> _levels = [];

  bool _isSpeakingAssigned = false;
  int _userCurrentDay = 1;
  bool _isWorksheetUploaded = false;
  String? _lastWorksheetPath;

  int get selectedLevel => _selectedLevelId;
  List<Level> get levels => _levels;
  bool get isSpeakingAssigned => _isSpeakingAssigned;
  bool get isWorksheetUploaded => _isWorksheetUploaded;
  String? get lastWorksheetPath => _lastWorksheetPath;
  int get userCurrentDay => _userCurrentDay;

  void update(AuthViewModel authViewModel) async {
    _authProvider = authViewModel;
    if (_authProvider.isSignedIn) {
      await fetchLevels();
      await fetchUserData(_authProvider.user!.uid);
      await checkIfWorksheetUploaded();
    }
  }

  void setLastWorksheetImageUrl(String imageUrl) {
    _lastWorksheetPath = imageUrl;
  }

  Future<void> checkIfWorksheetUploaded() async {
    try {
      User? user = _firebaseAuthService.getUser();
      if (user == null) {
        throw Exception("User not logged in");
      }

      QuerySnapshot querySnapshot = await firestoreService.getLastWorksheet();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot lastWorksheetDoc = querySnapshot.docs.first;

        Map<String, dynamic>? studentsMap =
            lastWorksheetDoc['students'] as Map<String, dynamic>?;

        if (studentsMap != null && studentsMap.containsKey(user.uid)) {
          _isWorksheetUploaded = true;
          String imageUrl = lastWorksheetDoc['imageUrl'];
          setLastWorksheetImageUrl(imageUrl);
        } else {
          _isWorksheetUploaded = false;
        }
      } else {
        _isWorksheetUploaded = false;
        print("No worksheets found in the collection.");
      }
    } catch (e) {
      print("Error checking worksheet upload: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> uploadWorksheetImage({
    required String imagePath,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      User? user = _firebaseAuthService.getUser();
      UserModel? userModel = await firestoreService.getUser(user!.uid);

      // Upload the student's image and get the URL
      String studentImagePath = await uploadImageAndGetUrl(
        imagePath,
        'worksheet_solution_${DateTime.now().millisecondsSinceEpoch}',
      );
      QuerySnapshot querySnapshot = await firestoreService.getLastWorksheet();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the last worksheet document
        DocumentSnapshot lastWorksheetDoc = querySnapshot.docs.first;
        // Update the worksheet with the student's info
        await firestoreService.updateWorksheetWithStudent(
          worksheetDoc: lastWorksheetDoc.reference,
          studentName: userModel!.studentName!,
          studentImagePath: studentImagePath,
          userId: userModel.id!,
        );
        Map<String, dynamic>? studentsMap =
            lastWorksheetDoc['students'] as Map<String, dynamic>?;
        String imageUrl = lastWorksheetDoc['imageUrl'];
        _isWorksheetUploaded = true;
        setLastWorksheetImageUrl(imageUrl);
        print("Student data associated with the last worksheet successfully.");
      } else {
        print("No worksheets found in the collection.");
      }
    } catch (e) {
      print("Error uploading worksheet solution: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String> uploadImageAndGetUrl(
      String imagePath, String imageName) async {
    try {
      File imageFile = File(imagePath);
      Uint8List imageData = await imageFile.readAsBytes();

      UploadTask uploadTask = FirebaseStorage.instance
          .ref('worksheets/student_solutions/$imageName')
          .putData(imageData);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
    } finally {}
    return '';
  }

  Future<void> fetchUserData(String userId) async {
    UserModel? userModel = await firestoreService.getUser(userId);
    _isSpeakingAssigned = userModel!.isSpeakingAssigned!;
  }

  Future<void> fetchLevels() async {
    if (_levels.isNotEmpty) {
      return;
    }
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

  Future<void> fetchSections(Level level, {int? desiredDay}) async {
    isLoading = true;
    notifyListeners();
    try {
      error = null;
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
      rethrow;
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
