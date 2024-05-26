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

  Future<Level?> parseData() async {
    ByteData data = await rootBundle.load('assets/questions.xlsx');
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // Decode Excel data
    var excel = Excel.decodeBytes(bytes);
    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table]!.rows) {
        print('$row');
      }
    }

    var sheet = excel.tables.keys.first;
    List<List<dynamic>> excelData = excel.tables[sheet]!.rows;

    for (List<dynamic> csvParts in excelData) {
      String levelName = csvParts[0]!.value.toString();
      String sectionName = csvParts[1]!.value.toString();
      String unitName = csvParts[2]!.value.toString();
      String descriptionEnglish = csvParts[3]!.value.toString();
      String descriptionArabic = csvParts[4]!.value.toString();
      String questionEnglish = csvParts[5]!.value.toString();
      String questionArabic = csvParts[6]!.value.toString();
      List<String> englishWords = csvParts[7]!.value.toString().split(',');

      List<BaseQuestion> questions = englishWords
          .map((word) => DictationQuestionModel(
                questionText: questionEnglish,
                imageUrl: '',
                voiceUrl: '',
                answer: word,
              ))
          .toList();

      Unit unit = Unit(name: unitName, questions: questions);

      Section section = Section(
        name: sectionName,
        description: descriptionEnglish,
        units: [unit],
      );

      Level level = Level(
        id: 1,
        name: levelName,
        description: '',
        sections: [section],
      );
      return level;
    }
    return null;
  }

  Future<void> saveLevelToFirestore(Level levelData) async {
    try {
      await _firestoreService.uploadLevelToFirestore(levelData);
    } catch (e) {
      print('Error saving level to Firestore: $e');
    }
  }
}
