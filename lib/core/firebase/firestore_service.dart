import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/firebase/constants.dart';
import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/level.dart';
import 'package:ez_english/features/models/section.dart';
import 'package:ez_english/features/models/unit.dart';
import 'package:ez_english/features/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  int allQuestionsLength = 0;
  int filteredQuestionsLength = 0;
  Future<List<Level>> fetchLevels(User user) async {
    try {
      dynamic questionsNumber;
      // Get current day from user data

      QuerySnapshot levelSnapshot =
          await _db.collection(FirestoreConstants.levelsCollection).get();
      if (levelSnapshot.docs.isEmpty) {
        throw "No levels found";
      }

      List<Level> levels = [];

      for (var levelDoc in levelSnapshot.docs) {
        Level level = Level.fromMap(levelDoc.data() as Map<String, dynamic>);
        int currentDay = await getCurrentDay(user, level.name);

        bool isFirstWeek = ((currentDay - 1) ~/ 5) % 2 == 0;

        // Fetch sections for each level
        QuerySnapshot sectionSnapshot = await _db
            .collection(FirestoreConstants.levelsCollection)
            .doc(level.name)
            .collection(FirestoreConstants.sectionsCollection)
            .get();

        if (sectionSnapshot.docs.isNotEmpty) {
          List<Section> sections = [];
          List<String> daySections = getSectionsForDay(currentDay, isFirstWeek);

          for (var sectionDoc in sectionSnapshot.docs) {
            Section section =
                Section.fromMap(sectionDoc.data() as Map<String, dynamic>);

            // Fetch units for each section
            DocumentReference unitReference = _db
                .collection(FirestoreConstants.levelsCollection)
                .doc(level.name)
                .collection(FirestoreConstants.sectionsCollection)
                .doc(RouteConstants.getSectionIds("reading"))
                .collection(FirestoreConstants.unitsCollection)
                // TODO: unit logic
                .doc("Unit1");
            await unitReference.get().then((snapshot) {
              questionsNumber = (snapshot.data()
                  as Map<String, dynamic>)['numberOfQuestions']!;
            });
            section.numberOfQuestions = questionsNumber;
            sections.add(section);
          }
          for (Section section in sections) {
            if (daySections.contains(section.name)) {
              section.isAssigned = true;
            }
          }

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

  List<String> getSectionsForDay(int day, bool isFirstWeek) {
    List<List<String>> week1Sections = [
      [
        RouteConstants.readingSectionName,
        RouteConstants.grammarSectionName,
        RouteConstants.vocabularySectionName,
      ],
      [
        RouteConstants.listeningWritingSectionName,
        RouteConstants.vocabularySectionName,
      ],
    ];

    List<List<String>> week2Sections = [
      [
        RouteConstants.listeningWritingSectionName,
        RouteConstants.vocabularySectionName,
      ],
      [
        RouteConstants.readingSectionName,
        RouteConstants.grammarSectionName,
        RouteConstants.vocabularySectionName,
      ],
    ];

    int dayIndex = (day - 1) % 5;
    if (dayIndex < week1Sections.length) {
      return isFirstWeek ? week1Sections[dayIndex] : week2Sections[dayIndex];
    }
    return [];
  }

  Future<int> getCurrentDay(User currentUser, String level) async {
    DocumentReference userDocRef = FirebaseFirestore.instance
        .collection(FirestoreConstants.usersCollections)
        .doc(currentUser.uid);

    DocumentSnapshot userDoc = await userDocRef.get();
    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      if (userData.containsKey('levelsProgress') &&
          userData['levelsProgress'].containsKey(level)) {
        Map<String, dynamic> levelProgress = userData['levelsProgress'][level];
        return levelProgress['currentDay'] ?? 1; // Default to 1 if not set
      } else {
        return 1; // Default to 1 if level progress not found
      }
    } else {
      throw Exception('User document does not exist');
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

  Future<void> updateDocuments({
    required DocumentReference docPath,
    required Map<String, dynamic> newValues,
  }) async {
    try {
      await docPath.update(newValues);
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
          'attempted': section.attempted,
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
