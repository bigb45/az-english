import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/firebase/constants.dart';
import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/fetch_assigned_section_question_result.dart';
import 'package:ez_english/features/models/level.dart';
import 'package:ez_english/features/models/level_progress.dart';
import 'package:ez_english/features/models/section.dart';
import 'package:ez_english/features/models/section_progress.dart';
import 'package:ez_english/features/models/unit.dart';
import 'package:ez_english/features/models/user.dart';
import 'package:ez_english/features/models/worksheet.dart';
import 'package:ez_english/features/models/worksheet_student.dart';
import 'package:ez_english/features/sections/models/passage_question_model.dart';
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
  String? currentDayString;

  void reset() {
    _userModel = null;
    _user = null;
    allQuestionsLength = 0;
    filteredQuestionsLength = 0;
    unitNumber = null;
  }

  Future<List<Level>> fetchLevels(User user) async {
    _user = user;
    try {
      QuerySnapshot levelSnapshot =
          await _db.collection(FirestoreConstants.levelsCollection).get();
      if (levelSnapshot.docs.isEmpty) {
        return [];
      }

      _userModel = await getUser(_user!.uid);
      DocumentReference userDocRef =
          _db.collection(FirestoreConstants.usersCollections).doc(_user!.uid);
      DocumentSnapshot userDoc = await userDocRef.get();
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      // Initialize levelsProgress if not present
      if (!userData.containsKey('levelsProgress') ||
          userData["levelsProgress"] == null) {
        userData['levelsProgress'] = {};
      }

      List<Level> levels = levelSnapshot.docs.map((levelDoc) {
        Level level = Level.fromMap(levelDoc.data() as Map<String, dynamic>);
        if (!userData['levelsProgress'].containsKey(level.name) ||
            userData["levelsProgress"][level.name] == null) {
          userData['levelsProgress'][level.name] = {
            'description': '',
            'completedSections': [],
            'sectionProgress': {},
            'examResults': {},
            'currentDay': 1,
          };
        }
        return level;
      }).toList();
      await userDocRef.update({'levelsProgress': userData['levelsProgress']});

      return levels;
    } on FirebaseException catch (e) {
      throw CustomException.fromFirebaseFirestoreException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<SectionFetchResult> fetchAssignedQuestions(
      {User? user, String? userId, required String sectionName}) async {
    try {
      Map<int, BaseQuestion> questions = {};
      List<MapEntry<int, dynamic>> filteredQuestionsData = [];
      if (userId == null) {
        _user = user;
        _userModel = await getUser(_user!.uid);
        // TODO: refactor this ^^^^
      } else {
        _userModel = await getUser(userId);
      }

      DocumentReference userDocRef = _db
          .collection(FirestoreConstants.usersCollections)
          .doc(_userModel!.id);
      DocumentSnapshot userDoc = await userDocRef.get();

      if (!userDoc.exists) {
        throw Exception('User document does not exist');
      }

      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      if (!userData.containsKey('assignedQuestions') ||
          userData["assignedQuestions"] == null) {
        userData['assignedQuestions'] = {};
      }
      if (!userData['assignedQuestions']
              .containsKey(RouteConstants.sectionNameId[sectionName]!) ||
          userData["assignedQuestions"]
                  [RouteConstants.sectionNameId[sectionName]!] ==
              null) {
        userData['assignedQuestions']
            [RouteConstants.sectionNameId[sectionName]!] = {
          'questions': {},
          'sectionName': sectionName,
          'progress': 0.0,
          'lastStoppedQuestionIndex': 0,
          "numberOfQuestionsWithDeletion": 0,
          "numberOfQuestionWithoutDeletion": 0,
        };
      }
      double progress = (userData['assignedQuestions']
              [RouteConstants.sectionNameId[sectionName]!]['progress'] as num)
          .toDouble();
      Map<String, dynamic> sectionData = userData['assignedQuestions']
          [RouteConstants.sectionNameId[sectionName]!];
      Map<String, dynamic> questionData =
          Map<String, dynamic>.from(sectionData['questions'] as Map);
      Map<int, dynamic> questionsData =
          questionData.map((key, value) => MapEntry(int.parse(key), value));
      int lastQuestionIndex = sectionData['lastStoppedQuestionIndex'];

      allQuestionsLength = questionsData.length;
      var sortedEntries = questionsData.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));

      int maxKey = sortedEntries.isEmpty ? 0 : sortedEntries.last.key;
      int questionIndex = maxKey + 1;

      for (var entry in sortedEntries) {
        var mapData = entry.value as Map<String, dynamic>;
        if (mapData["questionType"] == "passage" &&
            mapData.containsKey("questions")) {
          var embeddedQuestionsData =
              mapData["questions"] as Map<String, dynamic>;
          var sortedEntries = embeddedQuestionsData.entries.toList()
            ..sort((a, b) => int.parse(a.key).compareTo(int.parse(b.key)));
          var sortedEmbeddedQuestionsData =
              Map<String, dynamic>.fromEntries(sortedEntries);
          allQuestionsLength = sortedEmbeddedQuestionsData.length + 1;
          var parentQuestionPath =
              "${FirestoreConstants.usersCollections}/${_userModel!.id}/"
              "assignedQuestions/"
              "${RouteConstants.getSectionIds(sectionName)}/"
              "${FirestoreConstants.questionsField}/${entry.key}";
          for (var embeddedEntry in sortedEmbeddedQuestionsData.entries) {
            var embeddedQuestionMap =
                embeddedEntry.value as Map<String, dynamic>;
            PassageQuestionModel embeddedQuestion = PassageQuestionModel(
              passageInEnglish: mapData['passageInEnglish'],
              passageInArabic: mapData['passageInArabic'],
              titleInArabic: mapData['titleInArabic'],
              titleInEnglish: mapData['titleInEnglish'],
              questions: {1: BaseQuestion.fromMap(embeddedQuestionMap)},
              questionTextInEnglish: mapData['questionTextInEnglish'],
              questionTextInArabic: mapData['questionTextInArabic'],
              imageUrl: mapData['imageUrl'],
              voiceUrl: mapData['voiceUrl'],
              questionType: QuestionType.passage,
            );
            embeddedQuestion.path =
                "$parentQuestionPath/embeddedQuestions/${embeddedEntry.key}";

            questions[questionIndex++] =
                embeddedQuestion; // Assign each embedded question a unique incremental key
          }
        } else {
          BaseQuestion question = BaseQuestion.fromMap(mapData);
          questions[entry.key] = question;
          question.path =
              "${FirestoreConstants.usersCollections}/${_userModel!.id}/"
              "assignedQuestions/"
              "${RouteConstants.getSectionIds(sectionName)}/"
              "${FirestoreConstants.questionsField}/${entry.key}";
        }
        filteredQuestionsData =
            questions.entries.skip(lastQuestionIndex).toList();
        filteredQuestionsLength = filteredQuestionsData.length;
      }
      Map<int, BaseQuestion<dynamic>> filteredQuestionsMap = {
        for (var entry in filteredQuestionsData) entry.key: entry.value,
      };
      questions = filteredQuestionsMap;

      await userDocRef
          .update({'assignedQuestions': userData['assignedQuestions']});
      return SectionFetchResult(questions: questions, progress: progress);
    } on FirebaseException catch (e) {
      throw CustomException.fromFirebaseFirestoreException(e);
    } catch (e) {
      rethrow;
    }
  }

  void updateQuestionsLength(
    int allQuestionsLengthTemp,
    int filteredQuestionLengthTemp,
  ) {
    allQuestionsLength = allQuestionsLengthTemp;
    filteredQuestionsLength = filteredQuestionLengthTemp;
  }

  Future<void> updateCurrentSectionQuestionIndexForAssignedQuestions(
      int newQuestionIndex, String sectionName) async {
    try {
      DocumentReference userDocRef = FirebaseFirestore.instance
          .collection(FirestoreConstants.usersCollections)
          .doc(_user!.uid);

      FieldPath lastStoppedQuestionIndexPath = FieldPath([
        'assignedQuestions',
        RouteConstants.sectionNameId[sectionName]!,
        "lastStoppedQuestionIndex"
      ]);
      FieldPath sectionProgressIndex = FieldPath([
        'assignedQuestions',
        RouteConstants.sectionNameId[sectionName]!,
        "progress"
      ]);
      int lastStoppedQuestionIndex =
          (allQuestionsLength - filteredQuestionsLength) + newQuestionIndex;
      double sectionProgress = 0;
      if (allQuestionsLength == 0) {
        sectionProgress = 0;
      } else {
        sectionProgress =
            (((lastStoppedQuestionIndex + 1) / allQuestionsLength) * 100);
      }

      await updateQuestionUsingFieldPath<int>(
          docPath: userDocRef,
          fieldPath: lastStoppedQuestionIndexPath,
          newValue: lastStoppedQuestionIndex);
      await updateQuestionUsingFieldPath<double>(
          docPath: userDocRef,
          fieldPath: sectionProgressIndex,
          newValue: sectionProgress);
    } on FirebaseException catch (e) {
      throw CustomException.fromFirebaseFirestoreException(e);
    }
  }

  Future<List<Unit>> fetchWorksheetUnits(
      String levelName, String worksheetSectionName) async {
    try {
      // Fetch the worksheet section document
      DocumentSnapshot sectionDoc = await _db
          .collection(FirestoreConstants.levelsCollection)
          .doc(levelName)
          .collection(FirestoreConstants.sectionsCollection)
          .doc(RouteConstants.getSectionIds(worksheetSectionName))
          .get();

      if (!sectionDoc.exists) {
        return []; // Return an empty list if the section doesn't exist
      }

      // Fetch the units inside the worksheet section
      QuerySnapshot unitSnapshot = await _db
          .collection(FirestoreConstants.levelsCollection)
          .doc(levelName)
          .collection(FirestoreConstants.sectionsCollection)
          .doc(RouteConstants.getSectionIds(worksheetSectionName))
          .collection(FirestoreConstants.unitsCollection)
          .get();

      // Map the unit documents to Unit objects
      List<Unit> units = unitSnapshot.docs.map((unitDoc) {
        return Unit.fromMap(unitDoc.data() as Map<String, dynamic>);
      }).toList();

      return units;
    } on FirebaseException catch (e) {
      throw CustomException.fromFirebaseFirestoreException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Section>> fetchSection(
    String levelName, {
    int? desiredDay,
  }) async {
    try {
      _userModel = await getUser(_user!.uid);
      DocumentReference userDocRef =
          _db.collection(FirestoreConstants.usersCollections).doc(_user!.uid);
      DocumentSnapshot userDoc = await userDocRef.get();
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      Map<String, dynamic> levelProgressData =
          userData['levelsProgress'][levelName];
      int currentDay = desiredDay ?? (levelProgressData['currentDay'] ?? 1);
      if (desiredDay == null) currentDayString = currentDay.toString();

      unitNumber = "unit$currentDay";

      List<String> daySections = getSectionsForDay();

      QuerySnapshot sectionSnapshot = await _db
          .collection(FirestoreConstants.levelsCollection)
          .doc(levelName)
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
            'progress': 0,
            'unitsCompleted': [],
            "interactedQuestions": {},
            'sectionName': section.name
          };
        }

        Map<String, dynamic> sectionProgress =
            levelProgressData['sectionProgress'][sectionId];
        if (desiredDay != null) {
          section.isAssigned = true;
          section.isCompleted = true;
          section.isAttempted = true;
          section.numberOfSolvedQuestions = 0;
          section.progress = 0;
        } else {
          section.isAssigned = sectionProgress['isAssigned'];
          section.isCompleted = sectionProgress['isCompleted'];
          section.isAttempted = sectionProgress['isAttempted'];
          section.numberOfSolvedQuestions =
              sectionProgress['lastStoppedQuestionIndex'];
          section.progress = (sectionProgress['progress'] is int)
              ? (sectionProgress['progress'] as int).toDouble()
              : (sectionProgress['progress'] ?? 0.0) as double;
        }
        if (daySections.contains(section.name)) {
          String tempUnitNumber = unitNumber!;

          if (section.name != RouteConstants.testSectionName) {
            section.isAssigned = true;
            levelProgressData['sectionProgress'][sectionId]['sectionName'] =
                section.name;
            levelProgressData['sectionProgress'][sectionId]['isAssigned'] =
                true;
          }
          DocumentReference unitReference = _db
              .collection(FirestoreConstants.levelsCollection)
              .doc(levelName)
              .collection(FirestoreConstants.sectionsCollection)
              .doc(sectionId)
              .collection(FirestoreConstants.unitsCollection)
              .doc(tempUnitNumber);

          dynamic questionsNumber = await unitReference.get().then((snapshot) {
            if (snapshot.exists && snapshot.data() != null) {
              return (snapshot.data() as Map<String, dynamic>)[
                      'numberOfQuestionsWithDeletion'] ??
                  0;
            } else {
              section.isAssigned = false;
              section.isAttempted = false;
              section.isCompleted = false;
              return 0;
            }
          });
          section.numberOfQuestions = questionsNumber;
        }
        return section;
      }).toList();

      // Save updated user progress back to Firestore
      if (desiredDay == null) {
        await userDocRef.update({'levelsProgress': userData['levelsProgress']});
      }

      return await Future.wait(sectionFutures);
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
      List<String> daySections = getSectionsForDay();

      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Update the completed units for each section and check if they are completed
      String sectionId = RouteConstants.getSectionIds(sectionName);

      SectionProgress sectionProgress =
          levelProgress.sectionProgress![sectionId]!;
      String tempUnitNumber = unitNumber!;
      if (!sectionProgress.unitsCompleted.contains(tempUnitNumber)) {
        sectionProgress.unitsCompleted.add(tempUnitNumber);
      }

      // Update isCompleted status if all units are completed
      if (sectionProgress.isSectionCompleted(tempUnitNumber)) {
        sectionProgress.isCompleted = true;
        sectionProgress.lastStoppedQuestionIndex = 0;
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

        if (testSectionProgress.isSectionCompleted(tempUnitNumber)) {
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
              sectionProgress.progress = 0.0;
              sectionProgress.interactedQuestions = {};

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

  List<String> getSectionsForDay() {
    List<List<String>> sectionsPattern = [
      [
        RouteConstants.readingSectionName,
        RouteConstants.grammarSectionName,
        RouteConstants.vocabularySectionName,
        RouteConstants.testSectionName,
        RouteConstants.listeningSectionName,
        RouteConstants.writingSectionName,
        RouteConstants.worksheetSectionName,
      ],
    ];

    return sectionsPattern[0];
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

  Future<Section?> fetchUnitsForLevelAndSection(
      String levelId, String sectionName) async {
    try {
      // Fetch the specific section for the provided levelId and sectionName
      final sectionSnapshot = await _db
          .collection(FirestoreConstants.levelsCollection)
          .doc(levelId)
          .collection(FirestoreConstants.sectionsCollection)
          .doc(RouteConstants.getSectionIds(sectionName))
          .get();

      if (sectionSnapshot.exists) {
        // Convert Firestore data to Section using fromMap
        Section section =
            Section.fromMap(sectionSnapshot.data() as Map<String, dynamic>);

        // Fetch units for this section
        final unitsSnapshot = await _db
            .collection(FirestoreConstants.levelsCollection)
            .doc(levelId)
            .collection(FirestoreConstants.sectionsCollection)
            .doc(RouteConstants.getSectionIds(sectionName))
            .collection(FirestoreConstants.unitsCollection)
            .get();

        // Convert Firestore data to Unit objects and assign to the section
        section.units = unitsSnapshot.docs.map((unitDoc) {
          return Unit.fromMap(unitDoc.data() as Map<String, dynamic>);
        }).toList();

        return section; // Return the section with units
      } else {
        return null; // Section not found
      }
    } catch (e) {
      print("Error fetching section or units: $e");
      return null;
    }
  }

  Future<Unit> fetchUnit(String sectionName, String level,
      {String? unit}) async {
    Map<int, BaseQuestion> questions = {};
    try {
      _userModel = await getUser(_user!.uid);
      Map<int, bool> interactedQuestions = _userModel!.levelsProgress![level]!
          .sectionProgress![sectionName]!.interactedQuestions;

      int lastQuestionIndex = _userModel!.levelsProgress![level]!
          .sectionProgress![sectionName]!.lastStoppedQuestionIndex;

      double progress = _userModel!
          .levelsProgress![level]!.sectionProgress![sectionName]!.progress;
      String tempUnitNumber = unit ?? unitNumber!;
      DocumentSnapshot levelDoc = await _db
          .collection(FirestoreConstants.levelsCollection)
          .doc(level)
          .collection(FirestoreConstants.sectionsCollection)
          .doc(sectionName)
          .collection(FirestoreConstants.unitsCollection)
          .doc(tempUnitNumber)
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

          List<MapEntry<int, dynamic>> filteredQuestionsData = [];

          if (RouteConstants.getSectionName(sectionName) ==
              RouteConstants.readingSectionName) {
            if (sortedEntries.first.value is Map<String, dynamic>) {
              var firstQuestion = sortedEntries.first;

              if (firstQuestion.value[FirestoreConstants.questionsField]
                  is Map<String, dynamic>) {
                var embeddedQuestionsMap =
                    firstQuestion.value[FirestoreConstants.questionsField]
                        as Map<String, dynamic>;

                var embeddedQuestions = embeddedQuestionsMap.entries
                    .map((entry) => MapEntry(int.parse(entry.key), entry.value))
                    .toList();

                embeddedQuestions.sort((a, b) => a.key.compareTo(b.key));

                var skippedEmbeddedQuestions =
                    embeddedQuestions.skip(lastQuestionIndex).toList();

                allQuestionsLength = embeddedQuestions.length + 1;

                filteredQuestionsData.add(firstQuestion);

                filteredQuestionsData.addAll(skippedEmbeddedQuestions
                    .map((e) => MapEntry(e.key + 1, e.value)));

                filteredQuestionsLength = filteredQuestionsData.length;

                // Convert back to Map<String, dynamic> for embedded questions
                Map<String, dynamic> orderedEmbeddedQuestions = {
                  for (var entry in skippedEmbeddedQuestions)
                    entry.key.toString(): entry.value
                };

                (firstQuestion.value as Map<String, dynamic>)[FirestoreConstants
                    .questionsField] = orderedEmbeddedQuestions;
              } else {
                throw Exception(
                    "Unexpected data structure for embedded questions");
              }
            } else {
              throw Exception(
                  "Unexpected data structure for the first question");
            }
          } else if (RouteConstants.getSectionName(sectionName) ==
              RouteConstants.vocabularySectionName) {
            for (var entry in sortedEntries) {
              if (interactedQuestions.containsKey(entry.key)) {
                if (entry.value is Map<String, dynamic>) {
                  (entry.value as Map<String, dynamic>)['isNew'] = false;
                }
              }
            }

            filteredQuestionsData.addAll(sortedEntries);
            filteredQuestionsLength =
                filteredQuestionsData.length - interactedQuestions.length;
          } else {
            filteredQuestionsData =
                sortedEntries.skip(lastQuestionIndex).toList();

            filteredQuestionsLength = filteredQuestionsData.length;
          }

          for (var entry in filteredQuestionsData) {
            if (entry.value is Map<String, dynamic>) {
              var mapData = entry.value as Map<String, dynamic>;
              BaseQuestion question = BaseQuestion.fromMap(mapData);
              question.path = "${FirestoreConstants.levelsCollection}/$level/"
                  "${FirestoreConstants.sectionsCollection}/$sectionName/"
                  "${FirestoreConstants.unitsCollection}/$tempUnitNumber/"
                  "${FirestoreConstants.questionsField}/${entry.key}"; // Set path
              questions[entry.key] = question; // Use key as map key
            } else {
              throw Exception("Unexpected data structure for question");
            }
          }
        }

        return Unit(
            name: tempUnitNumber,
            descriptionInEnglish: data['descriptionInEnglish'],
            descriptionInArabic: data['descriptionInArabic'],
            questions: questions,
            progress: progress);
      } else {
        throw Exception('Level document does not exist');
      }
    } on FirebaseException catch (e) {
      throw CustomException.fromFirebaseFirestoreException(e);
    }
  }

  Future<List<BaseQuestion<dynamic>>> fetchAllQuestions() async {
    // TODO: test
    List<BaseQuestion<dynamic>> allQuestions = [];

    try {
      // Fetch all levels
      QuerySnapshot levelsSnapshot =
          await _db.collection(FirestoreConstants.levelsCollection).get();

      for (var levelDoc in levelsSnapshot.docs) {
        String level = levelDoc.id;

        // Fetch all sections within the level
        QuerySnapshot sectionsSnapshot = await _db
            .collection(FirestoreConstants.levelsCollection)
            .doc(level)
            .collection(FirestoreConstants.sectionsCollection)
            .get();

        for (var sectionDoc in sectionsSnapshot.docs) {
          String section = sectionDoc.id;

          // Fetch all units within the section
          QuerySnapshot unitsSnapshot = await _db
              .collection(FirestoreConstants.levelsCollection)
              .doc(level)
              .collection(FirestoreConstants.sectionsCollection)
              .doc(section)
              .collection(FirestoreConstants.unitsCollection)
              .get();

          for (var unitDoc in unitsSnapshot.docs) {
            String unit = unitDoc.id;

            // Fetch questions in the unit
            DocumentSnapshot unitSnapshot = await _db
                .collection(FirestoreConstants.levelsCollection)
                .doc(level)
                .collection(FirestoreConstants.sectionsCollection)
                .doc(section)
                .collection(FirestoreConstants.unitsCollection)
                .doc(unit)
                .get();

            if (unitSnapshot.exists) {
              Map<String, dynamic> data =
                  unitSnapshot.data() as Map<String, dynamic>;
              if (data[FirestoreConstants.questionsField] != null) {
                Map<int, dynamic> questionsData =
                    (data[FirestoreConstants.questionsField]
                            as Map<String, dynamic>)
                        .map((key, value) => MapEntry(int.parse(key), value));

                var sortedEntries = questionsData.entries.toList()
                  ..sort((a, b) => a.key.compareTo(b.key));

                for (var entry in sortedEntries) {
                  final question = BaseQuestion.fromMap(entry.value);
                  question.path =
                      "${FirestoreConstants.levelsCollection}/$level/"
                      "${FirestoreConstants.sectionsCollection}/$section/"
                      "${FirestoreConstants.unitsCollection}/$unit/"
                      "${FirestoreConstants.questionsField}/${entry.key}";
                  allQuestions.add(question);
                }
              }
            }
          }
        }
      }
      return allQuestions;
    } on FirebaseException catch (e) {
      throw CustomException.fromFirebaseFirestoreException(e);
    }
  }

  Future<List<BaseQuestion<dynamic>>> fetchQuestions({
    required String level,
    required String section,
    required String day,
  }) async {
    try {
      DocumentReference unitRef = _db
          .collection(FirestoreConstants.levelsCollection)
          .doc(level)
          .collection(FirestoreConstants.sectionsCollection)
          .doc(RouteConstants.getSectionIds(section))
          .collection(FirestoreConstants.unitsCollection)
          .doc('unit$day');

      DocumentSnapshot unitSnapshot = await unitRef.get();

      if (unitSnapshot.exists) {
        Map<String, dynamic> data = unitSnapshot.data() as Map<String, dynamic>;
        if (data[FirestoreConstants.questionsField] != null) {
          Map<int, dynamic> questionsData =
              (data[FirestoreConstants.questionsField] as Map<String, dynamic>)
                  .map((key, value) => MapEntry(int.parse(key), value));

          var sortedEntries = questionsData.entries.toList()
            ..sort((a, b) => a.key.compareTo(b.key));

          if (section == RouteConstants.readingSectionName) {
            if (sortedEntries.first.value is Map<String, dynamic>) {
              var firstQuestion =
                  sortedEntries.first.value as Map<String, dynamic>;

              if (firstQuestion[FirestoreConstants.questionsField]
                  is Map<String, dynamic>) {
                var embeddedQuestionsMap =
                    firstQuestion[FirestoreConstants.questionsField]
                        as Map<String, dynamic>;

                var embeddedQuestions = embeddedQuestionsMap.entries
                    .map((entry) => MapEntry(int.parse(entry.key), entry.value))
                    .toList();

                embeddedQuestions.sort((a, b) => a.key.compareTo(b.key));

                // Convert back to Map<String, dynamic>
                Map<String, dynamic> orderedEmbeddedQuestions = {
                  for (var entry in embeddedQuestions)
                    entry.key.toString(): entry.value
                };

                firstQuestion[FirestoreConstants.questionsField] =
                    orderedEmbeddedQuestions;
              } else {
                throw Exception(
                    "Unexpected data structure for embedded questions");
              }
            } else {
              throw Exception(
                  "Unexpected data structure for the first question");
            }
          }

          return sortedEntries.map((entry) {
            final question = BaseQuestion.fromMap(entry.value);
            question.path = "${FirestoreConstants.levelsCollection}/$level/"
                "${FirestoreConstants.sectionsCollection}/${RouteConstants.getSectionIds(section)}/"
                "${FirestoreConstants.unitsCollection}/unit$day/"
                "${FirestoreConstants.questionsField}/${entry.key}";
            return question;
          }).toList();
        }
      }
      return [];
    } on FirebaseException catch (e) {
      throw CustomException.fromFirebaseFirestoreException(e);
    }
  }

  double calculateNewProgress(int newQuestionIndex) {
    int lastStoppedQuestionIndex =
        (allQuestionsLength - filteredQuestionsLength) + newQuestionIndex;
    double sectionProgress =
        (((lastStoppedQuestionIndex + 1) / allQuestionsLength) * 100);
    return sectionProgress;
  }

  Future<void> updateCurrentSectionQuestionIndex(
      int newQuestionIndex, String levelName, String sectionName) async {
    try {
      DocumentReference userDocRef = FirebaseFirestore.instance
          .collection(FirestoreConstants.usersCollections)
          .doc(_user!.uid);

      FieldPath lastStoppedQuestionIndexPath = FieldPath([
        'levelsProgress',
        levelName,
        'sectionProgress',
        RouteConstants.sectionNameId[sectionName]!,
        "lastStoppedQuestionIndex"
      ]);
      FieldPath sectionProgressIndex = FieldPath([
        'levelsProgress',
        levelName,
        'sectionProgress',
        RouteConstants.sectionNameId[sectionName]!,
        "progress"
      ]);
      int lastStoppedQuestionIndex =
          (allQuestionsLength - filteredQuestionsLength) + newQuestionIndex;
      double sectionProgress =
          (((lastStoppedQuestionIndex + 1) / allQuestionsLength) * 100);

      await updateQuestionUsingFieldPath<int>(
          docPath: userDocRef,
          fieldPath: lastStoppedQuestionIndexPath,
          newValue: lastStoppedQuestionIndex);
      await updateQuestionUsingFieldPath<double>(
          docPath: userDocRef,
          fieldPath: sectionProgressIndex,
          newValue: sectionProgress);
    } on FirebaseException catch (e) {
      throw CustomException.fromFirebaseFirestoreException(e);
    }
  }

  Future<void> updateInteractedQuestionsList(
      int questionIndex, String levelName, String sectionName) async {
    try {
      DocumentReference userDocRef = FirebaseFirestore.instance
          .collection(FirestoreConstants.usersCollections)
          .doc(_user!.uid);

      // Manually construct the path string
      String interactedQuestionsPath =
          'levelsProgress.$levelName.sectionProgress.${RouteConstants.sectionNameId[sectionName]}.interactedQuestions.$questionIndex';

      // Use Firestore's FieldValue to update the map directly
      await userDocRef.update({interactedQuestionsPath: true});
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
      await docPath.set(newValues, SetOptions(merge: true));
    } catch (e) {
      print("Error updating progress: $e");
    }
  }

  Future<void> deleteQuestionUsingFieldPath({
    required DocumentReference docRef,
    bool? deletionRef,
    required String questionFieldPath,
  }) async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      batch.update(docRef, {questionFieldPath: FieldValue.delete()});
      if (deletionRef == null) {
        batch.update(docRef,
            {'numberOfQuestionsWithDeletion': FieldValue.increment(-1)});
      } else {
        String numberOfQuestionsPath = questionFieldPath.replaceFirst(
            RegExp(r'\.questions\.\d+$'), '.numberOfQuestionsWithDeletion');

        batch.update(docRef, {numberOfQuestionsPath: FieldValue.increment(-1)});
      }
      await batch.commit();
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

  Future<void> addDocument(
      Map<String, dynamic> modelMap, String collectionName) async {
    try {
      await _db.collection(collectionName).doc().set(modelMap);
    } on FirebaseException catch (e) {
      throw CustomException.fromFirebaseFirestoreException(e);
    }
  }

  Future<QuerySnapshot> getLastWorksheet() async {
    return await _db
        .collection(FirestoreConstants.worksheetsCollection)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();
  }

  Future<List<Worksheet>> getAllWorksheets() async {
    final querySnapshot = await _db
        .collection(FirestoreConstants.worksheetsCollection)
        .orderBy('timestamp', descending: true)
        .get();

    List<Worksheet> worksheets = querySnapshot.docs.map((doc) {
      return Worksheet.fromMap(doc.data());
    }).toList();

    return worksheets;
  }

  Future<void> addWorksheet({
    required Worksheet worksheet,
    required String levelID,
    required String sectionName,
    required String unitNumber,
  }) async {
    try {
      _userModel = await getUser(_user!.uid);
      uploadQuestionToFirestore(
          day: unitNumber,
          level: levelID,
          section: sectionName,
          questionMap: worksheet.toMap());
    } on FirebaseException catch (e) {
      throw CustomException.fromFirebaseFirestoreException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<WorksheetStudent> addStudentSubmission({
    required String level,
    required String section,
    required String studentImagePath,
    required String workSheetID,
    String? tempUnitNumber,
  }) async {
    try {
      WorksheetStudent studentSubmission = WorksheetStudent(
        studentName: _userModel!.studentName,
        imagePath: studentImagePath,
        dateSolved: DateTime.now(),
        worksheetId: workSheetID,
        unitNumber: tempUnitNumber ?? unitNumber,
      );

      // Reference to the unit document
      DocumentReference unitRef = _db
          .collection(FirestoreConstants.levelsCollection)
          .doc(level)
          .collection(FirestoreConstants.sectionsCollection)
          .doc(RouteConstants.getSectionIds(section))
          .collection(FirestoreConstants.unitsCollection)
          .doc(tempUnitNumber ?? unitNumber);

      FieldPath fieldPath = FieldPath([
        FirestoreConstants.questionsField,
        workSheetID,
        'students',
        _userModel!.id!
      ]);

      await updateQuestionUsingFieldPath(
        docPath: unitRef,
        fieldPath: fieldPath,
        newValue: studentSubmission.toMap(),
      );
      return studentSubmission;
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
        _userModel = UserModel.fromMap(doc.data() as Map<String, dynamic>);
        return _userModel;
      }
    } on FirebaseException catch (e) {
      throw CustomException.fromFirebaseFirestoreException(e);
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<List<UserModel?>> getUsers() async {
    try {
      QuerySnapshot querySnapshot =
          await _db.collection(FirestoreConstants.usersCollections).get();
      List<UserModel?> users = querySnapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      return users;
    } on FirebaseException catch (e) {
      throw CustomException.fromFirebaseFirestoreException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Level?>> getLevels() async {
    try {
      QuerySnapshot querySnapshot =
          await _db.collection(FirestoreConstants.levelsCollection).get();
      List<Level?> levels = querySnapshot.docs.map((doc) {
        return Level.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      return levels;
    } on FirebaseException catch (e) {
      throw CustomException.fromFirebaseFirestoreException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Unit?>> getDays(String level, String section) async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection(FirestoreConstants.levelsCollection)
          .doc(level)
          .collection(FirestoreConstants.sectionsCollection)
          .doc(RouteConstants.getSectionIds(section))
          .collection(FirestoreConstants.unitsCollection)
          .get();
      List<Unit?> units = querySnapshot.docs.map((doc) {
        return Unit.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      return units;
    } on FirebaseException catch (e) {
      throw CustomException.fromFirebaseFirestoreException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> _documentExists(DocumentReference docRef) async {
    try {
      var docSnapshot = await docRef.get();
      return docSnapshot.exists;
    } catch (e) {
      print('Error checking document existence: $e');
      return false;
    }
  }

  Future<String?> assignQuestion({
    required String userId,
    required String sectionName,
    required Map<String, dynamic> questionMap,
  }) async {
    String? questionId;
    try {
      DocumentReference userDocRef = _db
          .collection(FirestoreConstants.usersCollections)
          .doc(_userModel!.id);
      DocumentSnapshot userDoc = await userDocRef.get();

      if (!userDoc.exists) {
        throw Exception('User document does not exist');
      }

      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      if (!userData.containsKey('assignedQuestions') ||
          userData["assignedQuestions"] == null) {
        userData['assignedQuestions'] = {};
      }
      if (!userData['assignedQuestions']
              .containsKey(RouteConstants.sectionNameId[sectionName]!) ||
          userData["assignedQuestions"]
                  [RouteConstants.sectionNameId[sectionName]!] ==
              null) {
        userData['assignedQuestions']
            [RouteConstants.sectionNameId[sectionName]!] = {
          'questions': {},
          'sectionName': sectionName,
          'progress': 0.0,
          'lastStoppedQuestionIndex': 0,
          "numberOfQuestionWithoutDeletion": 0,
          "numberOfQuestionsWithDeletion": 0
        };
      }

      await _db.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(userDocRef);

        if (!snapshot.exists) {
          throw Exception("User document does not exist!");
        }

        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        Map<String, dynamic> sectionData = data['assignedQuestions']
                [RouteConstants.sectionNameId[sectionName]!]
            as Map<String, dynamic>;

        int numberOfQuestions =
            sectionData['numberOfQuestionWithoutDeletion'] ?? 0;
        questionId = (numberOfQuestions + 1).toString();

        sectionData['questions'][questionId] = questionMap;

        sectionData['numberOfQuestionsWithDeletion'] = FieldValue.increment(1);
        sectionData['numberOfQuestionWithoutDeletion'] =
            FieldValue.increment(1);

        transaction.set(
          userDocRef,
          {
            'assignedQuestions': {
              RouteConstants.sectionNameId[sectionName]!: sectionData
            }
          },
          SetOptions(merge: true),
        );
      });
      return questionId;
    } on FirebaseException catch (e) {
      throw CustomException.fromFirebaseFirestoreException(e);
    }
  }

  Future<void> uploadQuestionToFirestore({
    required String level,
    required String section,
    required String day,
    required Map<String, dynamic> questionMap,
  }) async {
    try {
      // Check if the level exists
      DocumentReference levelRef = _db.collection('levels').doc(level);
      bool levelExists = await _documentExists(levelRef);

      if (!levelExists) {
        await levelRef.set({
          "id": RouteConstants.getLevelIds(level),
          'name': level,
          'description': '',
          'sections': []
        });
      }

      // Check if the section exists
      DocumentReference sectionRef = levelRef
          .collection('sections')
          .doc(RouteConstants.getSectionIds(section));
      bool sectionExists = await _documentExists(sectionRef);

      if (!sectionExists) {
        await sectionRef.set({'name': section, 'description': '', 'units': []});
      }

      // Check if the unit exists
      DocumentReference unitRef =
          sectionRef.collection('units').doc('unit$day');
      bool unitExists = await _documentExists(unitRef);

      if (!unitExists) {
        await unitRef.set({
          'name': 'unit$day',
          'descriptionInEnglish': '',
          'descriptionInArabic': '',
          'questions': {},
          "numberOfQuestionsWithDeletion": 0,
          "numberOfQuestionWithoutDeletion": 0
        });
      }

      await _db.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(unitRef);

        if (!snapshot.exists) {
          throw Exception("Unit document does not exist!");
        }

        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        int numberOfQuestions = data['numberOfQuestionWithoutDeletion'] ?? 0;
        String questionId = (numberOfQuestions + 1).toString();

        transaction.set(
          unitRef,
          {
            'questions': {questionId: questionMap},
            'numberOfQuestionsWithDeletion': FieldValue.increment(1),
            "numberOfQuestionWithoutDeletion": FieldValue.increment(1)
          },
          SetOptions(merge: true),
        );
      });
    } on FirebaseException catch (e) {
      throw CustomException.fromFirebaseFirestoreException(e);
    }
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
          unit.numberOfQuestionWithoutDeletion =
              unit.numberOfQuestionsWithDeletion;
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
