import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/core/firebase/firebase_authentication_service.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/base_viewmodel.dart';
import 'package:ez_english/features/models/unit.dart';
import 'package:ez_english/features/models/worksheet.dart';
import 'package:ez_english/features/models/worksheet_student.dart';
import 'package:ez_english/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StudentWorksheetViewModel extends BaseViewModel {
  String? levelId;

  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  WorksheetStudent? _uploadedWorksheet;
  WorksheetStudent? get uploadedWorksheet => _uploadedWorksheet;

  Worksheet? _worksheetAnswer;
  Worksheet? get worksheetAnswer => _worksheetAnswer;

  final String _currentUserId = FirebaseAuth.instance.currentUser!.uid;
  Map<String, BaseQuestion> _worksheets = {};
  Map<String, BaseQuestion> get worksheets => _worksheets;

  Future<void> setValuesAndInit() async {
    levelName = RouteConstants.getLevelName(levelId!);
    await fetchWorksheets();
  }

  Future<void> uploadStudentSubmission(
      {required String imagePath, required String worksheetID}) async {
    isLoading = true;
    notifyListeners();
    try {
      String studentImagePath = await uploadImageAndGetUrl(
        imagePath,
        'worksheet_solution_${DateTime.now().millisecondsSinceEpoch}',
      );

      WorksheetStudent studentSubmission =
          await firestoreService.addStudentSubmission(
        level: levelName!,
        section: RouteConstants.worksheetSectionName,
        studentImagePath: studentImagePath,
        workSheetID: worksheetID,
      );
      if (_worksheets.containsKey(worksheetID)) {
        Worksheet currentWorksheet = _worksheets[worksheetID] as Worksheet;

        currentWorksheet.students ??= {};
        currentWorksheet.students![_currentUserId] = studentSubmission;
        _worksheets[worksheetID] = currentWorksheet;
      }

      print("Student data associated with the last worksheet successfully.");
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

  bool getCurrentUserSubmission(String worksheetId) {
    final worksheetEntry = _worksheets.entries.firstWhere(
        (element) => element.key == worksheetId,
        orElse: () => MapEntry('', Worksheet()));

    if (worksheetEntry.value is Worksheet) {
      final workSheet = worksheetEntry.value as Worksheet;
      final userSubmission = workSheet.students?.entries.firstWhere(
          (studentEntry) => studentEntry.key == _currentUserId,
          orElse: () => MapEntry('', WorksheetStudent()));

      if (userSubmission != null) {
        _uploadedWorksheet = userSubmission.value;
        _worksheetAnswer = workSheet;
        printDebug(
            "Submission: ${_worksheetAnswer?.students}, ${_worksheetAnswer?.imageUrl}, ");
        return true;
      } else {
        printDebug("No submission found for user $_currentUserId");
      }
    }
    return false;
  }
}
