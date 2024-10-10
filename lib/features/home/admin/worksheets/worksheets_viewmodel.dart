import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/core/firebase/firebase_authentication_service.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/level.dart';
import 'package:ez_english/features/models/section.dart';
import 'package:ez_english/features/models/unit.dart';
import 'package:ez_english/features/models/user.dart';
import 'package:ez_english/features/models/worksheet.dart';
import 'package:ez_english/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminWorksheetsViewmodel extends ChangeNotifier {
  final FirestoreService firestoreService = FirestoreService();
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  bool _isLoading = false;
  List<Level> _levels = [];
  List<Level> get levels => _levels;
  bool get isLoading => _isLoading;
  List<BaseQuestion> _worksheets = [];
  List<BaseQuestion> get worksheets => _worksheets;

  set worksheets(List<BaseQuestion<dynamic>> value) {
    _worksheets = value;
    notifyListeners();
  }

  Future<void> fetchLevels() async {
    try {
      User user = _firebaseAuthService.getUser()!;
      UserModel? userModel = await firestoreService.getUser(user.uid);
      List<String>? assignedLevels = userModel!.assignedLevels;
      _levels = await firestoreService.fetchLevels(user);
      for (var level in _levels) {
        level.sections = [
          Section(
            name: RouteConstants.worksheetSectionName,
            units: await firestoreService.fetchWorksheetUnits(
                level.name, RouteConstants.worksheetSectionName),
            description: '',
          ),
        ];

        level.isAssigned = assignedLevels!.contains(level.name);
      }
    } on CustomException catch (e) {
      _handleError(e.message);
    } catch (e) {
      _handleError("An undefined error occurred ${e.toString()}");
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchWorksheets({
    required String levelName,
    required String unitName,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      Level selectedLevel =
          _levels.firstWhere((level) => level.name == levelName);
      Unit selectedUnit = selectedLevel.sections!.first.units!
          .firstWhere((unit) => unit.name == unitName);
      _worksheets = selectedUnit.questions.values
          .where((question) => question is Worksheet)
          .cast<Worksheet>()
          .toList();

      _worksheets.sort((a, b) {
        final aTimestamp = (a as Worksheet).timestamp ?? Timestamp(0, 0);
        final bTimestamp = (b as Worksheet).timestamp ?? Timestamp(0, 0);

        return aTimestamp.compareTo(bTimestamp);
      });
    } catch (e) {
      _handleError("Error occurred: ${e.toString()}");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _handleError(String e) {
    Utils.showErrorSnackBar(e);
  }
}
