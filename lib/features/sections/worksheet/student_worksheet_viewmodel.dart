import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/firebase/constants.dart';
import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/core/firebase/firebase_authentication_service.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/base_viewmodel.dart';
import 'package:ez_english/features/models/unit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StudentWorksheetViewModel extends BaseViewModel {
  String? levelId;

  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  Map<String, BaseQuestion> _worksheets = {};
  Map<String, BaseQuestion> get worksheets => _worksheets;
  bool _isWorksheetUploaded = false;
  String? _lastWorksheetPath;

  bool get isWorksheetUploaded => _isWorksheetUploaded;
  String? get lastWorksheetPath => _lastWorksheetPath;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setValuesAndInit() async {
    levelName = RouteConstants.getLevelName(levelId!);
    await fetchWorksheets();
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

  Future<void> uploadStudentSubmission(
      {required String imagePath, required String worksheetID}) async {
    _isLoading = true;
    notifyListeners();
    try {
      String studentImagePath = await uploadImageAndGetUrl(
        imagePath,
        'worksheet_solution_${DateTime.now().millisecondsSinceEpoch}',
      );
      await firestoreService.addStudentSubmission(
        level: levelName!,
        section: FirestoreConstants.worksheetsCollection,
        studentImagePath: studentImagePath,
        workSheetID: worksheetID,
      );
      _isWorksheetUploaded = true;
      print("Student data associated with the last worksheet successfully.");
    } catch (e) {
      print("Error uploading worksheet solution: $e");
    } finally {
      _isLoading = false;
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

  // region fetchWorhsheets
  Future<void> fetchWorksheets() async {
    isLoading = true;
    notifyListeners();
    try {
      Unit worksheet = await firestoreService.fetchUnit(
        RouteConstants.sectionNameId[RouteConstants.worksheetSectionName]!,
        levelName!,
      );

      // _worksheets = worksheet.questions.cast<String, BaseQuestion>();
      _worksheets = worksheet.questions.map((key, value) {
        return MapEntry(key.toString(), value!);
      });

      progress = worksheet.progress;

      error = null;
    } on CustomException catch (e) {
      error = e;
    } catch (e) {
      error = CustomException("An undefined error occurred $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  FutureOr<void> init() {}

  // endregion fetchWorhsheets
}
