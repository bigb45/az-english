import 'dart:io';

import 'package:excel/excel.dart';
import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/levels/data/models/reading_question.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/features/models/level.dart';
import 'package:ez_english/features/models/section.dart';
import 'package:ez_english/features/models/unit.dart';
import 'package:ez_english/features/sections/models/fill_the_blanks_question_model.dart';
import 'package:ez_english/features/sections/models/listening_question_model.dart';
import 'package:ez_english/features/sections/models/multiple_choice_answer.dart';
import 'package:ez_english/features/sections/models/passage_question_model.dart';
import 'package:ez_english/features/sections/models/string_answer.dart';
import 'package:ez_english/features/sections/models/word_definition.dart';
import 'package:ez_english/features/sections/models/youtube_lesson_model.dart';
import 'package:ez_english/widgets/radio_button.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

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
      PassageQuestionModel? currentPassage;
      String? previousSectionName;

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
          String? imageName =
              convertToNull(csvParts[15]!.value.toString().trim());
          // String? imageName =
          //     convertToNull(csvParts[16]!.value.toString().trim());

          String? imageUrl = imageName != null && imageName.isNotEmpty
              ? await uploadImageAndGetUrl(imageName)
              : null;
          // Check if the level already exists in the levels map
          var existingLevel = levels.firstWhere(
            (level) => level.name == levelName,
            orElse: () => Level(
              // TODO: map the level id to the given level name
              id: RouteConstants.getLevelIds(levelName),
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
          var existingUnit = existingSection?.units?.firstWhere(
            (unit) => unit.name == unitName,
            orElse: () => Unit(
              name: unitName,
              descriptionInEnglish:
                  descriptionEnglish != '-' ? descriptionEnglish : null,
              descriptionInArabic:
                  descriptionArabic != '-' ? descriptionArabic : null,
              questions: {}, // Initialize an empty map of questions
            ),
          );

          if (previousSectionName != null &&
              previousSectionName != sectionName) {
            currentPassage = null;
          }
          previousSectionName = sectionName;

          // Add questions dynamically based on the row data
          Map<int, BaseQuestion?> questions = {};
          int nextIndex = existingUnit!.questions.length;
          switch (QuestionTypeExtension.fromString(questionType)) {
            case QuestionType.dictation:
              questionText?.split(';').forEach((word) {
                var question = DictationQuestionModel(
                  questionTextInEnglish: questionEnglish,
                  questionTextInArabic: questionArabic,
                  imageUrl: imageUrl,
                  voiceUrl: "",
                  speakableText: word,
                  answer: StringAnswer(answer: word),
                );
                if (currentPassage != null) {
                  currentPassage.questions.add(question);
                } else {
                  existingUnit.questions[nextIndex++] = question;
                }
                existingUnit.numberOfQuestions++;
              });

              break;
            case QuestionType.multipleChoice:
              var question = MultipleChoiceQuestionModel(
                questionTextInEnglish: questionEnglish,
                questionTextInArabic: questionArabic,
                questionSentence: questionText,
                imageUrl: imageUrl,
                // voiceUrl: '',
                options:
                    questionAnswerOrOptionsInMCQ.asMap().entries.map((entry) {
                  int index = entry.key;
                  String option = entry.value!;
                  return RadioItemData(value: index.toString(), title: option);
                }).toList(), // Assign index as the value
                answer: MultipleChoiceAnswer(
                  answer: RadioItemData(
                    title: questionAnswerOrOptionsInMCQ[
                            int.tryParse(mcqAnswer!)!] ??
                        "",
                    value: mcqAnswer,
                  ),
                ),
              );
              if (currentPassage != null) {
                currentPassage.questions.add(question);
              } else {
                existingUnit.questions[nextIndex++] = question;
              }
              existingUnit!.numberOfQuestions++;
              break;

            case QuestionType.speaking:
              // TODO: Handle this case.
              throw Exception(UnimplementedError());
            case QuestionType.sentenceForming:
              // TODO: Handle this case.
              throw Exception(UnimplementedError());
            case QuestionType.youtubeLesson:
              var question = YoutubeLessonModel(
                youtubeUrl: imageName,
                questionTextInEnglish: questionEnglish,
                questionTextInArabic: questionArabic,
                imageUrl: imageUrl,
                voiceUrl: '',
                questionType: QuestionTypeExtension.fromString(questionType),
              );
              if (currentPassage != null) {
                currentPassage.questions.add(question);
              } else {
                existingUnit.questions[nextIndex++] = question;
              }
              existingUnit!.numberOfQuestions++;

              break;
            case QuestionType
                  .vocabularyWithListening: // TODO: Should we add the listening ability to all vocabularies
            case QuestionType.vocabulary:
              questionText?.split(';').forEach((wordInEnglishAndArabic) {
                List<String> wordsAndExamples =
                    wordInEnglishAndArabic.split(":");
                List<String> englishAndArabicWordAsList =
                    wordsAndExamples[0].split("0");
                List<String>? englishAndArabicExamplesAsList =
                    wordsAndExamples.length > 1
                        ? wordsAndExamples[1].split("0")
                        : null;

                var question = WordDefinition(
                  englishWord: englishAndArabicWordAsList[0],
                  arabicWord: englishAndArabicWordAsList.length > 1
                      ? englishAndArabicWordAsList[1]
                      : null,
                  type: WordTypeExtension.fromString(questionEnglish!),
                  exampleUsageInEnglish: switch (
                      WordTypeExtension.fromString(questionEnglish)) {
                    WordType.sentence => null,
                    WordType.verb => wordsAndExamples.length > 1
                        ? [englishAndArabicExamplesAsList![0]]
                        : null,
                    WordType.word => wordsAndExamples.length > 1
                        ? [englishAndArabicExamplesAsList![0]]
                        : null,
                  },
                  exampleUsageInArabic: switch (
                      WordTypeExtension.fromString(questionEnglish)) {
                    WordType.sentence => null,
                    WordType.verb => wordsAndExamples.length > 1
                        ? [englishAndArabicExamplesAsList![1]]
                        : null,
                    WordType.word => wordsAndExamples.length > 1
                        ? [englishAndArabicExamplesAsList![1]]
                        : null,
                  },
                  questionTextInEnglish: questionEnglish,
                  questionTextInArabic: questionArabic,
                  questionType: QuestionTypeExtension.fromString(questionType),
                  imageUrl: imageUrl,
                  voiceUrl: '',
                );

                if (currentPassage != null) {
                  currentPassage.questions.add(question);
                } else {
                  existingUnit.questions[nextIndex++] = question;
                }
                existingUnit!.numberOfQuestions++;
              });
              break;

            case QuestionType.fillTheBlanks:
              questionText?.split(';').asMap().forEach((index, questionText) {
                List<String> questionParts = questionText.split("0");
                var question = FillTheBlanksQuestionModel(
                  incompleteSentenceInEnglish:
                      questionParts.isNotEmpty ? questionParts[0] : null,
                  incompleteSentenceInArabic:
                      questionParts.length > 1 ? questionParts[1] : null,
                  answer:
                      StringAnswer(answer: questionAnswerOrOptionsInMCQ[index]),
                  questionTextInEnglish: questionEnglish,
                  questionTextInArabic: questionArabic,
                  imageUrl: '',
                  voiceUrl: '',
                );

                if (currentPassage != null) {
                  currentPassage.questions.add(question);
                } else {
                  existingUnit.questions[nextIndex++] = question;
                }
                existingUnit.numberOfQuestions++;
              });

              break;
            case QuestionType.listening:
              var question = ListeningQuestionModel(
                words: questionText!.split(";"),
                questionTextInEnglish: questionEnglish,
                questionTextInArabic: questionArabic,
                imageUrl: '',
                voiceUrl: '',
              );
              if (currentPassage != null) {
                currentPassage.questions.add(question);
              } else {
                existingUnit.questions[nextIndex++] = question;
              }
              existingUnit!.numberOfQuestions++;
              break;
            case QuestionType.passage:
              currentPassage = PassageQuestionModel(
                questions: [],
                passageInEnglish: passageInEnglish,
                passageInArabic: passageInArabic,
                titleInEnglish: titleInEnglish,
                titleInArabic: titleInArabic,
                questionTextInEnglish: questionEnglish,
                questionTextInArabic: questionArabic,
                imageUrl: '',
                voiceUrl: '',
              );
              existingUnit!.numberOfQuestions++;
              break;
            default:
              break;
          }

          if (currentPassage != null && currentPassage.questions.isEmpty) {
            existingUnit.questions[nextIndex++] = currentPassage;
          }

          // Add the unit to the section if it's not already added
          if (!existingSection!.units!.contains(existingUnit)) {
            existingSection.units!.add(existingUnit!);
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

  Future<String> uploadImageAndGetUrl(String imageName) async {
    try {
      final byteData =
          await rootBundle.load('assets/questions/images/$imageName.png');
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/$imageName');
      await file.writeAsBytes(byteData.buffer.asUint8List());

      String fileName = basename(file.path);

      UploadTask uploadTask =
          FirebaseStorage.instance.ref('questions/$fileName').putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return '';
    }
  }

  Future<void> saveLevelToFirestore(Level levelData) async {
    try {
      await _firestoreService.uploadLevelToFirestore(levelData);
    } catch (e) {
      print('Error saving level to Firestore: $e');
    }
  }
}
