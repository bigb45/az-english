import 'package:excel/excel.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/levels/data/models/reading_question.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/level.dart';
import 'package:ez_english/features/models/reading_unit.dart';
import 'package:ez_english/features/models/section.dart';
import 'package:ez_english/features/models/unit.dart';
import 'package:ez_english/features/sections/models/fill_the_blanks_question_model.dart';
import 'package:ez_english/features/sections/models/listening_question_model.dart';
import 'package:ez_english/features/sections/models/word_definition.dart';
import 'package:ez_english/features/sections/writing/practice.dart';
import 'package:ez_english/widgets/radio_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../sections/models/dictation_question_model.dart';
import '../../sections/models/multiple_choice_question_model.dart';

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
      String? convertToNull(String value) {
        return value == '-' ? null : value;
      }

      for (var csvParts in excel.tables[sheet]!.rows) {
        if (csvParts.any((cell) =>
            cell != null &&
            cell.value != null &&
            cell.value.toString().trim().isNotEmpty)) {
          String levelName = csvParts[0]!.value.toString().trim();
          String sectionName = csvParts[1]!.value.toString().trim();
          String unitName = csvParts[2]!.value.toString().trim();
          String? descriptionEnglish =
              convertToNull(csvParts[3]!.value.toString().trim());
          String? descriptionArabic =
              convertToNull(csvParts[4]!.value.toString().trim());
          String? questionEnglish =
              convertToNull(csvParts[5]!.value.toString().trim());
          String? questionArabic =
              convertToNull(csvParts[6]!.value.toString().trim());
          String? questionText = convertToNull(csvParts[7]!.value.toString());
          List<String?> questionAnswerOrOptionsInMCQ = csvParts[8]!
              .value
              .toString()
              .split(';')
              .map(convertToNull)
              .toList();
          String? mcqAnswer = convertToNull(csvParts[9]!.value.toString());
          String questionType = csvParts[10]!.value.toString().trim();
          String? titleInEnglish =
              convertToNull(csvParts[11]!.value.toString().trim());
          String? titleInArabic =
              convertToNull(csvParts[12]!.value.toString().trim());
          String? passageInEnglish =
              convertToNull(csvParts[13]!.value.toString().trim());
          String? passageInArabic =
              convertToNull(csvParts[14]!.value.toString().trim());

          // Check if the level already exists in the levels map
          var existingLevel = levels.firstWhere(
            (level) => level.name == levelName,
            orElse: () => Level(
              // TODO: map the level id to the given level name
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
            orElse: () => sectionName == "Reading"
                ? ReadingUnit(
                    name: unitName,
                    questions: [],
                    passageInEnglish: passageInEnglish,
                    passageInArabic: passageInArabic,
                    titleInEnglish: titleInEnglish,
                    titleInArabic: titleInArabic,
                    descriptionInEnglish:
                        descriptionEnglish != '-' ? descriptionEnglish : null,
                    descriptionInArabic:
                        descriptionArabic != '-' ? descriptionArabic : null,
                  )
                : Unit(
                    name: unitName,
                    descriptionInEnglish:
                        descriptionEnglish != '-' ? descriptionEnglish : null,
                    descriptionInArabic:
                        descriptionArabic != '-' ? descriptionArabic : null,
                    questions: [], // Initialize an empty list of questions
                  ),
          );

          // Add questions dynamically based on the row data
          List<BaseQuestion?> questions = [];
          switch (QuestionTypeExtension.fromString(questionType)) {
            case QuestionType.dictation:
              questions = questionText?.split(';').map((word) {
                    return DictationQuestionModel(
                      questionTextInEnglish: questionEnglish,
                      questionTextInArabic: questionArabic,
                      imageUrl: '',
                      voiceUrl: '',
                      answer: word,
                    );
                  }).toList() ??
                  [];
              break;
            case QuestionType.multipleChoice:
              questions = [
                MultipleChoiceQuestionModel(
                  questionTextInEnglish: questionEnglish,
                  questionTextInArabic: questionArabic,
                  questionSentence: questionText,
                  imageUrl: '',
                  voiceUrl: '',
                  options:
                      questionAnswerOrOptionsInMCQ.asMap().entries.map((entry) {
                    int index = entry.key;
                    String option = entry.value!;
                    return RadioItemData(
                        value: index.toString(), title: option);
                  }).toList(), // Assign index as the value
                  answer: RadioItemData(
                      title: questionAnswerOrOptionsInMCQ[
                          int.tryParse(mcqAnswer!)!]!,
                      value: questionAnswerOrOptionsInMCQ[
                          int.tryParse(mcqAnswer)!]!),
                )
              ];
              break;
            case QuestionType.findWordsFromPassage:
            case QuestionType.answerQuestionsFromPassage:
              questions = [
                ReadingQuestion(
                  questionTextInEnglish: questionEnglish,
                  questionTextInArabic: questionArabic,
                  imageUrl: '',
                  voiceUrl: '',
                  questionType: QuestionTypeExtension.fromString(questionType),
                  titleInEnglish: titleInEnglish,
                  titleInArabic: titleInArabic,
                  passageInEnglish: passageInEnglish,
                  passageInArabic: passageInArabic,
                  words: questionText?.split(';'),
                  answers: questionAnswerOrOptionsInMCQ,
                )
              ];
              break;

            case QuestionType.speaking:
            // TODO: Handle this case.
            case QuestionType.sentenceForming:
              // TODO: Handle this case.
              throw Exception(UnimplementedError());
            case QuestionType.youtubeLesson:
            // TODO: Handle this case.
            case QuestionType.vocabulary:
              questions = questionText?.split(';').map((word) {
                    return WordDefinition(
                      word: word.split(":")[0].toString(),
                      type: WordTypeExtension.fromString(questionEnglish!),
                      definition: switch (
                          WordTypeExtension.fromString(questionEnglish)) {
                        WordType.sentence => null,
                        WordType.verb => word.split(":")[1].toString(),
                        WordType.word => word.split(":")[1].toString(),
                      },
                    );
                  }).toList() ??
                  [];
            case QuestionType.fillTheBlanks:
              questions =
                  questionText?.split(';').asMap().entries.map((question) {
                        int index = question.key;
                        String questionText = question.value;
                        return FillTheBlanksQuestionModel(
                          answer: questionAnswerOrOptionsInMCQ[index],
                          questionTextInEnglish: questionText,
                          questionTextInArabic: '',
                          imageUrl: '',
                          voiceUrl: '',
                        );
                      }).toList() ??
                      [];
            case QuestionType.listening:
              questions = [
                ListeningQuestionModel(
                  words: questionText!.split(";"),
                  questionTextInEnglish: questionEnglish,
                  questionTextInArabic: questionArabic,
                )
              ];
            default:
              questions = [];
          }

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
