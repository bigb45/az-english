import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/models/worksheet.dart';
import 'package:ez_english/utils/utils.dart';
import 'package:flutter/material.dart';

class WorksheetsViewmodel extends ChangeNotifier {
  List<WorkSheet> _worksheets = [];
  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<WorkSheet> get worksheets => _worksheets;

  Future<void> getWorksheets() async {
    _isLoading = true;
    notifyListeners();
    try {
      _worksheets = await _firestoreService.getAllWorksheets();
    } catch (e) {
      printDebug("Error getting worksheets: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
