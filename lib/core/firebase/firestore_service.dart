import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_english/core/firebase/constants.dart';
import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/level.dart';
import 'package:ez_english/features/models/user.dart';
import 'package:ez_english/features/sections/reading/model/reading_question.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Level>> fetchLevels() async {
    try {
      QuerySnapshot snapshot =
          await _db.collection(FirestoreConstants.levelsCollection).get();
      if (snapshot.docs.isEmpty) {
        throw "No levels found";
      }
      return snapshot.docs
          .map((doc) => Level.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } on FirebaseException catch (e) {
      throw CustomException.fromFirebaseFirestoreException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<BaseQuestion>> fetchQuestions(
      String section, String level) async {
    List<BaseQuestion> questions = [];
    try {
      DocumentSnapshot levelDoc = await _db
          .collection(FirestoreConstants.levelsCollection)
          .doc(level)
          .collection(FirestoreConstants.sectionsCollection)
          .doc(section)
          .collection(FirestoreConstants.unitsCollection)
          .doc("Unit1")
          .get();
      if (levelDoc.exists) {
        Map<String, dynamic> data = levelDoc.data() as Map<String, dynamic>;

        if (data.containsKey('questions')) {
          List<dynamic> questionsData = data['questions'];

          for (var mapData in questionsData) {
            ReadingQuestionModel? question =
                ReadingQuestionModel.fromMap(mapData as Map<String, dynamic>);
            questions.add(question);
          }
        }
      }
      return questions;
    } on FirebaseException catch (e) {
      throw CustomException.fromFirebaseFirestoreException(e);
    }
  }

  Future<void> addUser(UserModel user) async {
    try {
      await _db
          .collection(FirestoreConstants.usersCollections)
          .doc("${user.id}")
          .set(user.toMap());
    } on FirebaseException catch (e) {
      throw CustomException.fromFirebaseFirestoreException(e);
    }
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      DocumentSnapshot doc = await _db
          .collection(FirestoreConstants.usersCollections)
          .doc(userId)
          .get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
    } on FirebaseException catch (e) {
      throw CustomException.fromFirebaseFirestoreException(e);
    } catch (e) {
      rethrow;
    }
    return null;
  }
}
