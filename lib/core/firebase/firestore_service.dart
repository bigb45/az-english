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
  String? unitNumber;
  Future<List<Level>> fetchLevels(User user) async {
    try {
      QuerySnapshot levelSnapshot =
          await _db.collection(FirestoreConstants.levelsCollection).get();
      if (levelSnapshot.docs.isEmpty) {
        throw "No levels found";
      }

      List<Future<Level>> levelFutures =
          levelSnapshot.docs.map((levelDoc) async {
        Level level = Level.fromMap(levelDoc.data() as Map<String, dynamic>);
        int currentDay = await getCurrentDay(user, level.name);
        unitNumber = "unit$currentDay";
        bool isFirstWeek = ((currentDay - 1) ~/ 5) % 2 == 0;
        List<String> daySections = getSectionsForDay(currentDay, isFirstWeek);

        QuerySnapshot sectionSnapshot = await _db
            .collection(FirestoreConstants.levelsCollection)
            .doc(level.name)
            .collection(FirestoreConstants.sectionsCollection)
            .get();

        List<Future<Section>> sectionFutures =
            sectionSnapshot.docs.map((sectionDoc) async {
          Section section =
              Section.fromMap(sectionDoc.data() as Map<String, dynamic>);
          if (daySections.contains(section.name)) {
            DocumentReference unitReference = _db
                .collection(FirestoreConstants.levelsCollection)
                .doc(level.name)
                .collection(FirestoreConstants.sectionsCollection)
                .doc(RouteConstants.getSectionIds("reading"))
                .collection(FirestoreConstants.unitsCollection)
                .doc(unitNumber);

            dynamic questionsNumber =
                await unitReference.get().then((snapshot) {
              return (snapshot.data()
                  as Map<String, dynamic>)['numberOfQuestions']!;
            });

            section.numberOfQuestions = questionsNumber;
            section.isAssigned = true;
          }
          return section;
        }).toList();

        List<Section> sections = await Future.wait(sectionFutures);
        level.sections = sections;
        return level;
      }).toList();

      return await Future.wait(levelFutures);
    } on FirebaseException catch (e) {
      throw CustomException.fromFirebaseFirestoreException(e);
    } catch (e) {
      rethrow;
    }
  }

  List<String> getSectionsForDay(int day, bool isFirstWeek) {
    // Define the basic two-day repeating section pattern
    List<List<String>> sectionsPattern = [
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

    // Calculate which pattern to use based on the week and day
    // (day - 1) % 2 determines the pattern within the week,
    // day index is adjusted by adding (week number * 2) % 2 to alternate every week.
    int weekNumber = ((day - 1) ~/ 5) %
        2; // Calculate the week number (0 for first week, 1 for second within the cycle)
    int dayIndex =
        (day - 1) % 2; // Calculate the day index within the week (0 or 1)

    if (!isFirstWeek) {
      weekNumber = 1 -
          weekNumber; // Invert week number for the second overall week to start with the opposite pattern
    }
    // Adjust day index based on the calculated week number
    dayIndex = (dayIndex + weekNumber) % 2;

    return sectionsPattern[dayIndex];
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
    int startIndex,
  ) async {
    Map<int, BaseQuestion> questions = {};
    try {
      DocumentSnapshot levelDoc = await _db
          .collection(FirestoreConstants.levelsCollection)
          .doc(level)
          .collection(FirestoreConstants.sectionsCollection)
          .doc(sectionName)
          .collection(FirestoreConstants.unitsCollection)
          .doc(unitNumber)
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
                "${FirestoreConstants.unitsCollection}/$unitNumber/"
                "${FirestoreConstants.questionsField}/${entry.key}"; // Set path
            questions[entry.key] = question; // Use key as map key
          }
        }

        return Unit(
          name: unitNumber!,
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

      List<Future<void>> uploadFutures = [];

      for (Section section in level.sections!) {
        Map<String, dynamic> sectionMetadata = {
          'name': section.name,
          'description': section.description,
          'attempted': section.attempted,
        };
        CollectionReference sectionsCollection = levelsCollection
            .doc(level.name)
            .collection(FirestoreConstants.sectionsCollection);

        uploadFutures.add(sectionsCollection
            .doc(RouteConstants.getSectionIds(section.name))
            .set(sectionMetadata));

        for (Unit unit in section.units!) {
          CollectionReference unitsCollection = sectionsCollection
              .doc(RouteConstants.getSectionIds(section.name))
              .collection(FirestoreConstants.unitsCollection);
          Map<String, dynamic> unitData = unit.toMap();

          uploadFutures.add(unitsCollection.doc(unit.name).set(unitData));
        }
      }

      await Future.wait(uploadFutures);
      print('Level data uploaded successfully to Firestore.');
    } catch (e) {
      print('Error uploading level data to Firestore: $e');
    }
  }
}
