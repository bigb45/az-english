import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/firebase/constants.dart';
import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/level.dart';
import 'package:ez_english/features/models/level_progress.dart';
import 'package:ez_english/features/models/section.dart';
import 'package:ez_english/features/models/section_progress.dart';
import 'package:ez_english/features/models/unit.dart';
import 'package:ez_english/features/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  FirestoreService._privateConstructor();

  static final FirestoreService _instance =
      FirestoreService._privateConstructor();

  factory FirestoreService() {
    return _instance;
  }
  UserModel? _userModel;
  User? _user;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  int allQuestionsLength = 0;
  int filteredQuestionsLength = 0;
  String? unitNumber;
  Future<List<Level>> fetchLevels(User user) async {
    _user = user;
    _userModel = await getUser(_user!.uid);
    try {
      QuerySnapshot levelSnapshot =
          await _db.collection(FirestoreConstants.levelsCollection).get();
      if (levelSnapshot.docs.isEmpty) {
        throw "No levels found";
      }

      DocumentReference userDocRef =
          _db.collection(FirestoreConstants.usersCollections).doc(user.uid);
      DocumentSnapshot userDoc = await userDocRef.get();
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      // Initialize levelsProgress if not present
      if (!userData.containsKey('levelsProgress')) {
        userData['levelsProgress'] = {};
      }

      List<Future<Level>> levelFutures =
          levelSnapshot.docs.map((levelDoc) async {
        Level level = Level.fromMap(levelDoc.data() as Map<String, dynamic>);

        // Initialize levelProgress if not present
        if (!userData['levelsProgress'].containsKey(level.name)) {
          userData['levelsProgress'][level.name] = {
            'description': '',
            'completedSections': [],
            'sectionProgress': {},
            'currentDay': 1,
          };
        }

        Map<String, dynamic> levelProgressData =
            userData['levelsProgress'][level.name];
        int currentDay = levelProgressData['currentDay'] ?? 1;
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
          String sectionId = RouteConstants.getSectionIds(section.name);

          // Initialize sectionProgress if not present in user data
          if (!levelProgressData['sectionProgress'].containsKey(sectionId)) {
            levelProgressData['sectionProgress'][sectionId] = {
              'isAssigned': false,
              'isCompleted': false,
              'isAttempted': false,
              'lastStoppedQuestionIndex': 0,
              'progress': '',
              'unitsCompleted': [],
              'sectionName': ""
            };
          }

          Map<String, dynamic> sectionProgress =
              levelProgressData['sectionProgress'][sectionId];

          // Update section properties from user data
          section.isAssigned = sectionProgress['isAssigned'];
          section.isCompleted = sectionProgress['isCompleted'];
          section.isAttempted = sectionProgress['isAttempted'];
          section.numberOfSolvedQuestions =
              sectionProgress['lastStoppedQuestionIndex'];
          if (daySections.contains(section.name)) {
            DocumentReference unitReference = _db
                .collection(FirestoreConstants.levelsCollection)
                .doc(level.name)
                .collection(FirestoreConstants.sectionsCollection)
                .doc(sectionId)
                .collection(FirestoreConstants.unitsCollection)
                .doc(unitNumber);

            dynamic questionsNumber =
                await unitReference.get().then((snapshot) {
              return (snapshot.data()
                  as Map<String, dynamic>)['numberOfQuestions']!;
            });

            section.numberOfQuestions = questionsNumber;
            if (section.name != RouteConstants.testSectionName) {
              section.isAssigned = true;
              levelProgressData['sectionProgress'][sectionId]['sectionName'] =
                  section.name;
              levelProgressData['sectionProgress'][sectionId]['isAssigned'] =
                  true;
            }
          }
          return section;
        }).toList();

        List<Section> sections = await Future.wait(sectionFutures);
        level.sections = sections;

        // Save updated user progress back to Firestore
        await userDocRef.update({'levelsProgress': userData['levelsProgress']});

        return level;
      }).toList();

      return await Future.wait(levelFutures);
    } on FirebaseException catch (e) {
      throw CustomException.fromFirebaseFirestoreException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserProgress(String levelName, String sectionName) async {
    User? user = _user;
    try {
      DocumentReference userDocRef = FirebaseFirestore.instance
          .collection(FirestoreConstants.usersCollections)
          .doc(user?.uid);

      // Fetch the user's progress data
      DocumentSnapshot userDoc = await userDocRef.get();
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      Map<String, dynamic> levelProgressData =
          userData['levelsProgress'][levelName];
      LevelProgress levelProgress = LevelProgress.fromMap(levelProgressData);

      List<String> daySections =
          getSectionsForDay(levelProgress.currentDay, true);

      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Update the completed units for each section and check if they are completed
      String sectionId = RouteConstants.getSectionIds(sectionName);

      SectionProgress sectionProgress =
          levelProgress.sectionProgress![sectionId]!;

      if (!sectionProgress.unitsCompleted.contains(unitNumber)) {
        sectionProgress.unitsCompleted.add(unitNumber!);
      }

      // Update isCompleted status if all units are completed
      if (sectionProgress.isSectionCompleted(unitNumber!)) {
        sectionProgress.isCompleted = true;
      }

      // Add the section progress update to the batch
      batch.update(userDocRef, {
        'levelsProgress.$levelName.sectionProgress.$sectionId':
            sectionProgress.toMap(),
      });

      // Check if all sections except the test are completed
      bool allSectionsCompleted = daySections
          .where((daySection) => daySection != RouteConstants.testSectionName)
          .every((daySection) {
        String sectionId = RouteConstants.getSectionIds(daySection);
        return levelProgress.sectionProgress!.containsKey(sectionId) &&
            levelProgress.sectionProgress![sectionId]!.isCompleted;
      });

      if (allSectionsCompleted) {
        String testSectionId =
            RouteConstants.getSectionIds(RouteConstants.testSectionName);

        SectionProgress testSectionProgress =
            levelProgress.sectionProgress![testSectionId]!;
        testSectionProgress.isAssigned = true;

        // Add the test section progress update to the batch
        batch.update(userDocRef, {
          'levelsProgress.$levelName.sectionProgress.$testSectionId':
              testSectionProgress.toMap(),
        });

        if (testSectionProgress.isSectionCompleted(unitNumber!)) {
          testSectionProgress.isCompleted = true;
          levelProgress.currentDay++;

          // Reset the sections for the new day
          for (String sectionName in daySections) {
            String sectionId = RouteConstants.getSectionIds(sectionName);
            if (levelProgress.sectionProgress!.containsKey(sectionId)) {
              SectionProgress sectionProgress =
                  levelProgress.sectionProgress![sectionId]!;
              sectionProgress.isAttempted = false;
              sectionProgress.isAssigned = false;
              sectionProgress.isCompleted = false;
              sectionProgress.lastStoppedQuestionIndex = 0;
              sectionProgress.progress = "";

              // Add the reset section progress update to the batch
              batch.update(userDocRef, {
                'levelsProgress.$levelName.sectionProgress.$sectionId':
                    sectionProgress.toMap(),
              });
            }
          }
        }
      }

      // Add the level progress update to the batch
      batch.update(userDocRef, {
        'levelsProgress.$levelName.currentDay': levelProgress.currentDay,
      });

      // Commit the batch update
      await batch.commit();
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
        RouteConstants.testSectionName,
      ],
      [
        RouteConstants.listeningWritingSectionName,
        RouteConstants.vocabularySectionName,
        RouteConstants.testSectionName,
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
  ) async {
    Map<int, BaseQuestion> questions = {};
    try {
      _userModel = await getUser(_user!.uid);
      int lastQuestionIndex = _userModel!.levelsProgress![level]!
          .sectionProgress![sectionName]!.lastStoppedQuestionIndex;

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

          List<MapEntry<int, dynamic>> filteredQuestionsData;
          if (RouteConstants.getSectionName(sectionName) ==
              RouteConstants.readingSectionName) {
            // Always include the first question for reading section
            filteredQuestionsData = [];
            var embeddedQuestions = (sortedEntries.first.value
                    as Map<String, dynamic>)[FirestoreConstants.questionsField]
                as List<dynamic>;
            allQuestionsLength = embeddedQuestions.length;
            var skippedEmbeddedQuestions =
                embeddedQuestions.skip(lastQuestionIndex).toList();
            filteredQuestionsData.addAll(skippedEmbeddedQuestions
                .asMap()
                .entries
                .map((e) => MapEntry(e.key + 1, e.value)));
          } else {
            // Filter questions based on lastQuestionIndex for non-reading sections
            filteredQuestionsData =
                sortedEntries.skip(lastQuestionIndex).toList();
          }
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

  Future<void> updateCurrentSectionQuestionIndex(
      int newQuestionIndex, String levelName) async {
    try {
      DocumentReference userDocRef = FirebaseFirestore.instance
          .collection(FirestoreConstants.usersCollections)
          .doc(_user!.uid);

      FieldPath lastStoppedQuestionIndexPath = FieldPath([
        'levelsProgress',
        levelName,
        'sectionProgress',
        RouteConstants.sectionNameId[RouteConstants.readingSectionName]!,
        "lastStoppedQuestionIndex"
      ]);
      FieldPath sectionProgressIndex = FieldPath([
        'levelsProgress',
        levelName,
        'sectionProgress',
        RouteConstants.sectionNameId[RouteConstants.readingSectionName]!,
        "progress"
      ]);
      int lastStoppedQuestionIndex =
          (allQuestionsLength - filteredQuestionsLength) + newQuestionIndex;
      String sectionProgress =
          (((lastStoppedQuestionIndex + 1) / allQuestionsLength) * 100)
              .toString();
      await updateQuestionUsingFieldPath<int>(
          docPath: userDocRef,
          fieldPath: lastStoppedQuestionIndexPath,
          newValue: lastStoppedQuestionIndex);
      await updateQuestionUsingFieldPath<String>(
          docPath: userDocRef,
          fieldPath: sectionProgressIndex,
          newValue: sectionProgress);
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
