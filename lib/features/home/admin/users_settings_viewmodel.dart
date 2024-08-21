import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/models/base_viewmodel.dart';
import 'package:ez_english/features/models/level.dart';
import 'package:ez_english/features/models/user.dart';
import 'package:ez_english/utils/utils.dart';
import 'package:ez_english/widgets/checkbox.dart';

class UsersSettingsViewmodel extends BaseViewModel {
  List<UserModel?> _users = [];
  List<UserModel?> _filteredUsers = [];

  final FirestoreService _firestoreService = FirestoreService();
  List<Level?> _levels = [];

  Future<void> myInit() async {
    isLoading = true;
    _users = await _firestoreService.getUsers();
    _filteredUsers = _users;
    _levels = await firestoreService.getLevels();
    isInitialized = true;
    isLoading = false;
    notifyListeners();
  }

  List<UserModel?> get users => _users;
  List<UserModel?> get filteredUsers => _filteredUsers;
  List<Level?> get levels => _levels;

  @override
  bool isLoading = false;

  @override
  FutureOr<void> init() {}

  void filterUsers(String query) {
    printDebug("filtering by $query");
    _filteredUsers = _users
        .where((user) =>
            user?.studentName
                ?.toLowerCase()
                .trim()
                .contains(query.toLowerCase().trim()) ??
            true)
        .toList();
    notifyListeners();
  }

  Future<void> updateName(String userId, String newStudentName) async {
    try {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection("users").doc(userId);
      await _firestoreService.updateQuestionUsingFieldPath(
        docPath: userDocRef,
        fieldPath: FieldPath(const ['studentName']),
        newValue: newStudentName,
      );
      // Update the local user model
      UserModel? user = _users.firstWhere((user) => user?.id == userId);
      if (user != null) {
        user.studentName = newStudentName;
      }
      notifyListeners();
    } catch (e) {
      // TODO: set error state and show error in UI
      // Utils.showErrorSnackBar("Error updating studentName");
      print("Error updating studentName: $e");
    }
  }

  Future<void> updateUserType(UserType newUserType, String userId) async {
    try {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection("users").doc(userId);
      await _firestoreService.updateQuestionUsingFieldPath(
        docPath: userDocRef,
        fieldPath: FieldPath(const ['userType']),
        newValue: newUserType.toShortString(),
      );
      // Update the local user model
      UserModel? user = _users.firstWhere((user) => user?.id == userId);
      if (user != null) {
        user.userType = newUserType;
      }
      notifyListeners();
    } catch (e) {
      print("Error updating user type: $e");
    }
  }

  Future<void> updateParentPhoneNumber(
      String userId, String newPhoneNumber) async {
    try {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection("users").doc(userId);
      await _firestoreService.updateQuestionUsingFieldPath(
        docPath: userDocRef,
        fieldPath: FieldPath(const ['parentPhoneNumber']),
        newValue: newPhoneNumber,
      );
      // Update the local user model
      UserModel? user = _users.firstWhere((user) => user?.id == userId);
      if (user != null) {
        user.parentPhoneNumber = newPhoneNumber;
      }
      notifyListeners();
    } catch (e) {
      print("Error updating phone number: $e");
    }
  }

  Future<void> updateAssignedLevels(
      String userId, List<CheckboxData>? levels) async {
    List<String> assignedLevels = levels?.map((e) => e.title).toList() ?? [];
    try {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection("users").doc(userId);
      await _firestoreService.updateQuestionUsingFieldPath(
        docPath: userDocRef,
        fieldPath: FieldPath(const ['assignedLevels']),
        newValue: assignedLevels,
      );
      // Update the local user model
      UserModel? user = _users.firstWhere((user) => user?.id == userId);
      if (user != null) {
        user.assignedLevels = assignedLevels;
      }
      notifyListeners();
    } catch (e) {
      print("Error updating assigned levels: $e");
    }
  }
}
