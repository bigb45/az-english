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

// TODO generic function
  Future<List<BaseQuestion>> fetchQuestions(
    String sectionName,
    String level,
    int startIndex,
  ) async {
    List<BaseQuestion> questions = [];
    List<dynamic> filteredQuestionsData = [];
    try {
      DocumentSnapshot levelDoc = await _db
          .collection(FirestoreConstants.levelsCollection)
          .doc(level)
          .collection(FirestoreConstants.sectionsCollection)
          .doc(sectionName)
          .collection(FirestoreConstants.unitsCollection)
          .doc("Unit1")
          .get();
      if (levelDoc.exists) {
        Map<String, dynamic> data = levelDoc.data() as Map<String, dynamic>;

        if (data.containsKey('questions')) {
          List<dynamic> questionsData = data['questions'];
          // Ensure the startIndex is within bounds
          if (startIndex < questionsData.length) {
            filteredQuestionsData = questionsData.sublist(startIndex);
          }
          for (var mapData in filteredQuestionsData) {
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

  Future<void> updateQuestionProgress(
      {required String userId,
      required String levelName,
      required String sectionName,
      required int newQuestionIndex}) async {
    try {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('Users').doc(userId);

      FieldPath lastStoppedQuestionIndex = FieldPath([
        'levelsProgress',
        levelName,
        'sectionProgress',
        sectionName,
        "lastStoppedQuestionIndex"
      ]);
      FieldPath sectionProgressIndex = FieldPath([
        'levelsProgress',
        levelName,
        'sectionProgress',
        "reading",
        "progress"
      ]);

      await userDocRef.update({
        lastStoppedQuestionIndex: newQuestionIndex,
        sectionProgressIndex:
            ((newQuestionIndex + 1) / 10 * 100).toStringAsFixed(2)
      });
    } catch (e) {
      print("Error updating progress: $e");
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
