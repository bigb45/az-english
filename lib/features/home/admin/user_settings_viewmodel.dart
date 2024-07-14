import 'dart:async';

import 'package:ez_english/features/models/base_viewmodel.dart';
import 'package:ez_english/widgets/checkbox.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserSettingsViewmodel extends BaseViewModel {
  // TODO: get user
  User? _user;
  List<CheckboxData> _levels = [
    CheckboxData(title: "A1"),
    CheckboxData(title: "A2"),
  ];

  @override
  FutureOr<void> init() {}

  User? get user => _user;
  List<CheckboxData> get levels => _levels;

  void updateName(String name) {
    // _user!.updateDisplayName(name);
    print("new name: $name");
    notifyListeners();
  }

  void updatePhoneNumber(String phoneNumber) {
    // _user!.updatePhoneNumber(phoneNumber);
    notifyListeners();
  }

  void updateAssignedLevels(List<CheckboxData> levels) {
    List<String> assignedLevels = levels.map((e) => e.title).toList();
    print("newly assigned levels: $assignedLevels");
    _levels = levels;
    notifyListeners();
  }
}
