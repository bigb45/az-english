import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/firebase/constants.dart';
import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/level.dart';
import 'package:ez_english/features/models/section.dart';
import 'package:ez_english/features/models/unit.dart';
import 'package:ez_english/features/models/user.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  int allQuestionsLength = 0;
  int filteredQuestionsLength = 0;
  Future<List<Level>> fetchLevels() async {
    try {
      QuerySnapshot levelSnapshot =
          await _db.collection(FirestoreConstants.levelsCollection).get();
      if (levelSnapshot.docs.isEmpty) {
        throw "No levels found";
      }

      List<Level> levels = [];

      for (var levelDoc in levelSnapshot.docs) {
        Level level = Level.fromMap(levelDoc.data() as Map<String, dynamic>);

        // Fetch sections for each level
        QuerySnapshot sectionSnapshot = await _db
            .collection(FirestoreConstants.levelsCollection)
            .doc(level.name)
            .collection(FirestoreConstants.sectionsCollection)
            .get();

        if (sectionSnapshot.docs.isNotEmpty) {
          List<Section> sections = sectionSnapshot.docs
              .map((doc) => Section.fromMap(doc.data() as Map<String, dynamic>))
              .toList();
          level.sections = sections;
        }

        levels.add(level);
      }

      return levels;
    } on FirebaseException catch (e) {
      throw CustomException.fromFirebaseFirestoreException(e);
    } catch (e) {
      rethrow;
    }
  }

// TODO generic function
  Future<Unit> fetchUnit(
    String sectionName,
    String level,
    int startIndex, {
    String unitName = "Unit1",
  }) async {
    Map<int, BaseQuestion> questions = {};
    try {
      DocumentSnapshot levelDoc = await _db
          .collection(FirestoreConstants.levelsCollection)
          .doc(level)
          .collection(FirestoreConstants.sectionsCollection)
          .doc(sectionName)
          .collection(FirestoreConstants.unitsCollection)
          .doc(unitName)
          .get();
      if (levelDoc.exists) {
        Map<String, dynamic> data = levelDoc.data() as Map<String, dynamic>;

        if (data.containsKey(FirestoreConstants.questionsField)) {
          // Convert keys from String to int
          Map<int, dynamic> questionsData =
              (data[FirestoreConstants.questionsField] as Map<String, dynamic>)
                  .map((key, value) => MapEntry(int.parse(key), value));
          allQuestionsLength = questionsData.length;

          var sortedEntries = questionsData.entries.toList()
            ..sort((a, b) => a.key.compareTo(b.key));

          // Filter questions based on startIndex
          var filteredQuestionsData = sortedEntries.skip(startIndex).toList();
          filteredQuestionsLength = filteredQuestionsData.length;

          for (var entry in filteredQuestionsData) {
            var mapData = entry.value as Map<String, dynamic>;
            BaseQuestion question = BaseQuestion.fromMap(mapData);
            question.path = "${FirestoreConstants.levelsCollection}/$level/"
                "${FirestoreConstants.sectionsCollection}/$sectionName/"
                "${FirestoreConstants.unitsCollection}/$unitName/"
                "${FirestoreConstants.questionsField}/${entry.key}"; // Set path
            questions[entry.key] = question; // Use key as map key
          }
        }

        return Unit(
          name: unitName,
          descriptionInEnglish: data['descriptionInEnglish'],
          descriptionInArabic: data['descriptionInArabic'],
          questions: questions,
        );
      } else {
        throw Exception('Level document does not exist');
      }
    } on FirebaseException catch (e) {
      throw CustomException.fromFirebaseFirestoreException(e);
    }
  }

  Future<void> updateQuestionUsingFieldPath<T>(
      {required DocumentReference docPath,
      required FieldPath fieldPath,
      required T newValue}) async {
    try {
      await docPath.update({
        fieldPath: newValue,
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

  Future<void> uploadLevelToFirestore(Level level) async {
    try {
      CollectionReference levelsCollection = FirebaseFirestore.instance
          .collection(FirestoreConstants.levelsCollection);
// TODO: Important: When adding new attributes to the Level class,
// make sure to include all attributes here in the levelMetadata map.
// Exclude attributes that will be stored as sub-collections, such as 'sections' in this case.
      Map<String, dynamic> levelMetadata = {
        'name': level.name,
        'description': level.description,
        'id': level.id
      };
      await levelsCollection.doc(level.name).set(levelMetadata);

      for (Section section in level.sections!) {
        Map<String, dynamic> sectionMetadata = {
          'name': section.name,
          'description': section.description,
        };
        CollectionReference sectionsCollection = levelsCollection
            .doc(level.name)
            .collection(FirestoreConstants.sectionsCollection);
        await sectionsCollection
            .doc(RouteConstants.getSectionIds(section.name))
            .set(sectionMetadata);

        for (Unit unit in section.units!) {
          CollectionReference unitsCollection = sectionsCollection
              .doc(RouteConstants.getSectionIds(section.name))
              .collection(FirestoreConstants.unitsCollection);
          Map<String, dynamic> unitData = unit.toMap();
          await unitsCollection.doc(unit.name).set(unitData);
        }
      }

      print('Level data uploaded successfully to Firestore.');
    } catch (e) {
      print('Error uploading level data to Firestore: $e');
    }
  }
}
