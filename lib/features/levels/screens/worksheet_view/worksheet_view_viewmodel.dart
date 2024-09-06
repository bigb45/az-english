import 'package:flutter/material.dart';

class WorksheetViewViewmodel extends ChangeNotifier {
  WorksheetViewViewmodel() {
    getWorksheet();
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> getWorksheet() async {
    _isLoading = true;
    notifyListeners();
    // TODO: fetch the latest uploaded worksheet from firebase
    await Future.delayed(Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();
  }
}
