import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/models/worksheet.dart';
import 'package:ez_english/utils/utils.dart';
import 'package:flutter/material.dart';

class AdminWorksheetsViewmodel extends ChangeNotifier {
  List<Worksheet> _worksheets = [];
  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<Worksheet> get worksheets => _worksheets;

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

  void selectWorksheet(int level, int index) {
    _worksheets = levels["level$level"]![index];

    notifyListeners();
  }

// Define levels with units, each unit containing a set of worksheets
  final Map<String, List<List<Worksheet>>> levels = {
    "level0": [
      [
        // Unit 1 worksheets
        Worksheet(
          imageUrl: null,
          title: "Worksheet 1",
          timestamp: Timestamp.fromDate(DateTime.now()),
        ),
        Worksheet(
          imageUrl: null,
          title: "Worksheet 2",
          timestamp: Timestamp.fromDate(DateTime.now()),
        ),
      ],
      [
        // Unit 2 worksheets
        Worksheet(
          imageUrl: null,
          title: "Worksheet 3",
          timestamp: Timestamp.fromDate(DateTime.now()),
          students: {},
        ),
      ],
    ],
    "level1": [
      [
        // Unit 1 worksheets
        Worksheet(
          imageUrl: null,
          title: "new worksheet 4",
          timestamp: Timestamp.fromDate(DateTime.now()),
        ),
        Worksheet(
          imageUrl: null,
          title: "new 2",
          timestamp: Timestamp.fromDate(DateTime.now()),
        ),
      ],
      [
        // Unit 2 worksheets
        Worksheet(
          imageUrl: null,
          title: "new 3",
          timestamp: Timestamp.fromDate(DateTime.now()),
        ),
      ],
    ]
  };
}
