import 'package:excel/excel.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/level.dart';
import 'package:ez_english/features/models/section.dart';
import 'package:ez_english/features/models/unit.dart';
import 'package:ez_english/features/sections/writing/components/dictation_question.dart';
import 'package:ez_english/features/sections/writing/practice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UploadDataViewmodel extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  Future<List<Level>> parseData() async {
    List<Level> levels = [];

    ByteData data = await rootBundle.load('assets/questions.xlsx');
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    try {
      // Decode Excel data
      var excel = Excel.decodeBytes(bytes);
      var sheet = excel.tables.keys.first;

      for (var csvParts in excel.tables[sheet]!.rows) {
        String levelName = csvParts[0]!.value.toString();
        String sectionName = csvParts[1]!.value.toString();
        String unitName = csvParts[2]!.value.toString();
        String descriptionEnglish = csvParts[3]!.value.toString();
        String questionEnglish = csvParts[5]!.value.toString();
        List<String> englishWords = csvParts[7]!.value.toString().split(',');
        String questionType = csvParts[8]!.value.toString();
        // Check if the level already exists in the levels map
        var existingLevel = levels.firstWhere(
          (level) => level.name == levelName,
          orElse: () => Level(
            // TODO: map the level id to the given level name
            //TODO add this field to the toMap function
            id: levels.length + 1,
            name: levelName,
            description: '',
            sections: [], // Initialize an empty list of sections
          ),
        );

        // Check if the section already exists in the existing level
        var existingSection = existingLevel.sections?.firstWhere(
          (section) => section.name == sectionName,
          orElse: () => Section(
            name: sectionName,
            description: descriptionEnglish,
            units: [], // Initialize an empty list of units
          ),
        );

        // Check if the unit already exists in the existing section
        var existingUnit = existingSection?.units.firstWhere(
          (unit) => unit.name == unitName,
          orElse: () => Unit(
            name: unitName,
            questions: [], // Initialize an empty list of questions
          ),
        );

        // Add questions dynamically based on the row data
        List<BaseQuestion> questions = englishWords.map((word) {
          var questionData = {
            'questionType': questionType,
            'questionText': questionEnglish,
            'imageUrl': '',
            'voiceUrl': '',
            'answer': word,
            'options': [], // Add appropriate options if needed
            'correctAnswer':
                '', // Set correct answer for multiple choice questions if needed
          };

          return BaseQuestion.fromMap(questionData);
        }).toList();
        // Add the questions to the existing unit
        existingUnit?.questions.addAll(questions);

        // Add the unit to the section if it's not already added
        if (!existingSection!.units.contains(existingUnit)) {
          existingSection.units.add(existingUnit!);
        }

        // Add the section to the level if it's not already added
        if (!existingLevel.sections!.contains(existingSection)) {
          existingLevel.sections!.add(existingSection);
        }

        // Add the level to the list if it's not already added
        if (!levels.contains(existingLevel)) {
          levels.add(existingLevel);
        }
      }
    } catch (e) {
      print('Error parsing data: $e');
      return [];
    }

    return levels;
  }

  Future<void> saveLevelToFirestore(Level levelData) async {
    try {
      await _firestoreService.uploadLevelToFirestore(levelData);
    } catch (e) {
      print('Error saving level to Firestore: $e');
    }
  }
}
