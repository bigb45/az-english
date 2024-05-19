import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_english/core/firebase/constants.dart';
import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/level.dart';
import 'package:ez_english/features/models/user.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Level>> fetchLevels() async {
    try {
      QuerySnapshot snapshot =
          await _db.collection(FirestoreConstants.levelsCollection).get();
      if (snapshot.docs.isEmpty) {
        throw CustomException(
            message: "No levels found",
            type: FirebaseExceptionType.networkError);
      }
      return snapshot.docs
          .map((doc) => Level.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CustomException(
          message: "A network error occured",
          type: FirebaseExceptionType.networkError);
    }
  }

  Future<List<BaseQuestion>> fetchQuestions(
      String section, String level, String userId) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection(FirestoreConstants.questionsCollection)
          .where("section", isEqualTo: section)
          .where("level", isEqualTo: level)
          .get();
      if (snapshot.docs.isEmpty) {
        throw CustomException(
            message: "No questions found",
            type: FirebaseExceptionType.networkError);
      }
      return snapshot.docs
          .map((doc) =>
              BaseQuestion.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error: $e");

      throw CustomException(
          message: "A network error occured",
          type: FirebaseExceptionType.networkError);
    }
  }

  Future<void> addUser(UserModel user) async {
    try {
      await _db
          .collection(FirestoreConstants.usersCollections)
          .doc("${user.id}")
          .set(user.toMap());
    } catch (e) {
      throw Exception('Failed to add user: $e');
    }
  }
}
